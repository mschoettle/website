---
migrated: true
date:
  created: 2021-05-28
  updated: 2023-06-23
categories:
  - Django
#   - Howto
tags:
  - Django
  - Howto
  - Python
  - Bootstrap
slug: django-django_tables2-and-bootstrap-table
---

# Django, django_tables2 and Bootstrap Table

I was always intrigued by [Django](https://www.djangoproject.com/).
After all, it's slogan is

QUOTE: The web framework for perfectionists with deadlines

Last year I started a project for a client who needed a web app to manage a digital printing workflow.
I evaluated Django and did their [tutorial](https://docs.djangoproject.com/en/stable/intro/tutorial01/) (which is really well made by the way).
Since the project also required lots of data processing of different data sources (CSV, XML, etc.) Python made a lot of sense.
So in the end the choice was to use Django.

I needed to create several tabIes showing data from the Django models.
In this post I explain how I combined [`django_tables2`](https://github.com/jieter/django-tables2) (for the table definitions) and [Bootstrap Table](https://bootstrap-table.com/) (for visualizing the tables and client-side table features).

<!-- more -->

NOTE: If I were to do something similar again now I would do this using server-side rendering only and add the interactivity using [HTMX](https://htmx.org/) or [unpoly](https://unpoly.com/).

## Using `django_tables2` with custom model methods

Initially, I started using `django_tables2` since it can create tables for Django models without having to write a lot of code (or HTML) and has support for pagination and sorting.
The [documentation](https://django-tables2.readthedocs.io/en/latest/index.html) shows how to set it up and get started.

In the models I made use of quite a few custom model methods to derive data from existing model fields.
The Django tutorial shows [how custom methods are added to a model](https://docs.djangoproject.com/en/stable/intro/tutorial02/#playing-with-the-api) and also [how they can be used in the model's admin](https://docs.djangoproject.com/en/stable/intro/tutorial07/#customize-the-admin-change-list).
I thought that this was great.
Derived properties is something I used whenever possible when metamodelling.
However, this actually causes problems for sorting.
To be efficient, sorting is performed on the `QuerySet`, i.e., it is performed at the database-level and is translated to an `ORDER BY ...` in SQL.

Another feature I wanted to support was searching.
While there is [support with the help of `django-filter`](https://django-tables2.readthedocs.io/en/latest/pages/filtering.html) you end up with a separate input field per model field.

So I started looking for a framework that supported sorting and searching on the client side.
I did find [DataTables](https://datatables.net) and [Bootstrap Table](https://bootstrap-table.com).
I tested both and went with _Bootstrap Table_ because I found it to be easier to configure and it is extremely customizable.

## Combining django_tables2 and Bootstrap Table

Now, finally, comes the reason why I am writing all of this.

Since `django_tables2` actually allows to nicely define tables I wanted to keep using it.
In the end what this allows is to use `django_tables2` for the table definition and data retrieval, and _Bootstrap Table_ (you could actually use something else) for visualizing the table on the client side.
And, it would also be possible to later switch to server-side processing if necessary (the client-side approach becomes a performance problem for large amounts of data).

### Getting table columns and data

So I did some digging into the [`django_table2` source code](https://github.com/jieter/django-tables2) to determine how the table columns and data are determined.
I created a _mixin_ with the common functionality that can be reused across the different class-based views.

To build and populate the table there are two parts required.

The first is the table columns.
We need the column name and the header.
The header is usually the verbose name of the model field or the verbose name defined in the table.

The second part is getting the actual data that should be shown in the table.

The following code takes care of getting the columns of the table and building an ordered dictionary mapping from the name to the header (usually the verbose name of the model field):

```python
table: Table = self.get_table()
table_columns: List[Column] = [
    column
    for column in table.columns
]
columns_tuples = [(column.name, column.header) for column in table_columns]
columns: OrderedDict[str, str] = OrderedDict(columns_tuples)
```

And the second piece of code takes care of retrieving the data of the table and converting to a mapping of column name to value:

```python
table: Table = self.get_table()
data = [
    {column.name: cell for column, cell in row.items()}
    for row in table.paginated_rows
]
```

### Putting it all together

What I did in the end, which is probably a bit of a hack, is to use an existing URL for the view and if it has `?json` appended to it returns the table data as JSON instead of the HTML template.

So putting it all together the `TableViewMixin` looks as follows:

```python title="TableViewMixin"
from collections import OrderedDict
from typing import List
from django.http import JsonResponse
from django_tables2 import Column, SingleTableMixin, Table


class TableViewMixin(SingleTableMixin):
    # disable pagination to retrieve all data
    table_pagination = False

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # build list of columns and convert it to an
        # ordered dict to retain ordering of columns
        # the dict maps from column name to its header (verbose name)
        table: Table = self.get_table()
        table_columns: List[Column] = [
            column
            for column in table.columns
        ]
        # retain ordering of columns
        columns_tuples = [(column.name, column.header) for column in table_columns]
        columns: OrderedDict[str, str] = OrderedDict(columns_tuples)
        context['columns'] = columns

        return context

    def get(self, request, *args, **kwargs):
        # trigger filtering to update the resulting queryset
        # needed in case of additional filtering being done
        response = super().get(self, request, *args, **kwargs)

        if 'json' in request.GET:
            table: Table = self.get_table()
            data = [
                {column.name: cell for column, cell in row.items()}
                for row in table.paginated_rows
            ]
            return JsonResponse(data, safe=False)
        else:
            return response
```

And to build the table in the template you can do the following:

```html
<table class="table table-bordered table-hover"
    data-toggle="table"
    data-pagination="true"
    data-search="true"
    [...]
    data-url="{% url request.resolver_match.view_name %}?json">
  <thead class="thead-light">
    {% for id, name in columns.items %}
      <th data-field="{{ id }}" data-sortable="true">{{ name }}</th>
    {% endfor %}
  </thead>
</table>
```

If you have many pages with a table you can even put this part into a base template that is reused (extended) in each page's template.

### Supporting server-side table operations

Finally, it would also be possible to support server-side pagination, sorting and searching with this approach with a few modifications (and caveats).

As mentioned above, you cannot sort or search the data that is coming from custom model methods since these operations are performed on the `QuerySet`.
In theory it should be possible to convert the `QuerySet` to a list and perform sorting on the list using `sorted(...)` but I haven't found the right place where this could be done yet.
Basically, for non-fields there needs to be a check that prevents the call to `QuerySet.order_by(...)` and then do custom sorting.

#### Server-side pagination

To support server-side pagination, the `table_pagination` needs to be set to `True` (or removed since the default is `True`) and the JSON response needs to contain the total number of rows:

```python
data = {
    'total': self.queryset.count(),
    'rows': rows
}
```

On the template side there are the [specific table settings for server-side pagination](https://bootstrap-table.com/docs/api/table-options/#sidepagination) and some JavaScript to send the correct request when requesting another page or sorting:

```html
data-side-pagination="server"
data-query-params="queryParams"
data-query-params-type=""
```

```javascript
<script type="text/javascript">
  function queryParams(params) {
    if (params.sortName !== undefined) {
      // change sort name to support Django related model fields (foo__bar__name)
      params.sort = params.sortName.replace('.', '__')
      // change sort param to Django way of sorting (- for DESC)
      if (params.sortOrder == 'desc') {
        params.sort = `-${params.sort}`
      }
    }

    return {
      page: params.pageNumber,
      per_page: params.pageSize,
      search: params.searchText,
      sort: params.sort,
    }
  }
</script>
```

#### Server-side searching

Supporting [server-side searching](https://bootstrap-table.com/docs/api/table-options/#searchable) is a bit trickier since there is one search field but no builtin way in Django to search directly across several field.

If you are already using the [django-rest-framework](https://www.django-rest-framework.org/) you could directly use the [`SearchFilter`](https://www.django-rest-framework.org/api-guide/filtering/#searchfilter) it provides.
It is based on [Django admin's search functionality](https://docs.djangoproject.com/en/stable/ref/contrib/admin/#django.contrib.admin.ModelAdmin.search_fields)

> UPDATES: **Updates to this blog post**
>
> - **23.06.2023:** Added note about doing it using server-side rendering using `HTMX` or `unpoly`.

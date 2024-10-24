---
migrated: true
date:
  created: 2011-04-14
  updated: 2011-04-14
categories:
  - Java
  - Struts
slug: things-discovered-in-struts-2
---
# Things discovered in Struts 2

In this post I write about some things I discovered during the development of a university project where [Struts 2](http://struts.apache.org "Apache Struts project website") is used.
I note them since I couldn't find them in the [documentation](http://struts.apache.org/2.x/docs/home.html "Apache Struts 2 documentation") and they were discovered through digging through pieces of documentation, the code and the web.

<!-- more -->

In general, sometimes more detailed information can be found in the Javadoc of the frameworks classes, e.g. interceptors.

## Skipping validation for a specific method in an action class

If you use the [validation interceptor](http://struts.apache.org/2.x/docs/validation-interceptor.html) some methods are already excluded by default (e.g. back or input) and you could add some more method names (even with a wildcard) to that list.
This will be applied to the interceptor.
But if you want to specify it in the action class on the method itself then you can use an annotation for that.
Simply add `@SkipValidation` to the method and it will be skipped by the validation interceptor.

## Using the parameters prepare trick with model driven actions

In the [documentation of the interceptors](http://struts.apache.org/2.x/docs/interceptors.html#Interceptors-TheDefaultConfiguration) there's a trick (`paramsPrepareParams` trick) explained to call the parameters interceptor twice in order to be able to load something from the database in the prepare method (e.g. using a given ID) and then getting the new parameters set to the loaded object.

This approach does not work when using model driven actions.
When the parameters interceptor is called the first time, the model object doesn't exist on the stack yet.
Moving the model driven interceptor before the added parameters interceptor doesn't work either because then the object on the stack doesn't get updated (somehow).
That means the model driven interceptor gets added a second time before the first parameters interceptor.
That way the model object can be loaded from the database in `prepare` with the given parameters and then gets updated when the parameters interceptor gets executed the second time.

## Receiving JSON requests (and using the model driven approach)

The JSON plugin for Struts can also receive requests containing JSON.
All you have to do is simply add the JSON interceptor to your interceptor stack.
Depending on the other interceptors you use it should be located after the model driven interceptor and before the validation interceptor for example.
If you are using model driven actions though, you have to make a small adjustment because the interceptor tries to set the values to the action and not on to the model.

The interceptor has a property called `root`.
All values will be added to this object.
By default it is the action class.
You can either set a param when you add the interceptor to your stack.

```xml
<interceptor-ref name="json">
    <param name="root">model</param>
</interceptor-ref>
```

Or set the param on your stack reference.

```xml
<interceptor-ref name="myStack">
    <param name="json.root">model</param>
</interceptor-ref>
```

But this means this will be applied to every action class.
Even those that are not model driven.
This will lead to a `RuntimeException` as the root object can't be determined.
Therefore I wrote my own small JSON intercepter (I already needed one so it wasn't a big deal) that extends the original one and simply set `model` as the root object when the current action class is model driven.
But the root object has to be reset in any other case because the interceptor will be instantiated once.

```java
@Override
public String intercept(ActionInvocation invocation) throws Exception {
    if (invocation.getAction() instanceof ModelDriven) {
        setRoot("model");
    }
    else {
        setRoot(null);
    }

    return super.intercept(invocation);
}
```

**Update:** This issue is resolved in Struts 2.2.3 (not released as of now).
See this [bug report](https://issues.apache.org/jira/browse/WW-3498).

**Update #2:** Since Struts 2.2.3 the root object is always considered to be the model if the action is model driven.
This means that when creating the JSON request only the model will get serialized.
In some cases one might use model driven for receiving requests and send something else in the response.
Then the root object has to be changed.
This can be done by setting the root parameter as shown above in the interceptor or for example in the result type.

```xml
<result-type name="json" class="org.apache.struts2.json.JSONResult">
    <param name="root">action</param>
</result-type>
```

---
categories:
  - Eclipse Modeling Framework (EMF)
date:
  created: 2013-05-02
  updated: 2013-05-02
migrated: true
slug: modifying-the-new-child-sub-menu-items-in-emf
tags:
  - archived
  - java
  - tips
---

# Modifying the "New Child" sub-menu items in EMF

--8<-- "docs/snippets/archive.md"

I was just looking into a way to adjust the text of the items in the "New Child" (the same applies to "New Sibling" as well) sub-menu of the generated editor with EMF.
By default the items just show the type name of the element to create.
Depending on your meta-model it might be necessary to add some more information in order to be able to see which feature the new element gets added (or set) to.

The available items are depending on the current selected element.
The `collectNewChildDescriptors(Collection<Object>, Object)` method is called on the item provider of this element.
The actions for those menu items are created inside your `ActionBarContributor` class (see `generateCreateChildActions(Collection<?>, ISelection)`), which is located in the editor project.
The text for this action is determined by `CreateChildCommand.getText()`, which in turn calls `getCreateChildText(Object, Object, Object, Collection<?>)` of the corresponding item provider.
The default case is implemented in `ItemProviderAdapter`.

There seem to be two approaches, depending on what your goal is.

<!-- more -->

## General Approach

If you want to change the text independent from the element, meaning for all elements, you should change the `_UI_CreateChild_text` key in `plugin.properties`.
By default this is `{0}`.
This refers to the type name of the child.
Also available are the feature text (`{1}`) and the type name of the owner (`{2}`).

## Case-specific Approach

If you just need to adjust it for one element, simply overwrite `getCreateChildText(Object, Object, Object, Collection<?>)` in the corresponding item provider and adjust it to your needs.
Here is an example, that simply adds the features' text in front of the default child text:

```java
@Override
public String getCreateChildText(Object owner, Object feature,
        Object child, Collection&lt;?> selection) {
    StringBuffer result = new StringBuffer();

    result.append(getFeatureText(feature));
    result.append(" ");
    result.append(super.getCreateChildText(owner, feature, child, selection));

    return result.toString();
}
```

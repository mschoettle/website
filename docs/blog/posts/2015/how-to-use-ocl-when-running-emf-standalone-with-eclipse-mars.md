---
migrated: true
date:
  created: 2015-08-18
  updated: 2015-08-18
categories:
  - Eclipse Modeling Framework (EMF)
slug: how-to-use-ocl-when-running-emf-standalone-with-eclipse-mars
---
# How to use OCL when running EMF standalone with Eclipse Mars

--8<-- "docs/snippets/archive.md"

I previously explained on [how to use OCL when running EMF in standalone](../2012/how-to-use-ocl-when-running-emf-standalone.md) (not as an Eclipse application).
This method works until Eclipse Luna.
With Eclipse Mars, OCL was heavily updated again.
For instance, it was promoted out of the examples space.

The good thing is it seems to be much easier to initialize it now.
Add a dependency to `org.eclipse.ocl.xtext.completeocl` and use the following code:

```java
PivotStandaloneSetup.doSetup();
CompleteOCLStandaloneSetup.doSetup();
```

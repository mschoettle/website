---
migrated: true
date:
  created: 2012-05-31
  updated: 2015-08-18
categories:
  - Eclipse Modeling Framework (EMF)
#   - Howto
#   - Java
slug: how-to-use-ocl-when-running-emf-standalone
---
# How to use OCL when running EMF standalone

--8<-- "docs/snippets/archive.md"

If you are using the Eclipse Modeling Framework (EMF) standalone, i.e., you are not running it in an Eclipse-based environment, and you want to use OCL, some additional steps have to be performed besides registering your resource factory.

<!-- more -->

This description is for the [MDT OCL project](https://eclipse.dev/modeling/mdt/?project=ocl) which can be found and installed from the Juno update site under _Modeling > OCL Examples and Editors_.

!!! note

    See the [update for Eclipse Mars](../2015/how-to-use-ocl-when-running-emf-standalone-with-eclipse-mars.md).

For the sake of completeness this is the code necessary to register a resource factory to be able to load your model files:

```java
// Register the XMI resource factory for the any extension
Resource.Factory.Registry registry = Resource.Factory.Registry.INSTANCE;
Map<String, Object> map = registry.getExtensionToFactoryMap();
map.put("*", new XMIResourceFactoryImpl()); // or specifically state your file extension

// initialize your package
YourPackage.eINSTANCE.eClass();
```

If you are using your own resource factory, e.g., to force generation of unique IDs when serializing your model, replace `XMIResourceFactoryImpl` with your own.

To use OCL as well use the following:

```java
// Register Pivot globally (resourceSet == null)
// Alternatively register it just for your resource set (see Javadoc).
org.eclipse.ocl.examples.pivot.OCL.initialize(null);

String oclDelegateURI = OCLDelegateDomain.OCL_DELEGATE_URI_PIVOT;
EOperation.Internal.InvocationDelegate.Factory.Registry.INSTANCE.put(oclDelegateURI,
    new OCLInvocationDelegateFactory.Global());
EStructuralFeature.Internal.SettingDelegate.Factory.Registry.INSTANCE.put(oclDelegateURI,
    new OCLSettingDelegateFactory.Global());
EValidator.ValidationDelegate.Registry.INSTANCE.put(oclDelegateURI,
    new OCLValidationDelegateFactory.Global());

OCLinEcoreStandaloneSetup.doSetup();
// Install the OCL standard library.
OCLstdlib.install();
```

This requires dependencies to `org.eclipse.ocl.examples.xtext.oclinecore` and `com.google.log4j` (as David pointed out in the comments, thanks!).
EMF itself requires `org.eclipse.emf.ecore` and `org.eclipse.emf.ecore.xmi`.

If you encounter a `java.lang.NoClassDefFoundError: org/eclipse/uml2/uml/Type` exception during runtime when calling `OCLinEcoreStandaloneSetup.doSetup()`, you need to add a dependency to `org.eclipse.uml2.uml.resources` as well.
This is because starting with _Eclipse Luna_ [OCLInEcore does not re-export UML anymore](https://www.eclipse.org/forums/index.php/mv/msg/783873/1389274/#msg_1389274 "Eclipse Community Post").

> UPDATES: **Updates to this blog post**
>
> * **07.12.2012:** Added missing call to install the OCL standard library and dependencies.
> * **28.06.2014:** Added missing UML dependency for Eclipse Luna.
> * **Update 18.08.2015:** Updated for Eclipe Mars (in [separate post](../2015/how-to-use-ocl-when-running-emf-standalone-with-eclipse-mars.md)).

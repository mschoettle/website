---
migrated: true
date:
  created: 2019-12-12
  updated: 2019-12-12
categories:
  - Eclipse Modeling Framework (EMF)
tags:
  - archived
  - java
slug: making-emf-models-serialized-in-xmi-available-in-json-with-emfjson
---

# Making EMF models serialized in XMI available in JSON with `emfjson`

--8<-- "docs/snippets/archive.md"

This summer we had two interns in our team at the _Software Engineering Lab_ who started creating a web application for our [TouchCORE](https://djeminy.github.io/touchcore/) tool.
I have wanted this for a long time.
Not only does it allow you to model in your browser, you can also do this collaboratively!
For now class diagrams are supported but more supported will be added in the future (for example for sequence diagrams and feature models).

<!-- more -->

Re-creating the complete application right away was not feasible for this project.
Also, we are all about reuse and I had envisioned in the architecture from the beginning to reuse the backend parts when we build another user interface.
Therefore, the goal was to keep our current backend which makes of the [Eclipse Modeling Framework (EMF)](https://eclipse.dev/modeling/emf/) and making it available through an API to the web application.
Fortunately, there is already support for EMF and JSON by [`emfjson`](https://emfjson.github.io/projects/jackson/latest/).
The main use case however is to replace the XML/XMI serialization/deserialization with JSON.

There is a way to keep XMI on the backend and making it available through JSON.
This allows to keep the XMI serialization which is still being used by the existing application.
It requires to use unique IDs when serializing, otherwise you need to manage your own ID mapping (see below).

The `emfjson-jackson` setup is as follows:

```java
ObjectMapper mapper = new ObjectMapper();
// Optional
mapper.configure(SerializationFeature.INDENT_OUTPUT, true);

module = new EMFModule();
module.configure(EMFModule.Feature.OPTION_USE_ID, true);
// Optional
module.configure(EMFModule.Feature.OPTION_SERIALIZE_TYPE, true);

module.setIdentityInfo(new EcoreIdentityInfo("_id"));
mapper.registerModule(module);
```

The use of IDs along with the `EcoreIdentityInfo` ensures that the IDs used by EMF during serialization are used.
Now, assuming you loaded an existing model from a resource for any `EObject` of that model you can get the JSON by calling:

```java
mapper.writeValueAsString(eObject)
```

To do the reverse, you can identify an object by its ID.
To retrieve the `EObject` for a given ID, EMF of course has a handy utility method.
For this, you need the `Resource` of your model.

```java
resource.getEObject(id)
```

To get the ID of an object you can use `resource.getURIFragment(eObject)`.

If you have cross-references in your models to other models, the URI you get is of the form `anotherModel.ext#id`.
You can use the `ResourceSet` to get the resource of the other model or the cross-referenced object using the resource set's `getResource(URI, boolean)` and `getEObject(URI, boolean)` methods.

You can also maintain your own ID mapping by passing a custom `ValueWriter` as a second parameter to `EcoreIdentityInfo`, for example:

```java
module.setIdentityInfo(new EcoreIdentityInfo("_id",
    new ValueWriter<EObject, Object>() {
        @Override
        public Object writeValue(EObject eObj, SerializerProvider context) {
            // TODO: return ID of object
        }
    }
));
```

Furthermore, you need to handle references between objects specifically by customizing the reference serializer:

```java
module.setReferenceSerializer(new JsonSerializer<EObject>() {
    @Override
    public void serialize(EObject eObject, JsonGenerator generator, SerializerProvider serializer) throws IOException {
        generator.writeString(/* TODO: Get the ID of eObject */);
    }
});
```

There is one caveat though.
That is when using EMF notifications on the backend to notify the frontend that something changed.
If an object is deleted, EMF does not give you an ID for this deleted object anymore.
That's why we in the end used the custom ID solution.

As I researched some links for this post I noticed that there is now a whole Eclipse project to make EMF available in the cloud ([EMF.cloud](https://projects.eclipse.org/projects/ecd.emfcloud)).
It would be interesting to evaluate whether these technologies ([Sprotty](https://projects.eclipse.org/projects/ecd.sprotty) as the web-diagramming framework and [GLSP](https://projects.eclipse.org/projects/ecd.glsp) as the graphical language server protocol) are more suitable instead of a custom-baked solution.
Currently we use _Spring Boot_ on the backend with web sockets and _Angular_ with `mxgraph` on the frontend.

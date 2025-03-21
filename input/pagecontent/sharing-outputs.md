Many types of referrals and orders will involve the creation of some output resources, either as a final product or as part of an intermediate workflow step. This could include a results report, individual observations, a proposed plan of care, a consult note, etc. 

This section provides basic guidance for how these output documents may be communicated between the Placer and the Fulfiller. 

Generally, the createor of the output document will make a representation of that Output available on their FHIR server, and provide a reference to that Output in the shared coordination Task's Task.output, wherever that coordinating Task is hosted.

Placers may choose to create their own local representation of that content, and additionally, to host their own copy of that content on their own FHIR server so that its information is surfacable to others invovled in a patient's care. Provenance FHIR resources MAY be used to indicate that the originator of the latest version of the Output is the owner.


### Preliminary Results, Addenda, and Updates with FHIR Servers

In some contexts, a partial result may be shared from one system to another, or a later actor in the chain of care may decide to modify an earlier result. When this occurs, the actor may do so by updating their local representation of the earlier output, updating their FHIR resources for that content, and updating the Provenance, if recorded, to indicate that they are now the source of truth. The actor may notify others in the chain of the update based on their business agreements and using mechanisms described in this guide. 

For example - that update may be communicated with a Message that's been pre-defined to indicate a correction or update, or the originator of the Output document may receive a SubscriptionStatus notification that a copy of their document has been modified and should now be seen as the source of Truth. In that case, they SHOULD update their local copy as
needed, with an appropriate Provenance. 

{%include share-outputs.svg%}

Many referrals and orders create output resources, either as a final product or as part of an intermediate workflow step. This could include a results report, individual observations, a proposed plan of care, a consult note, etc. 

This section provides guidance for how these outputs may be communicated between the Fulfiller and the Placer. 

Generally, the creator of an output  will make a resource representing that output available on their FHIR server and provide a reference in the shared Coordination Task's Task.output, wherever that coordinating Task is hosted.

Placers may choose to create their own local representation of that content and additionally may host their own copy of that content on their  FHIR server so that its information is discoverable for others involved in a patient's care. Provenance FHIR resources MAY be used to indicate that the originator of the latest version of the Output is the owner, though note that many Event resources will already implicitly indicate their source (such as in DiagnosticReport.performer and .resultsInterpreter).


### Preliminary Results, Addenda, and Updates with FHIR Servers

In some contexts, a partial result may be shared from one system to another, or an actor may modify an earlier result. When this occurs, the actor may do so by updating their local representation of the earlier output, updating their FHIR resources for that content, and updating the Provenance, if recorded, to indicate that they are now the source of truth. The actor may notify others in the chain of the update based on their business agreements and using mechanisms described in this guide. 

For example - that update may be communicated with a Message that's been pre-defined to indicate a correction or update, or the originator of the Output document may receive a SubscriptionStatus notification that a copy of their document has been modified and should now be seen as the source of Truth. In that case, they SHOULD update their local copy and any provenance as
needed. 

<figure>
{%include share-outputs.svg%}
</figure>
<br clear="all"/>



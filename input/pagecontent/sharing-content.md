### Sharing inputs

When placing a clinical order, the Placer may need to share relevant clinical information as inputs to the order. These inputs provide context that the Fulfiller needs to carry out the requested service. For example, when prescribing nursing care, a Placer may share the patient's current medication list so that the nursing care provider has the information needed to safely administer and monitor medications.

### Sharing Information about clinical order
#### Sharing Information at the time of order

There are two major use cases when there is a RESTful exchange established between the Placer and Filler: `Task` at the Placer or `Task` at the Fulfiller.

When the `Task` is at the Fulfiller the expectation is that the Fulfiller will do a search on the Placer's FHIR Server to obtain the necessary information about the clinical order. This allows the Fulfiller what information is relevant for the order subject to the appropriate access control rules. 

When the `Task` is at the Placer there is an implicit (or explicit) subscription of the Fulfiller  to the Placer for the `Task`. In this case the Placer can provided the necessary information within the subscription notification `Bundle`. This allows the placing of the order and the necessary information in a single exchange, where the Placer determines what the initially provided information is. 

In summary, when the Placer wants to provide information in a single exchange at the time of order, they should use the following bundle types:

* Subscription Notification Bundle for a RESTful exchange when `Task` is at Placer
* Message Bundle for a messaging exchange.


#### Additional Information unsolicited by placer


Placers may provide supporting information alongside a request or its coordination task. As a guide, if the supporting information relates to why the request was authorized or what is authorized, it is associated with the Request resource (via `Request.supportingInfo`). Conversely, if the supporting information relates to how the request should be fulfilled, it is supplied with the Task (via `Task.input`).

For example, a Placer may wish to indicate that they received confirmation from a Payer that they would pay for a given service, and this may have impacted their choice of treatment — this context relates to the authorization itself. If a Placer has collected a Specimen that they expect a Fulfiller will use to perform a Lab Test, this relates to how the request is fulfilled and would be supplied with the Task.

Fulfiller systems may also update the Coordination Task's inputs with details of how they are fulfilling the request. For example, a Fulfiller may ask that a patient complete a Questionnaire and then track that this was used as input for their fulfillment of the related Request.

#### Additional Information requested by filler

In some cases, a Fulfiller may determine that they need additional information from the Placer before they can proceed with fulfilling a request. See the [Fulfillers requesting additional information](fulfiller-need-for-additional-info.html) pattern for details on how this is handled.

### Sharing outcomes of clinical orders

Many types of referrals and orders will involve the creation of output resources, either as a final product or as part of an intermediate workflow step. This could include a results report, individual observations, a proposed plan of care, a consult note, etc. 

This section provides basic guidance for how these outputs may be communicated between the Fulfiller and the Placer. 

Generally, the creator of an output  will make a resource representing that output available on their FHIR server and provide a reference in the shared Coordination Task's Task.output, wherever that coordinating Task is hosted.

Placers may choose to create their own local representation of that content, and additionally, to host their own copy of that content on their own FHIR server so that its information is discoverable for others involved in a patient's care. Provenance FHIR resources MAY be used to indicate that the originator of the latest version of the Output is the owner, though note that many Event resources will already implicitly indicate their source (such as in DiagnosticReport.performer and .resultsInterpreter).


#### Preliminary or Intermediate Results, Addenda, and Updates with FHIR Servers

In some contexts, a partial result may be shared from one system to another, or a later actor in the chain of care may decide to modify an earlier result. When this occurs, the actor may do so by updating their local representation of the earlier output, updating their FHIR resources for that content, and updating the Provenance, if recorded, to indicate that they are now the 'source of truth'. The actor may notify others in the chain of the update based on their business agreements and using mechanisms described in this guide. 

For example - that update may be communicated with a Message that's been pre-defined to indicate a correction or update, or the originator of the Output document may receive a SubscriptionStatus notification that a copy of their document has been modified and should now be seen as the source of Truth. In that case, they SHOULD update their local copy and any provenance as
needed.

The same directives for distributing outputs to CC recipients described under [Final Results/Outcomes](#final-resultsoutcomes) apply to intermediate and preliminary results as well.


#### Final Results/Outcomes

Providers often wish to ensure that other members of the patient's care team are made aware of outputs beyond the direct placer-fulfiller relationship. For example, a patient's Oncologist may order a lab test and wish to ensure that the patient's Primary Care Provider is given a copy of the result.

These intended CC recipients may be communicated via [CommunicationRequest resources](https://hl7.org/fhir/communicationrequest.html). When Placers wish to ensure that an Output is communicated to a specific destination for a CC provider, Placers SHOULD use a PractitionerRole resource in `CommunicationRequest.recipient`. Multiple CommunicationRequest resources can correspond to a single Workflow Request resource; for example, the Placer may indicate that there are specific providers they intend to notify of a result themselves via a CommunicationRequest resource with `.informationProvider` set to the Placer. This can serve a helpful function of informing the Fulfiller that they do not need to notify those recipients of the Output.

### Effect of intermediaries


### Access Controls 

<figure>
{%include share-outputs.svg%}
</figure>
<br clear="all"/>





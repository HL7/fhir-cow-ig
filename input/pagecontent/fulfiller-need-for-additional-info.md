Often, potential Fulfillers find that they need additional data from the Placer to process a request for care. They may do so by:
* Directly querying for information that a Placer already has, and which the Fulfiller is authorized to access. These requests for additional information are generally handled synchronously. For example - "Check insurance coverage" or "check patient's medication list". 
* Sending a request to the Placer asking that they provide additional information which will require user effort to prepare. This often takes the form of a letter or other communication from the Fulfiller to the Placer, which a user at the Placer's organization then processes. Often, these should be accompanied with a businessStatus in the shared coordination Task indicating that the Fulfiller is waiting for information. For example, a Long Term Care facility may communicate they have a shared room available, and ask if that is acceptable based on the patient's needs and preferences.
* A Fulfiller could even send Tasks or other instructions back to the Placer. For example, a surgeon may instruct that a lab test or imaging should be performed ahead of a surgical consult. 

### Supporting Direct Queries:
Fulfillers can perform RESTful queries against Placer's FHIR servers to obtain information that they suspect is already available.

Placers may choose to indicate in their initial notifications how related information for a patient could be obtained. For example, it may not be obvious to a Fulfiller what combination of queries would allow them to obtaina patient's insurance information and consent from a Placer.

At the same time, a Placer may wish to narrow what set of resources a fulfiller has access to; a Placer may wish to let a Fulfiller query for information related to ServiceRequests that have been assigned *to them*, without allowing the Fulfiller to see *all* ServiceRequests for a given service, including those that they've sent to the Fulfiller's competitor.

Likewise, a Placer may wish to limit a Fulfiller to accessing patient data only for patients to whom that Fulfiller is providing care.

Both of these objectives can be accomplished using aspects of the Subscriptions framework. Analagous functionality may be implemented in exchanges using RESTful Tasks or Messaging + REST. See:
* [Adding Queries to Notifications ]([url](https://build.fhir.org/ig/HL7/fhir-subscription-backport-ig/StructureDefinition-notification-authorization-hint.html))
* [Authorization within Notifications]([url](https://build.fhir.org/ig/HL7/fhir-subscription-backport-ig/StructureDefinition-notification-authorization-hint.html)) and the [authorization-hint]([url](https://build.fhir.org/ig/HL7/fhir-subscription-backport-ig/StructureDefinition-notification-authorization-hint.html)) extension.

### Requesting Additional Information Asynchronously via a Letter Flow with Status Update

A Fulfiller may find that additional information is needed that may only be obtained by communicating with the Placer asynchronously. While waiting for this information, the Fulfiller SHOULD update the status of their shared coordination Task to indicate this by updating Task.businessStatus to an appropriate status. 

Fulfillers SHOULD specify that they are awaiting information using an appropriate Task.businessStatus.

If desired, Fulfillers may register a record of communication that has occurred related to the Task, either via FHIR or out of band. For example:
```
* Commmunication.partOf referencing the shared coordination
* Communication.inResponseTo referencing an earlier communication, if present
* Communication.basedOn referencing the ServiceRequest
* Communication.Recipient
* Communication.Sender
* Communication.payload specifying the content of the message or the attachment, if available.
```

### Sending an Instruction Back to the Placer With Status Update

Often, Fulfillers may have some instructions for the Placer of a request: they may ask that the Placer ensure the patient have a Covid test, ask that specified information like Consents be supplied, etc. 

If these activities must be tracked as part of coordinating the original request for service, Fulfillers SHOULD coordinate these additional Tasks for the Fulfiller by updating Task.businessStatus to an appropriate status and by creating additional Task resources:

```
On the Shared CoordinationTask:
* Task.businessStatus is a value such as "Fulfiller awaiting information"
* Task.statusReason: 0..* codeable references that indicate what the Fulfiller needs. These could be Tasks, Communications, CommunicationRequests, etc. 

For any Tasks created to record that action is needed:
* Task.partOf referencing the shared coordination Task
* Task.performer specifying the party from whom action is needed (often the Placer of the original ServiceRequest 
```



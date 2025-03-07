Often, potential Fulfillers find that they need additional data from the Placer to process a request for care. They may do so by:
* Directly querying for information that a Placer already has, and which the Fulfiller is authorized to access. These requests for additional information are generally handled synchronously. For example - "Check insurance coverage" or "check patient's medication list". 
* Sending a request to the Placer asking that they provide additional information. This often takes the form of a letter, which a user at the Placer's organization processes. Ofen, these should be accompanied with a status indicating the Fulfiller is waiting for information.
* A Fulfiller could even send an instruction back to the placer, such as "Please ensure this patient has had a blood test before their consult". 

TODO - lots to write up here. Seems like we need some profiles. Do we need to specify this in this guide? It is a core challenge. 

### Supporting Direct Queries with authorization_base
When a Fulfiller needs additional information that they expect already exists on the placer's server, they can perform RESTful queries against the placer's server.

However - a placer may wish to narrow what set of resources a fulfiller has access to: it may be appropriate that the Fulfiller can find ServiceRequests that they've been asked to perform, or supporting information
like MedicationRequests for patients that have been referred to them, but the Placer may not want to let the Fulfiller see *all* ServiceRequests for a given service, including those that they've sent to the Fulfiller's
competitor. 

Several features of the Subscriptions framework can be used to help with this. Analagous functionality can be implemented in exchanges using RESTful Tasks or Messaging+REST.

```
* SubscriptionStatus relatedQuery
* Authorization Base
.
```
### Requesting Additional Information Asynchronously via a Letter Flow with Status Update

A fulfiller may find that additional information is needed that may only be obtained by communicating with the Placer asynchronously. While waiting for this information, the Fulfiller SHOULD update the status of their shared coordination Task to indicate this by updating Task.businessStatus to an appropriate status. 

Fulfillers MAY specify the information which they are awaiting using Task.statusReason. Fulfillers may also indicate what information is needed by creating additional Task resources with:

```
* Commmunication.partOf referencing the shared coordination Task
* Communication.inResponseTo referencing an earlier communication, if present
* Communication.basedOn referencing the ServiceRequest (TODO - is this needed?)
* Communication.Recipient
* Communication.Sender
* Communicatoin.payload specifying the content of the message or the attachment, if available.
```

Such Communications may serve as a record of communications via FHIR (such as a Communication.Create on the Placer's FHIR server by the Fulfiller) or simply a record of communication that occurred out of band. 
    
TODO - decide if we need to link anything in Task.StatusReason
TODO - when to use Communication vs. CommunicationRequest

### Sending an Instruction Back to the Placer With Status Update

Often, Fulfillers may have some instructions for the Placer of a request: they may ask that the Placer ensure the patient have a Covid test, ask that specified information like Consents be supplied, etc. 

If these activities must be tracked as part of coordinating the original request for service, fulfillers may coordinate these additional Tasks for the Fulfiller by updating Task.businessStatus to an appropriate status and by creating additional Task resources with:

```
* Task.partOf referencing the shared coordination Task
* Task.performer specifying the Placer of the original ServiceRequest 
```

Often, potential Fulfillers find that they need additional data from the Placer to process a request for care. They may do so by:

* Directly querying for information that a Placer already has, and which the Fulfiller is authorized to access. These requests for additional information are generally handled synchronously. For example - "Check insurance coverage" or "check patient's medication list". 
* Sending a request to the Placer asking that they provide additional information. This often takes the form of a letter, which a user at the Placer's organization processes. Ofen, these should be accompanied with a status indicating the Fulfiller is waiting for information.
* A Fulfiller could even send an instruction back to the placer, such as "Please ensure this patient has had a blood test before their consult". 

## Supporting Direct Queries with authorization_base
When a Fulfiller needs additional information that they expect already exists on the placer's server, they can perform RESTful queries against the placer's server.

However - a placer may wish to narrow what set of resources a fulfiller has access to: it may be appropriate that the Fulfiller can find ServiceRequests that they've been asked to perform, or supporting information
like MedicationRequests for patients that have been referred to them, but the Placer may not want to let the Fulfiller see *all* ServiceRequests for a given service, including those that they've sent to the Fulfiller's
competitor. 

Several features of the Subscriptions framework can be used to help with this. Analagous functionality can be implemented in exchanges using RESTful Tasks or Messaging+REST.
* SubscriptionStatus relatedQuery
* Authorization Base
.
.
TODO - finish

### Requesting Additional Information Asynchronously via a Letter Flow with Status Update


### Sending an Instruction Back to the Placer With Status Update

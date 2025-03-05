This section describes how an order may be cancelled or modified after creation.

This guide requires that in circumstances where FHIR servers are prevalent and where resources are discoverable, the ServiceRequest that serves as the source-of-truth for the exchange SHALL be hosted on a FHIR server under the authority of the system from which it originated. Each party involved in an order, referral, or Transfer workflow may of course have their own internal representation as well. Actors SHOULD indicate if their own representation of a resource is not ‘primary’, however. 

A ServiceRequest SHALL only ever be directly modified by the party which instantiated that resource. 

In such circumstances, the shared coordinating Task used by both the placer and fulfiller may be hosted on either the placer’s FHIR server or the fulfiller's FHIR server as the circumstances demand. Trading partners must decide as part of their pre-coordinated activity where the shared status-tracking Task will be hosted.
 
As general guidance, this guide recommends that ServiceRequest.replaces be used when one ServiceRequest replaces another and use of ServiceRequest and Task resources with an intent of “Proposal” when one actor would like to suggest that the other authorize an action.


### Placer Initiated Cancellations.

This is equivalent to the normal flow through the step that an intended performer has been selected. In this flow, a placer sends a cancellation request to the fulfiller via a new Task resource with a status of “Requested” and a code of “Abort”. This satisfies a requirement of the FHIR Task State Machine that a task may not move from in-progress to cancelled. 
*	ServiceRequest
    *	Status: Revoked
* 1..* Task:
    *	Status: Cancelled 
    *	Code: Fulfill
    *	Intent: Order
    *	Focus: <the ServiceRequest>
*	New Task:
    *	Status: Requested
    *	Code: Abort
    * Input: original Task

### Fulfiller Decline to Perform:

This flow is equivalent to the normal flow up to the point that a placer first notifies a potential fulfiller of a service request. In this flow, a fulfiller declines to perform the service, and may or may not specify a reason. 
*	ServiceRequest:
    *	Status: active
    *	Intent: order
*	1 Task:
    *	Status: Rejected
    *	Performer: <specified>
    *	Code: Fulfill
    *	Intent: order

### Fulfiller Proposal for Particular or Alternative Service

This flow is equivalent to the normal flow through the step that a placer notifies an intended performer of an available service request. The potential fulfiller in this flow then notifies the placer of a proposal for a specific or alternative service. 

This could be expected (such as a bid) or a proposed modification to the original request for which the fulfiller seeks approval (as in many cases, the placer need not be aware of the specifics of what the Fulfiller is performing).

*	ServiceRequest (Original):
    *	Status: active
    *	Intent: order
*	Task:
    *	Status: Rejected
    * StatusReason: alternative proposal
    *	Performer: <specified>
    *	Code: Fulfill
    *	Focus: ServiceRequest (Original)
    *	Output (0..*)  
        *	Type: Alternative (exact valueset TBD)
        *	Value: ServiceRequest (proposed) – see below

*	ServiceRequest (proposed):
    *	Status: active
    *	Intent: Proposal

A placer may accept that proposal by:
1. Optionally – creating a new ServiceRequest that matches the proposal, updating the status of their original ServiceRequest to Revoked, and indicating in ServiceRequest.replaces on the new request that it is a replacement. This ServiceRequest may include the proposal in ServiceRequest.basedOn
2. Sending a Task back to the fulfiller with Task.Focus set to the replacement serviceRequest or proposal and an intent of Order.

### Fulfiller Selection of a More Specific Service (Under Original Authority)

**Example workflow**: a protocolling radiologist decides that a request for imaging should be performed as a specific procedure.

In many cases, the more specific service may not be of interest to the placer. If the fulfiller needs to surface the ServiceRequest corresponding to the more specific service they will perform, they may create a new ServiceRequest with ServiceRequest.replaces referencing the Placer’s ServiceRequest. 

Any output generated from this new service may still be linked in the Task.output of the shared status-tracking Task. Additionally, the output may be linked ‘back’ to the original ServiceRequest by following the chain of references.

Such a scenario may also occur in the case that a procedure could not be completed as originally ordered. For example, if a request is created that a patient undergo a Nuclear Medicine rest/stress test, in some circumstances a patient may only be able to perform the rest portion. 

### Fulfiller Unable to Perform:
In some scenarios, a fulfiller who initially accepted a request finds that they can no longer perform the requested service. Examples include when a specimen is dropped or if a bed didn’t open up. 
*	ServiceRequest:
    *	Status: active
    *	Intent: order
*	1 Task:
    * Status: Failed
    *	Performer: <specified>
    *	Code: Fulfill
    *	Intent: order


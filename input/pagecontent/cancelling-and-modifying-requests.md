This section describes how an order may be cancelled or modified after creation. In this section, the term "Request Resource" refers to one of the request resources that follow the [Request](https://www.hl7.org/fhir/workflow.html#request) pattern. 

This guide requires that in circumstances where FHIR servers are prevalent and where resources are discoverable, the Request resource that serves as the source-of-truth for the exchange SHALL be hosted on a FHIR server under the authority of the system from which it originated. Each party involved in an order, referral, or Transfer workflow may of course have their own internal representation as well. Actors SHOULD indicate if their own representation of a resource is not ‘primary’, however. 

A Request resource SHALL only ever be directly modified by the party which instantiated that resource. 

In such circumstances, the shared coordinating Task used by both the placer and fulfiller may be hosted on either the placer’s FHIR server or the fulfiller's FHIR server as the circumstances demand. Trading partners must decide as part of their pre-coordinated activity where the shared status-tracking Task will be hosted.
 
As general guidance, this guide recommends that [Request resource].replaces be used when one Request replaces another and use of Request resources and Tasks  with an intent of “Proposal” when one actor would like to suggest that the other authorize an action.


### Placer Initiated Cancellations.


This is equivalent to the normal flow through the step that an intended performer has been selected. In this flow, a placer sends a cancellation request to the fulfiller via a [CancellationRequestTask](StructureDefinition-cancellation-request-task.html) - having a status of “Requested” and a code of “Abort”. This satisfies a requirement of the FHIR Task State Machine that a task may not move from in-progress to cancelled. 


Until the Fulfiller begins work (indicated by updating the Coordination Task to a status of In-Progress), the Placer may cancel that request by directly updating on the Coordination Task.status --> Cancelled.

Once the filler has begun work, Placers must request cancellation by creating and communicating a CancellationRequest Task. This CancellationRequest Task has .code=Abort, a status of 'Requested', and the original Coordination Task in focus.

The filler may accept or reject that Cancellation by updating CancellationRequestTask.status to Accepted or Rejected, and they MAY update the status of the Coordination Task as well.   

<figure>
{%include cancelation-when-in-progress-example-task-at-fulfiller.svg%}
</figure>

```
Request Resource
    * id: Request1
    * Status: revoked

1..* Coordination Task:
    * id: task1
    * Status: cancelled
    * Code: fulfill
    * Intent: order
    * Focus: Request1
```
Note that this guide makes no requirements around whether a Placer may cancel the ServiceRequest. This guide does not require that the Placer first check the status of the Coordination Task before cancelling the Request. Such requirements may be imposed via business agreements. Placers SHALL create or update a Coordination Task to indicate cancellation, in  addition to updating the ServiceRequest.status. 
 
Also note that even once a Coordination Task is in-progress, Fillers may choose to immediately accept requests for cancellation per business agreements; user input at the fulfiller is not required.  


Upon receiving the request, the filler accepts or rejects the cancellation by updating the cancellation request task `.status`.  


Until the Fulfiller begins work (indicated by updating the Coordination Task to a status of In-Progress), the Placer may cancel that request by directly updating on the coordination Task.status --> Cancelled.  
 

Once the filler has begun work, Placers MUST request cancellation by creating and communicating a Cancellation Request Task. This Cancellation Request task has .code=Abort, and the original Coordination Task in focus and a status of Requested.   

The filler may accept or reject that Cancellation by updating Cancellation Task.status to Accepted or Rejected, and they MAY update the Coordination Task to On Hold.  
 
* Before there is a Coordination Task, the Placer MAY simply change the request.status.
  * When there is already a Coordination Task, it is necessary to issue a cancellation notice/request: the Placer SHALL create or update a Cancellation Request Task, in addition to updating the ServiceRequest.status. 

  Note that this guide makes no requirements around whether a Placer may cancel the ServiceRequest. This guide does not require that the Placer first check the status of the coordination task before cancelling the Service Request. Such requirements may be imposed via business agreements. 

  Note that even once a Task is in-progress, the Filler MAY choose to immediately accept requests for cancellation without user input, per business agreements.  




### Fulfiller request to cancel
In case a Fulfiller needs to request the cancellation of a request, the Cancellation Request Task is used to request the Placer to cancel their request.

```
Request Resource:
    * id: servicerequest1 
    * status: active
    * intent: order
Coordination Task:
    * status: rejected
    * focus: serviceRequest1
Cancellation Request Task:
    * Status: requested
    * Code: abort
    * focus: serviceRequest1
```



### Fulfiller Decline to Perform:

This flow is equivalent to the normal flow up to the point that a placer first notifies a potential fulfiller of a service request. In this flow, a fulfiller declines to perform the service, and may or may not specify a reason. 

```
Request Resource:
    * Status: active
    * Intent: order
1 Task:
    * Status: Rejected
    * Performer: <specified>
    * Code: Fulfill
    * Intent: order
```

If Fulfillers feel that no actor should fullfill a request, they may additionally send a proposal back to the Placer with:

```
CancellationRequest Task:
    * Status: Requested
    * Code: Abort
    * Intent: Proposal
    * Focus: Request
```

### Fulfiller Proposal for Particular or Alternative Service

This flow is equivalent to the normal flow through the step that a placer notifies an intended performer of an available service request. The potential fulfiller in this flow then notifies the placer of a proposal for a specific or alternative service. 

This could be expected (such as a bid) or a proposed modification to the original request for which the fulfiller seeks approval (as in many cases, the placer need not be aware of the specifics of what the Fulfiller is performing).

```
Request Resource (Original):
    * id: initial-request
    * status: active
    * intent: order
Task:
    * Status: Rejected
    * StatusReason: Alternative Proposal
    * Performer: <specified>
    * Code: Fulfill
    * Focus: initial-request
    * Output (0..*)  
      * Type: Alternative (exact valueset TBD)
      * Value: a new Request resource (proposed) – see below

Request Resource (proposed):
    * Status: active
    * Intent: Proposal
```

A placer may accept that proposal by:
1. Optionally – creating a new Request that matches the proposal, updating the status of their original Request to Revoked, and indicating in Request.replaces on the new request that it is a replacement. This Request may include the proposal in Request.basedOn
2. Sending a Task back to the fulfiller with Task.Focus set to the replacement Request or proposal and an intent of Order.

### Fulfiller Selection of a More Specific Service (Under Original Authority)

Fulfillers, as specialists, may elect to perform a more specific service than what was originally requested by a placer. For example, a protocolling radiologist may determine that a request for imaging should be performed as a specific procedure. The more specific service may or may not be of interest to the placer. If the fulfiller needs to surface the Request corresponding to the more specific service they will perform, they may create a new Request with Request.replaces referencing the Placer’s Request. 

Any output generated from this new service may still be linked in the Task.output of the shared Coordination Task. Additionally, the output may be linked back to the original Request by following the chain of references.

Such a scenario may also occur in the case that a procedure could not be completed as originally ordered. For example, if a request is created that a patient undergo a Nuclear Medicine rest/stress test, in some circumstances a patient may only be able to perform the rest portion. 

### Fulfiller Unable to Perform:
In some scenarios, a fulfiller who initially accepted a request finds that they can no longer perform the requested service. Examples include when a specimen is dropped or if a bed in a long term care facility didn’t become available when expected. 

Such scenarios may be represented like the below. The fulfiller may update their shared Coordination Task to indicate that the attempt failed. A placer may then decide whether to cancel the request, to initiate Tasks to others to fulfill the request, etc.
```
Request Resource:
    *  Status: active
    *  Intent: order
1 Task:
    * Status: Failed
    *  Performer: <specified>
    *  Code: Fulfill
    *  Intent: order
```

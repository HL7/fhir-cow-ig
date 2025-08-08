This section describes how an order may be cancelled or modified after creation. This can refer to several workflows, which may overlap:

1. A Placer may decide that they are no longer interested in the outcome of a Request they previously authorized, and may cancel their authorization. Absent business agreements to the contrary, this could occur before or after a fulfiller has begun work.
2. A Placer may decide that a Fulfiller should no longer fulfill a Request. Absent business agreements to the contrary, this could occur before or after a fulfiller has begun work. This guide includes a mechanism for Placers and Fulfillers to coordinate if needed.
3. A Placer may decide that a request they initiated should not be performed, by anyone, and may wish to ensure the original Request is not acted upon.
4. A Placer may wish to cancel a portion of an original Request. 
5. A Placer may wish to change their original Request. For example, a provider may indicate that they would now like a CT without contrast, rather than a CT with contrast.
6. A Fulfiller may indicate that they will not fulfill a request.
7. A Fulfiller may indicate that they will not Fulfill a request, and that in their opinion, the original Request is contraindicated and should be cancelled.
8. A Fulfiller may propose that an alternative service should be performed. 
9. A Fulfiller may indicate that they have attempted, but failed to fullfill a Request. For example, a specimen may have been dropped.
10. A Fulfiller may perform an alternative service under the authority of the original Request


Within COW, Request resource SHALL only be directly modified by the party which instantiated that resource. Parties may send Request and Task resources with an `.intent` of “Proposal” when they would like to suggest that another party change or cancel one of their Requests. If these changes are accepted, the original Request may be updated or a new Request may be created, optionally with `Request.replaces` referring back to the original Request.

Note that this guidance applies only to workflows between a Placer and a Fulfiller. In real care settings, a patient may see multiple Providers with prescribing privileges. For example, consider a patient who's General Practitioner / Primary Care Provider has prescribed blood thinners to reduce their risk of stroke. If that patient is then referred for surgery, their surgeon may prescribe that the patient pause their blood thinner. This guide does not directly address how a GP/PCP and a Surgeon should coordinate in this case. Guidance from this IG could be leveraged, but prescribers are also encouraged to review all available Requests for a patient to identify any Requests which supercede others.

<a name="fulfCancel"></a>

### Placer Cancellation of Authorization:
If a Placer is no longer interested in the outcome of a request that they previously authorized, they may update their Request resource to have a '.status' of 'revoked'. This implementation guide does not impose any requirement that Placers first check the status of the  Coordination Task shared with the Fulfiller before revoking their authorization, but business practices and workflow-specific implementation guides may do so. 

This implementation does impose that a Placer SHALL notify the Fulfiller that the authorization has been revoked. 

###  Placer Decision Fulfiller Should Not Perform
A placer may also decide that a particular Fulfiller should not Fulfill a Request, even if the Request is authorized. For example, the Provider may be told the Patient would like to go to a different Fulfiller. 

There are three options in this workflow, depending on business agreements and safety considerations. Authors of workflow-specific implementation guides are encouraged to provide guidance on when each of these mechanism should be used for a workflow.

**First**, a Placer may simply update `Task.status` on the Coordination Task to Cancelled. If the Coordination Task is hosted on the Fulfiller's FHIR server and cancelling the Task would violate a business rule, the Server may respond with an appropriate 4XX HTTP status code and an OperationOutcome.   

**Alternatively**, if business agreements require that the Placer and Fulfiller coordinate a cancellation, a Placer may send the Fulfiller a [Cancellation Request Task](StructureDefinition-cancellation-request-task.html) with having a `Task.status` of “Requested”, a `.code` of “Abort”, and the Coordination Task in the Cancellation Task's `Task.focus`.

The filler may accept or reject that Cancellation by updating CancellationRequestTask.status to Accepted or Rejected, and they MAY update the status of the Coordination Task as well.   

**Lastly**, if a Placer wants to ensure that a Fulfiller does not perform a Task that the Fulfiller had previously authorized, and if there is opportunity for ambiiguity, the Placer MAY also update the CoordinationTask with an appropriate `Task.doNotPerform` indicator. 

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Coordinating a Cancellation<button type="button" class="btn btn-default top-align-text" style="float: right;" data-target="#fig2" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig2" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include cancelation-when-in-progress-example-task-at-fulfiller.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

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

### Placer Decision to Cancel Part of a Request
A Placer may decide that a portion of what they had originally requested should not be performed. 

For example, the Placer may decide that one test in a Panel should be cancelled, or that a standing order should be ended before all of the originally anticipated occurrences are complete.

Placers have options in this case, and authors of workflow-specific implementation guides are encouraged to give guidance on the appropriate mechanism to choose.

First, Placers may always indicate that a Request has been completed to their satisfaction by updating the `Request.status` to completed. This can be done even if the full set of services was not performed, as indicated by an incomplete set of Event resources. Placers SHOULD provide an indication that may be shared in Request.statusReason indicating that the Request was ended early. 

Alternatively, Placers may modify their original Request and any corresponding Tasks which they created, as in the next section. 

### Placer Decision to Change their Request
This implementation guide does not place any constraints on the modifications a Placer may make to a Request that they originated, though business rules and workflow-specific implementation guides may do so. Placers SHALL update Coordination Tasks as necessary if they have modified the Task's underlying Request.

In scenarios where a new Request is needed, due to Business Rules, Placers are encouraged to use the [Request.replaces](https://hl7.org/fhir/request-definitions.html#Request.replaces) element. 

TODO - add guidance on how the Tasks are re-pointed to the new Request or if new Tasks are generated.


<a name="authCancel"></a>
### Fulfiller Decline to Perform:
If a Fulfiller declines to fulfill a Request, they may update the Coordination Task they share with the Placer to a `Task.status` of Rejected. 

```
Request Resource:
    * Status: active
    * Intent: order
1 Task:
    * Status: Rejected
    * Owner: <specified>
    * Code: Fulfill
    * Intent: order
```

### Fulfiller Request to Revoke the Authorization
A Fulfiller may determine that the authorization for a service for a particular patient is contraindicated or otherwise inappropriate. The Fulfiller may use a [Cancellation Request Task](StructureDefinition-cancellation-request-task.html) to request that the Placer  cancel their request.

```
Request Resource:
    * id: serviceRequest1 
    * status: active
    * intent: order
Coordination Task:
    * status: rejected 
    * focus: serviceRequest1
Cancellation Request Task:
    * Status: requested
    * intent: proposal
    * code: abort
    * focus: serviceRequest1
```

### Fulfiller Proposal for Alternative Service
A Fulfiller may propose an alternative to what was originally authorized by the Placer. If they are unwilling to perform the service that was originally described, they may update the `Task.status` of the Coordination Task to 'rejected', provide a statusReason indicating an alternative proposal, and provide that alternative in `Task.output` of the Coordination Task. 

```
Request Resource (original):
    * id: initial-request
    * status: active
    * intent: order
Task:
    * Status: Rejected
    * StatusReason: Alternative Proposal
    * Owner: <specified>
    * Code: Fulfill
    * Focus: initial-request
    * Output (0..*)  
      * Type: Alternative
      * Value: a new Request resource (proposed) – see below

Request Resource (proposed):
    * Status: active
    * Intent: Proposal
```

A placer may accept that proposal by creating a new Request that matches the proposal, updating the status of their original Request to Revoked, and indicating in `Request.replaces` on the new request that it is a replacement. This Request may include the proposal in `Request.basedOn`

Alternatively, if a Fulfiller may be willing to fulfill the original request, but still wishes to propse an alternative, they may set `Task.status` on the Coordination Task to On-Hold, and specify a proposed alternative in the `Task.statusReason.reference`. 

### Fulfiller Unable to Perform:
In some scenarios, a fulfiller who initially accepted a request finds that they can no longer perform the requested service. This could occur, for example, if a specimen necessary for a lab test is dropped or if a bed in a long term care facility doesn't become available when expected. 

In these scnearios, the Fulfiller may update their shared Coordination Task to indicate that the attempt failed. A placer may then decide whether to cancel the request or to initiate Tasks to others to fulfill the request.
```
Request Resource:
    *  Status: active
    *  Intent: order
1 Task:
    * Status: Failed
    *  Owner: <specified>
    *  Code: Fulfill
    *  Intent: order
```
### Fulfiller Selection of a More Specific Service (Under Original Authority)

If business agreements allow, a fulfiller may perform a service that is different from what the Placer originally requested, without the creation of a new Request resource. For example, a protocolling radiologist may determine that a request for imaging should be performed as a specific procedure. The more specific service may or may not be of interest to the placer. If the fulfiller needs to surface the Request corresponding to the more specific service they will perform, they may create a new Request with Request.replaces referencing the Placer’s Request. 

Any output generated from this new service may still be linked in the Task.output of the shared Coordination Task. Additionally, the output may be linked back to the original Request by following the chain of references.

This also presents an alternative option if a Fulfiller could only  partially fulfill a request. For example, if a request is created that a patient undergo a Nuclear Medicine rest/stress test, and a patient can only complete the rest portion, the Fulfiller may indicate that they performed this alternative Procedure in `Task.output` of the Coordination Task and update `Task.status` and `Task.statusReason` to indicate partial fulfillment. Placers may decide whether this fulfills their original Request, and update `Request.status` if so, or initiate additional Tasks. 




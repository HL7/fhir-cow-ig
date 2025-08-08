This page povides further details on the expected use of Task resources within this implementation guide. 

FHIR Task resources represent an instruction to fulfill one or more worklow steps related to a Request. Designers and implementers of systems implementing workflows using FHIR resources are encouraged to review the [Task resource](https://hl7.org/fhir/Task) pages for details. 

This guide introduces three types of Tasks for request-fulfillment workflows:
* **Bidding Tasks** which a Placer may create to solicit input from a group of potential fulfillers for whehter and how they could fulfill a request.
* **Coordination Tasks** that a Placer and Fulfiller share to track the status of execution of a request. See [profile](StructureDefinition-coordination-task.html)). The coordination Task is usually the focus of notification to a potential fulfiller or other party of the requested service. For example, a party may become aware of a Request via a Task they have received via POST, via a Message with `MessageHeader.focus` set to the Task, or by a SubscriptionStatus notification with `SubscriptionStatus.notificiationEvent.focus` set to the Task.
* **Cancellation and Modification Tasks** that request that another FHIR Task or FHIR Request be changed. These may be used in circumstances where the cancellation or modification of a request requires, by business agreement, approval by the other party. Though not required, circumstances where this could be helpful include a Placer asking a Fulfiller to cease service after the Fulfiller has already begun, a Fulfiller asking a Placer if an alternative serivce could be performed, or a Fulfiller asking a placer to cancel a Request. A pharmacist may wish to indicate that they do not intend to fulfill a MedicationRequest due to a contraindication, and may propose an alternative course of treatment. See [Cancelling and Modifying Orders](./cancelling-and-modifying-requests.html) and [profile](StructureDefinition-cancellation-request-task.html).


### Representing Workflow Execution:
FHIR distinguishes between the **status of authorization** for some care and the **status of execution** of that care. In FHIR, Request resourcers can indicate whether a provider's authorization for some care is in a draft status, active, not active, or completed. 

Task resources represent actions to be taken based on that authorization for care. The fulfillment of each action is tracked via `Task.status`, and further detail may be provided via `Task.businessStatus`. 

For example, a provider may authorize imaging and create a Task for a radiology department. That radiology department may indicate that their fulfillment is in-progress via `Task.status`, and may then provide detail such as "contrast administered" in `Task.businessStatus`.

### Communicating Who Has the Baton for a Request:


### Guidance on Creating New Tasks 
This implementation guide does not impose requirements for what Tasks are created beyond the Coordination Task or for when this occurs. Authors of workflow-specific implementation guides may choose to define this. 

We note briefly that there are multiple reasons 
* A Task may be broken into sub-components by a Fulfiller.
* Multiple Tasks may reflect multiple related Requests
* Several steps may need to occur in sequence.

Implementation guide authors should be aware of two points when specifying further Tasks:
1. The `Task.owner` element represents the party who currently has the baton for the Task. `Task.performer` represents parties who were previously involved in performing the request. If an audit is needed to tie actors to particular Task.outputs or workflow events, multiple Tasks can be beneficial. 
2. The Placer may not need details on all of the individual steps taken by the Fulfiller. Parties are encouraged to ensure that a workflow's overall status of execution may be understood from the overall Coordination Task. This includes linking any Event outputs that represent the overall fulfillment of the request to the Coordination Task's `Task.output`.


### Relating Tasks to Other Resources:

#### Task.input
`Task.input` is used to get the relevant Data for the performer to execute the Request. Examples:
- `Specimen` Resource
- `QuestionnaireResponse` Resource (for example ask at Order Entry Questions)
- etc.


#### Task.output
`Task.output` is used to get - if and when available - the output of the Request from the Filler to the Placer. Examples of resources that are typical outputs are:
- `DiagnosticReport`
- `Questionaires`
- `ImageStudy`
- etc.


### Coordinating several requests
The Task resource can be used to coordinate several requests, when they are grouped but not orchestrated (i.e. they are part of the same group, but are not interdependent). See the [Order Grouping](./order-grouping.html) page for details.

In future releases of FHIR, `Task.focus` is planned to expand to 0..* in support of the cases where there is a need to coordinate several requests. For supporting this in R4 and R5, implementers can use a built-in extension mechanism that "imports" an element as an extension. In this case, the task.focus element is imported as an additional extension on Task, thus allowing task.focus to effectively point to several requests.

```
Profile: GroupCoordinationTask
Parent: Task
* extension contains http://hl7.org/fhir/4.0/StructureDefinition/extension-Task.focus named focus 0..* MS
```
See the example of [grouped dispense](ex4-meds-grouped-dispense.html). 

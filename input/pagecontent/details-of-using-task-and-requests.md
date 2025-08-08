This page provides details on how Request and Task resources are used together within this implementation guide. See the [Glossary and Key Resources page](./glossary-and-key-resources.html) for an overview. 

In short, FHIR distinguishes between an **authorization** for care and the **execution** of that care. Request resource represents a Provider's authorization, and FHIR Tasks represent an instruction to fulfill one or more worklow steps related to that Request. 

This guide introduces three types of Tasks for request-fulfillment workflows:
* **Bidding Tasks** which a Placer may create to solicit input from a group of potential fulfillers for whehter and how they could fulfill a request.
* **Coordination Tasks** that a Placer and Fulfiller share to track the status of execution of a request. See [profile](StructureDefinition-coordination-task.html)). The coordination Task is usually the focus of notification to a potential fulfiller or other party of the requested service. For example, a party may become aware of a Request via a Task they have received via POST, via a Message with `MessageHeader.focus` set to the Task, or by a SubscriptionStatus notification with `SubscriptionStatus.notificiationEvent.focus` set to the Task.
* **Cancellation and Modification Tasks** that request that another FHIR Task or FHIR Request be changed. These may be used in circumstances where the cancellation or modification of a request requires, by business agreement, approval by the other party. Though not required, circumstances where this could be helpful include a Placer asking a Fulfiller to cease service after the Fulfiller has already begun, a Fulfiller asking a Placer if an alternative serivce could be performed, or a Fulfiller asking a placer to cancel a Request. A pharmacist may wish to indicate that they do not intend to fulfill a MedicationRequest due to a contraindication, and may propose an alternative course of treatment. See [Cancelling and Modifying Orders](./cancelling-and-modifying-requests.html) and the [Request Cancellation Task profile](StructureDefinition-cancellation-request-task.html).

### Tracking an Order's Status:
Request resourcers can indicate whether a provider's authorization for some care is in a draft status, active, not active, or completed. Task resources represent actions to be taken based on that authorization for care. The fulfillment of each action is tracked via `Task.status`, and further detail may be provided via `Task.businessStatus`. 

For example, a provider may authorize imaging and create a Task for a radiology department. That radiology department may indicate that their fulfillment is in-progress via `Task.status`, and may then provide detail such as "contrast administered" in `Task.businessStatus`.

[Request.statusReason](https://hl7.org/fhir/request-definitions.html#Request.statusReason) and [Task.statusReason](https://hl7.org/fhir/task-definitions.html#Task.statusReason) may provide additional context for why an Order is at a particular status; for example, why it is on hold.

### Mangaging Sub-Tasks in a Workflow: 
Except for the existence of a Coordination Task, this implementation guide does not impose requirements for what additional Tasks are created in a workflow or when this occurs. Authors of workflow-specific implementation guides may choose to define this.  

Implementation guide authors should be aware of three points when specifying further Tasks:
1. The `Task.owner` element represents the party who currently has the baton for the Task. `Task.performer` represents parties who were previously involved in performing the request. If a workflow requires that  is needed to tie actors to particular Task.outputs or workflow events, multiple Tasks can be beneficial.
2. Sub-tasks that are created in relation to the overall Coordination Task SHOULD refer back to the Coordination Task via `Task.partOf`.
3. The Placer may not need details on all of the individual steps taken by the Fulfiller. Parties are encouraged to ensure that a workflow's overall status of execution may be understood from the overall Coordination Task. This includes linking any Event outputs resulting from the fulfillment of the Request to the Coordination Task's `Task.output`. This could include, for example, DiagnosticReports, Procedures, Questionnaires, ImagingStudy resources, etc.

### Supplying Supporting Information:
Placers  may provide supporting information via `Request.supportingInfo` and `Task.input`. As a guide, if the supporting information relates to why the Request was authorized or what is authorized, it may be included in `Request.input` or another dedicated item on the Request. Conversely, if the supporting information relates to how the request is fulfilled, it should be supplied in `Task.input`. 

For example, a Placer may wish to indicate that they received confirmation from a Payer that they would pay for a given service, and this may have impacted their choice of treatment. The Placer may indicate this in `Request.input`. If a Placer has collected a Specimen that they expect a Fulfiller will use to perform a Lab Test, this may be indicated in `Task.input`. Details are left to workflow-specific implementation guides. 

Note that Fulfiller systems may also update Task.input on the Coordination Task with details of how they are fulfilling the request. For example, a Fulfiller may ask that a patient complete a Questionnaire. They may then track that this was used as input for their fulfillment of a related Request.   

See also the Workflow Pattern page for [Fulfillers requesting additional information](fulfiller-need-for-additional-info).

### Indicating an Intended Actor:
Requests resources can indiate a requested performer or performerType via the [Request.performer](https://hl7.org/fhir/request-definitions.html#Request.performer) and [Request.performerType](https://hl7.org/fhir/request-definitions.html#Request.performerType) elements. This is only an initial indication from a Placer of what person, device, or organization they would prefer, and is not in and of itself an instruction that these actors should fulfill the request.  

In R5, Task includes elements for both a [Task.owner](https://hl7.org/fhir/task-definitions.html#Task.owner) and a [Task.performer](https://hl7.org/fhir/task-definitions.html#Task.performer). `Task.owner` represents the actor who is currently responsible for the Task. For the Coordination Task, this should be the actor that the Placer considers responsible. Sub-tasks may be created, either by the Placer or the Fulfiller, that describe ownership for individual workflow steps with more granularity, and these may be related back to the Coordination Task via `Task.partof`. 

An additional useful function of `Task.owner` is to indicate to the recipient of a notification whether action is expected _from them_. Workflows may require that additional actors be made aware of a request beyond the Placer and the Fulfiller. For example, if a lab order is placed to test for an infectious disease, an organization's business practice may require that their Infection Control group be made aware of the request, even before the Result has come back. In that case, the Infection Control group may receive a Notification of the request, similar to what the Lab received as an intended Fulfiller. The infection control group can identify that there is no immediate action assigned to them based on the Task.owner (though they may choose to create their own Tasks from that notification). 

`Task.performer` in R5 and later versions may be used to indicate parties who _were_ previously involved in a Task's execution. This should not be confused with the actor who is currently responsible. In workflows that create Output Events, such as a DiagnosticReport, these actors may also be found from the Event. 

### Indicating the Actionability of a Request:
In and of itself (and perhaps confusingly given the name), a FHIR Request does not indicate an instruction to perform an action. The Request resource represents a provider's authorization that the care should occur under their authority. This guide recommends that Task resources be used to indicate a provider's intent that another actor fulfill the request. See the overview in the [Glossary and Key Resources])(./glossary-and-key-resources.html) page for details. 

Implementation Guide authors creating workflow-specific guides should pay special attention to the [Request.intent](https://hl7.org/fhir/request-definitions.html#Request.intent) element, and note that this element is immutable on a given resource. If a provider would like to propose a given service, they may do so with a Request resource with a `.intent` of 'proposal'. For this to become actionable within FHIR, another Request resource must be created with a `.intent` with an appropriate value from the [request-intent valueset](https://hl7.org/fhir/valueset-request-intent.html).    

### Coordinating related requests
The Task resource can be used to coordinate several requests, when they are grouped but not orchestrated (i.e. they are part of the same group, but are not interdependent). See the [Task and Request Grouping](./order-grouping.html) page for details and the example of a [grouped mediations dispense](ex4-meds-grouped-dispense.html). 

In future releases of FHIR, `Task.focus` is planned to expand to 0..* in support of the cases where there is a need to coordinate several requests. For supporting this in R4 and R5, implementers can use a built-in extension mechanism that "imports" an element as an extension. In this case, the task.focus element is imported as an additional extension on Task, thus allowing task.focus to effectively point to several requests.

```
Profile: GroupCoordinationTask
Parent: Task
* extension contains http://hl7.org/fhir/4.0/StructureDefinition/extension-Task.focus named focus 0..* MS
```




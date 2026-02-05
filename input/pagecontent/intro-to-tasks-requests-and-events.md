This page provides additional on how Task, Request, and Event resources are used together within this implementation guide. For those unfamiliar with these types of resources in FHIR Workflows more broadly, see the [Core Concepts](./core-concepts.html) page.

FHIR distinguishes between an **authorization** for care and the **execution** of that care. Request resource represents a Provider's authorization, and FHIR Tasks represent an instruction to fulfill one or more worklow steps related to that Request. 

This guide introduces three types of Tasks for request-fulfillment workflows:
* **Bidding Tasks** which a Placer may create to solicit input from a group of potential fulfillers for whehter and how they could fulfill a request.
* **Coordination Tasks** that a Placer and Fulfiller share to track the status of execution of a request. See [profile](StructureDefinition-coordination-task.html)). The coordination Task is usually the focus of notification to a potential fulfiller or other party of the requested service. For example, a party may become aware of a Request via a Task they have received via POST, via a Message with `MessageHeader.focus` set to the Task, or by a SubscriptionStatus notification with `SubscriptionStatus.notificiationEvent.focus` set to the Task.
* **Cancellation and Modification Tasks** that request that another FHIR Task or FHIR Request be changed. These may be used in circumstances where the cancellation or modification of a request requires, by business agreement, approval by the other party. Though not required, circumstances where this could be helpful include a Placer asking a Fulfiller to cease service after the Fulfiller has already begun, a Fulfiller asking a Placer if an alternative serivce could be performed, or a Fulfiller asking a placer to cancel a Request. A pharmacist may wish to indicate that they do not intend to fulfill a MedicationRequest due to a contraindication, and may propose an alternative course of treatment. See [Cancelling and Modifying Orders](./cancelling-and-modifying-requests.html) and the [Request Cancellation Task profile](StructureDefinition-cancellation-request-task.html).

### Mangaging Sub-Tasks in a Workflow: 
Except for the existence of a Coordination Task, this implementation guide does not impose requirements for what additional Tasks are created in a workflow or when this occurs. Authors of workflow-specific implementation guides may choose to define this.  

Implementation guide authors should be aware of three points when specifying further Tasks:
1. The `Task.owner` element represents the party who currently has the baton for the Task. `Task.performer` represents parties who were previously involved in performing the request. If a workflow requires that  is needed to tie actors to particular Task.outputs or workflow events, multiple Tasks can be beneficial.
2. Sub-tasks that are created in relation to the overall Coordination Task SHOULD refer back to the Coordination Task via `Task.partOf`.
3. The Placer may not need details on all of the individual steps taken by the Fulfiller. Parties are encouraged to ensure that a workflow's overall status of execution may be understood from the overall Coordination Task. This includes linking any Event outputs resulting from the fulfillment of the Request to the Coordination Task's `Task.output`. This could include, for example, DiagnosticReports, Procedures, Questionnaires, ImagingStudy resources, etc.

### Indicating an Intended Actor:
There may be actors in a workflow who should be notified of the existence of a task even if they are not the expected performer of that task. For example - an infection control unit may wish to be informed that a particular test has been ordered. See the [Order Initiation](./order-initiation.html) page for details of how a notification may indicate intended actors. 

### Indicating the Actionability of a Request:
In and of itself (and perhaps confusingly given the name), a FHIR Request does not indicate an instruction to perform an action. The Request resource represents a provider's authorization that the care should occur under their authority. This guide recommends that Task resources be used to indicate a provider's intent that another actor fulfill the request. See the [Order Initiation](./order-initiation.html) page for details.

### Coordinating related requests
The Task resource can be used to coordinate several requests, when they are grouped but not orchestrated (i.e. they are part of the same group, but are not interdependent). See the [Grouped, Related, and Dependent Orders](/grouped-related-and-dependent-orders.html) page for details and the example of a [grouped mediations dispense](ex4-meds-grouped-dispense.html). 

### Tracking an Order's Status:
Request resources can indicate whether a provider's authorization for some care is in a draft status, active, not active, or completed. Task resources represent actions to be taken based on that authorization for care. The fulfillment of each action is tracked via `Task.status`, and further detail may be provided via `Task.businessStatus`. See the [Tracking Workflow Progress](./tracking-workflow-progress.html) page for details.



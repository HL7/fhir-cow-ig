The Task resource is a FHIR resource dedicated to the management of workflows; 
except in very simple workflows, it is expectable that the Task resource will be used in most data exchanges when there are workflow needs. 
**Designers and implementers of systems implementing workflows using FHIR resources are highly recommended to review the [Task resource](https://hl7.org/fhir/Task) pages**.

The Task resource can convey the information for facilitating, steering or documenting the execution:
- Intended Performer - the coded entity that is expected to execute the Request
  - `.requestedPerformer` on `Task`
  - `.perfomerType` and `.performer` this is also available in the Request Pattern
-  Performer - the entity that actually performed the Request
   - In R5 and later `.performer` on `Task`
   - In R4 this would be a pre-adopted extension
- Owner - the entity that is responsible for the executing, delegating, rejecting...
  - In R4 and later the `.owner` on `Task`

This Implementation Guide introduces two specific types of Task that are important for the execution of workflows:
* **Coordination Task** - the preferred way to keep track of statuses, and requested and performed activities (see [profile](StructureDefinition-coordination-task.html)).
* **Cancellation Request Task** - the preferred way to request cancellation of a Request, or of another Task (see [profile](StructureDefinition-cancellation-request-task.html)).  

<br>

Some of the elements that support the key purposes of the Task resource:

### Task creation and execution: **`Task.status`** 
The Task status represents the status of the activity that is being performed. To support system interoperability, the `status` is limited to a set of values.  

### Tracking workflow status: **`Task.businessStatus`**
One of the core aspects in FHIR workflow is that FHIR distinguishes **status of authorization** and **status of execution**. While it is common to consider concepts like "status of the order", in FHIR the status of the order is simply whether an authorization is draft, active, not active, and completed.
The Task resource and specifically `Task.businessStatus` is used to track the actual execution, assigning a code for the status.  

### Focal resource: **`Task.focus`**
Tasks can be used for tracking and coordinating the execution of requests. `Task.focus` indicates which request is being acted upon by the Task and its derivatives, inputs and outputs.   

### Task.input
`Task.input` is used to get the relevant Data for the performer to execute the Request. Examples:
- `Specimen` Resource
- `QuestionnaireResponse` Resource (for example ask at Order Entry Questions)
- etc.


### Task.output
`Task.output` is used to get - if and when available - the output of the Request from the Filler to the Placer. Examples of resources that are typical outputs are:
- `DiagnosticReport`
- `Questionaires`
- `ImageStudy`
- etc.


### Coordinating several requests
The Task resource can be used to coordinate several requests, when they are grouped but not orchestrated (i.e. they are part of the same group, but are not interdependent). 

In future releases of FHIR, `Task.focus` is planned to expand to 0..* in support of the cases where there is a need to coordinate several requests. For supporting this in R4 and R5, implementers can use a built-in extension mechanism that "imports" an element as an extension. In this case, the task.focus element is imported as an additional extension on Task, thus allowing Task.focus to effectively point to several requests.

```
Profile: GroupCoordinationTask
Parent: Task
* extension contains http://hl7.org/fhir/4.0/StructureDefinition/extension-Task.focus named focus 0..* MS
```
See the example of [grouped dispense](ex4-meds-grouped-dispense.html). 



<div markdown="1">
Implementers are invited to provide feedback on the use of Task.focus, and point to input on the coordination of several requests.
</div>
{:.stu-note}

<div markdown="1">
Note to balloters: Throughout this implementation guide there are references to a "performer of a Task". In FHIR R4, the Task resource only has an `owner` element, however FHIR R5 has also added a `performer` element. HL7 invites balloters to provide input on whether the `owner` element is sufficient to represent the performer concept, or if they may be different in some use cases.
</div>
{:.stu-note}


### Mangaging Sub-Tasks in a Workflow

Except for the existence of a Coordination Task, this implementation guide does not impose requirements for what additional Tasks are created in a workflow or when this occurs. Authors of workflow-specific implementation guides may choose to define this.

Implementation guide authors should be aware of three points when specifying further Tasks:

1. The `Task.owner` element represents the party who currently has the baton for the Task. `Task.performer` represents parties who were previously involved in performing the request. If a workflow requires that is needed to tie actors to particular `Task.outputs` or workflow events, multiple Tasks can be beneficial.  
2. Sub-tasks that are created in relation to the overall Coordination Task SHOULD refer back to the Coordination Task via `Task.partOf`.  
3. The Placer may not need details on all of the individual steps taken by the Fulfiller. Parties are encouraged to ensure that a workflow's overall status of execution may be understood from the overall Coordination Task. This includes linking any Event outputs resulting from the fulfillment of the Request to the Coordination Task's `Task.output`. This could include, for example, DiagnosticReports, Procedures, Questionnaires, ImagingStudy resources, etc.

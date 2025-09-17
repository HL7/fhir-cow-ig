This table outlines how a Request can be represented across its lifecycle, independent of the chosen FHIR exchange mechanism. Specification authors building on this IG may convey equivalent states using other methods (e.g., <code>MessageHeader.event</code>), but must ensure that required information is captured in both the Task and the Request. This guidance builds on the [Task state machine](https://hl7.org/fhir/task.html#statemachine)

Not all states will apply to every workflow or use case, and implementations may not need to expose resources for every stage. Authors extending this guide may further refine these states using elements like <code>Task.businessStatus</code> to suit specific needs.

<div markdown="1">
Note to balloters: Throughout this implementation guide there are references to a "performer of a Task". In FHIR R4, the Task resource only has an `owner` element, however FHIR R5 has also added a `performer` element. HL7 invites balloters to provide input on whether the `owner` element is sufficient to represent the performer concept, or if they may be different in some use cases.
</div>
{:.stu-note}

### Common workflow states

| Workflow State to Represent | Request resource representation |Task resource representation | Event resources representation | Descriptions |
| ----------------------------- | -----------------------------| -----------------------------| -----------------------------| -----------------------------| 
| Request Placed (no designated performer)        | Request:<br>- Status: active<br>- Intent: order<br>- 0..* SupportingInfo   | Task:<br>- Status: requested<br>- Focus: [the Request]<br>- Performer: [null]<br>- Code: fulfill<br>- Intent: order<br>- 0..* Input  | *Not set*  | This state can be a starting point for cases where the patient chooses the performer, cases when someone can *claim* the task, etc.       |
| Request placed and performer selected           | Request:<br>- Status: active<br>- Intent: order         | Task:<br>- Status: requested<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order     | *Not set*  | This state can be a starting point for systems where the authorization of a request and the selection of a performer are done at the same time.  |
| Request Placed and Multiple Potential Performers Notified | Request:<br>- Status: active<br>- Intent: order         | 1..* Tasks:<br>- Status: requested<br>- Performer: [specified]<br>- Code: request-fulfillment<br>- Intent: order  | *Not set*          | This state can be a starting point for systems where there are multiple potential Fulfillers and they *bid* for the fulfillment.    |
| Potential Fulfiller Awaiting for Information    | Request:<br>- Status: active<br>- Intent: order     | 1 Task:<br>- Status: received<br>- BusinessStatus: Awaiting Information<br>- StatusReason/ReasonReference: [details on the information needed]<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order<br><br>0..* Tasks for other potential Fulfillers still seeking fulfillment | *Not set*          | |
| Fulfiller Accepted          | Request:<br>- Status: active<br>- Intent: order     | 1..* Task:<br>- Status: accepted<br>- Performer: [specified]<br>- Code: request-fulfillment<br>- Intent: order  | *Not set*          | This state may be used where several potential Fulfillers may indicate they can provide service, and the Placer and Patient then choose.         |
| Fulfiller Selected          | Request:<br>- Status: active<br>- Intent: order     | 1 Task:<br>- Status: accepted<br>- BusinessStatus: selected<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order<br><br>0..* Task:<br>- Status: cancelled<br>- StatusReason: not selected<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order | *Not set*          | This state represents the selection of one out of possibly multiple Fulfillers who had bid on the Task.          |
| In Progress       | Request:<br>- Status: active<br>- Intent: order     | Task:<br>- Status: in-progress<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order      | *Not set*          |    |
| Partial fulfillment         | Request:<br>- Status: active<br>- Intent: order     | Task:<br>- Status: in-progress<br>- BusinessStatus: [images available, end exam, awaiting interpretation, etc.]<br>- Code: fulfill<br>- Intent: order           | Awaiting Interpretation      |    | 
| Partial fulfillment         | Request:<br>- Status: active<br>- Intent: order     | Task:<br>- Status: in-progress<br>- BusinessStatus: [images available, end exam, awaiting interpretation, etc.]<br>- Code: fulfill<br>- Intent: order<br>- 1..* Output    | Draft    |    |
| Preliminary fulfillment     | Request:<br>- Status: active<br>- Intent: order     | Task:<br>- Status: in-progress<br>- BusinessStatus: Preliminary<br>- Code: fulfill<br>- Intent: order<br>- 1..* Output   | Preliminary        |    |
| Complete          | Request:<br>- Status: completed<br>- Intent: order  | Task:<br>- Status: completed<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order<br>- 0..* Output (DiagnosticReport, Observations, DocumentReference, CarePlan, etc.)   | Complete (if service has an output) | |
{: .grid .table-striped}


<br>

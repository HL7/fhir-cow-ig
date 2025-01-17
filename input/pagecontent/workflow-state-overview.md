TO DO: Workflow state vs Order state


The below represents a set of states as triggered by a request. Not all of these states states will apply to all workflows or use-cases. This guidance builds on the [Task State 
Machine]([url](https://build.fhir.org/workflow-communications.html#12.10.2)) and is intended to provide a way to communicate the status of a request regardless of the choice of FHIR exhcange mechanism.


### Common workflow states


| Workflow State to Represent  | Request resource representation  | Task resource representation  | Event resources representation | Descriptions   |   |
| ------------| -----| -------| ------| ----|---|
| Request Placed (no designated performer)        | Request:<br>- Status: active<br>- Intent: order<br>- 0..* SupportingInfo   | Task:<br>- Status: requested<br>- Focus: [the ServiceRequest]<br>- Performer: [null]<br>- Code: fulfill<br>- Intent: order<br>- 0..* Input  | *Not set*  | This state can be a starting point for cases where the patient chooses the performer, cases when someone can *claim* the task, etc.       ||
| Request placed and Performer Selected           | Request:<br>- Status: active<br>- Intent: order         | Task:<br>- Status: requested<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order     | *Not set*  | This state can be a starting point for systems where the decision to authorize the request and determining the performer is done at the same time.  ||
| Request Placed and Multiple Potential Performers Notified | Request:<br>- Status: active<br>- Intent: order         | 1..* Tasks:<br>- Status: requested<br>- Performer: [specified]<br>- Code: request-fulfillment<br>- Intent: order  | *Not set*          | This state can be a starting point for systems where there are multiple potential fulfillers and they *bid* for the fulfillment.    ||
| Potential Fulfiller Awaiting for Information    | Request:<br>- Status: active<br>- Intent: order     | 1 Task:<br>- Status: received<br>- BusinessStatus: Awaiting Information<br>- StatusReason/ReasonReference: [details on the information needed]<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order<br><br>0..* Tasks for other potential fulfillers still seeking fulfillment | *Not set*          | NOTE - challenge still to address. StatusReason is 0..1. Could be waiting for multiple pieces of information.    ||
| Fulfiller Accepted          | Request:<br>- Status: active<br>- Intent: order     | 1..* Task:<br>- Status: accepted<br>- Performer: [specified]<br>- Code: request-fulfillment<br>- Intent: order  | *Not set*          | This state represents one or more potential fulfillers who are bidding for the Task.         ||
| Fulfiller Selected          | Request:<br>- Status: active<br>- Intent: order     | 1 Task:<br>- Status: accepted<br>- BusinessStatus: selected<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order<br><br>0..* Task:<br>- Status: cancelled<br>- StatusReason: not selected<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order | *Not set*          | This state represents the selection of one out of possibly multiple fulfillers who had bid on the Task.          ||
| In Progress       | Request:<br>- Status: active<br>- Intent: order     | Task:<br>- Status: in-progress<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order      | *Not set*          |    ||
| Partial fulfillment         | Request:<br>- Status: active<br>- Intent: order     | Task:<br>- Status: in-progress<br>- BusinessStatus: [images available, end exam, awaiting interp, etc.]<br>- Code: fulfill<br>- Intent: order           | Awaiting Interpretation      |    | |
| Partial fulfillment         | Request:<br>- Status: active<br>- Intent: order     | Task:<br>- Status: in-progress<br>- BusinessStatus: [images available, end exam, awaiting interp, etc.]<br>- Code: fulfill<br>- Intent: order<br>- 1..* Output    | Draft    |    ||
| Preliminary fulfillment     | Request:<br>- Status: active<br>- Intent: order     | Task:<br>- Status: in-progress<br>- BusinessStatus: Preliminary<br>- Code: fulfill<br>- Intent: order<br>- 1..* Output   | Preliminary        |    ||
| Complete          | Request:<br>- Status: completed<br>- Intent: order  | Task:<br>- Status: completed<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order<br>- 0..* Output (DiagnosticReport, Observations, DocumentReference, CarePlan, etc.)   | Complete (if service has an output) |    ||
{:.table-bordered .table-hover .table-sm}


<br>
These table outline how a Request can be represented across its lifecycle independent of the chosen FHIR exchange mechanism. Specification authors building on this IG may convey equivalent states using other methods (e.g., <code>MessageHeader.event</code>), but must ensure that required information is captured in both the Task and the Request. This guidance builds on the [Task state machine](https://hl7.org/fhir/task.html#statemachine)

Not all states will apply to every workflow or use case, and implementations may not need to expose resources for every stage. Authors extending this guide may further refine these states using elements like <code>Task.businessStatus</code> to suit specific needs.

TODO - should we combine this with the Fulfiller Selection page?

### Request to a Single Fulfiller with Acceptance

In this example, the placer and the fulfiller's business agreement requires that the fulfiller confirm whether they can perform the desired service.

{% include img.html img="request-accept.png" %}

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Task at Fulfiller with Subscriptions<button type="button" class="btn btn-default top-align-text" style="float: right;" data-target="#fig5" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig5" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include subscriptions-with-acceptance-task-at-fulfiller.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Task at Placer with Subscriptions<button type="button" class="btn btn-default" style="float: right;" data-target="#fig4" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig4" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include subscriptions-with-acceptance-task-at-placer.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

| Workflow State to Represent                               | Request resource representation                                            |Task resource representation                                                                                                                                                                                                                                                                          | Event resources representation      | Descriptions |
| -----------------------------                             | -----------------------------                                              | -----------------------------                                                                                                                                                                                                                                                                        | -----------------------------       | -----------------------------| 
| Request placed and performer selected                     | Request:<br>- Status: active<br>- Intent: order                            | Coordination Task:<br>- Status: requested<br>- Owner: [specified]<br>- Code: fulfill<br>- Intent: order                                                                                                                                                                                              | *Not set*                           | This state can be a starting point for systems where the authorization of a request and the selection of a performer are done at the same time.  |
| Fulfiller Awaiting  Information                           | Request:<br>- Status: active<br>- Intent: order                            | Coordination Task:<br>- Status: received<br>- BusinessStatus: Awaiting Information<br>- StatusReason/ReasonReference: [details on the information needed, such as a questionnaire or Task back to the placer]<br>- Owner: [specified]<br>- Code: fulfill<br>- Intent: order                          | *Not set*                           | |
| Fulfiller Accepted                                        | Request:<br>- Status: active<br>- Intent: order                            | Coordination Task:<br>- Status: accepted<br>- Owner: [specified]<br>- Code: request-fulfillment<br>- Intent: order                                                                                                                                                                                   | *Not set*                           |          |
| In Progress                                               | Request:<br>- Status: active<br>- Intent: order                            | Coordination Task:<br>- Status: in-progress<br>- Owner: [specified]<br>- Code: fulfill<br>- Intent: order                                                                                                                                                                                            | *Not set*                           |    |
| Partial fulfillment                                       | Request:<br>- Status: active<br>- Intent: order                            | Coordination Task:<br>- Status: in-progress<br>- BusinessStatus: [images available, end exam, awaiting interpretation, etc.]<br>- Code: fulfill<br>- Intent: order                                                                                                                                   | Awaiting Interpretation             |    | 
| Partial fulfillment                                       | Request:<br>- Status: active<br>- Intent: order                            | Coordination Task:<br>- Status: in-progress<br>- BusinessStatus: [images available, end exam, awaiting interpretation, etc.]<br>- Code: fulfill<br>- Intent: order<br>- 1..* Output                                                                                                                  | Draft                               | Unlike the previous state, an output has been started, but is still in a draft state. This may not be surfaceable    |
| Preliminary fulfillment                                   | Request:<br>- Status: active<br>- Intent: order                            | Coordination Task:<br>- Status: in-progress<br>- BusinessStatus: Preliminary<br>- Code: fulfill<br>- Intent: order<br>- 1..* Output                                                                                                                                                                  | Preliminary                         |    |
| Complete                                                  | Request:<br>- Status: completed<br>- Intent: order                         | Coordination Task:<br>- Status: completed<br>- Owner: [specified]<br>- Code: fulfill<br>- Intent: order<br>- 0..* Output (DiagnosticReport, Observations, DocumentReference, CarePlan, etc.)                                                                                                         | Complete (if service has an output) | |
{: .grid .table-striped}

### Request to Bid to Multiple Fulfillers:
This flow differs from the previous flow in that multiple potential fulfillers are informed of the request. Potential fulfillers may respond with information about their ability to perform the service, before the patient and their provider ultimately choose a performer. 

{% include img.html img="request-bid.png" %}

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Subscriptions - Task at Placer Example<button type="button" class="btn btn-default" style="float: right;" data-target="#fig9" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig9" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include subscriptions-bid-task-at-placer.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

| Workflow State to Represent                               | Request resource representation                                            |Task resource representation                                                                                                                                                                                                                                                                         | Event resources representation      | Descriptions |
| -----------------------------                             | -----------------------------                                              | -----------------------------                                                                                                                                                                                                                                                                       | -----------------------------       | -----------------------------| 
| Request Placed and Multiple Potential Performers Notified | Request:<br>- Status: active<br>- Intent: order                            | 1..* Bidding Tasks:<br>- Status: requested<br>- Owner: [specified]<br>- Code: request-fulfillment <br>- Intent: bid                                                                                                                                                                                 | *Not set*                           | This state can be a starting point for systems where there are multiple potential fulfillers and they *bid* for the fulfillment.    |
| Potential Fulfiller Awaiting Information                  | Request:<br>- Status: active<br>- Intent: order                            | 1 Bidding Task:<br>- Status: received<br>- BusinessStatus: Awaiting Information< br>- StatusReason/ReasonReference: [details on the information needed]<br>- Owner: [specified]<br>- Code: request-fulfillment <br>- Intent: bid<br><br>0..* Tasks for other potential fulfillers                   | *Not set*                           | |
| Fulfiller Accepted                                        | Request:<br>- Status: active<br>- Intent: order                            | 1..* Bidding Task:<br>- Status: accepted<br>- Owner: [specified]<br>- Code: request-fulfillment<br>- Intent: bid                                                                                                                                                                                    | *Not set*                           | A fulfiller has indicated they are willing to perform the service, and perhaps provided a 'bid' with details, such as when they could start |
| Fulfiller Selected                                        | Request:<br>- Status: active<br>- Intent: order                            | 1 Coordination Task:<br>- Status: accepted<br>- basedOn: [Bidding Task]<br>- Owner: [specified]<br>- Code: request-fulfillment<br>- Intent: order<br><br>0..* Bidding Tasks:<br>- Status: cancelled<br>- StatusReason: not selected<br>- Owner: [specified]<br>- Code: fulfill<br>- Intent: bid     | *Not set*                           | The Placer and Patient have reviewed one or more bids and found one acceptable.|
{: .grid .table-striped}

Once the fulfiller has been selected, the workflow continues in a manner similar to the previous example.


### Provider Authorization and Patient Selection:

Many orders and referrals take the form that a provider 'authorizes' that care with another provider may occur, but the patient (or their agent) then manages the coordination of that care. Once the patient has selected a performer, that performer may wish to query additional information (including the authorization) and to share information with the original requestor. 

Examples:
* In community prescriptions, the Patient usually chooses a Pharmacy.
* A requestor may indicate that a blood draw should occur for a patient. The patient may choose for themselves to which lab they will present (perhaps one lab is on their commute between their home and work).
* A provider may determine that a patient would benefit from receiving care in a long term care facility, and authorize that level of service. The patient and their family may consider several care facilities before deciding which they like.
* A patient may discuss with their primary care provider that they would like to see a specialist, such as OB/MFM, an orthopedist, a psychologist, etc. The GP may authorize this service without having a specific performer in mind, and may rely on the patient to then find a specialist.  

{% include img.html img="request-patient.png" %}

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Subscriptions - Task at Fulfiller Example <button type="button" class="btn btn-default top-align-text" style="float: right;" data-target="#fig7" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig7" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include subscriptions-task-at-fulfiller-patient.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

TODO: is this better without the Coordination Task at the Placer? This does make it clear no one else has started.

| Workflow State to Represent                               | Request resource representation                                            |Task resource representation                                                                                                                                                                                                                                                                          | Event resources representation      | Descriptions |
| -----------------------------                             | -----------------------------                                              | -----------------------------                                                                                                                                                                                                                                                                        | -----------------------------       | -----------------------------| 
| Request placed (no designated performer)                  | Request:<br>- Status: active<br>- Intent: order                            | Not created or created with Owner not set                                                                                                                                                                                             | *Not set*                           | This state can be a starting point for systems where the authorization of a request and the selection of a performer are done at the same time.  |
| Performer selected by patient                             | Request:<br>- Status: active<br>- Intent: order                            | Coordination Task:<br>- Status: in-progress<br>- Owner: [specified]<br>- Code: fulfill<br>- Intent: order                                                                                                                                                                                            | *Not set*                           |    |
{: .grid .table-striped}

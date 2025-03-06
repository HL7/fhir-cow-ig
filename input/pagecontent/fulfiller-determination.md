There are several ways a fulfiller is determined.   

A placer may initiate and authorize:
* A simple order, in which a placer creates a request and directs it to a specific performer who the placer is confident will make a best-effort attempt to fulfill the request. 
* A simple referral, in which a placer creates a request for a specific intended performer, but the selected performer may decline to perform the requested service.
* A request which a patient then uses to seek service at a place of their choosing.
* A request which a placer directs to an expected performer, with the option that a patient may elect to receive the service elsewhere.
* A request that may be broadcasted to several potential performers, in which any of them may claim the request.
* A request sent to several potential performers, where the requestor and patient will then review proposals or bids sent back by the performers before selecting a definite performer.
* A request to a central coordinator who will assign the request to a performer and notify the requestor of who will fulfill the request.
* A request to a central coordinator who will assign the request to a performer and additionally mediate further communication between the requestor and performer. (TODO - decide if including. Grahame paper).

### Placer assigned

In the most simple flow, the placer creates a request and indicates the specific fulfiller that should perform it. In this scenario, the placer is confident - based on pre-coordinated business and IT agreements, availability, etc. - that the performer won't decline the request.

Based on the workflow of interest, the performer may or may not notify the requestor of an 'outcome' at a later time. 

{% include img.html img="request-simplest.png" %}


Examples: 
[Scenario 1 - Placer-assigned Lab order tracking with Task](ExampleScenario-scenario1-lab-order.html)

##### Task at Fulfiller

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Task at Fulfiller<button type="button" class="btn btn-default top-align-text" style="float: right;" data-target="#fig2" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig2" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include no-decline-subscriptions-task-at-fulfiller.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

#### Example using Task at Placer with Subscriptions

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Task at Placer with Subscriptions<button type="button" class="btn btn-default top-align-text" style="float: right;" data-target="#fig1" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig1" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include subscriptions-no-decline-task-at-placer.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

#### Example using Messaging (Relying on Identifiers)

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Messaging <button type="button" class="btn btn-default top-align-text" style="float: right;" data-target="#fig3" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig3" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include messaging-no-decline.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

<hr>

<hr>


### Request with acceptance

When a requestor can't be certain of whether the fulfiller will be willing to perform a service (based on availability, insurance, etc.), they may ask the fulfiller to confirm that they accept the proposed service. If the performer declines to perform the service (or fails to respond within a pre-coordinated period), the requestor may choose to follow up with other potential performers. 

{% include img.html img="request-accept.png" %}

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Task at Fulfiller<button type="button" class="btn btn-default top-align-text" style="float: right;" data-target="#fig5" data-toggle="collapse">+</button></div>
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

#### Example using Messaging (Relying on Identifiers)

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Messaging <button type="button" class="btn btn-default top-align-text" style="float: right;" data-target="#fig6" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig6" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include messaging-with-acceptance.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

<hr>

### Patient-mediated requests
Many orders and referrals take the form that a provider 'authorizes' that care with another provider may occur, but the patient (or their agent) then manages the coordination of that care. Once the patient has selected a performer, that performer may wish to query additional information (including the authorization) and to share information with the original requestor. 

Examples:
* In community prescriptions, the Patient usually chooses a Pharmacy.
* A requestor may indicate that a blood draw should occur for a patient. The patient may choose for themselves to which lab they will present (perhaps one lab is on their commute between their home and work).
* A provider may determine that a patient would benefit from receiving care in a long term care facility, and authorize that level of service. The patient and their family may consider several care facilities before deciding which they like.
* A patient may discuss with their primary care provider that they would like to see a specialist, such as OB/MFM, an orthopedist, a psychologist, etc. The GP may authorize this service without having a specific performer in mind, and may rely on the patient to then find a specialist.  

{% include img.html img="request-patient.png" %}

##### Example with Subscriptions with Task at Fulfiller

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Subscriptions - Task at Fulfiller <button type="button" class="btn btn-default top-align-text" style="float: right;" data-target="#fig7" data-toggle="collapse">+</button></div>
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

<hr>


### Request with multiple performers

Sometimes, a requestor may choose to immediately notify several potential performers that a service has been requested. If the requestor and the patient do not have a preference around who will perform the service, it may be that the first potential fulfiller to indicate availability may functionally 'claim' that service.

{% include img.html img="request-claim.png" %}

This can be accomplished by leveraging the Request-with-Acceptance flow, and keeping a separate task per potential fulfiller. For brevity, only one flow is described here. 

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Subscriptions - Task at Placer<button type="button" class="btn btn-default" style="float: right;" data-target="#fig8" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig8" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include subscriptions-multiple-claim-task-at-placer.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

<hr>


### Request with multiple performers with bidding

Alternatively (and more often), a requestor may notify one or more potential fulfillers that they have a which must be performed. Those potential fulfillers may respond back with a 'bid' describing the service they could perform. The details of that 'bid' will vary by care-domain, but may indicate the performer's availability, the details of a more specific service they would perform, cost, information about the specific performer who may provide the service, etc.

The requestor and the patient may then review the information received from potential performers and then decide which specific performer will be used. 

{% include img.html img="request-bid.png" %}

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Subscriptions - Task at Placer<button type="button" class="btn btn-default" style="float: right;" data-target="#fig9" data-toggle="collapse">+</button></div>
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

<hr>


### Requests to a central coordinator
Many locales and care domains rely on a central coordinator to manage some aspects of an order, referral, or transfer workflow. In these flows, a requestor notifies a central management group that they have a service which must be performed, and that central management group may then triage, notify performers, assign providers, or perhaps even schedule the service.

Details may vary considerably by business agreements (such as whether the coordinator may _assign_ a request to a performer, or merely notify them) and architecture.

Some common reasons for a central coordinator include:
* Facilitating triage of scarce resources
* Managing waitlists
* Facilitating some parts of the exchange like endpoint discovery and client registration

{% include img.html img="request-central.png" %}

Given the variability, this section is provided only for illustrative value. This section outlines two potential configurations (of several) based on the capabilities of the broker. The intent of the first example is that (with regards to exchange functionality) the Placer need be only minimally aware of whether they are interacting with a coordinator or with a fulfiller directly. 

In the second flow, the coordinator may identify relevant service providers, triage the request, and even assign the request. In this exmaple, once the assignment has occurred, the Placer then interacts directly with the designated Fulfiller. This saves on the need for the Coordinator to faciliate rewrites or for Placers to track Provenance on outputs, but may require greater pre-coordination to facilitate Client Registration.  

Other IGs may build on top of this to include details of the endpoint discovery, handling holds the coordinator may place on an assigned Fulfiller, tracking authorization from a coordinator, etc. 

Similar flows may be constructed using FHIR Subscriptions with the original Task hosted at the Placer or via FHIR messaging. 

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Coordinator Mediated Exchange<button type="button" class="btn btn-default" style="float: right;" data-target="#fig10" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig10" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include subscriptions-task-at-coordinator-mediating-requests.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">Initial Request to Triage With Later Direct Communication<button type="button" class="btn btn-default" style="float: right;" data-target="#fig11" data-toggle="collapse">+</button></div>
  </div>
  <div id="fig11" class="panel-collapse collapse">
    <div class="panel-body">
        <figure>
        {%include subscriptions-task-at-fulfiller-coordinator-handoff.svg%}
        </figure>
        <br clear="all"/>
    </div>
  </div>
</div>

<hr>


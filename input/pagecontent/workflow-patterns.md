This page provides an overview of how Requests may be coordinated across actors using a variety of exchange patterns. This is illustrative and meant to convey one end-to-end flow; details are provided elsewhere.

<div markdown="1">
Note to balloters: Throughout this page there are references to a "performer of a Task". In FHIR R4, the Task resource only has an `owner` element, however FHIR R5 has also added a `performer` element. HL7 invites balloters to provide input on whether the `owner` element is sufficient to represent the performer concept, or if they may be different in some use cases.
</div>
{:.stu-note}

The other pages in this section outline considerations for specific parts of a Request's lifecycle in FHIR. These include:
* **Order initiation**:  
This section addresses aspects of how orders are created that relate to FHIR workflows. Many details are left to implementers or more specific implementation guides. 

* **Order grouping**  
How multiple requests for service (or multi-item requests) may be communicated and how dependencies between requests may be communicated and coordinated.

* **Fulfiller determination**  
After a request has been created, how a fulfiller for that service is selected. This could be direct assignment by a placer, assignment by a central triage or coordination office, or patient-selection.

* **Requests by a Fulfiller for additional information**  
How potential Fulfillers may ask for additional information about a Request, either while determining if they can fulfill the Request or later.

* **Cancelling and modifying orders**  
This section describes how Placers and Fulfillers may modify a request once it has been created. This includes:
    * A placer cancelling a request before service has begun
    * A placer requesting that an in-progress request for service be cancelled
    * A fulfiller proposing an alternative service back to the placer
    * A fulfiller electing to perform a more specific service under their own authority
    * A fulfiller informing a placer that they can no longer perform a service

* **Sharing outputs from an order**  
How the outputs from a Request, such as a diagnostic result report or a consult note, may be linked back to the original Request and shared between actors. This includes how actors may make the Outputs discoverable for others involved in a patient's care later, even if the later actors can only contact the Placer. 

<br>

### Overview Example - Coordination Task at Fulfiller with Optional Subscriptions
The below is an overview of how a Request may be coordinated with the Coordination Task hosted at the Fulfiller. In this example, the Placer and the Fulfiller have pre-coordinated that the Placer is Subscribed to updates on Tasks that they originate. Note, however, that this is optional for the example: a Placer could query for updates on the Coordination Task at some expected date or ahead of their next visit with the patient. 

Many details are deferred for more detailed discussions elsewhere in this guide or for later implementation guides. 

<figure>
  {% include subscriptions-general-example-task-at-fulfiller.svg %} 
</figure>

<br>

### Overview Example - Subscriptions with Task at Placer
The below is a similar overview in which the Coordination Task is hosted at the Placer. In this example, the Placer and the Fulfiller have pre-coordinated that the Fulfiller is Subscribed to Tasks that the Placer creates for them in which the Fulfiller is the expected Task.performer. 

<!--
<figure>
  {% include subscriptions-general-example-task-at-placer.svg %} 
</figure>
-->

{% include svg.html img="subscriptions-general-example-task-at-placer.svg" %}

<br>

### Overview Example - Messaging
Equivalent flows can be constructed via FHIR Messaging. The Placer and the Fulfiller pre-coordinate their endpoints and events of interest, just as with Messaging. The key distinction is that (in this example, where we assume no FHIR servers may be queried RESTfully) the notifications must contain the information the Placer anticipates the Fulfiller will need. Just as in HL7 v2 messaging today, actors rely on shared identifiers and reliable messaging to coordinate State.

<figure>
  {% include pure-messaging-with-placer-identifiers.svg %} 
</figure>


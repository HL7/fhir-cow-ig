This section describes several patterns of interaction for order, referral, and transfer workflows, with a brief description of clinical scenarios in which they may apply.

The areas identified in this Implementation Guide are:

* **Order initiation**:  
(TO DO) This section addresses some aspects of how orders are created - some of those aspects are workflow-related and are identified here, while others are detailed in other specifications or are not currently in scope.

* **Fulfiller determination**  
After a request has been created, this section describes how a fulfiller for that service is selected. This could be direct assignment by a placer, assignment by a central triage or coordination office, or patient-selection.

* **Requests by a fulfiller for additional information**  
This section also describes how potential fulfillers may request additional information about the requested service, which may be important to their determining if they will accept the request for service. 

* **Cancelling and modifying orders**  
This section describes how placers and fulfillers may modify a request once it has been created. This includes:
    * A placer cancelling a request before service has begun
    * A placer requesting that an in-progress request for service be cancelled
    * A fulfiller proposing an alternative service back to the placer
    * A fulfiller electing to perform a more specific service under their own authority
    * A fulfiller informing a placer that they can no longer perform a service

* **Order grouping**  
This section addresses how multiple requests for service may be communicated and, briefly, how dependencies between requests may be communicated and coordinated.

* **Sharing outputs from an order**  
This section describes how the outputs from a request for service, such as a diagnostic result report, a consult note, or other content, may be linked back to the request and shared between actors. This section does not specify any requirements on the content of such outputs or when such outputs must be present. Instead, it specifies merely how they are linked across FHIR servers to aid discoverability. 


<hr>
<hr>
<hr>


### Overview Example - Subscriptions with Task at Placer
The below is a general overview of how Subscriptions may be used with the coordinating Task hosted at the Placer. Many details are deferred for more detailed discussions elsewhere in this guide for for later implementation guides. 

<!--
<figure>
  {% include subscriptions-general-example-task-at-placer.svg %} 
</figure>
-->

{% include svg.html img="subscriptions-general-example-task-at-placer.svg" %}

### Overview Example - Subscriptions with Task at Fulfiller

<div>
  {% include subscriptions-general-example-task-at-fulfiller.svg %} 
</div>


### Overview Example - Messaging
<figure>
  {% include pure-messaging-with-placer-identifiers.svg %} 
</figure>


This section provides an overview of FHIR resources may be used to faciliate requests for service. For those new to this space, this section may be best read alongside the Overview of Workflow Patterns page, which descirbes how the concepts described below may be applied to an end-to-end workflow. 

### Actors:

This guide describes actions between those who create requests for service and those who perform services. A variety of terms are used. For our purposes:

* **Placer, (service) requestor, referrer, and prescriber** may all be considered equivalent for the purposes of this guide. We generally try to avoid the term "Requestor" to avoid ambiguity with the client-server interactions. 
* **Performer and fulfiller** may be considered equivalent. In many contexts, these actors may also be thought of as *potential* fulfillers or performers. This is excluded in most places for brevity unless the distinction may lead to confusion.
* **Patient** may refer either to the person to whom a service will be given or, in some workflow steps, their healthcare agent or some other non-healthcare decision maker helping to coordinate a patient's care. For example, a young patient's parent may help to coordinate where that patient will receive care, or a social worker may assist a patient with post-discharge placement.

### Requests, Tasks, and Outputs Events:
This section provides a brief overview of how FHIR resources are used to represent a workflow. See the [Workflow Resource Patterns](https://www.hl7.org/fhir/workflow.html#respatterns) section for more details. 

* **Request** resources are the FHIR representation of the request for that a provider is creating, proposing, or authorizing. These request resources contain at least minimal information about the action to be performed, the overall status of the request, and links to supporting information. Examples include FHIR ServiceRequests and DeviceRequests. In this guide, the source-of-truth ServiceRequest is always 'hosted' on the system in which the request for service (or the proposed modification for service, etc.) originated. See the 'Cancelling and modifying requests' workflow pattern for more details. This guide supports that a placer may choose to create a single ServiceRequest, which any of several fulfillers may perform, or a single ServiceRequest per potential fufliller.
  
* **Task** resources can serve many purposes. In this guide, Tasks serve a core role of helping a placer and a _specific_ *potential*, or *eventual* fulfiller manage the status of a request (in scenarios where FHIR servers are used). Many Tasks MAY correspond to the same ServiceRequest, and (for the purposes of coordination) separate Shared Coordination Tasks are generated for each placer and (potential) fulfiller pair. For example, if a hospital would like to coordinate transportation assistance for a patient, they may create a single "transportation ServiceRequest" for that patient, with one Task per potential provider of transportation (each of which references the same ServiceRequest), or separate ServiceRequest and Task resources per fulfiller. Placers and fulfillers must pre-coordinate where their shared Shared Coordination Task will be hosted to ensure there is always an agreed upon source of truth. 
  
* **Output Events** - requests for service may result in a variety of output events, each with their own representation in FHIR. For the purposes of this IG, we refer to these generically without specifying their form. Example outputs that could be generated include a DocumentReference for a Consult Note, a DiagnosticReport and set of Observations for a lab, a CarePlan describing proposed care, or even new ServiceRequests. In scenarios with FHIR servers, this IG specifies that Outputs may be linked back to an originating ServiceRequest via Task.Output, where the Tasks (eventually) point back to a ServiceRequest via Task.BasedOn and ServiceRequest.basedOn.  It is also possible that a request could result in no output (such as a request for transportation), or that a request could result in only a partial output. See the "Sharing outputs of referrals and orders" Workflow Patterns section for additional detail. This guide assumes that in most cases the (source of truth) Resource representing the Output is hosted on the Fulfiller's FHIR server, although the Placer may of course have a copy that they can in turn surface to others. 

{% include img.html img="relation-of-placer-request-task-output-filler.png" %}

### Authorization and Authorization Base:

As discussed in the Background section, actors in a RESTful exchange often wish to limit the set of resources that another actor may access (or the interactions they may initiate), with more granularity than what is provided with traditional OAuth 2.0 scopes. 

This guide recommends two complementary options, though their use is optional within this IG:

1. Actors may leverage [SMART v2 scopes](https://hl7.org/fhir/smart-app-launch/) to provide finer-grained control of what another actor may access. For example, a Placer may indicate that a Fulfiller can query only for ServiceRequests of a particular category, such as ServiceRequests related social care referrals or Observation resources related to Labs.
2. Senders of a notification may optionally include an [authorization hint](https://build.fhir.org/ig/HL7/fhir-subscription-backport-ig/StructureDefinition-notification-authorization-hint.html) that the recipient may redeem while requesting an access token. Such an authorization hint (also called an authorization_base in some specifications) may be used by its creator to tailor the set of resources the actor presenting the authorization hint (and requesting an access token) may access. As an example, this can be used to limit a Service Provider to only obtaining information for patients for whom an authorization hint has been sent to them as part of a referral notification, rather than allowing them access to all patients in the database.  

### Sharing Content When Intermediaries Are Present:

Most examples in this guide assume that a fulfiller and a placer may communicate directly. In reality, there are often intermediaries. For example, a clinician may collect a specimen and send it to a community lab, only for the community lab to forward the specimen to a reference lab. 

Such "chain care" is common. While it presents complexities, scenarios like this are also a motivation for many of the abstractions this guide recommends. Consider a model like the below, where a request originates from some "upstream" actor (such N-1), and a later fulfiller (such as Actor N+1) then needs information that an earlier actor possessed.

{% include img.html img="sharing-info-with-intermediaries.png" %}

If the actors are able to communicate, and if references across notifications were preserved, the fulfiller may query the placer directly. Whether these actors can communicate depends on the broader exchange ecosystem. In environments with well known endpoints, extensive (or dynamic) client registration, broad agreement on scopes and business rules, etc., such direct communication may be possible. 

In environments where the fulfillers and the placer may be unable to communicate, an intermediary may need to store local representations of information so they may provide it to later actors. Alternatively, actors may "proxy" requests from later actors to those upstream. In either of these scenarios, when forwarding requests, a party must rewrite references within the notification they create to point to their own server, rather than actors upstream.

Alternatively, actors in the chain can reduce the importance of references by including in the body of their notifications (whether that is a Message, a SubscriptionStatus notification, etc.) the information that they expect later parties in the chain will need in order to process a request. 

These scenarios also further motivate the guidance that Tasks, rather than requests, be the focus of communication, as this ensures that Notification N-1 and Notification N in the diagram may of the same structure, and the Placer need not (necessarily) be aware of the organization downstream: each pair of actors need merely agree upon how they will coordinate the Shared Coordination Task for their pair. More complex exchanges may then be composed of the parts. 

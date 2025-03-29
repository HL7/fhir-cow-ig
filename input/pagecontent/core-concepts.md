This section provides an overview of FHIR resources used to support Request workflows. Readers new to the topic may find it helpful to review this alongside the Overview of Workflow Patterns page, which shows how these concepts apply to end-to-end workflows. 

### Actors:

This guide describes interactions between those requesting and those performing services. The following terms are used:

* **Placer, requestor, referrer, and prescriber** are treated as equivalent. We generally avoid "Requestor" to prevent confusion with client-server terminology.
* **Performer and fulfiller** are also considered equivalent. These often refer to potential fulfillers, though we omit "potential" unless needed for clarity
* **Patient** refers to the individual receiving care, but may also include their representative—such as a parent, healthcare agent, or social worker—when they participate in coordinating services.

### Requests, Tasks, and Outputs Events:
This section provides a brief overview of how FHIR resources are used to represent Request workflows. For more detail, see [Workflow Resource Patterns](https://www.hl7.org/fhir/workflow.html#respatterns). 

* **Request resources** (e.g., ServiceRequest, DeviceRequest, MedicationRequest) are the FHIR representation of the request that a provider is creating, proposing, or authorizing. These request resources contain at least minimal information about the action to be performed, the overall status of the request, and links to supporting information. In this guide, the source-of-truth Request is always 'hosted' on the system in which the Request (or the proposed modification) originated. See the 'Cancelling and modifying requests' workflow pattern for details. A Placer may create a single Request, which any of several Fulfillers may perform, or a single Request per potential Fufliller.
  
* **Task resources** play multiple roles. In this guide, Most notably, this guide uses Coordination Tasks to track status between a placer and a _specific_ *potential*, or *eventual* Fulfiller (when using FHIR servers). Multiple Task resources may point to the same Request, with one Coordination Task per placer-fulfiller pair. In cases where multiple Fulfillers may each contribute a partial output (e.g., pharmacies providing partial dispenses), Placers may create a Parent Coordination Task - modifiable only by the placer - in addition to the individual Coordination Tasks for each Fulfiller. Overall workflow status may be Tracked using <code>Request.status</code> and the presence of Outputs or, when a parent Task exists, via the parent <code>Task.businessStatus</code> and <code>Task.status</code>. Placers and fulfillers must pre-coordinate which system hosts the shared Coordination Task to ensure a consistent source of truth.
    * For example, a hospital arranging transportation assistance for a patient may create one "transportation ServiceRequest" for that patient and a Task per Transportation Provider, all referencing the same ServiceRequest. Alternatively, they may create or separate ServiceRequest/Task pairs per Fulfiller.

* **Output Events** represent the result of a request and can take many forms. This guide treats Outputs generically without prescribing structure, but specifies that Outputs may be associated to an originating Request via Task.Output (including via intermediate Task.basedOn and ServiceRequest.basedOn references). See the "Sharing outputs of referrals and orders" Workflow Patterns section for additional detail. This guide assumes that in most cases the (source of truth) Resource representing the Output is hosted on the Fulfiller's FHIR server, although the Placer may retain a copy that they can surface to others. 
Examples include:
    * Consult notes via DocumentReference
    * DiagnosticReports and Observations
    * CarePlans outlining proposed care
    * New ServiceRequests
 
<figure>
{% include relation-of-placer-request-task-output-filler.svg %}
</figure>


### Managing Access by Fulfillers:

As described in the Background section, actors in a RESTful exchange often wish to limit the set of resources that another actor may access (or the interactions they may initiate), with more granularity than what is provided with traditional OAuth 2.0 scopes. 

This guide recommends two complementary options, though their use is optional within this IG:

1. Actors may leverage [SMART v2 scopes](https://hl7.org/fhir/smart-app-launch/) to provide finer-grained control of what another actor may access. For example, a Placer may indicate that a Fulfiller can query only for resources of a particular category, such as ServiceRequests related to social care referrals or Observation resources related to Labs.
2. Senders of a notification may include an [authorization hint](https://build.fhir.org/ig/HL7/fhir-subscription-backport-ig/StructureDefinition-notification-authorization-hint.html) that the recipient may redeem while requesting an access token. Such an authorization hint (also called an authorization_base in some specifications) may be used by its creator to tailor the set of resources the actor presenting the authorization hint may access. As an example, this can be used to limit a Service Provider to only obtaining information on patients for whom an authorization hint has been sent to them as part of a referral notification.  

### Sharing Content when Intermediaries are Present:

While many examples in this guide assume direct communication between a Placer and Fulfiller, real-world workflows often involve intermediaries. For example, a clinician may send a specimen to a community lab, which in turn forwards it to a reference lab.

This type of “chain care” is common and introduces complexity—but also motivates many of the abstractions recommended in this guide. Consider a scenario where a request originates from an upstream actor (e.g., N–1), but a downstream fulfiller (e.g., N+1) needs access to information held by an earlier actor.

{% include img.html img="sharing-info-with-intermediaries.png" %}

If direct communication is possible, and if references across notifications were preserved, the Fulfiller may query the Placer directly. Whether such communication is possible depends on the broader environment, e.g. endoint discoverability, (dynamic) client registration, shared scopes and business rules, etc.

Where direct communication isn't feasible, intermediaries may:
* Store local representations of relevant data so they may provide it to downstream.
* Proxy" requests from later actors to those upstream.

In either of these scenarios, when forwarding requests, a party must rewrite references in the notificatoins they send to point to their own server, rather than actors upstream.

Alternatively, actors in the chain can reduce dependency on references by including information they expect later parties will need with the notifications (whether that is a Message bundle, a SubscriptionStatus notification bundle, etc.).

These patterns reinforce the guide’s recommendation to center communication around Tasks rather than Requests. Doing so ensures consistency across handoffs (e.g., Notification N–1 and N can follow the same structure), and allows each actor pair to coordinate around a shared Task without requiring full awareness of downstream workflows. Complex exchanges can then be composed from these modular interactions.

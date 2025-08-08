This section provides brief guidance on workflow steps that may occur before a Request is considered actionable based on `Request.status` and (preferrably) the existence of a Task.

### Initiating Orders

Prior to creating an actionable order, providers often go through several workflow steps. A clinician may:
1. Use a decision support engine to see what interventions are recommended for a patient.
2. Consult a catalogue to discover what interventions are available. That catalogue may represent individual services, medications, etc. that are available, or more complex pre-defined protocols.
3. Leverage decision-support again to 
4. Consult with a Payer to confirm a patient's eligibility for an intervention with that Payer, what a patient may need to pay out of pocket that insurance does not cover, etc.
5. Obtain dual-signoff for an order that requires input from multiple clinicians, such as a controlled substance.
6. If necessary, create a digital signature for that request so that others may verify the Requests's authenticity.   

The above is just a brief overview. Implementation guide authors creating workflow-specific guides may choose to define additional workflow steps, such as for consent collection.

#### Decision Support in ordering
While this implementation guide focuses on order execution and tracking, this guidance is designed to be compatible with Decision Support Guidance, namely the [Clinical Practice Guidelines](https://hl7.org/fhir/uv/cpg/activityflow.html) and its workflows.

#### Ordering from Service, Formulary, and Product Catalogs
In many systems, the "orderable" items are established in a catalog - sometimes referred to as a "formulary" for Medications or a "product catalogue" for devices. These catalogs may present different functionality to help clinicians find available orderables, and may include the option to order pre-defined groups of orders (panels) according to clinical protocols. 

<figure>
{%include initiation-catalog.svg%}
</figure>
<br clear="all"/>

This implementation guide defers to the other active work in the interop community for details of these guides.  

Note that catalogues may integrate with provider and endpoint directories to also indicate from where a service may be obtained and to where notifications for that service should be directed.  Catalogue information may be downloaded and synchronized in advance, or may be accessed in real-time and in-workflow as a provider creates Reqeusts. For more details about order catalogs, see the [Order Catalog Implementation Guide](https://hl7.org/fhir/uv/order-catalog).

#### Prior Authorization
Providers may need to obtian prior authorization from a Payer before a Request may become actioanble. This is often employed as a cost-saving mechanism, and may also inform a patient and a clinician's choice of treatment, based on what the patient's expected out-of-pocket expenses woudl be. The process of communicating with a Payer for prior authorization may follow a workflow similar to decision support (where patient eligibility is determined in-workflow), or may require an asynchronous workflow in which providers request authorization, supply supporting information, and then potentially respond to inquiries from the payer. While this workflow resembles the clinical workflows under discussion in this guide, they are not a primary point of focus.   

#### Co-Authoring Requests and Dual Sign-off:
Some orders require signoff by multiple clinicians before they become actionable. This may be required for Controlled Substances. Details of these workflows are left to workflow-specific implementation guides. Note that while a `Request.intent` is an immutable item, `Request.status` is not; a request may be Drafted by one provider, and then signed by another. Additionally, note that  `Request.requester` is single valued. This field should be populated with the last actor to take action who authored the request. Other providers may be indicated in the Provenance resource referenced from `Request.relevantHistory`

#### Creating Digital Signatures
Some workflows require that Ordering providers take additional steps to generate a digital signature for a request. This can be used to verify a request's authenticity. These digital signatures may be communicated in Provenance resources via `Provenance.signature`.

This section provides an overview of FHIR resources used to support Request workflows. Readers new to the topic may find it helpful to review this alongside the Overview of Workflow Patterns page, which shows how these concepts apply to end-to-end workflows. 

Other pages in this section dive into specific resources in more depth.

### Actors:

This guide describes interactions between those requesting and those performing services. The following terms are used:

* **Placer, requestor, referrer, and prescriber** are treated as equivalent. We generally avoid "Requestor" to prevent confusion with client-server terminology.
* **Performer and fulfiller** are also considered equivalent. These often refer to potential fulfillers, though we omit "potential" unless needed for clarity
* **Patient** refers to the individual receiving care, but may also include their representative—such as a parent, healthcare agent, or social worker—when they participate in coordinating services.

### Requests, Tasks, and Outputs Events:
This section provides a brief overview of how FHIR resources are used to represent Request workflows. For more detail, see [Workflow Resource Patterns](https://www.hl7.org/fhir/workflow.html#respatterns). 

* **Request resources** (e.g., ServiceRequest, DeviceRequest, MedicationRequest) are the FHIR representation of the request that a provider is creating, proposing, or authorizing. These request resources contain at least minimal information about the action to be performed, the overall status of the request, and links to supporting information. In this guide, the source-of-truth Request is always 'hosted' on the system in which the Request (or the proposed modification) originated. See the 'Cancelling and modifying requests' workflow pattern for details. A Placer may create a single Request, which any of several Fulfillers may perform, or a single Request per potential Fulfiller.
  
* **Task** resources can serve many purposes. In this guide, a Coordination Task serves a core role of helping a placer and a _specific_ *potential*, or *eventual* fulfiller manage the status of a request (in scenarios where FHIR servers are used). Many Tasks MAY correspond to the same ServiceRequest, with a Coordination Tasks for each placer and (potential) fulfiller pair. In environments where several potential fillers may each contribute a partial output (such as multiple pharmacies each providing a partial dispense), Placers may also initiate a 'parent' Coordination Task that they own and only they may modify, in addition to the shared fulfiller-specific Coordination Tasks. The overall status of the workflow may be represented using Request.status and the presence of Outputs or, when a parent Task exists, via the parent Task.businessStatus and Task.status. The page [using Task](using-task.html) provides additional guidance on the use of the Task resource.

For example, if a hospital would like to coordinate transportation assistance for a patient, they may create a single "transportation ServiceRequest" for that patient, with one Task per potential provider of transportation (each of which references the same ServiceRequest), or separate ServiceRequest and Task resources per fulfiller. Placers and fulfillers must pre-coordinate where their shared Coordination Task will be hosted to ensure there is always an agreed upon source of truth. 

* **Output Events** represent the result of a request and can take many forms. This guide treats Outputs generically without prescribing structure, but specifies that Outputs may be associated to an originating Request via Task.Output (including via intermediate Task.basedOn and ServiceRequest.basedOn references). See the "Sharing outputs of referrals and orders" Workflow Patterns section for additional detail. This guide assumes that in most cases the (source of truth) Resource representing the Output is hosted on the Fulfiller's FHIR server, although the Placer may retain a copy that they can surface to others. 
Examples include:
    * Consult notes via DocumentReference
    * DiagnosticReports and Observations
    * CarePlans outlining proposed care
    * New ServiceRequests
 
<figure>
{% include relation-of-placer-request-task-output-filler.svg %}
</figure>

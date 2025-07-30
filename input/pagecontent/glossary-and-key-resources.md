This section provides an overview of FHIR resources used to support Request workflows. Readers new to the topic may find it helpful to review this alongside the Overview of Workflow Patterns page, which shows how these concepts apply to end-to-end workflows. 

Other pages in this section dive into specific resources in more depth.

### Actors:

This guide describes interactions between those requesting and those performing services. The following terms are used:

* **Placer, requestor, referrer, and prescriber** are treated as equivalent. We generally avoid "Requestor" to prevent confusion with client-server terminology.
* **Performer, fulfiller, and service provider** are also considered equivalent. Note that these often refer to *potential* fulfillers of a request. 
* **Patient** refers to the individual receiving care, but may also include their representative—such as a parent, healthcare agent, or social worker—when they participate in coordinating services.

### Requests, Tasks, and Outputs Events:
This section provides a brief overview of how FHIR resources are used to represent Request workflows. For more detail, see [Workflow Resource Patterns](https://www.hl7.org/fhir/workflow.html#respatterns). 

**Request resources**, such as ServiceRequests, DeviceRequests, MedicationRequests, and CarePlans, represent an action or set of actions that a provider has proposed or authorized. Request resources provide details on the action to be performed, supporting information, and the status of the request from the request-originator's perspective. For example, a provider may create a ServiceRequest that authorizes CT imaging of the Chest for a patient. They may indicate that the reason for imaging is chest pain, that it's urgent, and that they have confirmed the patient can have contrast. When the request has been completed to the provider's satisfaction, they can update the request's status to Complete, indicating that no further action should be taken based on this authorization, and that a new authorization would be needed for any new activity. 

Requests can be grouped by several mechanisms, including CarePlan and RequestOrchestration resources. Requests can also be the basis for additional requests: for example, a Request for CT Contrast could be created per-protocol due to a Request for Imaging, or an imaging center may create a more specific ServiceRequest, such as for an X-Ray 3-view, due to a more general request from a patient's family doctor that they examine shoulder pain. The granularity of requests and the circumstances in which a new authorization is needed is left to implementers and later implementation guides. 

Note that a Placer may create multiple Requests for the same service (one per potential Fulfiller), or a single Request, which any of a number of groups could Fulfill.

Note that in FHIR workflows, Request resources are owned (from a business standpoint) by the party that created the Rrequest. A Request may be superceded by a later Request (such as an instruction to stop taking a Medication), and other parties may suggest that a Request be modified. This has a corrolary that Request resources are often hosted on the Placer's FHIR server, though this is not required. Even when the FHIR resource which parties agree to regard as the source of truth is hosted on a FHIR server that is not in the Placer's control, only the Request's originator, under who's authority the Request is performed, can modify their own authorization.  

**Tasks** are instructions to perform an action. While a ServiceRequest could indicate that a provider authorizes imaging of the shoulder, a Task asks that a particular imaging clinic fulfill that request. That Task may then spawn other Tasks, such a Task to collect the patient's consent, to collect their insurance info, or to administer contrast. 

In this guide, a Coordination Task serves a core role of helping a placer and a _specific_ *potential*, or *eventual* fulfiller manage the fulfillment of that request. Many Tasks MAY correspond to the same ServiceRequest, with a Coordination Tasks for each placer and (potential) fulfiller pair. In environments where several potential fillers may each contribute a partial output (such as multiple pharmacies each providing a partial dispense), Placers may also initiate a 'parent' Coordination Task that they coordinate, in addition to the shared fulfiller-specific Coordination Tasks. The overall status of the workflow may be represented using Request.status and the presence of Outputs or via the parent Tasks's .businessStatus and .status. The page [using Task](using-task.html) provides additional guidance on the use of the Task resource.

For example, if a hospital would like to coordinate transportation assistance for a patient, they may create a single "transportation ServiceRequest" for that patient, with one Task per potential provider of transportation. Placers and fulfillers must pre-coordinate where their shared Coordination Task will be hosted to ensure there is always an agreed upon source of truth. 

**Outputs** are Event resources in the FHIR Workflow model. They could include DiagnosticReports, Communications, Procedure resources, etc. Events represent what was done for a patient. 

The details of what outputs are required for a given workflow and their content are left to implementers and later implementation guides. Outputs may directly reference Request resources that led to their creation via the basedOn element. Outputs may also be associated to an originating Request via Task.Output (including via intermediate Task.basedOn and Request.basedOn references). See the "Sharing outputs of referrals and orders" Workflow Patterns section for additional detail. In environments with RESTful FHIR exchanges, the source of truth Resource representing the Output is generally hosted on the Fulfiller's FHIR server, although the Placer may retain a copy that they can surface to others. 

**In summary** a Request represents a provider's authorization or proposal that some action should be taken (e.g. "the patient should take beta blockers for high blood pressure"). Outputs document that action was taken (e.g. "a pharmacy dispensed the patient beta-blockers, based on the provider's request"). If the Placer and the Fulfiller of a request need to coordinate the fullfilment of that that request, they do so via Tasks (e.g. if a provider would like a particular pharmacy to provide the patient with beta-blockers, they create a Task for them to do so).   
 
<figure>
{% include relation-of-placer-request-task-output-filler.svg %}
</figure>

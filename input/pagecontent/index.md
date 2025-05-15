### Introduction
This implementation guide provides a framework for Request-fulfillment workflows in FHIR. This includes prescriptions for medications, orders for procedures, supplies devices, or nutrition, referrals for surgical and specialist consults, transfers, and requests for patient placement. 

The framework draws from the FHIR Workflow Module and defines shared data models and coordination rules for how actors create, manage, and act on Requests. It supports both RESTful exchange (using Tasks and optionally Subscriptions) and Messaging-based workflows.

Regardless of the exchange mechanism, the same data models apply. For instance, a doctor may notify a service provider by creating a Task on the service provider's FHIR server, by creating a Task on the doctor's own FHIR server to which the service provider is subscribed, or by sending a Message with the Task in <code>MessageHeader.focus</code>. 

In addition to shared data models, common rules—such as resource ownership—are enforced. Only the initiating party may create or modify a Request. Task-based communication should be used to relay updates or status changes.

The guide is intended to serve as a starting point on which other implementation guides may be built. Those other IGs may be tailored to particular care domains, such as specialist consults, social care referrals, placement in long term care facilities, requests for imaging, requests for medical equipment, etc., or built upon to meet the needs of specific jurisdictions, such as the United States or Belgium. 

### Structure of this Implementation Guide
This guide is split into the below sections. 

- **Background** - explains how this guide is intended to be used, the challenges it addresses, and why orders, referrals, and transfer workflows are considered together. It also outlines key considerations for spec authors in this space and provides a brief survey of the exchange mechanisms this guide references. 

- **Core Concepts** - describes actors and the key FHIR resources and concepts used in this guide. We suggest reading this section before proceeding further. This section also includes the basic model for representing the state of a Request from the time it is placed to its fulfillment. 

- **Workflow Patterns** - contains an overview of common workflows relevant to orders, referrals, and transfers, and how these may be combined and represented in the FHIR exchanges and state model described in the Core Concepts section. This includes how placers notify potential fulfillers of a Request, how fulfillers request additional information, and how Outputs may be shared. Each workflow is accompanied by a basic FHIR pattern or resources description.

- **Examples** - this section provides informative guidance for how the concepts developed in this guide may be applied to specific care domains. It includes basic examples such as lab ordering and resulting and post-discharge placement for patients needing ongoing care. These scenarios use various FHIR exchange mechanisms to validate and demonstrate the robustness of the chosen approach.

- **Resource profiles** - Reusable resource profiles used as part of this base guidance. 

### Boundaries and Relationships
* This guide is universal-realm and does not reference any national base or core profiling. This guide leverages concepts from [FHIR-Workflow](https://hl7.org/fhir/workflow.html) and applies them to Order, Referral, and Transfer workflows. 
* This implementation guide presents patterns that can be used in a variety of architectures, and does not intend to recommend any specific architecture of the involved systems.
* The recommendations in this implementation guide are designed for inter-system communication, not intra-system communication - while it is possible to use the same patterns and data structures inside a system, the goal is to support interoperability.  
* This guide draws inspiration from a growing number of different projects (past and ongoing), both by HL7 and by implementers. It provides guidance and content to support such projects, but in finding the common framework, it does not guarantee compatibility with such projects.


#### Key Challenges Today:
Several challenges affect referrals, orders, and transfers—particularly in cross-organization workflows. This guide offers at least partial guidance on all of the below except endpoint discovery.

* **Workflow management and tracking** – tracking the status of execution; coordinating responsibilities, tracking request status, and managing earlier steps in the process.
  
* **Sharing supporting information** – it's often difficult to include all relevant background with a request. For example, HL7 v2 struggles to associate a surgical consult with a specific imaging study. This guide offers ways to share supporting data, though it doesn’t cover how fulfillers communicate their information requirements (e.g., via order questionnaires).
  
* **Requesting additional information** – fulfillers may need information not already in the chart and not always required for similar services, making ad hoc follow-ups necessary.

* **Closing the loop** – ensuring outcomes (e.g., consult notes, imaging results, care plans) are shared back with the initiating provider.

* **Endpoint discovery** – determining where to send initial notifications or query for additional information.  


#### Aspects Included in this IG
This guide outlines how the following workflow aspects can be supported using FHIR:

* **Order initiation** - mechanisms that are important to consider before an order is active - while orthogonal to the order execution, order creation is a common need and some basic guidance is presented.
  
* **Order grouping** - description on mechanisms for order grouping (multi-item orders) - also orthogonal to the execution of the workflows, but guidance is given to ensure correct order execution and tracking for single- and multi-item orders.
  
* **Request notification** – A Placer notifies a (potential) Fulfiller of a request, including necessary supporting information for assessing fulfillment.
  
* **Information requests from performers** – May include RESTful queries, letters requiring action by the placer, or instructions (e.g., to order a pre-service blood test).
  
* **Coordination of fulfillment** – Between the Placer, patient, and potential Fulfillers to determine who will fulfill the request.
  
* **Request updates from Placers** – Such as cancellations, added information, or patient demographic changes.
  
* **Status updates from fulfillers** – Communicating progress or changes in request handling.
  
* **Outcome sharing** – Including results, consult notes, or notifications that a request could not be completed.

#### Aspects not detailed in this IG:
The following areas are important for designing full end-to-end workflows, but are not covered in depth in this guide:

* **Client registration** - registering a client with an authorization server and identifying the set of data a client may access and the actions it may take (collectively "scopes") to carry out a set of workflows per a business agreement.
   
* **Patient matching** – it is mentioned, as approaches vary by jurisdiction and available identifiers and doesn't impact the other mechanisms.
  
* **Provider directories** – Identifying providers, their affiliations, and electronic endpoints.
  
* **Service catalogs** - what tests, procedures, or other services a fulfiller can perform, and what information they would require to perform a service or to assess their ability to perform a service (such as their order-specific questions).
  
* **Decision support and prior authorization** - this IG provides only minimal guidance on workflow steps that occur before the creation of an actionable request for service.
  
* **Scheduling** - confirming the time slot, location, provider, and materials with which a service will be performed
  
* **Authentication, authorization, and auditing** - this guide assumes the use of OAuth 2.0 protocols and includes high-level access-control considerations but does not detail client/user/server authentication or scope management.
  
* **Outcome / result format and content of supporting resources** - this IG provides guidance  on linking Outputs back to an original Request to support loop closure, but does not impose any requirements that such outputs exist or on their form or content.

* **Details about the information requirements to execute a workflow** (e.g. which Specimen detail information is needed to execute a Laboratory test, which Patient detail Information is needed for a Referral, which detailed information is required regarding a MedicationRequest). This specification only adds constraints to ensure data exchange about workflows is interoperable. Details about needed information are domain-specific and usually jurisdiction-specific, and should be defined in specific Implementation Guides).

### Dependencies
This IG Contains the following dependencies on other IGs.

{% include dependency-table.xhtml %}

### Cross Version Analysis

{% capture cross-version-analysis %}{% include cross-version-analysis.xhtml %}{% endcapture %}{{ cross-version-analysis | remove: '<p>' | remove: '</p>'}}

### Global Profiles

{% include globals-table.xhtml %}

### Intellectual Property

{% include ip-statements.xhtml %}

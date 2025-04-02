### Introduction
This implementation guide provides a framework upon which Request-fulfillment workflows may be facilitated in FHIR. This includes Orders for procedures or devices, Prescriptions for medications, surgical and specialist consults, transfers, and requests for patient placement. 

It includes a model to represent the state of a Request from the time it is first made actionable until it is fulfilled. 

This guide also describes how actors can coordinate and act on Requests using the RESTful exchange of Tasks, Subscriptions, or Messaging. Regardless of the exchange mechanism, the intent is that the same data model may be applied. For example, doctors may inform a service provider of a request by creating a Task on the service provider's FHIR server, by creating a Task on the doctor's own FHIR server to which the service provider is subscribed, or by sending a Message with the Task in MessageHeader.focus. Regardless of the paradigm, resource ownership rules apply: only the initiating party may create or modify a Request. Updates or status changes should be communicated via Tasks

This guidance serves as a foundation upon which more detailed or region-specific implementation guides may be built.

### Structure of this Implementation Guide
This guide is split into the below sections. 

- **Background** - explains how this guide is intended to be used, the challenges it addresses, and why orders, referrals, and transfer workflows are considered together. It also outlines key considerations for spec authors in this space and provides a brief survey of the exchange mechanisms this guide references. 

- **Core Concepts** - describes actors and the key FHIR resources and concepts used in this guide. We suggest reading this section before proceeding further. This section also includes the basic model for representing the state of a Request from the time it is placed to its fulfillment. 

- **Workflow Patterns** - contains an overview of common workflows relevant to orders, referrals, and transfers, and how these may be represented via the FHIR exchanges and state model described in the Core Concepts section. This includes how placers notify potential fulfillers of a Request, how fulfillers request additional information, and how Outputs may be shared. Each workflow is accompanied by a basic FHIR pattern or resources-description.

- **Examples** - this section provides non-binding guidance for how the concepts developed in this guide may be applied to specific care domains. It includes basic examples such as lab ordering and resulting and post-discharge placement for patients needing ongoing care. These scenarios use various FHIR exchange mechanisms to demonstrate—and stress-test—the flexibility of the approach.

- **Resource profiles** - profiles of specific resources used as part of this base guidance. 

### Boundaries and Relationships
This guide is universal-realm and does not reference any national base or core profiling. This guide leverages concepts from [FHIR-Workflow](https://hl7.org/fhir/workflow.html) and applies them to Order, Referral, and Transfer workflows. 

This guide draws inspiration from 360X, work by the Netherlands FHIR community in their work on the Notified Pull framework (which was incorporated into FHIR Subscriptions in R6), work by the Canadian FHIR community to facilitate referrals, work by BSeR to facilitate social care referrals, and earlier guidance created for Durable Medical Equipment orders. While it attempts to distill shared concepts, it does not guarantee compatibility with any of these.

#### Key Challenges Today:
Several challenges affect referrals, orders, and transfers—particularly in cross-organization workflows. This guide offers at least partial guidance on all of the below except endpoint discovery.

* Endpoint discovery – determining where to send initial notifications or query for additional information.

* Sharing supporting information – it's often difficult to include all relevant background with a request. For example, HL7 v2 struggles to associate a surgical consult with a specific imaging study. This guide offers ways to share supporting data, though it doesn’t cover how fulfillers communicate their information requirements (e.g., via order questionnaires).

* Requesting additional information – fulfillers may need information not already in the chart and not always required for similar services, making ad hoc follow-ups necessary.

* Workflow management and tracking – coordinating responsibilities, tracking request status, and managing earlier steps in the process.

* Closing the loop – ensuring outcomes (e.g., consult notes, imaging results, care plans) are shared back with the initiating provider.

#### Aspects Included in this IG
This guide outlines how the following workflows can be supported using FHIR:

* Request notification – A Placer notifies a (potential) Fulfiller of a request, including necessary supporting information for assessing fulfillment.
* Information requests from performers – May include RESTful queries, letters requiring action by the placer, or instructions (e.g., to order a pre-service blood test).
* Coordination of fulfillment – Between the Placer, patient, and potential Fulfillers to determine who will fulfill the request.
* Request updates from Placers – Such as cancellations, added information, or patient demographic changes.
* Status updates from fulfillers – Communicating progress or changes in request handling.
* Outcome sharing – Including results, consult notes, or notifications that a request could not be completed.

#### Aspects Not Covered in this IG:
The following areas are important for full end-to-end workflow design but are not covered in depth in this guide:

* Client registration - registering a client with an authorization server and identifying the set of data a client may access and the actions it may take (collectively "scopes") to carry out a set of workflows per a business agreement.
* Patient matching – Minimal guidance is provided, as approaches vary by jurisdiction and available identifiers.
* Provider directories – Identifying providers, their affiliations, and electronic endpoints.
* Service catalogs - what tests, procedures, or other services a fulfiller can perform, and what information they would require to perform a service or to assess their ability to perform a service (such as their order-specific questions).
* Decision support and prior authorization - this IG provides only minimal guidance on workflow steps that occur before the creation of an actionable request for service.
* Scheduling - confirming the time slot, location, provider, and materials with which a service will be performed
* Authentication, authorization, and auditing - this guide assumes the use of OAuth 2.0 protocols and includes high-level access-control considerations but does not detail client/user/server authentication or scope management.
* Outcome / result format and content of supporting resources - this IG provides guidance  on linking Outputs back to an original Request to support loop closure, but does not impose any requirements that such outputs exist or on their form or content.

### Dependencies
This IG Contains the following dependencies on other IGs.

{% include dependency-table.xhtml %}

### Cross Version Analysis

{% capture cross-version-analysis %}{% include cross-version-analysis.xhtml %}{% endcapture %}{{ cross-version-analysis | remove: '<p>' | remove: '</p>'}}

### Global Profiles

{% include globals-table.xhtml %}

### Intellectual Property

{% include ip-statements.xhtml %}

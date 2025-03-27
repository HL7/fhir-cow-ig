### Introduction
This implementation guide provides basic guidance for how service-request fulfillment workflows, such as Orders, Referrals, and Transfers, may be facilitated in FHIR. It includes an overview of relevant FHIR exchange mechanisms, actor definitions, and core concepts to help promote alignment.

This guide creates a basic representation of the state of a request for service in FHIR and outlines how actors involved in a request for service may coordinate and act on that request for service using a RESTful approach with either subscription notifications or polling. 

While the guide mainly focuses on RESTful exchange, it also outlines how actors wishing to leverage other paradigms, such as FHIR messaging, could do so while leveraging the same data-model in order to promote interoperability. For example, where the RESTful workflow approach conveys information using Tasks, an implementation leveraging Messaging could convey equivalent information via a Task resource in MessageHeader.focus.  Similarly, rules around what resource instances are controlled by which party should also be adhered to regardless of paradigm (e.g. the original Request should not be updated by the filler).

The guide is intended only to provide a starting point on which other implementation guides may be built. Those other IGs may be tailored to particular care domains, such as specialist consults, social care referrals, placement in long term care facilities, requests for imaging, requests for medical equipment, etc., or built upon to meet the needs of specific jurisdictions, such as the United States or the Netherlands. 

### Structure of this Implementation Guide
This guide is split into the below sections. 

- **Background** - describes key actors, why this guide considers order, referral, and transfer workflows together, and challenges that IG authors operating in this space should consider in planning their approach. This guide directly addresses only a subset of these challenges. Where possible for other challenges, we briefly address other work within the interoperability community, including in-flight initiatives, and discuss how this guide may fit alongside them.  

- **Core Concepts** -  This section describes the use of key FHIR resources in this guide and some considerations for event-driven exchanges in FHIR. This section also includes this guide's recommendation for representing the state of a request for service from the time it is placed to its fulfillment. 

- **Workflow Patterns** - this section contains an overview of common workflows relevant to orders, referrals, and transfers, and how they may be represented via the FHIR exchanges and state model described in the Core Concepts section. This includes how placers may first notify potential fulfillers of a request for service, how placers would select a fulfiller, how fulfillers may request additional information, and how either side may cancel a request after creation, subject to relevant business rules. Each of these 'archetypical patterns" is accompanied by a basic FHIR pattern, with details for particular care-domains removed, and a brief list of example workflows to which it may apply. 

- **Examples** - this section provides non-binding guidance for how the concepts developed in this guide may be applied to particular care domains. For example - it includes an overview of how a basic lab order and result may be managed, how placement in a long-term care facility may occur, etc. These examples include a variety of FHIR exchange mechanisms and are meant to demonstrate (and stress-test) the flexibility of the approach described in this guide.   

- **Resource profiles** - profiles of specific resources used as part of this base guidance. 

### Boundaries and Relationships
This guide is universal-realm and does not reference any national base or core profiling. This guide leverages concepts from [FHIR-Workflow](https://hl7.org/fhir/workflow.html) and applies them to Order, Referral, and Transfer workflows. 

This guide draws inspiration from 360X, work by the Netherlands FHIR community in their work on the Notified Pull framework (which was incorporated into FHIR Subscriptions in R6), work by the Canadian FHIR community to facilitate referrals, work by BSeR to facilitate social care referrals, and earlier guidance created for Durable Medical Equipment orders. While it attempts to distill shared concepts, it does not guarantee compatibility with any of these.

#### Key Challenges Today:
Some key challenges in the referral, orders, and transfer space, especially for cross-organization exchanges, are shown below. This IG provides at least partial guidance for all but endpoint discovery. 

* Endpoint discovery - letting actors know to where an initial notification should be pushed, or from where additional information may be queried.
* Sharing supporting information - it can be hard to supply all of the necessary and relevant background information with an order or referral today. For example - in HL7 v2, it's challenging to refer a patient for a surgical consult while communicating that it is based on a _particular_ set of imaging. This IG provides guidance on sharing supporting information, but does not address how a Fulfiller may communicate alongside its service catalogue what information it requires in order to process a request (such as order questionnaires).
* Requesting additional information - providers who receive a request for service may find that additional specific information is needed. That information may not already exist in the patient's chart, and often that information of interest is not _always_ necessary to a given type of service. 
* Workflow management and tracking - coordinating which actor has the baton, monitoring the overall status of a referral, managing the earlier steps, etc.
* Closing the loop - sharing the outcome (and partial outcomes), such as a consult note, an imaging result, a proposed plan of care, etc. 

#### Aspects Included in this IG
This IG provides guidance for how the following workflows could be accomplished in FHIR:

* A placer notifying a (potential) fulfiller of a request - including sharing supporting information necessary for the fulfiller to determine their ability to fulfill the request.
* Performers requesting additional information - this could be a RESTful query for specific information, a letter asking for information (requiring action by the Placer), or even an instruction to the placer (such as to order and coordinate a blood test for the patient prior to service by the fulfiller). 
* A placer, patient, and potential performers coordinating who will ultimately fulfill a request
* Requestors sending updates to requests - this could be a cancellation of the request, additional supporting information, a demographics change of the patient, etc.
* Fulfillers sharing status updates
* Performers sharing outcomes of the request for service - where applicable, this could be a result, a consult note, etc. A fulfiller may also inform a placer that they could not complete the request for service. 
* Corrections - in which updates are made to an output after the request for service has been completed.

#### Aspects Not Covered in this IG:
While specification authors and data exchange architects should consider the areas below when designing full end-to-end workflows for orders, referrals, and transfers, they are not discussed in depth in this IG. 

* Client registration - registering a client with an authorization server and identifying the set of data a client may access and the actions it may take (collectively "scopes") to carry out a set of workflows per a business agreement.
* Patient matching - this guide provides minimal guidance on how the exchanging actors should confirm the identity of the patient in the exchange, since this may vary considerably by jurisdiction based on local identifiers and the availability of national IdPs. 
* Provider address books - identifying the set of providers, where they work, and their electronic endpoints for communication.
* Service catalogs - what tests, procedures, or other services a fulfiller can perform, and what information they would require to perform a service or to assess their ability to perform a service (such as their order-specific questions).
* Decision support and prior authorization - this IG provides only minimal guidance on workflow steps that occur before the creation of an actionable request for service. Many jurisdictions require that providers receive prior-authorization for a request for service from insurers or other payers.
* Scheduling - confirming the time slot, location, provider, and materials with which a service will be performed
* Authentication, authorization, and auditing - this guide assumes the use of OAuth 2.0 protocols in examples, and includes discussion of access-control considerations that spec authors should consider when designing more specific exchanges. However, this guide does not discuss the specific details of client-system authentication, user authentication, or server authentication. It also does not discuss in detail how authorized scopes of interaction may be codified.
* Outcome / result format and content of supporting resources - in the overarching guidance, this IG only specifies that _some_ output may be generated from an order or referral, such as a result, a note, etc. This guide does not place any requirements on the form or content of these documents. For example - while examples in this IG may mention that a referral for imaging may conclude with a radiologist's result report, and this may be modelled in examples using DiagnosticReport and ImagingStudy resources, this guidance is not binding, and no further details are given for how the content of that DiagnosticReport may relate to particular observations, etc. This IG does provide guidance for how such output content may be tied back to an original service request to close the loop on an order or referral. 

### Dependencies
This IG Contains the following dependencies on other IGs.

{% include dependency-table.xhtml %}

### Cross Version Analysis

{% capture cross-version-analysis %}{% include cross-version-analysis.xhtml %}{% endcapture %}{{ cross-version-analysis | remove: '<p>' | remove: '</p>'}}

### Global Profiles

{% include globals-table.xhtml %}

### Intellectual Property Considerations

{% include ip-statements.xhtml %}
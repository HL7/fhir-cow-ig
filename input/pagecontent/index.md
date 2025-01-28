### Introduction
This implementation guide provides basic guidance for how service-request fulfillment workflows, such as Orders, Referrals, and Transfers, may be facilitated in FHIR. It includes an overview of relevant FHIR exchange mechanisms, actor definitions, and core concepts to help promote alignment.

This implementation guide defines specific exchanges to achieve workflow objectives. The main focus is on using a RESTful approach (with subscription notifications or polling used to share awareness of changes made on remote systems). Some environments may choose to implement these types of workflows using messaging or custom operations and this IG will expose the commonality of these approaches.

The guidance provided here in terms of data flow and supporting structures should be consistently applied. For example, if the RESTful workflow approach to convey information uses Task, then the MessageHeader.focus or custom operation body should also make use of Task populated in the same manner.  Similarly, rules around what resource instances are controlled by which party should also be adhered to regardless of paradigm (e.g. the original Request should not be updated by the filler).

Documents (on their own) are not suitable for controlling workflows, although they may be used to report workflow results.  Documents do not 'ask' for action – some more active paradigm is required.

The guidance as-written is meant only as a starting point on which other IGs may be built. Those other IGs may be tailored to particular care domains, such as surgical referrals, referrals to social care, nursing home placement, etc., or to the needs of specific jurisdictions, such as the United States, the Netherlands, etc. 

### Structure of this Implementation Guide
This guide is split into the below sections. 

- **Background** - provides a more detailed overview of the scope of this IG, parts to the orders, referrals, and transfer workflows, including what makes these hard today, additional information on what is out of scope for this IG, and guidance for how to build on this IG for particular domains. 

- **Core Concepts** - describes key actors and how the domains see Order, Referral, and Transfers relate to each other. This section also provides an overviwe of how key FHIR resources are used in this guide, and points to consider for event-driven exchanges in FHIR.

- **Example Patterns** - this section contains an overview of common workflow exchange patterns relevant to orders, referrals, and transfers. For example - patterns where a single fulfiller is asked whether they have availablitly, those where a fulfiller may modify the service to be performed, those where a placer merely authorizes a service, but the patient chooses where and by whom it will be performed, etc. Each of these 'archetypical patterns" is accompanied by a basic FHIR pattern (with details for particular care-domains removed) and a list of some example workflows to which it may apply. This section concludes with a set of more generic exchange patterns that summarize key 'optional' components demonstrated in the earlier patterns. 

- **Example Use Case Applications** - this section provides non-binding guidance for how the concepts developed in this IG may be applied to particular care domains. For example - it includes an overview of how a basic lab order and result may be managed, how placement in a long-term care facility may occur, etc.  

- **Resource profiles** - profiles of specific resources used as part of this base guidance. 

### Boundaries and Relationships
This guidance is intended to be universal-realm, and as such does not reference any national base or core profiling. See the general [FHIR-Workflow](https://hl7.org/fhir/workflow.html). This guide leverages concepts from that guide and applies them to Order, Referral, and Transfer workflows. 

Many of the concepts in this guide are built on top of work by the Netherlands FHIR community in their work on the Notified Pull framework which was incorporated into FHIR Subscriptions in R6, work by the Canadian FHIR community to faciliate referrals, work by BSeR to faciliate social care referrals, and earlier guidance created for Durable Medical Equipment orders. This guide also draws inspiration from work on 360X. 

### Dependencies
This IG Contains the following dependencies on other IGs.

{% include dependency-table.xhtml %}

### Cross Version Analysis

{% capture cross-version-analysis %}{% include cross-version-analysis.xhtml %}{% endcapture %}{{ cross-version-analysis | remove: '<p>' | remove: '</p>'}}

### Global Profiles

{% include globals-table.xhtml %}

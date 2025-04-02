Order initiation refers to the different activities that may exist or be required up until an order or authorization is ready to be actioned. There are some  considerations and mechanisms to consider in this ordering process:

### Order progression 

#### **Status** and **intent**:  
* `request.status` is a coded element with required binding - the status of the request is limited to those statuses identified in the resource, and MAY NOT be extended. The request `.status` is the status of the authorization, not the status of execution.  

  * Orders can be created in `active` status, or may evolve from `draft` to `active` - an order instance may be created as "draft" and then be updated to become "active"  ...


* the extension `statusReason` contains **reasons** for a given status of authorization. It SHALL NOT be used to contain detailed statuses.
  * example: "expired" is a possible reason for an order to be "revoked", but is not an additional status.

* **`request.intent` is an immutable element, meaning that systems SHALL NOT update the intent of an order**. For creating a plan from a proposal, or an order from a plan or proposal, a new request resource instance **MUST** be created, basedOn the proposal/plan instance.  

  * Note: some possible values for intent have a hierarchical relationship. This is means that while intent is immutable, it is possible to change from an intent to a 'sub-intent' because this doesn't change the intent, it just refines it.


* Order intent may be, among others:
  * **`proposal`**: a suggestion made by someone/something that does not have an intention to ensure it occurs.  
  * **`plan`**: an intention to ensure something occurs without providing an authorization for others to act.  
  * **`order`**: a request/demand and authorization for action by the requestor.  


#### Co-authoring
In some cases, additional confirmation / sign-off is needed - this is common for special procedures, controlled substances.  
In other cases, order creation follows different steps - resulting in co-authoring of the order. 
This ImplementationGuide currently addresses fulfillment of orders, so this co-authoring is therefore not in the primary scope.   



#### Prior Auth
Prior Authorization is a common use case. Depending on the jurisdictions, it may happen as a rule, or may be required to prevent fraud, or to allow patients to decide considering also the costs, even if the processes and criteria are broadly different. This is also prior to execution and as such not a primary scope.

Co-authoring, prior authorization can include different participants and can be predefined or *ad-hoc* processes. While this is not the focus of the present edition of this guidance, Implementers are invited to provide input on their needs, for consistent guidance where possible.
{:.stu-note}




#### Actionable orders

In FHIR, requests express authorizations, and are not intended to be actionable *per se*. An order becomes actionable if:

* it's tagged as actionable (using the ["actionable" tag](https://hl7.org/fhir/valueset-common-tags.html) in [`meta.tag`](https://build.fhir.org/valueset-common-tags.html))
* there's a Task pointing to the request telling to fulfill it
* there's a message or operation that implies it is to be actioned  

It is **not recommended** to consider orders actionable outside these scenarios, as it may prevent system expansion and/or break interoperability with systems that follow FHIR workflow recommendations.


#### Ordering from Service/Product Catalogs
In many systems, the "orderable" items are established in a catalog - sometimes referred to as a "formulary" for Medications. The service catalogs may present different types of functionalities on the services, like searching, clustering, or providing details on the orderable items.  

<figure>
{%include initiation-catalog.svg%}
</figure>
<br clear="all"/>

The availability of catalogs and interactions with catalog services are a common dependency but are out of scope of this guidance.  They are mentioned here to acknowledge that:

The interaction with catalogs may exist before or during the creation and update of orders. Catalog information can be downloaded and synchronized in advance, or may be queried for example before ordering, changing or   validating orders, or for checking or fulfilling orders. This interaction is orthogonal to the scope of this ImplementationGuide. For more details about order catalogs, users are invited to consult the [Order Catalog Implementation Guide](https://hl7.org/fhir/uv/order-catalog).

* HL7 is producing guidance on order catalogs, namely the [Order Catalog Implementation Guide](https://hl7.org/fhir/uv/order-catalog).


<hr>

#### Order set protocols

Protocols are sets of defined orders, possibly interdependent. Order sets may be ordered:
* As group of orders, as defined in [grouping](order-grouping.html);
* In a single request, if a designation or code exists for the order set. In this case, the order will be broken down:
  * at the order placer when seeking fulfillment - thus becoming a group order. 
  * at the fulfiller side, upon initiating fulfillment. In this case, the orchestration is done by one Task for the entire order; additional orchestration may be done by grouping filler orders, with one task coordinating the orders, or several tasks - see order grouping.



#### Decision Support in ordering

One of the most common uses for Decision Support is to assist in ordering. While this implementation guide focuses on the order execution and tracking, this guidance is designed to be compatible with Decision Support Guidance, namely the [Clinical Practice Guidelines](https://hl7.org/fhir/uv/cpg/activityflow.html) and its workflows.


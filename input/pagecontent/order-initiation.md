Order initiation refers to the different activities that may exist or be required up until an order or authorization is ready to be actioned. These are transversal mechanisms that may be combined:


### Order status progression

**Status** vs **intent**:  
* Order status may evolve from `draft` to `active` - an order instance may be created as "draft" and then be udpated to become "active"
* Order intent may be, among others:
  * proposal: a suggestion made by someone/something that does not have an intention to ensure it occurs.  
  * plan: an intention to ensure something occurs without providing an authorization for others to act.  
  * order: a request/demand and authorization for action by the requestor.  
  It is important to note that **`request.intent` is an immutable element, meaning that systems SHALL NOT update the intent on an order**. For creating a plan from a proposal, or an order from a plan or proposal, a new request resource instance **MUST** be created, basedOn the proposal/plan instance.  
  what we can do is to refine from order to placer-order...

(see https://build.fhir.org/valueset-request-intent.html)



### Actionable orders

In FHIR, requests express authorizations, and are not intended to be actionable *per se*. An order becomes actionable if:

* it's tagged as actionable (using the "actionable" tag)
* there's a Task pointing to the request telling to fulfill it
* there's a message or operation that implies it is to be actioned  

in very simple workflows, an order may be considered actionable in that context.....?????

<br>
<br>
<br>


#### Ordering from Service/Product Catalogs
In many systems, the "orderable" items are established in a catalog - sometimes referred to as a "formulary" for Medications. The service catalogs may present different types of functionalities on the services, like searching, clustering, or providing details on the orderable items. 

<figure>
{%include initiation-catalog.svg%}
</figure>
<br clear="all"/>


The interaction with catalogs may exist in any point where the order is potentially changed - upon ordering, upon changing, upon validation,... this interaction is orthogonal to the scope of this ImplementationGuide. For more details about order catalogs, users are invited to consult the [Order Catalog Implementation Guide](https://hl7.org/fhir/uv/order-catalog).



<hr>

#### Order set protocols

Protocols are ....



#### Decision Support in ordering

One of the most common uses for Decision Support is to assist in ordering....

The [Clinical Practice Guidelines](https://hl7.org/fhir/uv/cpg/activityflow.html) 
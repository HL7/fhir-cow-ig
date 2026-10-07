*Clinical orders are often related to other orders: they may be entered together, depend on each other, replace one another, or be split into further requests during fulfillment. This page describes the core patterns for such grouped, related, and dependent orders: the relationships between orders; the grouping of orders, actions, and outcomes; the resources and elements used for grouping; and how multiple fulfillers may coordinate. Implementers are encouraged to follow these patterns, so that grouped, related, and dependent orders can be tracked consistently and in the same way as single orders. Approaches that deviate from these patterns may make the tracking of such orders more complex and less interoperable.*

### Relationships between orders

*Orders can be related in several typical ways, each supported by elements of the Request resources:*
* **Grouped** – *requests that belong to the same order have the same `.groupIdentifier` (or `ServiceRequest.requisition`).*
* **Replaces** – *a request that replaces another request references it in `.replaces`.*
* **Based on** – *a request that is created to fulfill, or as a consequence of, another request references it in `.basedOn`.*

### Grouping of orders

*Orders can be grouped in different ways – unrelated, independent, or interdependent (see below). Typical scenarios include:*
* protocol orders that are issued and split into sub-orders;
* protocols that create grouped requests;
* a Placer requests a single item, and derived requests are created at the Fulfiller side (e.g. lab reflex testing);
* new requests that are added to an existing group.

#### Multi-item orders

In several cases and jurisdictions, there is a need to capture multiple orders that are entered at the same time.  
Examples: 
* Multiple-line medication prescriptions
* Custom diet orders comprised of different nutrition products
* Groups of lab tests/panels that don't have a single orderable code

In FHIR, each order is represented as a Request for one item - a service, a medication, a supply,...  
The implementation for group orders is done with the following approach:

* If several requests are created separately or their creation and action is not inter-related: a set of unrelated requests; The order identifiers are the `.identifier`s of each of the requests.   
* To support the cases where several requests are intended to be grouped but still actionable independently, for example they have been authorized more or less simultaneously by a single author, **a group identifier may be added to each request** in `.groupIdentifier` / `.requisition` element, representing the identifier of the requisition or prescription. The overall order identifier is the `.groupIdentifier`;  
* To represent the situation where the requests are related to each other, by relations of timing, prerequisite, or other, **a RequestGroup should be used, referencing each request**. The order identifier is then the `RequestGroup.identifier`. 
  This means that the requests are no longer independent - All resources referenced by the RequestGroup must have an intent of "option", meaning that they cannot be interpreted independently - and that changes to them must take into account the impact on referencing resources. The RequestGroup and all of its referenced "option" Requests are treated as a single integrated Request whose status is the status of the RequestGroup.


##### Unrelated, independent requests

This is the approach without grouping - each order is independent of the others.

<figure>
{%include group-independentrequests.svg%}
</figure>
<br clear="all"/>

<br>

##### Grouped, independent requests

This approach simply adds a groupIdentifier to the orders, indicating they are somehow part of a group. The "group" doesn't exist as a separate data object - elements like author, date, patient, etc. are captured in each of the requests (in case of a true "group order" these would be the same values for all requests with the same group identifier).

<figure>
{%include group-groupedrequests.svg%}
</figure>
<br clear="all"/>


<br>

##### Grouped, interdependent requests

The use of a "grouping" / "orchestration" resource is reserved to situations where the different ordered items are not independent. These items cannot have their statuses individually changed - the change happens at the group level.
This is a common case where procedures have dependencies, or medications that must be taken together.  
**In FHIR, request orchestration is done with the use of RequestGroup which points to the individual requests.**


<figure>
{%include group-dependentrequests.svg%}
</figure>
<br clear="all"/>



### Grouping of actions

*The execution of requests can be grouped, at the Placer or at the Fulfiller side – for example, for convenience, several requests may be performed together. Within a workflow, the work for a request may also be split into sub-tasks that are managed as part of the overall Task.*

### Grouping of outcomes

*The outcomes of grouped requests may also be grouped – for example, when the results of several requests are reported together.*

### Grouping resources and relationships

*The boundaries of a group, and the relationships within it, can be represented with:*
* grouping resources:
  * RequestGroup (RequestOrchestration in R5) *– for interdependent requests (see above)*;
  * CarePlan;
  * Bundle;
* relationships between resources:
  * `Task.groupIdentifier`
  * `Task.partOf`
  * `Request.groupIdentifier` (i.e. [`ServiceRequest.requisition`](https://hl7.org/fhir/R4/servicerequest-definitions.html#ServiceRequest.requisition))
  * `Request.basedOn`
  * `Event.basedOn`

### Finding and managing grouped requests 
The grouping of requests presents some challenges for finding and tracking, notably: 
* How to search and manage request (e.g. based on order identifier) regardless of  whether that is a group order or a single order.

To allow for this, there are 2 additional search parameters (which are expected as from the next release of FHIR, and given here for pre-adoption):

* Request `group-or-identifier`: Allows a single search to be issued for a value matching either `.requisition/groupIdentifier` or `.identifier`. In environments that have both single-item or grouped orders, this search parameter is recommended.
* RequestGroup `activity-resource`: Allows searching on (or including results from searching on) requests in a RequestGroup. This search parameter on RequestGroup allows searches like `/xxxRequest?_revInclude=RequestGroup:activity-resource`.

### Tracking

To ensure the workflow management patterns apply, grouped requests are tracked in a way similar to single-item requests. 
* Task.focus points to the Request or to the RequestOrchestration.
  * In cases where a single fulfillment Task must reference several requests (requests with a common .groupIdentifier but no requestGroup), `task.Focus` must point to all the requests; See [using Task](requests-events-tasks.html) for guidance.
  * In very specific cases, the Task.focus may contain a logical reference to the requests' groupIdentifier. This is generally not recommended approach because the purpose is to track and traverse links across resources, and logical references break that possibility.

* Requests to change an order follow the same patterns - the request to change points at the `.identifier`, `.groupIdentifier`, or `RequestGroup.identifier`.

### Coordination among multiple fulfillers

*Several Fulfillers may coordinate while fulfilling a grouped request – or a single request. This collaboration on the execution may be planned, for example when the work is divided between Fulfillers in advance, or unplanned, when the need arises during fulfillment.*

### Examples

*The following examples describe, functionally, how grouped, related, and dependent orders occur in practice.*

#### MRI with contrast

An MRI order with contrast is placed. This kicks off:
1. an MRI screening form (a Task with a Questionnaire);
2. a lab test to check kidney function before the patient is given contrast;
3. a device check of the patient's pacemaker, if they have one, to make sure it can go in the MRI;
4. an order for the contrast and whatever else is needed;
5. the execution of the MRI, with administration of the contrast.

#### Hearing device

1. The patient must have a hearing test.
2. The report of the hearing test is awaited.
3. After the patient's decision, the device can be pre-ordered.
4. The order is completed.

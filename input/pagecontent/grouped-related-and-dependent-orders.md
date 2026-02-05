### Multi-item orders

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


#### Unrelated, independent requests

This is the approach without grouping - each order is independent of the others.

<figure>
{%include group-independentrequests.svg%}
</figure>
<br clear="all"/>

<br>

#### Grouped, independent requests

This approach simply adds a groupIdentifier to the orders, indicating they are somehow part of a group. The "group" doesn't exist as a separate data object - elements like author, date, patient, etc. are captured in each of the requests (in case of a true "group order" these would be the same values for all requests with the same group identifier).

<figure>
{%include group-groupedrequests.svg%}
</figure>
<br clear="all"/>


<br>

#### Grouped, interdependent requests

The use of a "grouping" / "orchestration" resource is reserved to situations where the different ordered items are not independent. These items cannot have their statuses individually changed - the change happens at the group level.
This is a common case where procedures have dependencies, or medications that must be taken together.  
**In FHIR, request orchestration is done with an additional resource. There is no "Parent" group resource "containing" the orders.**


<figure>
{%include group-dependentrequests.svg%}
</figure>
<br clear="all"/>



### Finding and managing grouped requests 
The grouping of requests presents some challenges for finding and tracking, notably: 
* How to search and manage request (e.g. based on order identifier) regardless of  whether that is a group order or a single order.

To allow for this, there are 2 additional search parameters (which are expected as from the next release of FHIR, and given here for pre-adoption):

* Request `group-or-identifier`: Allows a single search to be issued for a value matching either `.requisition/groupIdentifier` or `.identifier`. In environments that have both single-item or grouped orders, this search parameter is recommended.
* RequestGroup `activity-resource`: Allows searching on (or including results from searching on) requests in a RequestGroup. This search parameter on RequestGroup allows searches like `/xxxRequest?_revInclude=RequestGroup:activity-resource`.

### Tracking

To ensure the workflow management patterns apply, grouped requests are tracked in a way similar to single-item requests. 
* Task.focus points to the Request or to the RequestOrchestration.
  * In cases where a single fulfillment Task must reference several requests (requests with a common .groupIdentifier but no requestGroup), `task.Focus` must point to all the requests; See [using Task](using-task.html) for guidance.
  * In very specific cases, the Task.focus may contain a logical reference to the requests' groupIdentifier. This is generally not recommended approach because the purpose is to track and traverse links across resources, and logical references break that possibility.

* Requests to change an order follow the same patterns - the request to change points at the `.identifier`, `.groupIdentifier`, or `RequestGroup.identifier`.


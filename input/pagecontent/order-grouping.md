Order grouping

### Multi-item orders

In several cases and jurisdictions, there is a need to support order grouping or multi-item orders.  
Examples: 
* Mutliple-line medication prescriptions
* Custom diet orders comprised of different nutrition products
* Groups of lab tests/panels that don't have a single orderable code

In FHIR, each order is represented as a Request for one item - a service, a medication, a supply,...  
The implementation for group orders is done with the following approach:

* If several requests are created separately or their creation and action is not inter-related: a set of unrelated requests; The request IDs are the `.identifier`s of each of the requests.   
* If several requests are intended to be grouped but still actionable independently, for example they have been authorized more or less simultaneously by a single author, **a group identifier is added** in `.groupIdentifier` / `.requisition` element, representing the identifier of the requisition or prescription. The overall request ID is the `.groupIdentifier`;  
* If the requests are related to each other, by relations of timing, prerequisite, or others, **a RequestOrchestration may be added**. The request ID is then the `RequestGroup.identifier` This means that the requests are no longer independent - All resources referenced by the RequestGroup must have an intent of "option", meaning that they cannot be interpreted independently - and that changes to them must take into account the impact on referencing resources. The RequestGroup and all of its referenced "option" Requests are treated as a single integrated Request whose status is the status of the RequestGroup.


#### Unrelated, independent requests

<figure>
{%include group-independentrequests.svg%}
</figure>
<br clear="all"/>

#### Grouped, independent requests

<figure>
{%include group-groupedrequests.svg%}
</figure>
<br clear="all"/>

#### Grouped, interdependent requests
<figure>
{%include group-dependentrequests.svg%}
</figure>
<br clear="all"/>



### Finding and managing grouped requests 
The grouping of requests presents some challenges for finding and tracking, notably: How to handle request (e.g. based on request ID) but not impacted on whether that is a group order or a single order.
The key requirement is to make sure that when a request has multiple items, those items are returned in a search.

To allow for this, there are 2 additional search parameters (which are planned to be part of newer releases of FHIR, and given here for pre-adoption):

* Request `group-or-identifier`: Allows a single search to be issued for a value matching either `.requisition/groupIdentifier` or `.identifier`. In environments that have both single-item or grouped orders, this search parameter is recommended.
* RequestGroup `activity-resource`: To return the RequestGroup when querying a request in a group, the search would be on `/xxxRequest?_revInclude=RequestGroup:activity-resource`. This new search parameter on RequestGroup enables this functionality. 


### Tracking

To ensure the workflow management patterns apply, grouped requests are tracked in a way similar to single-item requests. 
* Task.focus points to the Request or to the RequestOrchestration.
  * In cases where a single fulfillment Task must reference several requests (requests with a common .groupIdentifier but no requestGroup), task.Focus must point to all the requests
  TO DO: Could it also be a logical reference to .groupIdentifier?
  

* Requests to change an order follow the same principle



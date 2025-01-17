## Placer initiated cancellation
(TO DO: Describe what happens here / what we are /are-not saying about what can be billed, whether the result exists, etc.)
This is equivalent to the normal flow through the step that an intended performer has been selected. This step assumes that the service provider has not already begun service. 

| Workflow State to Represent  | Request resource representation  | Task resource representation  | Event resources representation | Descriptions   |   |
| ------------| -----| -------| ------| ----|---|
|Placer Initiates Cancellation<br>(Before performance)|*Not set*|ServiceRequest<br>- Status: Revoked<br><br><br>1..* Task:<br>- Status: cancelled<br>- Code: fulfil<br>- Intent: order<br>- Focus: [the ServiceRequest]<br><br>OR - if a placer can't cancel on their own, BusinessStatus of CancelRequested? <br>Or a New Task with:<br><br><br>New Task:<br>- Status: Requested<br>- Code: Abort<br>- Input: [original Task]||
  </tr>
</tbody></table>
{:.table-bordered .table-hover .table-sm}

### Placer cancellation of ServiceRequest

### Placer initiated cancellation - before service started

### Placer initiated cancellation after service started (request to stop)


## Fulfiller initiated cancellation or modifications
Some workflows allow a fulfiller to modify a request without prior approval from the proposal. For example:
* A fulfiller may receive a general request to perform some service, and may then choose themselves which specific service should be performed.
* A fulfiller may apply their own expertise to determine that an alternative service is more appropriate, and may initiate this on behalf of the original placer and under their authorityu.
* A fulfiller may attempt to fulfill the requested service, but find that it can't be done due to the patient's condition or some other factor. In this case, they may complete a partial or alternative service. 

(TO DO: Describe Placer initiated alteration before or after service started (request to stop))




### Fulfiller decline to perform
This flow is equivalent to the normal flow up to the point that a placer first notifies a potential fulfiller of a service request. In this flow, a fulfiller declines to perform the service, and may or may not specify a reason. 

| Workflow State to Represent  | Request resource representation  | Task resource representation  | Event resources representation | Descriptions   |   |
| ------------| -----| -------| ------| ----|---|
| Fulfiller Declines Request | *Not set* | ServiceRequest:<br>- Status: active<br>- Intent: order<br><br>1 Task:<br>- Status: rejected<br>- Performer: [specified]<br>- Code: fulfill<br>- Intent: order |
{:.table-bordered .table-hover .table-sm}

### Fulfiller unable to perform
?? Is this different?

### Fulfiller modification request
Fulfiller proposal for alternate service

### Fulfiller modifications
Fulfiller performing alternate / more specific service



This section includes examples of how the patterns described elsewhere in this IG could be applied to particular use-cases. These examples are non-binding, and are intended only to illustrate to spec authors the expected use of the concepts here. 


### Example instances
(TO DO)



### Example Scenarios
(TO DO)


| Scenario | Description | Fulfiller Selection | Tracking |
|---|---|----|---|
|Placer-assigned Lab order| etc. | Placer-assigned | Task tracking |
|[Simple Lab Order Flow](ex1-simple-lab-order-flow.html)|A Simple Lab Order Workflow with a single Glucose Test|Placer assigned||
|[Simple Lab Order Flow with a Collection Center](ex2-simple-lab-order-flow-with-phlebotomist.html)|A Simple Lab Order Workflow with a single Glucose Test. Sample Collected at a collection Center|Placer assigned||
|[Lab Order Workflow where a Reflex is imitated by the Laboratory](ex3-lab-order-flow-reflex-initiated-lab.html)|A Lab Order Workflow with a single Glucose Test which triggers because of Laboratory Protocol a Reflex test|Placer assigned||
|[Medication Dispense with cancellation and order grouping](ex4-meds-grouped-dispense.html)|A medication workflow with cancellation and multiple items A Lab Order Workflow where the sample is insufficient|Placer Assigned||.
|[Lab Order Flow with insufficient sample](ex5-lab-order-flow-specimen-rejected.html)|A Lab Order Workflow where the sample is insufficient|Placer assigned||
|[Lab Order with involvement of a reference lab](ex6-lab-order-flow-with-reference-lab.html)|A Lab Order Workflow which involves a Reference Laboratory|Placer assigned||
|[Post-discharge placement in a SNF](ex7-discharge-placement.html)|A patient and their provider determine how a patient should receive skilled nursing and other care post discharge|Chosen among several||

{:.table-bordered .table-sm .table-striped }


Examples include:
* An order for a simple test to a specific laboratory to which the patient will present for collection - this example corresponds to the first scenario described in this IG.
* A result that, per protocol, should require a reflex test
* A request for service for which the fulfiller determines that an alternative service should be performed. For example, a patient is referred for imaging for Shoulder Pain. Radiologists protocoling the request determine that a 3-view should be performed.  
* A request for ongoing transport assistance for a patient to a social care organization, where the requestor is unsure if the patient meets the program's criteria. This corresponds to the second scenario described in the IG, in which a potential performer may decline the request.
* A referral for a surgical consult, in which there is specific supporting information needed for the consult, but additional information may be of interest to the surgeon. This is a more advanced version of the starting example. 
* An attempt to find a long term care facility able to take a patient with particular needs as part of discharge placement. In this example, multiple organizations are notified of the request, and they may request additional information to help confirm their ability to care for the patient. In this scenario, the LTC facility may also identify information which they should continue to monitor.
* A request for durable medical equipment to be delivered to the patient's home for monitoring
* An authorization by a physician that a patient should receive physical therapy, with the patient then choosing for themselves where to seek that physical therapy. 


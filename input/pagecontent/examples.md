This section includes examples of how the patterns described elsewhere in this IG could be applied to particular use-cases. These examples are non-binding, and are intended only to illustrate to spec authors the expected use of the concepts here. 


### Example Scenarios

| Scenario | Description | Fulfiller Selection |
|---|---|----|
|Placer-assigned Lab order| etc. | Placer-assigned |
|[Simple Lab Order Flow](ex1-simple-lab-order-flow.html)|A Simple Lab Order Workflow with a single Glucose Test, Sample is collected by Physician|Placer assigned||
|[Simple Lab Order Flow with a Collection Center](ex2-simple-lab-order-flow-with-phlebotomist.html)|A Simple Lab Order Workflow with a single Glucose Test. Sample Collected at a collection Center|Placer assigned|
|[Lab Order Workflow where a Reflex is imitated by the Laboratory](ex3-lab-order-flow-reflex-initiated-lab.html)|A Lab Order Workflow with a single Glucose Test which triggers because of Laboratory Protocol a Reflex test, Sample is collected by Physician|Placer assigned|
|[Ordering and dispensing several medications](ex4-meds-grouped-dispense.html)|A medication workflow with cancellation and multiple items|Patient Mediated|
|[Lab Order Flow with insufficient sample](ex5-lab-order-flow-specimen-rejected.html)|A Lab Order Workflow where the sample is insufficient, Sample is collected by Physician|Placer assigned|
|[Lab Order with involvement of a reference lab](ex6-lab-order-flow-with-reference-lab.html)|A Lab Order Workflow which involves a Reference Laboratory, Sample is collected by Physician|Placer assigned|
|[Post-discharge placement](ex7-discharge-placement.html)|A patient and their provider determine how a patient should receive skilled nursing and other care post discharge|Chosen among several|

{:.table-bordered .table-sm .table-striped }

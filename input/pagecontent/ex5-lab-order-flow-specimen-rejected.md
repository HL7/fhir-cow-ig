### Lab Order Workflow with an unsufficient Sample

#### Important Information
- This is a **minimal viable definition** of a possible laboratory workflow
- This is not implementable for now but tries to show the flow of the order and the minimal needed information
- 
#### Assumptions
- Physician knows which Specimen to draw (i.e. via an Order Catalog)
- Specimen is drawn by the Physician
- It is clear which Order Filler will execute the Order
- `ServiceRequest` is owned by the Order Placer; changes are allowed only to be done by Placer
- `Task` is a shared resource of Placer and Filler and updated by both
- Order Result is reported via `DiagnosticReport`
- Order is accepted and is started to be fulfilled 
- Lab internal flow is **out of scope**
- Lab detects an insufficient samples
- All needed data is accessible
- All needed data around the Sample is in the `Specimen` like collection information (`Procedure`, collection date/time, body Site, ...)
#### Not defined
- Ownership of `Specimen` Resource (Ownership should/could/might change with the physical location - this should be defined in a more detailed Lab IG build on the COW principles)
- Transport of the Sample

### Example
<figure>
  {% include ex5-lab-order-flow-specimen-rejected.svg %}
</figure>

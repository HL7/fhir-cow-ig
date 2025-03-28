### Simple Lab Order Workflow with a single Glucose (LOINC 2345-7) Test 

#### Important Information
- This is a **minimal viable definition** of a possible laboratory workflow
- This is not implementable for now but tries to show the flow of the order and the minimal needed information

#### Assumptions
- Physician knows which Sample to draw (i.e. via an Order Catalog)
- Specimen is drawn at the Physician office
- It is clear which Order Filler will execute the Order
- `ServiceRequest` is owned by the Order Placer; changes are allowed only to be done by Placer
- `Task` is a shared resource of Placer and Filler and updated by both
- Order Result is reported via `DiagnosticReport`
- `DiagnosticReport` is owned by the Order Filler
- Order will be accepted and fulfilled 
- Lab internal flow is **out of scope**
- All needed data is accessible
- All needed data around the Sample is in the `Specimen` like collection related information (`Procedure`, collection date/time, body Site, ...)
#### Not defined
- Ownership of `Specimen` Resource (Ownership should/could/might change with the physical location - this should be defined in a more detailed Lab IG build on the COW principles)
- Transport of the Sample

### Example
<figure>
  {% include ex1-simple-lab-order-flow.svg %}
</figure>

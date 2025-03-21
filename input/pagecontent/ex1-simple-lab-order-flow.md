### Simple Lab Order Workflow with a single Glucose (LOINC 2345-7) Test 

#### Assumptions
- Physician knows which Specimen to draw (i.e. via an Order Catalog)
- Specimen is drawn at the Physician office
- It is clear which Order Filler will execute the Order
- ""ServiceRequest"" is owned by the Order Placer; changes are allowed only to be done by Placer
- ""Task"" is a shared resource of Placer and Filler and updated by both
- Order Result is reported via ""DiagnosticReport""
- ""DiagnosticReport"" is owned by the Order Filler
- Order will be accepted and fulfilled 
- Lab internal flow is **out of scope**
- All needed data is accessible
#### Not defined
- Ownership of Specimen Resource (Ownership should/could/might change with the physical location)

### Example using Subscriptions with Task at Placer
<figure>
  {% include ex1-simple-lab-order-flow.svg %}
</figure>

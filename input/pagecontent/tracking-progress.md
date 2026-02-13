Clinical orders can have varying life-cycles. In general progress is tracked via `Task.status`, `Task.businessStatus`, and `Task.statusReason`. In cases where the progress can be ''coded'' systems should use the `.businessStatus` element in the Coordination Task to represent that progress status e.g. `collection-complete` or `mandatory-program-complete`.

If further detail on progress is needed, the mechanism depends on whether there is a need to persist and exchange the progress, or whether the stakeholders can consult the relevant resources to determine progress from those resources.

In many cases the fulfillment of clinical orders is a multi-step process that can involve the occurrence of several instances of services or events. The following are two mechanisms for persisting and exchanging the information about how many instances have been completed.

### Counting `Task.output`

This approach doesn't require any access to data elements on any other resources. It relies on counting the actual/expected outputs of certain types (i.e. represented by one or more specific `Task.output.type` codes).

- Systems should know what `Task.output`s to count (resource types, status) - this is dependent on business rules, and should be consistent between impacted parties.
  - Note that this also requires access to `Task.output` (see [Sharing Content](./sharing-content.html) ).


On the "Sharing Outputs from an Order or Referral"

### Track progress with an explicit `Task.output` as a Ratio

In cases where a ratio is expected and can be determined, for example when there is a need for n out of m instances are completed or a percentage of progress towards completion, and the ratio can be persisted in a `Task.output` element with `Task.output.valueRatio`.

The appropriate display of ratios and the presentation to users is out of scope for this Implementation Guide.
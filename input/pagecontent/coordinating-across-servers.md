The wider exchange ecosystem influences whether details of an event should be sent alongisde a notification, or if actors can instead rely on a recipient's ability to query for additional information if needed.

While support for targeted queries is a key feature of FHIR, it introduces optionality that integration architects should consider.  

TODO - add sections on:
* Provenance

### Managing Access by Fulfillers:
Actors in a RESTful exchange often wish to limit the set of resources that another actor may access (or the interactions they may initiate), with more granularity than what is provided with traditional OAuth 2.0 scopes. This can sometimes encourage groups to rely on Messages rather than permitting RESTful exchange.

This guide provides two options to consider, though their use is optional within this IG:

1. Actors may leverage [SMART v2 scopes](https://hl7.org/fhir/smart-app-launch/) to provide finer-grained control of what another actor may access. For example, a Placer may indicate that a Fulfiller can query only for resources of a particular category, such as ServiceRequests related to social care referrals or Observation resources related to Labs.
2. Senders of a notification may include an [authorization hint](https://build.fhir.org/ig/HL7/fhir-subscription-backport-ig/StructureDefinition-notification-authorization-hint.html) that the recipient may redeem while requesting an access token. Such an authorization hint (also called an authorization_base in some specifications) may be used by its creator to tailor the set of resources the actor presenting the authorization hint may access. As an example, this can be used to limit a Service Provider to only obtaining information on patients for whom an authorization hint has been sent to them as part of a referral notification.

### Resolving References:

The choice of exchange mechanism impacts how supporting information may be communicated between systems. By 'exchange mechanism', we mean whether actors use FHIR messaging, FHIR subscriptions with a Task at the Placer, or the posting of Task resources to a downstream system

**If the exchange relies on FHIR messaging**, with no expectation that FHIR servers are available for follow-up query, then all information necessary to process the request must be included in the message. A sender of a message and the recipient of a message must also pre-coordinate on shared business identifiers so that the recipient can interpret the contents of the message.

**If the exchange relies on subscription status notifications triggered for a Task at the Placer's system**, then the Task will likely reference other information on the Placer's system (leaving aside the question of chained care - see the next section). It is expected in these scenarios that the recipient of a notification can use business identifiers and other data elements on the resources from the Placer's system to perform appropriate matching in their own system; for example, a Task at the Placer's system may reference a particular Patient resource in the Placer system. The recipient of the notification would be expected to use data from that Patient resource to determine whether that patient already exists within the recipient system, and to match to them if so.

**If relying on one party creating Tasks or other resources at another party's FHIR server**, Architects and Implementation Guide Authors are advised to specify how References will be handled and how these requests will be orchestrated. The actors must coordinate on whether References in the Task, such as to the Patient, would be:
- [Logical references]([url](https://hl7.org/fhir/references.html#logical)) (i.e. those relying only on identifiers with which the other system could perform a lookup against its own database)
- Communicated as [Contained resources]([url](https://hl7.org/fhir/references.html#contained)), which essentially serve in this scenario as an enhanced version of a logical reference to facilitate more complex lookup by the recipient.
- References back to the originator's FHIR server. For example, a Placer may create a Task at a Fulfiller that refers back to the Placer's Patient Resource and Service Request. A Fulfiller could then query these to determine how they relate to objects in the Fulfiller's own database.
- Looked up or created on the Recipient's FHIR server prior to the creation of a Task. For example, a Placer may perform a $match on a Fulfiller's FHIR server to determine whether a relevant Patient resource already exists, and reference that resource when it creates a Task. 

### Sharing Content When Intermediaries are Present:

While many examples in this guide assume direct communication between a Placer and Fulfiller, real-world workflows often involve intermediaries. For example, a clinician may send a specimen to a community lab, which in turn forwards it to a reference lab.

This type of “chain care” is common and introduces complexity—but also motivates many of the abstractions recommended in this guide. Consider a scenario where a request originates from an upstream actor (e.g., N–1), but a downstream fulfiller (e.g., N+1) needs access to information held by an earlier actor.

{% include img.html img="sharing-info-with-intermediaries.png" caption="Figure 4.2.1 Intermediaries" %}

If direct communication is possible, and if references across notifications were preserved, the Fulfiller may query the Placer directly. Whether such communication is possible depends on the broader environment, e.g. endpoint discoverability, (dynamic) client registration, shared scopes and business rules, service and business agreements, etc.

Where direct communication isn't feasible, intermediaries may:
* Act as **intermediate record holders** that store local representations of relevant data so they may provide it to involved systems. 
* Act as **brokers** that proxy requests from later actors to prior ones, while maintaining little or minimal state themselves.

In either of these scenarios, when forwarding requests, a party must rewrite references in the notifications they send to point to their own server, rather than actors upstream.

Alternatively, actors in the chain can reduce dependency on references by including information they expect later parties will need with the notifications that they send (whether that is sent as a Message bundle, a SubscriptionStatus notification bundle, etc.).

These patterns reinforce the guide’s recommendation to center communication around Tasks rather than Requests. Doing so ensures consistency across handoffs (e.g., Notification N–1 and N may follow the same structure), and allows each actor pair to coordinate around a shared Task without requiring full awareness of downstream workflows. Complex exchanges can then be composed from these modular interactions.

Note that an *exchange* intermediary need not necessarily be a *workflow* intermediary. An exchange intermediary may exist purely to facilitate communication by acting as a "hub and spoke" that reduces the need for pairwise client registration and the number of parties able to mutually authenticate, by simplifying addressbook synchronization, or by assisting with the aggregation of audit logs. An exchange broker fulfilling these roles may still be entirely invisible to the workflow. As an example, a system may exist to connect prescribers to pharmacies; depending on the workflows of interest, it may act in a stateless manner and simply route prescriptions from placers to pharmacies, or it may itself act as a repository of prescriptions that may be queried and updated.

Likewise, a workflow intermediary may be either an 'intermediate record holder', a 'broker', or both from an exchange perspective. The example of a community lab, a hospital lab, and a reference lab is typical; a hospital lab may produce its own resources relevant to a workflow, even as it also facilitates communication between a communnity lab and a reference lab by proxying requests or by storing copies of data. Depending on workflow need and the exchange ecosystem, the community lab and the reference lab may or may not be aware of each other and may or may not be able to communicate directly.

For additional information on this topic, architects and implementation guide authors are encouraged to read the White Paper from the FHIR Infrastructure group available [here]([url](https://confluence.hl7.org/spaces/FHIR/pages/144967060/Intermediaries+White+Paper)). 

#### Effect of Exchange Intermediaries on Coordination Tasks:

If intermediaries act purely as brokers for exchange, Placers and Fulfillers must coordinate which party will host resources relevant to managing the workflow. For example, a Placer and Fulfiller must  agree whether the Coordination Task that acts as their shared source of truth will be hosted at a FHIR server designated by the Placer or one designated by the Fulfiller.    
Intermediaries acting as intermediate record holder for the exchange introduce an additional option, which is that they may themselves host workflow resources. 

<table border="1" borderspacing="0" style='border: 1px solid black; border-collapse: collapse' class="table">
    <thead>
      <tr>
        <th></th>
        <th>From Fulfiller Perspective: Task at Placer</th>
        <th>From Fulfiller Perspective: Task at Fulfiller</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><b>From Placer Perspective: Task at Placer</b></td>
        <td>Intermediary may be a broker or an intermediate record holder. The intermediary must rewrite references so each actor may function as when they communicate directly.</td>
        <td>Intermediary must extract Task information from Placer and create a duplicate at Fulfiller. They must also reflect any changes to the Fulfiller's Task back to the Placer's Task. </td>
      </tr>
      <tr>
        <td><b>From Placer Perspective: Task at Fulfiller</b></td>
        <td>The Task used as the shared source of truth between the Placer and Fulfiller is at the Intermediary</td>
        <td>Intermediary may be a broker or an intermediate record holder. The intermediary must rewrite references so each actor may function as when they communicate directly.</td>
      </tr>
    </tbody>
  </table>


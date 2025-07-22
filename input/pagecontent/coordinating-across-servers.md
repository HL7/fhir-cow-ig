The wider exchange ecosystem influences whether details of an event should be sent alongisde a notification, or if actors can instead rely on a recipient's ability to query for additional information if needed.

While support for targetted queries is a key feature of FHIR, it introduces optionality that integration architects should consider.  

TODO - add sections on:
* Provenance
* Move some of the background about messages vs subscriptions here?


### Managing Access by Fulfillers:
Actors in a RESTful exchange often wish to limit the set of resources that another actor may access (or the interactions they may initiate), with more granularity than what is provided with traditional OAuth 2.0 scopes. This can sometimes encourage groups to rely on Messages rather than permitting RESTful exchange.

This guide provides two options to consider, though their use is optional within this IG:

1. Actors may leverage [SMART v2 scopes](https://hl7.org/fhir/smart-app-launch/) to provide finer-grained control of what another actor may access. For example, a Placer may indicate that a Fulfiller can query only for resources of a particular category, such as ServiceRequests related to social care referrals or Observation resources related to Labs.
2. Senders of a notification may include an [authorization hint](https://build.fhir.org/ig/HL7/fhir-subscription-backport-ig/StructureDefinition-notification-authorization-hint.html) that the recipient may redeem while requesting an access token. Such an authorization hint (also called an authorization_base in some specifications) may be used by its creator to tailor the set of resources the actor presenting the authorization hint may access. As an example, this can be used to limit a Service Provider to only obtaining information on patients for whom an authorization hint has been sent to them as part of a referral notification.  


### Sharing Content When Intermediaries are Present:

While many examples in this guide assume direct communication between a Placer and Fulfiller, real-world workflows often involve intermediaries. For example, a clinician may send a specimen to a community lab, which in turn forwards it to a reference lab.

This type of “chain care” is common and introduces complexity—but also motivates many of the abstractions recommended in this guide. Consider a scenario where a request originates from an upstream actor (e.g., N–1), but a downstream fulfiller (e.g., N+1) needs access to information held by an earlier actor.

{% include img.html img="sharing-info-with-intermediaries.png" %}

If direct communication is possible, and if references across notifications were preserved, the Fulfiller may query the Placer directly. Whether such communication is possible depends on the broader environment, e.g. endpoint discoverability, (dynamic) client registration, shared scopes and business rules, etc.

Where direct communication isn't feasible, intermediaries may:
* Store local representations of relevant data so they may provide it to downstream.
* Proxy" requests from later actors to those upstream.

In either of these scenarios, when forwarding requests, a party must rewrite references in the notifications they send to point to their own server, rather than actors upstream.

Alternatively, actors in the chain can reduce dependency on references by including information they expect later parties will need with the notifications (whether that is a Message bundle, a SubscriptionStatus notification bundle, etc.).

These patterns reinforce the guide’s recommendation to center communication around Tasks rather than Requests. Doing so ensures consistency across handoffs (e.g., Notification N–1 and N can follow the same structure), and allows each actor pair to coordinate around a shared Task without requiring full awareness of downstream workflows. Complex exchanges can then be composed from these modular interactions.

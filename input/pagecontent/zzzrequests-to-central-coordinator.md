Many locales and care domains rely on a central coordinator to manage some aspects of an order, referral, or transfer workflow. In these flows, a requestor notifies a central management group that they have a service which must be performed, and that central management group may then triage, notify performers, assign providers, etc.

Details may vary considerably by business agreements (such as whether the coordinator may _assign_ a request to a performer, or merely notify them) and architecture.

Some common reasons for a central coordinator include:
* Facilitating triage of scarce resources
* Managing waitlists
* Facilitating some parts of the exchange like endpoint discovery and client registration

Later sections of this guide include details for a FHIR implementation to minimize the extent to which a requestor must be 'aware' of whether they are interacting with a central coordinator or a fulfiller. 

{% include img.html img="request-central.png" %}

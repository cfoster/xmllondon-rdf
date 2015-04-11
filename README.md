# XML London - RDF Open Data

This repository holds the dataset found in the XML London RDF triple store. Everything about each XML London conference is represented and marked up according to the [Semantic Web Conference Ontology](http://data.semanticweb.org/ns/swc/swc_2009-05-09.html) (SWC).

<img src='https://raw.githubusercontent.com/wiki/cfoster/xmllondon-rdf/bones_256.png' width='50px' style="float:right;padding:5px;">

* [common-vocabularies](https://github.com/cfoster/xmllondon-rdf/tree/master/common-vocabularies), ontologies like PURL, FOAF, SWCO, etc.
* [specifics-generator](https://github.com/cfoster/xmllondon-rdf/tree/master/specifics-generator), XSLT code used to generate specifics from modified DOI batch files.
* [2013-general.ttl](https://github.com/cfoster/xmllondon-rdf/blob/master/2013-general.ttl), general info about the [XML London 2013](http://xmllondon.com/2013) conference.
* [2013-specifics.rdf](https://github.com/cfoster/xmllondon-rdf/blob/master/2013-specifics.rdf), specific info about [XML London 2013](http://xmllondon.com/2013), presentations, papers, etc.
* [2014-general.ttl](https://github.com/cfoster/xmllondon-rdf/blob/master/2014-general.ttl), general info about the [XML London 2014](http://xmllondon.com/2014) conference.
* [2014-specifics.rdf](https://github.com/cfoster/xmllondon-rdf/blob/master/2014-specifics.rdf), specific info about [XML London 2014](http://xmllondon.com/2014), presentations, papers, etc.
* [2015-general.ttl](https://github.com/cfoster/xmllondon-rdf/blob/master/2015-general.ttl), general info about the [XML London 2015](http://xmllondon.com) conference (**not yet complete**).
* [2015-specifics.rdf](https://github.com/cfoster/xmllondon-rdf/blob/master/2015-specifics.rdf), specifics about [XML London 2015](http://xmllondon.com/), presentations, papers, etc (**incomplete**).
* [locations.ttl](https://github.com/cfoster/xmllondon-rdf/blob/master/locations.ttl), holds information about places, such as UCL.
* [organisations.ttl](https://github.com/cfoster/xmllondon-rdf/blob/master/organisations.ttl), info about organisations that XML London knows about.
* [other-events.ttl](https://github.com/cfoster/xmllondon-rdf/blob/master/other-events.ttl), very basic info about other events, like XML Prague etc.
* [people.ttl](https://github.com/cfoster/xmllondon-rdf/blob/master/people.ttl), info about people which XML London knows about.
* [xmllondon-schema.ttl](https://github.com/cfoster/xmllondon-rdf/blob/master/xmllondon-schema.ttl), custom RDFS for concepts the common vocabularies didn't quite cover.

## SPARQL and Browse

You can run SPARQL queries and Visually browse and navigate the [XML London](http://xmllondon.com) triple store by clicking on the fixed SPARQL icon on the bottom right hand side of the [XML London](http://xmllondon.com) website.

<img src='https://raw.githubusercontent.com/wiki/cfoster/xmllondon-rdf/website-sparql-icon-shot-1.jpg' width='100%'>

SPARQL Endpoint: [http://xmllondon.com/sparql](http://xmllondon.com/sparql)

Graph Store Protocol: [http://xmllondon.com/data](http://xmllondon.com/data)
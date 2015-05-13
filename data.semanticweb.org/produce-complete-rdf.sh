# Produces a single complete RDF/XML file for http://data.semanticweb.org
#
# Takes Turtle as well as RDF/XML files in the parent directory and produces one
# large single complete RDF/XML file.
#
# Will not include common-vocabularies like owl, SCoRO, foaf, etc.

### SET where your rdfconvert directory is here
RDF_CONVERT_BIN=/crf/software/rdfconvert-0.3.2/bin/

##############################################################################
# No need to edit below here
##############################################################################

mkdir -p temp
COUNTER=1

## Convert Turtle files to RDF

for i in $( ls ../*.ttl ); do
 $RDF_CONVERT_BIN/rdfconvert.sh -i 'Turtle' -o 'RDF/XML' $i temp/$COUNTER.rdf
 let COUNTER+=1
done

## Copy RDF files in

cp ../*.rdf temp

## Make complete file

echo '<rdf:RDF

  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:swc="http://data.semanticweb.org/ns/swc/ontology#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:ical="http://www.w3.org/2002/12/cal/ical#"
  xmlns:swrc="http://swrc.ontoware.org/ontology#"
  xmlns:bibo="http://purl.org/ontology/bibo/"
  xmlns:xlswc="http://xmllondon.com/ns/swc/ontology#"
  xmlns:twitter="https://twitter.com/"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
  xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
  xmlns:wiki="http://www.wikipedia.org/wiki/"
  xmlns:dbpedia="http://dbpedia.org/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
  <!-- originally from https://github.com/cfoster/xmllondon-rdf -->
' > complete.rdf

for i in $( ls temp/*.rdf ); do
 xmllint --xpath '/node()/node()' $i >> complete.rdf
done

echo '
</rdf:RDF>' >> complete.rdf

rm -fr temp

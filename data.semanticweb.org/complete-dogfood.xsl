<?xml version="1.0" encoding="UTF-8"?>

<!--
  Stylesheet to produce complete RDF/XML documents, in a format which
  data.semanticweb.org are able to deal with and process.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xf="http://xmllondon.com/xsl/functions"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  exclude-result-prefixes="#all"
  version="2.0">
  
  <xsl:param name="year" as="xs:string" />
  
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  
  <xsl:template name="main">
    <xsl:sequence select="xf:amalgamate($year)"/>
  </xsl:template>
  
  <xsl:function name="xf:amalgamate">
    <xsl:param name="year" as="xs:string" />
    
    <xsl:variable name="shared" as="xs:string+" select="
      'locations.rdf',
      'organisations.rdf',
      'other-events.rdf',
      'people.rdf',
      'xmllondon-schema.rdf'" />
    
    <rdf:RDF
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
      xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
      xmlns:org="http://www.w3.org/ns/org#"
      xmlns:github="https://github.com/"
      xmlns:xmllondon="http://data.semanticweb.org/conference/xmllondon/"
      xmlns:xmlprague="http://www.xmlprague.cz/"
      xmlns:xmlss="http://xmlsummerschool.com/"
      xmlns:xmlamsterdam="http://xmlamsterdam.com/"
      xmlns:balisage="http://www.balisage.net/">
      
      <xsl:for-each select="$shared">
        <xsl:sequence select="fn:doc(
          fn:concat('temp/', .)
          )/element()/element()"/>
      </xsl:for-each>
      
      <xsl:sequence select="
        fn:doc(
        fn:concat('temp/', $year, '-general.rdf')
        )/element()/element()"/>

      <xsl:sequence select="
        fn:doc(
        fn:concat('temp/', $year, '-specifics.rdf')
        )/element()/element()"/>
      
    </rdf:RDF>
    
  </xsl:function>
  
</xsl:stylesheet>

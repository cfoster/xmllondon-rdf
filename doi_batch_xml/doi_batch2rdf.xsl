<xsl:stylesheet version="2.0"
                xmlns:f="http://xmllondon.com/xsl/functions"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:swc="http://data.semanticweb.org/ns/swc/ontology#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xpath-default-namespace="http://www.crossref.org/schema/4.3.0"
>

  <xsl:output indent="yes" omit-xml-declaration="yes" />

  <xsl:variable name="year"
    select="//body/conference/event_metadata/conference_date/@start_year"
    as="xs:gYear" />

  <xsl:variable name="acronym" select="'xmllondon'" />

  <xsl:template match="doi_batch">
    <RDF>
      <xsl:apply-templates select="body/conference" />
    </RDF>
  </xsl:template>

  <xsl:template match="conference">
    <Description rdf:about="{f:dog-food-uri('/proceedings')}">
      <xsl:apply-templates select="conference_paper" />
    </Description>
  </xsl:template>

  <xsl:template match="conference_paper">

    <xsl:variable name="surname" select="contributors/person_name[1]/surname"
      as="xs:string" />

    <xsl:variable name="surname-normalized" as="xs:string" 
      select="fn:replace(
        fn:lower-case(
          f:normalize-unicode($surname)
        ), '\s', '-')" />

    <swc:hasPart>
      <xsl:value-of
        select="f:dog-food-uri(fn:concat('/paper/', $surname-normalized))" />
    </swc:hasPart>

  </xsl:template>

  <xsl:function name="f:dog-food-uri" as="xs:anyURI">
    <xsl:param name="suffix" as="xs:string" />
    <xsl:value-of select="fn:concat(
      'http://data.semanticweb.org/conference/', $acronym, '/', $year,
      $suffix)" />
  </xsl:function>

  <xsl:function name="f:normalize-unicode" as="xs:string">
    <xsl:param name="value" as="xs:string" />

    <xsl:choose> <!-- hand-crafted exceptions -->
      <xsl:when test="$value eq 'Weingärtner'">weingaertner</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-unicode(replace(
          normalize-unicode($value,'NFKD'),'\p{Mn}',''),'NFKC')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>



</xsl:stylesheet>

<!--
<2014/paper/kay> a swc:Paper , swrc:InProceedings ;
  swc:isPartOf <http://data.semanticweb.org/conference/xmllondon/2014/proceedings> ;
  dc:creator <http://data.semanticweb.org/person/michael-kay> , <http://data.semanticweb.org/person/debbie-lockett> ;
  dc:subject "Benchmarking XSLT" , "Saxon" , "XSLT" ;
  dc:identifier "doi:10.14337/XMLLondon14.Kay01" ;
  dc:title "Benchmarking XSLT Performance" ;
  bibo:authorList <http://data.semanticweb.org/conference/xmllondon/2014/paper/kay/authorlist> ;
  bibo:doi "10.14337/XMLLondon14.Kay01" ;
  bibo:pageStart "10" ;
  bibo:pageEnd "23" ;
  swrc:abstract "This paper presents a new benchmarking framework for XSLT. The project, called XT-Speedo, is open source and we hope that it will attract a community of developers. The tangible deliverable consists of a set of test material, a set of test drivers for various XSLT processors, and tools for analyzing the test results. Underpinning these deliverables is a methodology and set of measurement objectives that influence the design and selection of material for the test suite, which are also described in this paper." ;
  swrc:month "June" ;
  swrc:year "2014" ;
  rdfs:label "Benchmarking XSLT Performance" ;
  foaf:maker <http://data.semanticweb.org/person/michael-kay> , <http://data.semanticweb.org/person/debbie-lockett> .

-->
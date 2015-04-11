<xsl:stylesheet version="2.0"
                xmlns:f="http://xmllondon.com/xsl/functions"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:swc="http://data.semanticweb.org/ns/swc/ontology#"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:ical="http://www.w3.org/2002/12/cal/ical#"
                xmlns:swrc="http://swrc.ontoware.org/ontology#"
                xmlns:bibo="http://purl.org/ontology/bibo/"
                xmlns:xlswc="http://xmllondon.com/ns/swc/ontology#"
                xpath-default-namespace="http://www.crossref.org/schema/4.3.0">

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
      <xsl:apply-templates select="conference_paper" mode="hasPart" />
    </Description>

    <xsl:apply-templates select="conference_paper" />
  </xsl:template>

  <xsl:template match="conference_paper" mode="hasPart">
    <xsl:variable name="surname-normalized" as="xs:string"
      select="f:normalized-surname(contributors/person_name[1])" />

    <swc:hasPart rdf:resource="{
      f:dog-food-uri(fn:concat('/paper/', $surname-normalized))}" />

  </xsl:template>

  <xsl:template match="conference_paper">
    <xsl:variable name="surname-normalized" as="xs:string"
      select="f:normalized-surname(contributors/person_name[1])" />

    <Description><!-- </Description> rdf:about="{f:dog-food-uri('/proceedings')}"> -->
      <xsl:attribute name="rdf:about">
        <xsl:value-of
          select="f:dog-food-uri(fn:concat('/paper/', $surname-normalized))" />
      </xsl:attribute>

      <rdf:type rdf:resource="http://data.semanticweb.org/ns/swc/ontology#Paper"/>
      <rdf:type rdf:resource="http://swrc.ontoware.org/ontology#InProceedings"/>

      <xsl:apply-templates select="pages/element()" />
      <xsl:apply-templates select="titles/title" />

      <rdfs:label>
        <xsl:value-of select='
          concat(contributors/person_name[1]/given_name, " ",
                 contributors/person_name[1]/surname, "&apos;s ", $year, " paper")
        ' />
      </rdfs:label>

      <swc:isPartOf rdf:resource="{f:dog-food-uri('/proceedings')}"/>

      <swrc:month>June</swrc:month> <!-- XML London always held in June -->

      <swrc:year>
        <xsl:value-of select="$year" />
      </swrc:year>

      <xsl:if test="doi_data/doi">
        <owl:sameAs rdf:resource="{concat('http://dx.doi.org/', f:doi(.))}" />
        <dc:identifier>doi:<xsl:value-of select="f:doi(.)"/></dc:identifier>
      </xsl:if>

      <xsl:apply-templates select="contributors/person_name" />
      <swc:relatedToEvent rdf:resource="{f:dog-food-uri(fn:concat('/presentation/', $surname-normalized))}" />

      <foaf:depiction rdf:resource="{
        fn:concat('http://xmllondon.com/', $year, '/images/thumbnails/papers/', $surname-normalized, '.gif')
      }"/>

    </Description>

    <xsl:if test="slides-url">
      <Description>
        <xsl:attribute name="rdf:about">
          <xsl:value-of select="slides-url" />
        </xsl:attribute>
        <rdfs:label>
          <xsl:value-of select='
            concat(contributors/person_name[1]/given_name, " ",
                   contributors/person_name[1]/surname, "&apos;s ", $year, " slides")
          ' />
        </rdfs:label>
        <swc:relatedToEvent rdf:resource="{f:dog-food-uri(fn:concat('/presentation/', $surname-normalized))}" />
        <rdf:type rdf:resource="http://data.semanticweb.org/ns/swc/ontology#SlideSet"/>
        <foaf:homepage rdf:resource="{slides-url}" />
        <foaf:depiction rdf:resource="{
          fn:concat('http://xmllondon.com/', $year, '/images/thumbnails/slides/', $surname-normalized, '.gif')
        }"/>
      </Description>
    </xsl:if>

    <Description rdf:about="{
      fn:concat('http://data.semanticweb.org/person/',
      f:normalized-complete-name(contributors/person_name[1]))}">
      <xlswc:gaveTalk rdf:resource="{f:dog-food-uri(fn:concat('/presentation/', $surname-normalized))}" />
    </Description>

    <Description rdf:about="{f:dog-food-uri(fn:concat('/presentation/', $surname-normalized))}">

      <rdf:type rdf:resource="http://data.semanticweb.org/ns/swc/ontology#TalkEvent"/>

      <swc:isSubEventOf rdf:resource="{f:dog-food-uri('')}" />

      <rdfs:label>
        <xsl:value-of select='
          concat(contributors/person_name[1]/given_name, " ",
                 contributors/person_name[1]/surname, "&apos;s ", $year, " talk")
        ' />
      </rdfs:label>

      <xlswc:talkGivenBy rdf:resource="{
        fn:concat('http://data.semanticweb.org/person/',
        f:normalized-complete-name(contributors/person_name[1]))}" />

      <swc:hasRelatedDocument rdf:resource="{f:dog-food-uri(fn:concat('/paper/', $surname-normalized))}" />

      <xsl:if test="slides-url">
        <swc:hasRelatedDocument rdf:resource="{slides-url/string()}" />
      </xsl:if>

      <foaf:depiction rdf:resource="{
        fn:concat('http://xmllondon.com/', $year, '/images/', $surname-normalized, '-speaking.jpg')
      }"/>

      <foaf:homepage rdf:resource="{
        fn:concat('http://xmllondon.com/', $year, '/presentations/', $surname-normalized)
      }"/>

    </Description>

  </xsl:template>

  <xsl:template match="contributors/person_name">

    <xsl:variable name="uri">
      <xsl:value-of select="
        fn:concat('http://data.semanticweb.org/person/',
        f:normalized-complete-name(.))" />
    </xsl:variable>

    <dc:creator rdf:resource="{$uri}" />

  </xsl:template>

  <xsl:template match="first_page">
    <bibo:pageStart>
      <xsl:value-of select="."/>
    </bibo:pageStart>
  </xsl:template>

  <xsl:template match="last_page">
    <bibo:pageEnd>
      <xsl:value-of select="."/>
    </bibo:pageEnd>
  </xsl:template>

  <xsl:template match="titles/title">
    <dc:title>
      <xsl:value-of select="." />
    </dc:title>
  </xsl:template>

  <xsl:function name="f:doi" as="xs:string">
    <xsl:param name="paper" as="element(conference_paper)" />
    <xsl:value-of select="$paper/doi_data/doi/string()" />
  </xsl:function>

  <xsl:function name="f:dog-food-uri" as="xs:anyURI">
    <xsl:param name="suffix" as="xs:string" />
    <xsl:value-of select="fn:concat(
      'http://data.semanticweb.org/conference/', $acronym, '/', $year,
      $suffix)" />
  </xsl:function>

  <xsl:function name="f:normalized-surname" as="xs:string">
    <xsl:param name="name" as="element(person_name)" />
    <xsl:value-of
      select="f:normalized-name-from-string($name/surname/string())" />
  </xsl:function>

  <xsl:function name="f:normalized-complete-name" as="xs:string">
    <xsl:param name="name" as="element(person_name)" />
    <xsl:value-of select="f:normalized-name-from-string($name/string())" />
  </xsl:function>

  <xsl:function name="f:normalized-name-from-string" as="xs:string">
    <xsl:param name="value" as="xs:string" />

    <xsl:choose> <!-- hand-crafted exceptions -->
      <xsl:when test="$value eq 'Weingärtner'">weingaertner</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="f:normalize-unicode(fn:normalize-space($value))" />
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>

  <xsl:function name="f:normalize-unicode" as="xs:string">
    <xsl:param name="value" as="xs:string" />

    <xsl:choose> <!-- hand-crafted exceptions -->
      <xsl:when test="fn:lower-case($value) eq 'weingärtner'">weingaertner</xsl:when>
      <xsl:when test="fn:lower-case($value) eq 'elias weingärtner'">elias-weingaertner</xsl:when>
      <xsl:when test="fn:lower-case($value) eq 'van den bleeken'">bleeken</xsl:when>
      <xsl:when test="fn:lower-case($value) eq 'van der vlist'">vlist</xsl:when>
      <xsl:when test='fn:lower-case($value) eq "o&apos;neil delpratt"'>oneil-delpratt</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="
          fn:replace(
            fn:lower-case(normalize-unicode(replace(
            normalize-unicode(fn:normalize-space($value),'NFKD'),'\p{Mn}',''),'NFKC')),
          '\s','-')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>

<!--
<2014/paper/kay> a swc:Paper , swrc:InProceedings ; [done]
  swc:isPartOf <http://data.semanticweb.org/conference/xmllondon/2014/proceedings> ; [done]
  dc:title "Benchmarking XSLT Performance" ; [done]
  bibo:pageStart "10" ; [done]
  bibo:pageEnd "23" ; [done]
  rdfs:label "Benchmarking XSLT Performance" ; [done]
  swrc:month "June" ; [done]
  swrc:year "2014" ; [done]
  dc:identifier "doi:10.14337/XMLLondon14.Kay01" ; [done]
  bibo:doi "10.14337/XMLLondon14.Kay01" ; [done]
  dc:creator <http://data.semanticweb.org/person/michael-kay> , <http://data.semanticweb.org/person/debbie-lockett> ; [done]
  foaf:maker <http://data.semanticweb.org/person/michael-kay> , <http://data.semanticweb.org/person/debbie-lockett> . [done]

  bibo:authorList <http://data.semanticweb.org/conference/xmllondon/2014/paper/kay/authorlist> ;

  swrc:abstract "This paper presents a new benchmarking framework for XSLT. The project, called XT-Speedo, is open source and we hope that it will attract a community of developers. The tangible deliverable consists of a set of test material, a set of test drivers for various XSLT processors, and tools for analyzing the test results. Underpinning these deliverables is a methodology and set of measurement objectives that influence the design and selection of material for the test suite, which are also described in this paper." ;
  dc:subject "Benchmarking XSLT" , "Saxon" , "XSLT" ;
-->
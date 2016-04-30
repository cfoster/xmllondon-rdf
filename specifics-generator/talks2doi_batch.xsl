<?xml version="1.0" encoding="UTF-8"?>
<!--
  talks to doi_batch XSLT
  
  Helps to produce an initial doi_batch XML file from a talks XML file,
  which can then be used to generate RDF/XML as well as getting most
  of the way there for getting something ready for crossref too.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:f="http://xmllondon.com/xsl/functions"
  xmlns="http://www.crossref.org/schema/4.3.0"
  exclude-result-prefixes="xs fn f"
  version="3.0">
  
  <xsl:output indent="yes" />
  
  <xsl:import href="doi_batch2rdf.xsl"/>
  
  <xsl:template match="conference">
    <doi_batch
      xmlns="http://www.crossref.org/schema/4.3.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.crossref.org/schema/4.3.0
      http://www.crossref.org/schema/deposit/crossref4.3.0.xsd"
      version="4.3.0">
      
      <head>
        
        <doi_batch_id>xml-london-2016-01</doi_batch_id>
        <timestamp>201606041000</timestamp> <!-- 2016-06-04T10:00:00 -->
        
        <depositor>
          <name>XML London</name>
        </depositor>
        <registrant>XML London</registrant>
      </head>
      
      <body>
        
        <conference>
          
          <contributors>
            <person_name sequence="first" contributor_role="chair">
              <given_name>Charles</given_name>
              <surname>Foster</surname>
            </person_name>
          </contributors>
          
          <event_metadata>
            <conference_name>XML London 2016 Conference</conference_name>
            <conference_acronym>XMLLondon16</conference_acronym>
            <!--
            <conference_sponsor>MarkLogic, http://www.marklogic.com</conference_sponsor>
            <conference_sponsor>oXygen, http://www.oxygenxml.com</conference_sponsor>
            <conference_sponsor>Saxonica, http://www.saxonica.com</conference_sponsor>
            -->
            <conference_number>4</conference_number>
            <conference_location>London, United Kingdom</conference_location>
            <conference_date start_day="4" start_month="6" start_year="2016"
              end_day="5" end_month="6"
              end_year="2016">June 4-5, 2016</conference_date>
          </event_metadata>
          
          <proceedings_metadata language="en">
            <proceedings_title>XML London 2016 Conference Proceedings</proceedings_title>
            <proceedings_subject>Innovations in XML, related technologies and the Semantic Web</proceedings_subject>
            <publisher>
              <publisher_name>XML London</publisher_name>
              <publisher_place>London</publisher_place>
            </publisher>
            <publication_date media_type="online">
              <month>6</month>
              <day>4</day>
              <year>2015</year>
            </publication_date>
            <isbn>978-0-9926471-3-1</isbn>
          </proceedings_metadata>
          
          <xsl:apply-templates select="day/talks/talk[
              fn:not(f:is-exception(.))
            ]" />
          
        </conference>
      </body>
      
    </doi_batch>
    
  </xsl:template>
  
  <xsl:template match="talk">
    
    <conference_paper language="en">
      <xsl:apply-templates select="people"/>
      <titles>
        <xsl:apply-templates select="talk/title"/>
        <xsl:apply-templates select="talk/subtitle"/>
      </titles>
      <publication_date media_type="online">
        <month>6</month>
        <day>4</day>
        <year>2016</year>
      </publication_date>
      <!--
      <pages>
        <first_page>9</first_page>
        <last_page>25</last_page>
      </pages>
      -->
      <publisher_item>
        <item_number item_number_type="article-number">
          <xsl:value-of select="fn:position()"/>
        </item_number>
      </publisher_item>
      
      <xsl:variable name="doi-suffix">
        <xsl:text>XMLLondon16.</xsl:text>
        <xsl:value-of select="
          f:capitalize-first(
            f:normalized-name-from-string(people/person[1]/last))"/>
        <xsl:text>01</xsl:text>
      </xsl:variable>
      
      <doi_data>
        <doi>
          <xsl:text>10.14337/</xsl:text>
          <xsl:value-of select="$doi-suffix"/>
        </doi>
        <resource>
          <xsl:text>http://xmllondon.com/</xsl:text>
          <xsl:value-of select="$doi-suffix"/>
        </resource>
      </doi_data>
      <!--
      <slides-url>http://xmllondon.com/2015/slides/Improving-XSLT-Pattern-Matching-Slideset.pdf</slides-url>
      -->
    </conference_paper>
    
  </xsl:template>
  
  <xsl:template match="people">
    <contributors>
      <xsl:apply-templates />
    </contributors>
  </xsl:template>
  
  <xsl:template match="person">
    <person_name sequence="first" contributor_role="author">
      <given_name>
        <xsl:value-of select="first"/>
      </given_name>
      <surname>
        <xsl:value-of select="last"/>
      </surname>
    </person_name>
  </xsl:template>
  
  <xsl:template match="title">
    <title>
      <xsl:value-of select="."/>
    </title>
  </xsl:template>

  <xsl:template match="subtitle">
    <subtitle>
      <xsl:value-of select="."/>
    </subtitle>
  </xsl:template>
  
  <xsl:function name="f:capitalize-first" as="xs:string?">
    <xsl:param name="arg" as="xs:string?"/>
    
    <xsl:sequence select="
      concat(upper-case(substring($arg,1,1)),
      substring($arg,2))
      "/>
  </xsl:function>
  
  <xsl:function name="f:is-exception" as="xs:boolean">
    <!-- where talks are not papers -->
    <xsl:param name="talk" as="element(talk)" />
    
    <xsl:sequence select="
      contains($talk/title, 'XSLT 3.0 Workshop')
      or
      contains($talk/title, 'Closing Address')"/>
    
  </xsl:function>
  
</xsl:stylesheet>
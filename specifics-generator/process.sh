#!/bin/sh
transform -s:doi_batch_xml_london_2013.xml -o:../2013-specifics.rdf -xsl:doi_batch2rdf.xsl
transform -s:doi_batch_xml_london_2014.xml -o:../2014-specifics.rdf -xsl:doi_batch2rdf.xsl
transform -s:doi_batch_xml_london_2015.xml -o:../2015-specifics.rdf -xsl:doi_batch2rdf.xsl

# transform -s:talks-xml/talks-2016.xml -o:doi_batch_xml_london_2016.xml -xsl:talks2doi_batch.xsl
transform -s:doi_batch_xml_london_2016.xml -o:../2016-specifics.rdf -xsl:doi_batch2rdf.xsl


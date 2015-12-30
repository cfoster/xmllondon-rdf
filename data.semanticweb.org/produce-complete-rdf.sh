# Produces a single complete RDF/XML file for http://data.semanticweb.org
#
# Takes Turtle as well as RDF/XML files in the parent directory and produces one
# large single complete RDF/XML file.
#
# Will not include common-vocabularies like owl, SCoRO, foaf, etc.

### SET where your rdfconvert directory is here
RDF_CONVERT_BIN=/crf/software/rdfconvert-0.3.2/bin/

### SET where your Saxon .jar is located
SAXON_LIB=/crf/misc/saxon/saxon-he-96/saxon9he.jar

##############################################################################
# No need to edit below here
##############################################################################

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

mkdir -p temp
# COUNTER=1

## Convert Turtle files to RDF
for i in $( ls ../*.ttl ); do
 FILE=`echo $i | sed 's/ttl/rdf/' | sed 's/..\///'`
 FILENAME_LENGTH=`echo $FILE | wc -m`
 COUNT=`expr 50 - $FILENAME_LENGTH`
 $RDF_CONVERT_BIN/rdfconvert.sh -i 'Turtle' -o 'RDF/XML' $i temp/$FILE
 if [ -s temp/$FILE ] ; then
   printf '%s%*s%s\n' "$FILE$GREEN" $COUNT "[OK]" "$NORMAL"
 else
   printf '%s%*s%s\n' "$FILE$RED" $COUNT "[FAIL]" "$NORMAL"
 fi
done

## Copy RDF files in

cp ../*.rdf temp

## Make complete file

function proc {
 OUT="xmllondon-complete-$1.rdf"
 rm -f $OUT
 java -cp $SAXON_LIB net.sf.saxon.Transform -it:main \
   -xsl:complete-dogfood.xsl year=$1 -o:$OUT

 if [ -s $OUT ] ; then
   printf '%s%*s%s\n' "$OUT$GREEN" 22 "[OK]" "$NORMAL"
 else
   printf '%s%*s%s\n' "$OUT$RED" 22 "[FAIL]" "$NORMAL"
 fi
}  


proc 2013
proc 2014
proc 2015

rm -fr temp

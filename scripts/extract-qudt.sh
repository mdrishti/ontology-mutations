
#!/bin/bash

# Extract the quantity/unit terms used for variant allele-frequency values.
#
# QUDT ships as two files: the core schema (QuantityValue, numericValue,
# hasUnit — extract cleanly with robot, see below) and the units vocabulary
# (unit:PERCENT). The units vocabulary is one densely interlinked graph —
# every unit individual points to quantitykind/, systemsOfUnits/, and
# dimensionVector/ resources and back — so a STAR/BOT module extraction for
# a single individual like unit:PERCENT pulls in most of the 2.3MB source
# file and trips robot's duplicate_label QC check thousands of times over
# unrelated multilingual labels elsewhere in the vocabulary (tested: BOT
# produced an 8.7MB module, STAR similar, both failing `robot report`).
# unit:PERCENT is hand-declared instead in ../extracted/qudt_unit_stub.ttl —
# see that file for the reasoning and the two triples actually needed.
echo "Extracting QUDT schema terms..."
robot extract \
	--input ../ontologies/qudt-schema.ttl \
	--term-file ../termFiles/qudtTermFile.txt \
	--method STAR \
  	--copy-ontology-annotations true \
	--output ../extracted/qudt_schema_star_temp.owl \
	--prefix 'qudt: http://qudt.org/schema/qudt/'

echo "Merging QUDT fragments..."
robot merge \
  --input ../extracted/qudt_schema_star_temp.owl \
  --input ../extracted/qudt_unit_stub.ttl \
  --output ../extracted/qudt_star_temp_merged.owl


# Add missing ontology metadata
echo "Annotating..."
robot annotate \
  --input ../extracted/qudt_star_temp_merged.owl \
  --ontology-iri "http://qudt.org/2.1/schema/qudt" \
  --annotation dc:title "QUDT Ontology (Extracted)" \
  --annotation dc:description "Extracted classifications from the Quantities, Units, Dimensions and Types (QUDT) schema and unit vocabularies" \
  --annotation dc:license "https://creativecommons.org/licenses/by/4.0/" \
  --output ../extracted/qudt_star_temp_annotated.owl



#cleanup
echo "Cleaning up.."
mv ../extracted/qudt_star_temp_annotated.owl ../extracted/qudt_star.owl
rm ../extracted/qudt_*star_temp*


# Generate a report to see what we got. --fail-on none: the QUDT schema
# module carries a handful of pre-existing duplicate/missing-label issues on
# classes unrelated to what MVIKG uses (UCUM encoding types, etc.) — see the
# report for details, but they don't block the build.
echo "Creating a report..."
robot report \
  --input ../extracted/qudt_star.owl \
  --output ../reports/qudt-extraction-report.txt \
  --fail-on none

echo "Check ../reports/qudt-extraction-report.txt for details"

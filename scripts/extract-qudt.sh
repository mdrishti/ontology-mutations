
#!/bin/bash

# Extract the quantity/unit terms used for variant allele-frequency values.
#
# QUDT ships as two files: the core schema (qudt:Unit, qudt:symbol — see
# below) and the units vocabulary (unit:PERCENT, unit:UNITLESS). Both files
# are densely self-interlinked — every unit/class points to quantitykind/,
# systemsOfUnits/, dimensionVector/, encoding/cardinality/ordering-type
# resources and back — so a STAR/BOT module extraction for even a single
# term (tested with qudt:Unit from the schema, and unit:PERCENT from the
# unit vocabulary) pulls in dozens to thousands of unrelated classes and
# trips robot's duplicate_label QC check over multilingual labels elsewhere
# in the vocabulary. Nothing is extracted from QUDT via robot anymore —
# qudt:Unit, unit:PERCENT, and unit:UNITLESS are all hand-declared instead
# in ../extracted/qudt_unit_stub.ttl — see that file for the reasoning and
# the handful of triples actually needed.

echo "Annotating..."
robot annotate \
  --input ../extracted/qudt_unit_stub.ttl \
  --ontology-iri "http://qudt.org/2.1/schema/qudt" \
  --annotation dc:title "QUDT Ontology (Extracted)" \
  --annotation dc:description "Hand-declared subset of the Quantities, Units, Dimensions and Types (QUDT) schema and unit vocabularies" \
  --annotation dc:license "https://creativecommons.org/licenses/by/4.0/" \
  --output ../extracted/qudt_star.owl


# Generate a report to see what we got.
echo "Creating a report..."
robot report \
  --input ../extracted/qudt_star.owl \
  --output ../reports/qudt-extraction-report.txt \
  --fail-on none

echo "Check ../reports/qudt-extraction-report.txt for details"

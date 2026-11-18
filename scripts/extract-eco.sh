#!/bin/bash

# Extract the evidence codes used to flag how a phenotype assertion was
# derived (ECO:0000305, ECO:0000035).
#
# Nothing is extracted from eco.owl via robot: ECO:0000305 is defined via a
# complex owl:equivalentClass intersection, so a STAR/BOT module for it alone
# pulls in a large chunk of ECO's own internal structure (same problem
# QUDT's Unit had). Both terms are hand-declared instead in
# ../extracted/eco_stub.ttl — see that file for the reasoning.

echo "Annotating..."
robot annotate \
  --input ../extracted/eco_stub.ttl \
  --ontology-iri "http://purl.obolibrary.org/obo/eco.owl" \
  --annotation dc:title "ECO Ontology (Extracted)" \
  --annotation dc:description "Hand-declared subset of the Evidence and Conclusion Ontology" \
  --annotation dc:license "https://creativecommons.org/publicdomain/zero/1.0/" \
  --output ../extracted/eco_star.owl


# Generate a report to see what we got.
echo "Creating a report..."
robot report \
  --input ../extracted/eco_star.owl \
  --output ../reports/eco-extraction-report.txt \
  --fail-on none

echo "Check ../reports/eco-extraction-report.txt for details"

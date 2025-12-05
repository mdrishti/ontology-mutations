#!/bin/bash

set -e  # Exit on error

echo "================================================"
echo "Building MVIKG Ontology"
echo "================================================"

echo ""

echo "Step 1: Merging source ../ontologies..."
robot merge \
  --input ../extracted/biolink_bot.owl \
  --input ../extracted/sosa_bot.owl \
  --input ../extracted/rdfs_star.owl \
  --input ../extracted/dcterms_star.owl \
  --input ../extracted/skos_star.owl \
  --output ../output/temp-sources-merged.owl
#  --input ../extracted/ro_star.owl \
#  --input ../extracted/gold_bot.owl \


robot remove \
  --input ../output/temp-sources-merged.owl \
  --select ontology \
  --output ../output/temp-sources-merged-removed.owl


echo "Step 2: Merging schema files..."
robot merge \
  --input ../mvikg/mvikg-annotations.ttl \
  --input ../mvikg/mvikg-property-constraints.ttl \
  --input ../mvikg/mvikg-restrictions.ttl \
  --output ../output/temp-mvikg-merged.owl
#  --input ../mvikg/cross-links.ttl \

echo "Step 3: Combining sources and schema..."
robot merge \
  --input ../output/temp-mvikg-merged.owl \
  --input ../output/temp-sources-merged-removed.owl \
  --output ../output/temp-combined.owl

echo "Step 4: Adding ontology metadata..."
robot annotate \
  --input ../output/temp-combined.owl \
  --ontology-iri "http://example.org/mvikg" \
  --version-iri "http://example.org/mvikg/0.0.1" \
  --output ../output/mvikg-integrated.owl \
  --annotation rdfs:label "MVIKG Ontology" \
  --annotation rdfs:comment "A schema for bacterial genotype-phenotype data integration" \
  --annotation dc:title "MVIKG: Multi-Variant Integration Knowledge Graph" \
  --annotation dc:description "An integrated ontology combining BioLink, SOSA, ENVO, RO, GOLD and other established ontologies for bacterial variant data modeling" \
  --annotation dc:license "https://creativecommons.org/licenses/by/4.0/" \
  --annotation dc:creator "MVIKG" \
  --annotation owl:versionInfo "0.0.1" \


echo "Step 5: Running reasoner (ELK)..."
robot reason \
  --input ../output/mvikg-integrated.owl \
  --reasoner ELK \
  --equivalent-classes-allowed asserted-only \
  --exclude-tautologies structural \
  --output ../output/mvikg-reasoned.owl

echo "Step 6: Generating validation report..."
robot report \
  --input ../output/mvikg-reasoned.owl \
  --output ../reports/mvikg-validation-report.txt \
  --fail-on none

echo "Step 7: Creating summary statistics..."
echo "Classes:" > ../reports/summary.txt
robot query \
  --input ../output/mvikg-reasoned.owl \
  --query "SELECT (COUNT(DISTINCT ?c) AS ?count) WHERE { ?c a owl:Class . FILTER(!isBlank(?c)) }" \
  /dev/stdout >> ../reports/summary.txt

echo "Object Properties:" >> ../reports/summary.txt
robot query \
  --input ../output/mvikg-reasoned.owl \
  --query "SELECT (COUNT(DISTINCT ?p) AS ?count) WHERE { ?p a owl:ObjectProperty }" \
  /dev/stdout >> ../reports/summary.txt

#echo "Step 8: Cleanup temporary files..."
#rm output/temp-*.owl

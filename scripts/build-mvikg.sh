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
  --input ../extracted/ro_star.owl \
  --input ../extracted/rdfs_star.owl \
  --input ../extracted/dcterms_star.owl \
  --input ../extracted/skos_star.owl \
  --input ../extracted/gold_bot.owl \
  --output output/temp-sources-merged.owl

echo "Step 2: Merging schema files..."
robot merge \
  --input schema/mvikg-crosslinks.ttl \
  --input schema/mvikg-property-constraints.ttl \
  --input schema/mvikg-restrictions.ttl \
  --input schema/mvikg-annotations.ttl \
  --output output/temp-schema-merged.owl

echo "Step 3: Combining sources and schema..."
robot merge \
  --input output/temp-sources-merged.owl \
  --input output/temp-schema-merged.owl \
  --output output/temp-combined.owl

echo "Step 4: Adding ontology metadata..."
robot annotate \
  --input output/temp-combined.owl \
  --ontology-iri "http://example.org/mvikg" \
  --version-iri "http://example.org/mvikg/1.0.0" \
  --annotation rdfs:label "MVIKG Ontology" \
  --annotation rdfs:comment "Multi-Variant Integration Knowledge Graph for genomic, environmental, and phenotypic data integration" \
  --annotation dcterms:title "MVIKG: Multi-Variant Integration Knowledge Graph" \
  --annotation dcterms:description "An integrated ontology combining BioLink, SOSA, ENVO, RO, GOLD and other established ../ontologies for multi-omics data modeling" \
  --annotation dcterms:license "https://creativecommons.org/licenses/by/4.0/" \
  --annotation dcterms:creator "Your Name" \
  --annotation owl:versionInfo "1.0.0" \
  --output output/mvikg-integrated.owl

echo "Step 5: Running reasoner (ELK)..."
robot reason \
  --input output/mvikg-integrated.owl \
  --reasoner ELK \
  --equivalent-classes-allowed asserted-only \
  --exclude-tautologies structural \
  --output output/mvikg-reasoned.owl

echo "Step 6: Generating validation report..."
robot report \
  --input output/mvikg-reasoned.owl \
  --output ../reports/mvikg-validation-report.txt \
  --fail-on none

echo "Step 7: Creating summary statistics..."
echo "Classes:" > ../reports/summary.txt
robot query \
  --input output/mvikg-reasoned.owl \
  --query "SELECT (COUNT(DISTINCT ?c) AS ?count) WHERE { ?c a owl:Class . FILTER(!isBlank(?c)) }" \
  /dev/stdout >> ../reports/summary.txt

echo "Object Properties:" >> ../reports/summary.txt
robot query \
  --input output/mvikg-reasoned.owl \
  --query "SELECT (COUNT(DISTINCT ?p) AS ?count) WHERE { ?p a owl:ObjectProperty }" \
  /dev/stdout >> ../reports/summary.txt

echo "Step 8: Listing GOLD biome classes included..."
robot query \
  --input output/mvikg-reasoned.owl \
  --query "PREFIX gold: <https://w3id.org/gold.path/>
           PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
           SELECT ?biome ?label WHERE {
             ?biome rdfs:subClassOf* gold:AtomicElement .
             OPTIONAL { ?biome rdfs:label ?label }
           } LIMIT 20" \
  ../reports/gold-biomes-sample.txt

echo "Step 9: Cleanup temporary files..."
rm output/temp-*.owl

echo ""
echo "================================================"
echo "Build Complete!"
echo "================================================"
echo "Final ontology: output/mvikg-reasoned.owl"
echo "Validation report: ../reports/mvikg-validation-report.txt"
echo "Summary: ../reports/summary.txt"
echo "GOLD biomes sample: ../reports/gold-biomes-sample.txt"
echo ""

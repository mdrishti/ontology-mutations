#!/bin/bash

set -e  # Exit on error

cd "$(dirname "$0")"  # always run relative to this script's directory

echo "================================================"
echo "Building MVIKG Ontology"
echo "================================================"

echo ""

echo "Step 1: Merging source ../ontologies..."
robot merge \
  --input ../extracted/biolink_bot.owl \
  --input ../extracted/sosa_star.owl \
  --input ../extracted/rdfs_star.owl \
  --input ../extracted/dcterms_star.owl \
  --input ../extracted/skos_star.owl \
  --input ../extracted/eco_star.owl \
  --input ../extracted/qudt_star.owl \
  --input ../extracted/so_star.owl \
  --output ../output/temp-sources-merged.owl
#  --input ../extracted/ro_star.owl \
#  --input ../extracted/gold_bot.owl \


robot remove \
  --input ../output/temp-sources-merged.owl \
  --select ontology \
  --output ../output/temp-sources-merged-removed.owl

echo "Step 1b: Dropping confusing vendor SOSA annotation (sosa:Sample as a rangeIncludes value on hasFeatureOfInterest clashes with MVIKG's own domain/range for that property)..."
robot query \
  --input ../output/temp-sources-merged-removed.owl \
  --update ../mvikg/remove-sample-range.ru \
  --update ../mvikg/remove-has-phenotype-biologicalentity.ru \
  --output ../output/temp-sources-merged-removed.owl


echo "Step 1c: Generating LinkML-authored portion of the MVIKG schema..."
cd .. && pipenv run gen-owl --no-use-native-uris linkml/mvikg.yaml > mvikg/mvikg-generated.ttl && cd scripts

echo "Step 1d: Stripping the LinkML schema's own ontology-level metadata (robot merge flattens every input's owl:Ontology header onto the final ontology IRI otherwise)..."
robot remove \
  --input ../mvikg/mvikg-generated.ttl \
  --select ontology \
  --output ../mvikg/mvikg-generated-removed.ttl

echo "Step 2: Merging schema files..."
robot merge \
  --input ../mvikg/mvikg-generated-removed.ttl \
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

echo "Step 6b: Running SHACL validation (linkml/mvikg-shapes.ttl)..."
# mvikg-reasoned.owl is TBox-only (no individuals), so this will report 0
# focus nodes for every shape until real KG instance data is validated
# against it -- that's expected, not a bug. The shapes themselves are
# exercised against synthetic fixtures in linkml/mvikg-shapes-test-data.ttl
# (not part of the build; run manually with pyshacl when editing shapes).
pipenv run pyshacl \
  --shacl ../linkml/mvikg-shapes.ttl \
  --data-file-format auto \
  --format human \
  ../output/mvikg-reasoned.owl \
  > ../reports/mvikg-shacl-report.txt 2>&1 || true

echo "Step 7: Creating summary statistics..."
echo "Classes:" > ../reports/summary.txt
robot query \
  --input ../output/mvikg-reasoned.owl \
  --query ../mvikg/count-classes.rq \
  /dev/stdout >> ../reports/summary.txt

echo "Object Properties:" >> ../reports/summary.txt
robot query \
  --input ../output/mvikg-reasoned.owl \
  --query ../mvikg/count-object-properties.rq \
  /dev/stdout >> ../reports/summary.txt

#echo "Step 8: Cleanup temporary files..."
#rm output/temp-*.owl

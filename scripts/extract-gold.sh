#!/bin/bash

echo "Extracting GOLD biome classes..."

# Extract the main biome classes and their children
robot extract \
  --input ontologies/gold.owl \
  --method BOT \
  --term-file termFiles/goldTermFile.txt \
  --copy-ontology-annotations true \
  --prefixes termFiles/gold-prefix.json \
  --output extracted/gold_bot_temp.owl
#  --prefix 'gold: https://w3id.org/gold.vocab/'\


# Add missing ontology metadata
echo "Annotating..."
robot annotate \
  --input extracted/gold_bot_temp.owl \
  --ontology-iri "http://purl.obolibrary.org/obo/gold.owl" \
  --annotation dc:title "GOLD Biome Ontology (Extracted)" \
  --annotation dc:description "Extracted biome classifications from the Genomes OnLine Database (GOLD)" \
  --annotation dc:license "https://gold.jgi.doe.gov/distribution_license" \
  --output extracted/gold_bot_temp_annotated.owl

# Add missing class definitions via template
#robot template \
#  --input extracted/gold_bot_temp_annotated.owl \
#  --template termFiles/gold-extraction-definitions.csv \
#  --prefixes termFiles/gold-prefix.json \
#  --output extracted/gold_bot.owl
#  --prefix 'gold: https://w3id.org/gold.vocab/'\

#cleanup
echo "Cleaning up.."
mv extracted/gold_bot_temp_annotated.owl extracted/gold_bot.owl
rm /gold_bot_temp*

# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input extracted/gold_bot.owl \
  --output reports/gold-extraction-report.txt

echo "Check reports/gold-extraction-report.txt for details"


#!/bin/bash

echo "Extracting biolink classes and props..."
robot extract \
	--input ontologies/biolink-model.owl.ttl \
	--method BOT \
	--term-file termFiles/biolinkTermFile.txt \
  	--copy-ontology-annotations true \
	--prefix 'biolink: https://w3id.org/biolink/vocab/' \
	--output extracted/biolink_bot_temp.owl

echo "Removing problematic terms..."
robot remove \
	--input extracted/biolink_bot_temp.owl \
	--term biolink:AgentTypeEnum#not_provided \
	--term biolink:KnowledgeLevelEnum#not_provided \
	--select "self" \
	--output extracted/biolink_bot_temp_removed.owl

echo "Annotating..."
robot annotate \
  --input extracted/biolink_bot_temp_removed.owl \
  --annotation dc:source "BioLink Model" \
  --annotation dc:title "BioLink Ontology (Extracted)" \
  --annotation dc:description "Extracted ontology classes and properties from BioLink" \
  --annotation dc:license "https://creativecommons.org/publicdomain/zero/1.0/" \
  --annotation rdfs:comment "Extracted biolink terms" \
  --output extracted/biolink_bot.owl

#cleanup
echo "Cleaning up.."
#mv extracted/biolink_bot_temp_annotated.owl extracted/biolink_bot.owl
rm extracted/biolink_bot_temp*

# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input extracted/biolink_bot.owl \
  --output reports/biolink-extraction-report.txt

echo "Check reports/biolink-extraction-report.txt for details"

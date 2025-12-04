
#!/bin/bash

echo "Extracting SOSA properties..."
robot extract \
	--input ../ontologies/ssn.owl \
	--term-file ../termFiles/sosaTermFile.txt \
	--method BOT \
  	--copy-ontology-annotations true \
	--output ../extracted/sosa_bot_temp.owl \
	--prefix 'sosa: http://www.w3.org/ns/sosa/'



# Add missing ontology metadata
echo "Annotating..."
robot annotate \
  --input ../extracted/sosa_bot_temp.owl \
  --ontology-iri "http://www.w3.org/ns/sosa/" \
  --annotation dc:title "SOSA Ontology (Extracted)" \
  --annotation dc:description "Extracted classifications from Sensor, Observation, Sample, and Actuator Ontology" \
  --annotation dc:license "http://www.opengeospatial.org/ogc/Software" \
  --output ../extracted/sosa_bot_temp_annotated.owl



#cleanup
echo "Cleaning up.."
mv ../extracted/sosa_bot_temp_annotated.owl ../extracted/sosa_bot.owl
rm ../extracted/sosa_bot_temp*


# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input ../extracted/sosa_bot.owl \
  --output ../reports/sosa_extraction-report.txt

echo "Check ../reports/sosa_extraction-report.txt for details"

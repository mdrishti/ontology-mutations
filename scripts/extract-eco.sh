
#!/bin/bash

# Extract the evidence codes used to flag how gene/variant assertions were derived
echo "Extracting ECO terms..."
robot extract \
	--input ../ontologies/eco.owl \
	--term-file ../termFiles/ecoTermFile.txt \
	--method STAR \
  	--copy-ontology-annotations true \
	--output ../extracted/eco_star_temp.owl \
	--prefix 'ECO: http://purl.obolibrary.org/obo/ECO_'


# Add missing ontology metadata
echo "Annotating..."
robot annotate \
  --input ../extracted/eco_star_temp.owl \
  --ontology-iri "http://purl.obolibrary.org/obo/eco.owl" \
  --annotation dc:title "ECO Ontology (Extracted)" \
  --annotation dc:description "Extracted classifications from the Evidence and Conclusion Ontology" \
  --annotation dc:license "https://creativecommons.org/publicdomain/zero/1.0/" \
  --output ../extracted/eco_star_temp_annotated.owl



#cleanup
echo "Cleaning up.."
mv ../extracted/eco_star_temp_annotated.owl ../extracted/eco_star.owl
rm ../extracted/eco_star_temp*


# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input ../extracted/eco_star.owl \
  --output ../reports/eco-extraction-report.txt

echo "Check ../reports/eco-extraction-report.txt for details"

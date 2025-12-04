
#!/bin/bash

# Extract the main biome classes and their children
echo "Extracting  RO properties..."
robot extract \
	--input ontologies/ro.owl \
	--term-file termFiles/roTermFile.txt \
	--method STAR \
  	--copy-ontology-annotations true \
	--output extracted/ro_star_temp.owl \
	--prefix 'RO: http://purl.obolibrary.org/obo/RO_'


# Add missing ontology metadata
echo "Annotating..."
robot annotate \
  --input extracted/ro_star_temp.owl \
  --ontology-iri "http://purl.obolibrary.org/obo/RO.owl" \
  --annotation dc:title "RO Ontology (Extracted)" \
  --annotation dc:description "Extracted classifications from Relational Ontology" \
  --annotation dc:license "https://creativecommons.org/publicdomain/zero/1.0/" \
  --output extracted/ro_star_temp_annotated.owl



#cleanup
echo "Cleaning up.."
mv extracted/ro_star_temp_annotated.owl extracted/ro_star.owl
rm extracted/ro_star_temp*


# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input extracted/ro_star.owl \
  --output reports/ro-extraction-report.txt

echo "Check reports/ro-extraction-report.txt for details"

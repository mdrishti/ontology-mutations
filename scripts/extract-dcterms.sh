
#!/bin/bash


# Extract the main biome classes and their children
echo "Extracting  RO properties..."
robot extract \
	--input-iri http://protege.stanford.edu/plugins/owl/dc/terms.owl \
	--term-file termFiles/dctermsTermFile.txt \
	--method STAR \
  	--copy-ontology-annotations true \
	--output extracted/dcterms_star_temp.owl \
	--prefix 'dcterms: http://purl.org/dc/terms/'


# Add missing ontology metadata
echo "Annotating..."
robot annotate \
  --input extracted/dcterms_star_temp.owl \
  --ontology-iri "http://protege.stanford.edu/plugins/owl/dc/terms.owl" \
  --annotation dc:title "DCTERMS Ontology (Extracted)" \
  --annotation dc:description "Extracted classifications from DCTERMS" \
  --annotation dc:license "https://creativecommons.org/licenses/by/4.0" \
  --output extracted/dcterms_star_temp_annotated.owl



#cleanup
echo "Cleaning up.."
mv extracted/dcterms_star_temp_annotated.owl extracted/dcterms_star.owl
rm extracted/dcterms_star_temp*


# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input extracted/dcterms_star.owl \
  --output reports/dcterms-extraction-report.txt

echo "Check reports/dcterms-extraction-report.txt for details"

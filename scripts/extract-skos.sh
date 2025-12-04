
#!/bin/bash

echo "Extracting SKOS properties..."
robot extract \
	--input ontologies/skos.owl \
	--term-file termFiles/skosTermFile.txt \
	--method STAR \
  	--copy-ontology-annotations true \
	--output extracted/skos_star_temp.owl \
	--prefix 'skos: http://www.w3.org/2004/02/skos/core#'


# Add missing ontology metadata
echo "Annotating..."
# FOR NOW, KEPT THE LICENSE INFO AS SHOWN BELOW. I COULD NOT FIND THE DISTRIBUTING LICENSE INFORMATION - 20251204
robot annotate \
  --input extracted/skos_star_temp.owl \
  --ontology-iri "http://www.w3.org/2004/02/skos/core#" \
  --annotation dc:title "SKOS Ontology (Extracted)" \
  --annotation dc:description "Extracted classifications from Simple Knowledge Organization System Ontology" \
  --annotation dc:license "https://creativecommons.org/publicdomain/by/4.0/" \
  --output extracted/skos_star_temp_annotated.owl



#cleanup
echo "Cleaning up.."
mv extracted/skos_star_temp_annotated.owl extracted/skos_star.owl
rm extracted/skos_star_temp*


# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input extracted/skos_star.owl \
  --output reports/skos_extraction-report.txt

echo "Check reports/skos_extraction-report.txt for details"

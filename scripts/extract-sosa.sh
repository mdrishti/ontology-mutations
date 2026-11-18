
#!/bin/bash

echo "Extracting SOSA properties..."
robot extract \
	--input ../ontologies/ssn.owl \
	--term-file ../termFiles/sosaTermFile.txt \
	--method STAR \
  	--copy-ontology-annotations true \
	--output ../extracted/sosa_star_temp.owl \
	--prefix 'sosa: http://www.w3.org/ns/sosa/'

echo "Pruning Sampling/Sampler/ssn:Property cluster pulled in incidentally by Sample's STAR module (see NOTES.md #12)..."
robot remove \
	--input ../extracted/sosa_star_temp.owl \
	--term sosa:Sampling \
	--term sosa:Sampler \
	--term sosa:hasResult \
	--term sosa:isResultOf \
	--term sosa:madeBySampler \
	--term sosa:madeSampling \
	--term sosa:resultTime \
	--term ssn:hasProperty \
	--term ssn:isPropertyOf \
	--term ssn:Property \
	--select "self" \
	--prefix 'sosa: http://www.w3.org/ns/sosa/' \
	--prefix 'ssn: http://www.w3.org/ns/ssn/' \
	--output ../extracted/sosa_star_temp_pruned.owl

# Add missing ontology metadata
echo "Annotating..."
robot annotate \
  --input ../extracted/sosa_star_temp_pruned.owl \
  --ontology-iri "http://www.w3.org/ns/sosa/" \
  --annotation dc:title "SOSA Ontology (Extracted)" \
  --annotation dc:description "Extracted classifications from Sensor, Observation, Sample, and Actuator Ontology" \
  --annotation dc:license "http://www.opengeospatial.org/ogc/Software" \
  --output ../extracted/sosa_star_temp_annotated.owl



#cleanup
echo "Cleaning up.."
mv ../extracted/sosa_star_temp_annotated.owl ../extracted/sosa_star.owl
rm ../extracted/sosa_star_temp*


# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input ../extracted/sosa_star.owl \
  --output ../reports/sosa_extraction-report.txt \
  --fail-on none

echo "Check ../reports/sosa_extraction-report.txt for details"

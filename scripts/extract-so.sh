
#!/bin/bash

# Extract the Sequence Ontology terms used to type sequence variants (and,
# for anything that doesn't map to a specific SO type, the generic
# SO:0001059 sequence_alteration fallback — see rdfLibMVIKG/ITEM5-PLAN.md).
#
# NOTE: robot's OBO->OWL conversion mints IRIs under the standard OBO PURL
# scheme (http://purl.obolibrary.org/obo/SO_0000048), NOT under
# http://www.sequenceontology.org/browser/current_svn/term/0000048 — the
# namespace rdfLibMVIKG's src/common/constants.py currently (incorrectly)
# uses for SO. Extracting under the real/standard PURL here is the correct
# thing to do; it means these labels won't resolve against the KG's current
# output until that constants.py namespace is also fixed (flagged
# separately, not fixed here per the rdfLibMVIKG-side work being handled
# later).
echo "Extracting SO terms..."
robot extract \
	--input ../ontologies/so-edit.obo \
	--term-file ../termFiles/soTermFile.txt \
	--method STAR \
  	--copy-ontology-annotations true \
	--output ../extracted/so_star_temp.owl \
	--prefix 'SO: http://purl.obolibrary.org/obo/SO_'


# Add missing ontology metadata
echo "Annotating..."
robot annotate \
  --input ../extracted/so_star_temp.owl \
  --ontology-iri "http://purl.obolibrary.org/obo/so.owl" \
  --annotation dc:title "SO Ontology (Extracted)" \
  --annotation dc:description "Extracted classifications from the Sequence Ontology" \
  --annotation dc:license "https://creativecommons.org/publicdomain/zero/1.0/" \
  --output ../extracted/so_star_temp_annotated.owl



#cleanup
echo "Cleaning up.."
mv ../extracted/so_star_temp_annotated.owl ../extracted/so_star.owl
rm ../extracted/so_star_temp*


# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input ../extracted/so_star.owl \
  --output ../reports/so-extraction-report.txt

echo "Check ../reports/so-extraction-report.txt for details"


#!/bin/bash

echo "Extracting biolink classes and props..."
robot extract \
	--input ../ontologies/biolink-model.owl.ttl \
	--method BOT \
	--term-file ../termFiles/biolinkTermFile.txt \
  	--copy-ontology-annotations true \
	--prefix 'biolink: https://w3id.org/biolink/vocab/' \
	--output ../extracted/biolink_bot_temp.owl

echo "Pruning Association/evidence-provenance cluster pulled in incidentally by GenomicEntity's BOT module (see NOTES.md #9)..."
robot remove \
	--input ../extracted/biolink_bot_temp.owl \
	--term biolink:GenomicSequenceLocalization \
	--term biolink:SequenceAssociation \
	--term biolink:Association \
	--term biolink:agent_type \
	--term biolink:knowledge_level \
	--term biolink:association_slot \
	--term biolink:predicate \
	--term biolink:subject \
	--term biolink:object \
	--term biolink:AgentTypeEnum \
	--term biolink:AgentTypeEnum#automated_agent \
	--term biolink:AgentTypeEnum#computational_model \
	--term biolink:AgentTypeEnum#data_analysis_pipeline \
	--term biolink:AgentTypeEnum#image_processing_agent \
	--term biolink:AgentTypeEnum#manual_agent \
	--term biolink:AgentTypeEnum#manual_validation_of_automated_agent \
	--term biolink:AgentTypeEnum#not_provided \
	--term biolink:AgentTypeEnum#text_mining_agent \
	--term biolink:KnowledgeLevelEnum \
	--term biolink:KnowledgeLevelEnum#knowledge_assertion \
	--term biolink:KnowledgeLevelEnum#logical_entailment \
	--term biolink:KnowledgeLevelEnum#not_provided \
	--term biolink:KnowledgeLevelEnum#observation \
	--term biolink:KnowledgeLevelEnum#prediction \
	--term biolink:KnowledgeLevelEnum#statistical_association \
	--select "self" \
	--prefix 'biolink: https://w3id.org/biolink/vocab/' \
	--output ../extracted/biolink_bot_temp_pruned.owl

echo "Removing empty owl:NamedIndividual stubs with no axioms, no labels, nothing (see NOTES.md #10)..."
robot remove \
	--input ../extracted/biolink_bot_temp_pruned.owl \
	--term biolink:ameliorates_condition \
	--term biolink:broad_match \
	--term biolink:contraindicated_in \
	--term biolink:decreases_sensitivity_to \
	--term biolink:disrupts \
	--term biolink:enabled_by \
	--term biolink:end_interbase_coordinate \
	--term biolink:exacerbates_condition \
	--term biolink:genetically_associated_with \
	--term biolink:has_active_ingredient \
	--term biolink:has_completed \
	--term biolink:has_decreased_amount \
	--term biolink:has_increased_amount \
	--term biolink:has_input \
	--term biolink:has_not_completed \
	--term biolink:has_output \
	--term biolink:has_part \
	--term biolink:increases_sensitivity_to \
	--term biolink:lacks_part \
	--term biolink:narrow_match \
	--term biolink:negatively_correlated_with \
	--term biolink:positively_correlated_with \
	--term biolink:preventative_for_condition \
	--term biolink:promotes_condition \
	--term biolink:start_interbase_coordinate \
	--select "self" \
	--prefix 'biolink: https://w3id.org/biolink/vocab/' \
	--output ../extracted/biolink_bot_temp_pruned2.owl

echo "Fixing known biolink extraction issues (see NOTES.md #4 and #8)..."
robot query \
	--input ../extracted/biolink_bot_temp_pruned2.owl \
	--update ../mvikg/remove-mentions-datatype-punning.ru \
	--output ../extracted/biolink_bot_temp_fixed.owl

echo "Annotating..."
robot annotate \
  --input ../extracted/biolink_bot_temp_fixed.owl \
  --annotation dc:source "BioLink Model" \
  --annotation dc:title "BioLink Ontology (Extracted)" \
  --annotation dc:description "Extracted ontology classes and properties from BioLink" \
  --annotation dc:license "https://creativecommons.org/publicdomain/zero/1.0/" \
  --annotation rdfs:comment "Extracted biolink terms" \
  --output ../extracted/biolink_bot.owl

#cleanup
echo "Cleaning up.."
#mv ../extracted/biolink_bot_temp_annotated.owl ../extracted/biolink_bot.owl
#rm ../extracted/biolink_bot_temp*

# Generate a report to see what we got
echo "Creating a report..."
robot report \
  --input ../extracted/biolink_bot.owl \
  --output ../reports/biolink-extraction-report.txt

echo "Check ../reports/biolink-extraction-report.txt for details"

PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX biolink: <https://w3id.org/biolink/vocab/>

# robot extract pulls in two biolink enum classes (AgentTypeEnum,
# KnowledgeLevelEnum) that both have a member called "not_provided". Because
# they both end up with the exact same rdfs:label "not_provided", robot report
# flags a duplicate_label error. It also flags the two enum classes themselves
# for having no rdfs:label at all.
#
# Fix: give the enum classes a label, and make each "not_provided" member's
# label unique by prefixing it with its enum's name.
DELETE {
  <https://w3id.org/biolink/vocab/AgentTypeEnum#not_provided> rdfs:label "not_provided" .
  <https://w3id.org/biolink/vocab/KnowledgeLevelEnum#not_provided> rdfs:label "not_provided" .
}
INSERT {
  biolink:AgentTypeEnum rdfs:label "AgentTypeEnum" .
  biolink:KnowledgeLevelEnum rdfs:label "KnowledgeLevelEnum" .
  <https://w3id.org/biolink/vocab/AgentTypeEnum#not_provided> rdfs:label "AgentTypeEnum not_provided" .
  <https://w3id.org/biolink/vocab/KnowledgeLevelEnum#not_provided> rdfs:label "KnowledgeLevelEnum not_provided" .
}
WHERE {
}

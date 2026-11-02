# Drops two vendor SOSA annotations that clash with MVIKG's own
# hasFeatureOfInterest domain/range (sosa:Sample -> biolink:GenomicEntity,
# see mvikg-property-constraints.ttl):
#  - sosa:hasFeatureOfInterest schema:rangeIncludes sosa:Sample
#    (Sample is MVIKG's domain for this property, not a valid range value)
#  - sosa:isFeatureOfInterestOf schema:domainIncludes sosa:Sample
#    (the inverse property's domain is biolink:GenomicEntity in MVIKG, not Sample)
# Both are non-logical (schema:domainIncludes/rangeIncludes are annotation
# properties, not rdfs:domain/range), so this doesn't change reasoning.
PREFIX sosa: <http://www.w3.org/ns/sosa/>
PREFIX schema: <http://schema.org/>
DELETE DATA {
  sosa:hasFeatureOfInterest schema:rangeIncludes sosa:Sample .
  sosa:isFeatureOfInterestOf schema:domainIncludes sosa:Sample .
}

# Drops biolink's own rdfs:domain/rdfs:range for has_phenotype/phenotype_of,
# which MVIKG overrides with a narrower owl:unionOf (see
# mvikg-property-constraints.ttl). Unlike remove-sample-range.ru, these ARE
# logical axioms (rdfs:domain/range, not schema:domainIncludes/rangeIncludes),
# so leaving biolink's biolink:BiologicalEntity domain/range stacked
# alongside MVIKG's union would make a reasoner infer every sosa:Sample or
# biolink:GenomicEntity individual used with has_phenotype/phenotype_of to
# also be classified as biolink:BiologicalEntity -- neither of which is
# formally a subclass of it in this ontology. Removing biolink's original
# axiom here means MVIKG's union is the only domain/range that applies.
PREFIX biolink: <https://w3id.org/biolink/vocab/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
DELETE DATA {
  biolink:has_phenotype rdfs:domain biolink:BiologicalEntity .
  biolink:phenotype_of rdfs:range biolink:BiologicalEntity .
}

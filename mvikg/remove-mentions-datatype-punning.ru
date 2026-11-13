PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX biolink: <https://w3id.org/biolink/vocab/>

# biolink:mentions / biolink:mentioned_by come out of robot extract (BOT method)
# declared as BOTH owl:ObjectProperty and owl:DatatypeProperty — an illegal OWL
# punning. The ObjectProperty declaration is the real one (it carries the actual
# subPropertyOf/inverseOf axioms); the DatatypeProperty declaration is a leftover
# stub from the source biolink-model.owl.ttl file and has no axioms of its own.
# Drop the stub so the property only has one type.
DELETE {
  ?p rdf:type owl:DatatypeProperty .
}
WHERE {
  VALUES ?p { biolink:mentions biolink:mentioned_by }
  ?p rdf:type owl:DatatypeProperty .
  ?p rdf:type owl:ObjectProperty .
}

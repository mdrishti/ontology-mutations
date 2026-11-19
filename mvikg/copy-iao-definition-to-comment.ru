PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

# OOPS (P08 "missing annotations") only recognizes rdfs:comment/dc:description/
# skos:definition as "defining" annotations -- not OBO's own obo:IAO_0000115
# ("definition") convention, which is what so-edit.obo actually uses. This
# copies IAO_0000115 values to rdfs:comment wherever a class has the former
# but not the latter, so OOPS's checker sees a definition it already has.
# Confirmed via SO_0000001 ("region"): has IAO_0000115 + rdfs:label, still
# flagged, because rdfs:comment was absent. See NOTES.md item 20.
INSERT {
    ?s rdfs:comment ?def .
}
WHERE {
    ?s obo:IAO_0000115 ?def .
    FILTER NOT EXISTS { ?s rdfs:comment ?anyComment }
}

# ontology-mutations
Initial repo for building ontology for mutations (specific to microbes) including re-purposing of other ontologies


# Pipeline
### install `robot`
See here: [robot](https://github.com/ontodev/robot)

### extract terms from biolink
```bash
robot extract --input ontologies/biolink-model.owl.ttl --term-file termFiles/biolinkTermFile.txt --method BOT --output results/biolink_bot.owl --prefix 'biolink: https://w3id.org/biolink/vocab/'
```
### extract terms from ro
```
bash
robot extract --input ontologies/ro.owl --term-file termFiles/roTermFile.txt --method BOT --output results/ro_bot.owl --prefix 'RO: http://purl.obolibrary.org/obo/RO_'
```

### extract terms from rdfs
```
bash
robot extract --input ontologies/rdf-schema.ttl --term-file termFiles/rdfsTermFile.txt --method BOT --output results/rdfs_bot.owl --prefix 'rdfs: http://www.w3.org/2000/01/rdf-schema#'
```

### extract terms from skos
```
bash
robot extract --input ontologies/skos.owl --term-file termFiles/skosTermFile.txt --method STAR --output results/skos_star.owl --prefix 'skos: http://www.w3.org/2004/02/skos/core#'
```

### extract terms from envo
```bash
robot extract --input ontologies/envo.owl --term-file termFiles/envoTermFile.txt --method BOT --output results/envo_bot.owl --prefix 'ENVO: http://purl.obolibrary.org/obo/ENVO_'
```

### extract terms from dcterms
```bash
robot extract --input ontologies/dublin_core_terms.ttl --term-file termFiles/dctermsTermFile.txt --method BOT --output results/dcterms_bot.owl --prefix 'dcterms: http://purl.org/dc/terms/'
```
gives the following error:
```
2025-11-26 15:45:22,229 ERROR org.obolibrary.robot.IOHelper - Input ontology contains 1 triple(s) that could not be parsed:
 - <http://purl.org/dc/terms/creator> <http://www.w3.org/2002/07/owl#equivalentProperty> <http://xmlns.com/foaf/0.1/maker>.

Ontology IRI cannot be null
````
but works if the iri (owl format) is used
```bash
robot extract --input-iri http://protege.stanford.edu/plugins/owl/dc/terms.owl --term-file termFiles/dctermsTermFile.txt --method BOT --output results/dcterms_bot.owl --prefix 'dcterms: http://purl.org/dc/terms/'
```

### extract terms from sosa
```bash
robot extract --input ontologies/ssn.owl --term-file termFiles/sosaTermFile.txt --method BOT --output results/sosa_bot.owl --prefix 'sosa: http://www.w3.org/ns/sosa/'
```

### extract terms from mesh
```bash
robot extract --input-iri https://nlmpubs.nlm.nih.gov/projects/mesh/rdf/mesh.nt --term-file termFiles/meshTermFile.txt --method BOT --output results/mesh_bot.owl --prefix 'mesh: https://id.nlm.nih.gov/mesh/'
```
# Notes
#### Ontology by Open Mutation Miner (OMM)
https://www.semanticsoftware.info/open-mutation-miner#OMM_Ontology

#### biolink ontology
https://biolink.github.io/biolink-model/biolink-model.owl.ttl

#### Access Boregistry for downloading the owl/rdf of ontology files `https://bioregistry.io/registry/`

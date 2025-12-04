# ontology-mutations
Initial repo for building ontology for mutations (specific to microbes) including re-purposing of other ontologies


# Pipeline
### install `robot`
See here: [robot](https://github.com/ontodev/robot)

### extract terms from biolink
```bash
sh extract-biolink.sh
```
### extract terms from ro
```
bash
sh extract-ro.sh
```

### extract terms from rdfs
```
bash
sh extract-rdfs.sh
```

### extract terms from skos
```
bash
sh extract-skos.sh
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
final script here:
```bash
sh extract-dcterms.sh
```


### extract terms from sosa
```bash
sh extract-sosa.sh
```

# Notes
#### Ontology by Open Mutation Miner (OMM)
https://www.semanticsoftware.info/open-mutation-miner#OMM_Ontology

#### biolink ontology
https://biolink.github.io/biolink-model/biolink-model.owl.ttl

#### Access Boregistry for downloading the owl/rdf of ontology files `https://bioregistry.io/registry/`

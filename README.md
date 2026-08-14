# ontology-mutations
Initial repo for building ontology for mutations (specific to microbes) including re-purposing of other ontologies


# Pipeline
### install `robot`
See here: [robot](https://github.com/ontodev/robot)

### extract terms from ontologies
```bash
sh scripts/extract-rdfs.sh
sh scripts/extract-skos.sh
sh scripts/extract-sosa.sh
sh scripts/extract-biolink.sh
sh scripts/extract-ro.sh
sh scripts/extract-so.sh
sh scripts/extract-eco.sh
sh scripts/extract-qudt.sh
sh scripts/extract-gold.sh
sh scripts/extract-dcterms.sh
```

### note on extracting terms from dcterms
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


### combine extracted terms and mvikg schema
```bash
sh build-mvikg.sh
```


### widoco documentation (with WebVOWL visualization)
```bash
java -jar widoco-1.4.25-jar-with-dependencies_JDK-17.jar -ontFile output/mvikg-reasoned.owl -getOntologyMetadata -webVowl -oops -outFolder mvikg_widoco
```

### to view ontology on web (localhost)
```bash
cd mvikg_widoco
python cors-http-server.py
```


# Notes
#### Ontology by Open Mutation Miner (OMM)
https://www.semanticsoftware.info/open-mutation-miner#OMM_Ontology

#### biolink ontology
https://biolink.github.io/biolink-model/biolink-model.owl.ttl

#### Access Boregistry for downloading the owl/rdf of ontology files `https://bioregistry.io/registry/`

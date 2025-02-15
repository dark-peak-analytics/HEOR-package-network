# HEOR-package-network

The aim of this project, currently at a very early stage, is to create a way to visualise the network of package dependencies in HEOR.

We want to understand:
- Which packages are central to the network.
- What is the risk associated with those and other packages.

There is a single R script which inputs the following packages to produce a network visual:
survHE hesim heemod survival flexsurv easysurv psm3mkv des flexsurvcure missingHE easyBIM BCEA 

## Applications & similar projects elsewhere
It would be useful to able to understand the dependencies in a given project, ideally at the function level within each package.
This is being attempted in the [assertHE](https://github.com/dark-peak-analytics/assertHE/issues/59) package. The aim is to extend the function network of a given model to include the external dependencies.

## Use of LLMs
We could use large language models to explain these relationships in prose.

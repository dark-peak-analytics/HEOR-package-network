# HEOR Software Network Visualization

## Overview
This R script visualizes the interdependence of various Health Economics and Outcomes Research (HEOR) software packages in R. The dependencies between packages are represented as a network, where:

- **Nodes** represent individual R packages.
- **Edges** represent dependencies, with arrows pointing from the package being depended on to the package using it.
- **Node size** is determined by degree centrality, making more central nodes appear larger.
- **Node color** is based on the riskmetric package score (ranging from orange to green, indicating quality and risk level).
- **Node shape** denotes the type of package (e.g., survival analysis, plotting, utility, etc.).
- **Node border color** reflects license compliance, with red indicating non-compliant licenses.

## Requirements
The script requires the following R packages:
- `igraph`
- `ggraph`
- `tidygraph`
- `riskmetric`
- `dplyr`
- `tidyr`
- `purrr`
- `visNetwork`

Ensure these packages are installed before running the script.

## Setup & Usage
1. Clone this repository and navigate to the project directory.
2. Install the required R packages if they are not already installed:
   ```r
   install.packages(c("igraph", "ggraph", "tidygraph", "riskmetric", "dplyr", "tidyr", "purrr", "visNetwork"))
   ```
3. Place the list of HEOR-related R package names in `data/R_package_names.csv` or use the hardcoded example in the script.
4. Run the script in R to generate an interactive visualization of package dependencies.

## Key Functionalities
### 1. Load and Process Package Dependencies
- Retrieves package dependency data from CRAN.
- Filters dependencies to only include those within the HEOR package list.

### 2. Compute Network Metrics
- Computes degree centrality to determine the prominence of each package.
- Assesses package quality using `riskmetric` to generate a risk score.

### 3. Create an Interactive Visualization
- Uses `visNetwork` to generate an HTML-based interactive network visualization.
- Implements node and edge attributes based on package characteristics.

## Output
The script generates an interactive network visualization displaying HEOR R package dependencies. Users can interact with the visualization, highlighting dependencies and selecting specific packages for further inspection.

## Applications & similar projects elsewhere
It would be useful to able to understand the dependencies in a given project, ideally at the function level within each package.
This is being attempted in the [assertHE](https://github.com/dark-peak-analytics/assertHE/issues/59) package. The aim is to extend the function network of a given model to include the external dependencies.

## Acknowledgments
This project is developed by **Dark Peak Analytics Ltd** and integrates insights from various HEOR-related R packages.

For more details, visit [Dark Peak Analytics](https://github.com/dark-peak-analytics).

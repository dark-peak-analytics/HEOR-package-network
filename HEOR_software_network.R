# ========================== #
#    HEOR Software network   #
# ========================== #

# Aim: To show the interdependence of different software packages in R.
# Show this as a network where each node is a diffent package
# and each edge is an interdependency - with the arrow from the package being depended 
# on to package using it. 

# Node size   = degree centrality, more central nodes are bigger.
# Node color  = riskmetric score of package (orange to green)
# Node shape  = type of package (e.g. square = survival analysis, circle = plotting, triangle = utility)
# Node border = licence - red if doesn't pass tests
rm(list = ls())

# create a visual HTML representation of the network of dependencies
# Load necessary packages
library(igraph)
library(ggraph)
library(tidygraph)
library(riskmetric)
library(dplyr)

source("R/processNodes.R")

# Read in vector of packages for HEOR
# HEpacks <- read.csv(file = "data/R_package_names.csv", row.names = 1) |> 
#                unlist(use.names = F)

# for testing
HEpacks <- c("survHE", "hesim", "heemod", "survival", "flexsurv", "easysurv", "psm3mkv", "des", "flexsurvcure", "missingHE", "easyBIM", "BCEA")


# Get the dependencies for each package from CRAN
# Note: This requires an internet connection
l_deps <-
  tools::package_dependencies(packages = unique(HEpacks), 
                              recursive = FALSE, 
                              reverse = FALSE, 
                              which = "strong")

# Create a tibble with the package name and the dependencies in wide format
# one row per package
df_packages <- tibble::tibble(Package = names(l_deps),
                      data = purrr::map(l_deps, as_tibble)) |>
  tidyr::unnest(data)

# Create a data frame of edges
df_edges <- do.call(what = rbind,
                    args = lapply(
                      X = names(l_deps),
                      FUN =  function(pkg) {
                        if (length(l_deps[[pkg]]) > 0) {
                          data.frame(from = pkg,
                                     to = l_deps[[pkg]],
                                     stringsAsFactors = FALSE)
                        }
                      }
                    ))

# Keep only edges within the package list
df_edges <- df_edges[df_edges$from %in% unique(HEpacks), ]  

# Create a data frame of nodes from the edges.
df_nodes <- processNodes(df_edges = df_edges,
                         from_col = "from",
                         to_col = "to")

# Create an igraph object
# Directed by the edges dataframe
graph_of_edges <- igraph::graph_from_data_frame(d = df_edges, directed = TRUE)

# Degree centrality -----------

# calculate degree centrality (out)
degree_centrality <-
  igraph::degree(graph = graph_of_edges, 
                 mode = "in") 
# remove NAs -
degree_centrality <-
  degree_centrality[!is.na(names(degree_centrality))]

# Scale Degree centrality values compared to the maximum values
#scaled_centrality <- degree_centrality / max(degree_centrality)

# Add scaled Degree centrality values to the dataframe
# for each node ID add in the scaled degree centrality
df_nodes$value <-
  degree_centrality[match(df_nodes$id, igraph::V(graph_of_edges)$name)] ^2


#=======================#
# Risk Metric ---------------
#=======================#

# Run the riskmetric package to assess coverage etc and give a single score
# very basic right now!!!
df_riskmetrics <- riskmetric::pkg_ref(x = df_nodes$id) |>
  as_tibble() |>
  riskmetric::pkg_assess(error_handler = function(e){NA},
                         assessments = list(riskmetric::assess_covr_coverage, 
                                            riskmetric::assess_has_news,
                                            riskmetric::assess_r_cmd_check,
                                            riskmetric::assess_downloads_1yr,
                                            riskmetric::assess_license)) |>
  riskmetric::pkg_score() 

# merge the datasets to get one dataset with all the information
df_merged <- merge(x = df_nodes,
                   y =  df_riskmetrics,
                   all.x = TRUE,
                   by.x = "id", 
                   by.y = "package")

# Color each node by the riskmetric score!!!!
# Red to green...
df_merged <- df_merged |>
  dplyr::mutate(color.background = scales::col_numeric(domain = 0:1, 
                                                       palette = c("red", "green")
                                                       )(pkg_score),
                color.border = color.background,
                color.highlight = color.background)







#=======================#
# Network visualisation -------------
#=======================#

# create the simple network.
g <- visNetwork::visNetwork(
  footer = paste0(
    '<a href="https://github.com/dark-peak-analytics/assertHE/"',
    '>Created with assertHE</a>'),
  nodes = df_merged |> dplyr::select(id, label, value, color.background, color.border,
                                     color.highlight),
  edges = df_edges,
  main = "HEOR R Package Dependencies")

# adapt the visual based upon the characteristics...
g <- g |>
  visNetwork::visEdges(arrows = 'from') |>
  visNetwork::visOptions(
    manipulation = TRUE,
    highlightNearest = list(
      enabled = TRUE,
      degree = nrow(df_merged),
      algorithm = "hierarchical"
    ),
    collapse = list(enabled = TRUE),
    height = "100%",
    width = "100%",
    nodesIdSelection = TRUE
  )

g




# Get the CRAN version of the packages

#package_info_df(df_nodes$id)
# df_nodes$version <- sapply(X = df_nodes$id,
#        FUN = function(x) {
#          tryCatch({
#            as.character(packageVersion(x))
#          }, error = function(e) {
#            NA
#          })
#          }) 


# Function to retrieve package information for multiple packages
# package_info_df <- function(packages) {
#   # Initialize an empty list to store each package's information
#   package_list <- lapply(packages, function(pkg) {
#     # Try to get package information, handle any missing packages gracefully
#     if (requireNamespace(pkg, quietly = TRUE)) {
#       description <- packageDescription(pkg)
#       data.frame(
#         Package = pkg,
#         Version = as.character(packageVersion(pkg)),
#         License = description$License,
#         Title = description$Title,
#         URL = description$URL,
#         Published = description$`Date/Publication`,
#         stringsAsFactors = FALSE
#       )
#     } else {
#       # Return NA for packages that are not installed
#       data.frame(
#         Package = pkg,
#         Version = NA,
#         License = NA,
#         Title = NA,
#         URL = NA,
#         Published = NA,
#         stringsAsFactors = FALSE
#       )
#     }
#   })
#   
#   # Combine individual package data frames into a single data frame
#   do.call(rbind, package_list)
# }

#' Process nodes
#' 
#' @param df_edges Data frame of edges
#' @param from_col Column name for the 'from' node
#' @param to_col Column name for the 'to' node
#' @return Data frame of nodes
processNodes <-
  function (df_edges,
            from_col = "from",
            to_col = "to")  {
    
    assertthat::assert_that(msg = "Number of rows of df_edges in 'processNodes' does not exceed 1",
                            nrow(df_edges) > 1)
    df_nodes <-
      dplyr::mutate(data.frame(id = stats::na.omit(unique(
        unlist(df_edges[,
                        c(from_col, to_col)], use.names = FALSE)
      ))), label = id)
    
    return(df_nodes)
  }
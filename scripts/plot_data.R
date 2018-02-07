
plot_data <- function(group_means){
  
  ggplot(group_means) +
    geom_col(aes(variable,value),fill="dodgerblue",color="grey35") +
    coord_flip() +
    facet_wrap(~class) +
    theme_bw()
    
}
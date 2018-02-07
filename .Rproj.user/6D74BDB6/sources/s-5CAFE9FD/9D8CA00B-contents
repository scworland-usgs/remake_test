
process_data <- function(fname){
  
  group_means <- read_csv(fname) %>%
    group_by(class) %>%
    summarize_all(funs(sd)) %>%
    gather(variable,value,-class)
  
}

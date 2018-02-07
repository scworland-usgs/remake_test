

download_data <- function(file_name){
  download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data",file_name)
  data <- read_delim(file_name,col_names = F,delim=",")
  names(data) <- c("sepal_length","sepal_width","petal_length","petal_width","class")
  write_csv(data, "data/iris_data.csv")
}


## library
library(tidyverse)
library(RSiteCatalyst)

## auth
load(auth.R)

## define segments
car_models <- c("model1","model2","model3","model4","model5")

## overlap performance
for (i in length(car_models)) {
  for (j in (i + 1) : length(car_models)) {
    models <- c(car_models[i],car_models[j])
    ## create segment
    mySegment<- list(container=list(type=unbox("visits"),
                                    rules = data.frame(
                                      name = "models",
                                      element = c("evar7"),
                                      operator = c("contains"),
                                      value = models
                                    )))
    ## get data
    df1 <- QueueRanked(
      report.suite = "",
      element = c("geoCity"),
      metrics = "",
      date.from = "",
      date.to = "",
      inline.segment = mySegment)
    
    df2 <- QueueOvertime(
      report.suite = "",
      metrics = "",
      date.from = "",
      date.to = "",
      inline.segment = mySegment)
    
  }
  
  
}		 
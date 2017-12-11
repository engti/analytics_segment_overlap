## library
library(tidyverse)
library(RSiteCatalyst)
library(jsonlite)

## auth
source("auth.R")

## define some metadata
  date_range  <- list(
    "start" = "2017-12-03",
    "end" = "2017-12-09"
  )
  rsid <- "kiamotors-uk-w"
## define segments ----
  ## get car model name
  car_models <- QueueRanked(
    reportsuite.id = rsid,
    date.from = date_range$start,
    date.to = date_range$end,
    metrics = "event2",
    elements = "evar7",
    top = 10
  )  


## overlap performance
for (i in 1:(nrow(car_models)-1)) {
  for (j in (i + 1) : nrow(car_models)) {
    models <- c(car_models$name[i],car_models$name[j])
    ## create segment
    mySegment<- list(container=list(type=unbox("visits"),
                                    rules = data.frame(
                                      name = "models",
                                      element = "evar7",
                                      operator = "contains",
                                      value = models
                                    )))
    ## get data
    # df1 <- QueueRanked(
    #   report.suite = "",
    #   element = c("geoCity"),
    #   metrics = "",
    #   date.from = "",
    #   date.to = "",
    #   inline.segment = mySegment)
    
    df2 <- QueueOvertime(
      reportsuite.id =  rsid,
      date.from = date_range$start,
      date.to = date_range$end,
      metrics = "event2",
      date.granularity = "week",
      segment.inline =  mySegment)
    
    df3 <- df2 %>% select(event2) %>%
      mutate(
        model1 = car_models$name[i],
        model2 = car_models$name[j]
      ) %>% select(model1,model2,event2)
    
    if(i == 1 & j == 2){
      car_segment_data <- df3
    }else{
      car_segment_data <- rbind(car_segment_data,df3)
    }
 
  }
}
  
write_csv(car_segment_data,"car_segment_data.csv")  

## spread into matrix
car_matrix <- spread(car_segment_data,model2,event2)


tmp <- car_segment_data %>%
  mutate(
    x = model1,
    y = model2
  ) %>%
  mutate(
    model1 = y,
    model2 = x
  ) %>% select(-x,-y)

tmp2 <- rbind(car_segment_data,tmp)

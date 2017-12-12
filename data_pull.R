## load library ----
  library(tidyverse)
  library(RSiteCatalyst)
  library(jsonlite)

## auth ----
  ## the file only has one line calling the SCAuth function from RSiteCatalyst
  source("auth.R")

## define metadata ----
  date_range  <- list(
    "start" = "2017-12-03",
    "end" = "2017-12-09"
  )
  
  ## define the report suite to pull data from
  rsid <- "kiamotors-uk-w"
  
## get ingredients for segment ----
  ## get car model name in this instance
  product_id <- QueueRanked(
    reportsuite.id = rsid,
    date.from = date_range$start,
    date.to = date_range$end,
    metrics = "visits",
    elements = "evar7",
    top = 10
  )  


## calculate overlap in visits for each model combination
  for (i in 1:(nrow(product_id)-1)) {
    for (j in (i + 1) : nrow(product_id)) {
      product_segment <- c(product_id$name[i],product_id$name[j])
      ## create segment
      mySegment<- list(container=list(type=unbox("visits"),
                                      rules = data.frame(
                                        name = "models",
                                        element = "evar7",
                                        operator = "contains",
                                        value = product_segment
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
        metrics = "visits",
        date.granularity = "week",
        segment.inline =  mySegment)
      
      df3 <- df2 %>% select(visits) %>%
        mutate(
          model1 = car_models$name[i],
          model2 = car_models$name[j]
        ) %>% select(model1,model2,visits)
      
      if(i == 1 & j == 2){
        car_segment_data <- df3
      }else{
        car_segment_data <- rbind(car_segment_data,df3)
      }
   
    }
    paste0(i,j)
  }

## create a matrix ----
  ## i am sure there's a better way of doing it

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

## spread into matrix
  car_matrix <- spread(tmp2,model2,visits)


## save the data
  write_csv(car_matrix,"car_matrix.csv")  

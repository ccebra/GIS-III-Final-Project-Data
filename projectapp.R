# Before the application can be run, wd set up.
# setwd("~/Code/RShiny")

library(finalprojectdata)#Created package with cleaned data for project
library(sf)
library(units)
library(raster)
library(dplyr)
library(spData)
library(tigris)#Package to import shapefiles from US Census Bureau
library(ggplot2)
library(shiny)
library(rgdal)
library(rgeos)
library(tmap)
library(leaflet)
library(vioplot)

# Import data from project package and merge
covid_data <- finalprojectdata::CountyCaseData
us_county_shp <- counties(c(17,18,19,26,27,39,55), cb = TRUE)#Vector of state FIPS codes for Great Lakes region
covid_by_county_shp <- merge(x = us_county_shp, y = covid_data, by = "GEOID", all = TRUE)

# Add columns for change over time
covid_by_county_shp$Feb27 = covid_by_county_shp$`58`/covid_by_county_shp$`37`
covid_by_county_shp$Mar06 = covid_by_county_shp$`65`/covid_by_county_shp$`44`
covid_by_county_shp$Mar13 = covid_by_county_shp$`72`/covid_by_county_shp$`51`
covid_by_county_shp$Mar20 = covid_by_county_shp$`79`/covid_by_county_shp$`58`
covid_by_county_shp$Mar27 = covid_by_county_shp$`86`/covid_by_county_shp$`65`
covid_by_county_shp$Apr03 = covid_by_county_shp$`93`/covid_by_county_shp$`72`
covid_by_county_shp$Apr10 = covid_by_county_shp$`100`/covid_by_county_shp$`79`
covid_by_county_shp$Apr17 = covid_by_county_shp$`107`/covid_by_county_shp$`86`
covid_by_county_shp$Apr24 = covid_by_county_shp$`114`/covid_by_county_shp$`93`
covid_by_county_shp$May01 = covid_by_county_shp$`121`/covid_by_county_shp$`100`
covid_by_county_shp$May08 = covid_by_county_shp$`128`/covid_by_county_shp$`107`
covid_by_county_shp$May15 = covid_by_county_shp$`135`/covid_by_county_shp$`114`
covid_by_county_shp$May22 = covid_by_county_shp$`142`/covid_by_county_shp$`121`
covid_by_county_shp$May29 = covid_by_county_shp$`149`/covid_by_county_shp$`128`
covid_by_county_shp$Iowa = covid_by_county_shp$`149`/covid_by_county_shp$`37`
covid_by_county_shp$Wisconsin = covid_by_county_shp$`149`/covid_by_county_shp$`86`
covid_by_county_shp$Indiana = covid_by_county_shp$`149`/covid_by_county_shp$`93`
covid_by_county_shp$CDC = covid_by_county_shp$`149`/covid_by_county_shp$`114`

# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("COVID-19 Data and Mask Mandates in the Upper Midwest"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      h3("Select a time period here"),
      helpText("Data will display change in COVID cases for the given range."),
      
      selectInput("Census_var", 
                  label = "Select a time period here",
                  choices = list("February 6-27", 
                                 "February 13-March 6",
                                 "February 20-March 13", 
                                 "February 27-March 20",
                                 "March 6-27",
                                 "March 13-April 3",
                                 "March 20-April 10",
                                 "March 27-April 17",
                                 "April 3-24",
                                 "April 10-May 1",
                                 "April 17-May 8",
                                 "April 24-May 15",
                                 "May 1-22",
                                 "May 8-29",
                                 "Since Iowa mandate repealed",
                                 "Since Wisconsin mandate repealed",
                                 "Since Indiana mandate repealed",
                                 "Since CDC guideline"),
                  selected = "February 6-27"),
      
      h4("About"),
      p("COVID-19 cases at the end of the time range, with May 29 the end date if not provided, as a ratio of cases at the start of the time range"),
      h4("Data Source"),
      p("This data is from the New York Times.")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      textOutput("selected_var"),
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Map", leafletOutput("working_map"))
      )
      
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {
  
  
  output$working_map <- renderLeaflet({
    
    #CamdenData <- readOGR(".","Camden")
    
    data <- switch(input$Census_var, 
                   "February 6-27" = "Feb27",
                   "February 13-March 6" = "Mar06",
                   "February 20-March 13" = "Mar13",
                   "February 27-March 20" = "Mar20",
                   "March 6-27" = "Mar27",
                   "March 13-April 3" = "Apr03",
                   "March 20-April 10" = "Apr10",
                   "March 27-April 17" = "Apr17",
                   "April 3-24" = "Apr24",
                   "April 10-May 1" = "May01",
                   "April 17-May 8" = "May08",
                   "April 24-May 15" = "May15",
                   "May 1-22" = "May22",
                   "May 8-29" = "May29",
                   "Since Iowa mandate repealed" = "Iowa",
                   "Since Wisconsin mandate repealed" = "Wisconsin",
                   "Since Indiana mandate repealed" = "Indiana",
                   "Since CDC guideline" = "CDC",
                   )
    
    color <- "red"
    
    legend <- "COVID cases on final date as proportion of previous date"
    
    working_map <- tm_shape(covid_by_county_shp) + tm_fill(data, title=input$Census_var, style="quantile")
    tmap_leaflet(working_map)
    
  })
  
}

# Create Shiny app ----
shinyApp(ui, server)
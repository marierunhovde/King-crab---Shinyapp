library(shiny)
library(tidyverse)
library(bslib)


## Parameters for the species 
## The parameters chosen are hypothetical, but based on real growth measures of the different animal groups. 
species_param <- list(
  Polychaeta = list(r = 0.8, k = 1500), 
  Starfish = list(r = 0.2, k = 500), 
  Molluscs = list(r = 0.5, k = 800)
)

## Function for simulation of the fishery 
simulate_fishery <- function(r, K, B0 = NULL, crab_density = 0.1, years = 30) {
  years <- as.integer(years)
  if (is.null(B0)) B0 <- K * 0.8
  B <- numeric(years)
  C <- numeric(years)
  B[1] <- B0
  
  for (t in 2:years) {
    predation <- crab_density * B[t-1]
    C[t-1] <- predation
    B[t] <- B[t-1] + r * B[t-1] * (1 - B[t-1] / K) - predation
    if (B[t] < 0) B[t] <- 0 
  }
  
  C[years] <- NA  
  
  data.frame(Year = 1:years, Biomass = B, Predation = C)
}


## UI
ui <- page_sidebar(
  title = "Feeding effect of king crab on benthic fauna", 
  sidebar = sidebar(
    width = "350px",
    card(
      card_header("Species"),
      checkboxGroupInput(
        "species",
        "Choose species",
        choices = c("Polychaeta", "Starfish", "Molluscs"),
        selected = 1)
    ), 
    sliderInput(inputId = "crab_density", label = "King crab density", min = 0, max = 1, value = 0.1, step = 0.01), 
    sliderInput("years", "Duration of predation (years)", min = 1, max = 50, value = 30), 
    actionButton("simulate", "Simulate")),
  card(
    card_header("Crab feeding effect"), 
    "Prey populations", 
    plotOutput("biomass_plot")
  )
)


## Server 
server <- function(input, output) {
  
  simulation <- eventReactive(input$simulate, {
    
    species_list <- input$species
    sim_results <- list()
    
    for (species in species_list) {
      params <- species_param[[species]]
      sim_results[[species]] <- simulate_fishery(
        r = params$r,
        K = params$k,  
        crab_density = input$crab_density,
        years = input$years
      )
    }
    sim_results
  })
  
  
  
  output$biomass_plot <- renderPlot({
    if (length(input$species) == 0) {
      showNotification("Choose at least one species to simulate", type = "error")
      return(NULL)
    }
    
    sim_results <- simulation()
    if (is.null(sim_results)) return(NULL)
    
    data_table <- bind_rows(lapply(names(sim_results), function(species) {
      sim_results[[species]] |> mutate(Species = species)
    }))
    
    ggplot(data_table, aes(x = Year, y = Biomass, color = Species)) +
      geom_line() +
      theme_minimal() + 
      theme(
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        axis.text = element_text(size = 12),   
        legend.text = element_text(size = 14),    
        legend.title = element_text(size = 16)
      ) 
  })
}

## Run app
shinyApp(ui = ui, server = server)

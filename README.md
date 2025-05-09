
# King crab predation simulator

This Shiny app demonstrates how king crab predation impact benthic species such as Polychaetes, Starfish, and Molluscs over time. 
It is an educational tool used to visualize how different densities of king crabs may affect the population of their prey through a simulation. 

Note: The values for r (intrinsic growth rate) and K (carrying capacity) used in the simulation are hypothetical and chosen for illustrative purposes. 

## Features

- Select which benthic species to simulate (Polychaetes, Starfish, Molluscs).
- Adjust king crab density.
- Choose predation duration.
- Click **Simulate** to update the biomass plot.
- Visualize how king crab predation affects prey biomass over time.

## How to run the app

1. Download this repository.
2. Open the folder in RStudio.
3. Make sure you have the required packages installed:
   ```r
   install.packages(c("shiny", "tidyverse", "bslib"))
   ```
4. Run the app by executing:
   ```r
   shiny::runApp()
   ```

The app will open in a browser window.

## Author

Marie Runhovde  
BIO302 – University of Bergen  

## Run Locally

To run this app locally, first clone the repository, and install the shiny library.  Then

```
library(shiny)
runApp('weighted_least_squares')
```

should work.

## Run in the Cloud

To publish the app on shinyapps.io, follow the instructions [here](http://docs.rstudio.com/shinyapps.io/getting-started.html#installation) to register and set up.  Once eberything is configured, you should be able to use

```
deployApp('weighted_least_squares/')
``` 

to deploy the app to the shinapps.io hosting service.
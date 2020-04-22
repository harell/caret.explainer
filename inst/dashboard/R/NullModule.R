# UI ----------------------------------------------------------------------
NullModuleUI <- function(id){
    ns <- NS(id)
    htmltools::div() # end dashboardBody
}

# Server ------------------------------------------------------------------
NullModuleServer <- function(input, output, session){
    ns <- session$ns
}

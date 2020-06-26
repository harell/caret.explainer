# Helper Functions --------------------------------------------------------
callModule <-  function(..., enable = TRUE) if(enable) shiny::callModule(...) else shiny::callModule(NullModuleServer, id = id)
renderDataTable <- DT::renderDataTable
datatable <- DT::datatable

# Database ----------------------------------------------------------------
database <- DBMS$new(path = tempfile("archive-"))$establish_connection()

# Get the {caret} Model ---------------------------------------------------
tags <- "mock:yes"
if(length(database$read(tags)) == 0)
    database$create(artifact = CaretModelFactory$new()$artifact, tags)

# Database ----------------------------------------------------------------
database <- DBMS$new(path = tempfile("archive-"))$establish_connection()

# Get the {caret} Model ---------------------------------------------------
tags <- "mock:yes"
if(length(database$read(tags)) == 0)
    database$create(artifact = CaretModelFactory$new()$artifact, tags)

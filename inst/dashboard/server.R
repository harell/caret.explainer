#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(pkgload)
pkgload::load_all(path = "./package", helpers = FALSE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    # Setup -------------------------------------------------------------------
    Dashboard$funs$load_data()
    model_elements <- caret$train %>% CaretModelDecomposition$new()
    explanations <-
        caret$train %>%
        CaretModelDecomposition$new() %>%
        ModelComposition$new() %>%
        Explanations$new()

    # Observation table -------------------------------------------------------
    ## Create DT table
    unseen_observations <-
        DT::datatable(
            data = caret$dataset,
            extensions = "Scroller",
            style = "bootstrap",
            class = "compact",
            selection = list(mode = "single", selected = 1, target = 'row'),
            width = "100%",
            options = list(
                deferRender = TRUE, dom = 't',
                scrollY = "400px", scrollCollapse = TRUE, paging = FALSE,
                autoWidth = FALSE,
                columnDefs = Dashboard$DT$col_to_show(caret$dataset, caret$role_info)
            ),
            editable = FALSE
        ) #%>%
    # DT::formatRound(columns = intersect(type_numeric, role_input), digits = 0)
    ## Wrap data frame in SharedData
    output$unseen_observations <- DT::renderDataTable(unseen_observations, server = TRUE)

    # Text --------------------------------------------------------------------
    output$print_text <- renderText({input$unseen_observations_rows_selected})

    # Break Down Plot ---------------------------------------------------------
    output$break_down <- renderPlot({
        selected_row <- input$unseen_observations_rows_selected
        new_observation <- caret$dataset[selected_row, ]
        explanations$plot_break_down(new_observation = new_observation)
    })

})

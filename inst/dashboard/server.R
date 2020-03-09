#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    # Setup -------------------------------------------------------------------
    Dashboard$funs$load_data()
    model_elements <- caret$train %>% CaretModelDecomposition$new()
    explanations <- instantiate_explainer(caret$train)

    context$values$role_input <- model_elements$role_input
    updateCheckboxGroupInput(session, inputId = "what_if_vars", choices = as.list(context$values$role_input))

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
        )
    ## Wrap data frame in SharedData
    output$unseen_observations <- DT::renderDataTable(unseen_observations, server = TRUE)

    # Break Down Plot ---------------------------------------------------------
    output$break_down <- renderPlot({
        selected_row <- input$unseen_observations_rows_selected
        new_observation <- if(length(selected_row) == 0) NULL else caret$dataset[selected_row, ]
        explanations$plot_break_down(new_observation = new_observation)
    })

    # Ceteris Paribus Plot ----------------------------------------------------
    output$ceteris_paribus <- renderPlot({
        selected_row <- input$unseen_observations_rows_selected
        new_observation <- if(length(selected_row) == 0) NULL else caret$dataset[selected_row, ]
        explanations$plot_ceteris_paribus(
            new_observation = new_observation,
            variables = context$values$variables
        )
    })

})

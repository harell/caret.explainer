# UI ----------------------------------------------------------------------
InstanceAnalysisUI <- function(id){
    ns <- NS(id)

    fluidRow(
        column(width = 4,
               box(dataTableOutput(ns("unseen_observations")), title = "Observations")
        ), # end column 4

        column(width = 2,
               box(checkboxGroupInput(inputId = ns("what_if_vars"), label = ""), title = "Variables")
        ),# end column 2

        column(width = 6,
               box(plotOutput(ns("break_down")), title = "Break Down Plot"),
               box(plotOutput(ns("ceteris_paribus")), title = "What-if Scenarios Analysis")
        )# end column 6
    ) # end dashboardBody
}

# Server ------------------------------------------------------------------
InstanceAnalysisServer <- function(input, output, session){
    # Setup -------------------------------------------------------------------
    ns <- session$ns
    Dashboard$funs$load_data()
    model_elements <- caret$train %>% CaretModelDecomposition$new()
    explanations <- instantiate_explainer(caret$train)
    context$values$role_target <- model_elements$role_target
    context$values$role_input <- setdiff(
        sapply(model_elements$data, class) %>%
            tibble::enframe("name", "type") %>%
            dplyr::filter(type %in% c("numeric", "integer")) %>%
            .$name,
        model_elements$role_target
    )

    # UI Widgets --------------------------------------------------------------
    updateCheckboxGroupInput(session, inputId = "what_if_vars", choices = as.list(context$values$role_input))

    # Observation table -------------------------------------------------------
    ## Create DT table
    unseen_observations <-
        datatable(
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
    output$unseen_observations <- renderDataTable(unseen_observations, server = TRUE)

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
            variables = input$what_if_vars
        )
    })
}

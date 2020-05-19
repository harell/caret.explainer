# UI ----------------------------------------------------------------------
InstanceAnalysisUI <- function(id){
    ns <- NS(id)

    fluidRow(
        column(width = 4,
               box(
                   title = "Filtering Options", collapsible = TRUE, collapsed = TRUE,
                   uiOutput(outputId = ns('instances_filters'), inline = TRUE)
               ),
               box(
                   title = "Observations",
                   dataTableOutput(outputId = ns("instances_table"))
               )
        ), # end column 4

        column(width = 2,
               box(checkboxGroupInput(inputId = ns("what_if_vars"), label = ""), title = "Variables")
        ),# end column 2

        column(width = 6,
               box(plotOutput(ns("break_down")), title = "Break Down Plot"),
               box(plotOutput(ns("ceteris_paribus")), title = "What-if Scenarios Analysis")
        )# end column 6
    ) # end fluidRow
}

# Server ------------------------------------------------------------------
InstanceAnalysisServer <- function(input, output, session){
    assert_exists <- function(x, env = parent.frame()) invisible(sapply(x, function(x, env) assertthat::assert_that(exists(x, envir = env), msg = paste(x, "doesn't exist")), env = env))

    # Get the data
    caret <- MockDatabase$funs$load_caret()
    assert_exists(c("dataset", "role_target", "role_input", "role_info", "role_pk"), env = caret)

    # Setup
    ns <- session$ns
    model_elements <- caret$train %>% CaretModelDecomposition$new()
    explanations <- instantiate_explainer(caret$train)
    vars_meta <- sapply(caret$dataset, class) %>% tibble::enframe("name", "type")
    context$values$role_pk <- caret$role_pk
    context$values$role_target <- caret$role_target
    context$values$role_input <- vars_meta %>% dplyr::filter(name %in% caret$role_input, type %in% c("numeric", "integer")) %>% .$name
    context$values$role_info <- vars_meta %>% dplyr::filter(name %in% caret$role_info, type %in% c("factor")) %>% .$name

    # UI Widgets
    updateCheckboxGroupInput(session, inputId = "what_if_vars", choices = as.list(context$values$role_input))

    # Observation table
    ## DT table filters
    tableFilterGenerator <- Dashboard$shiny$tableFilterGenerator
    output$instances_filters <- renderUI({
        purrr::map(
            context$values$role_info,
            ~ tableFilterGenerator(data = caret$dataset, col_name = .x, Namespace = ns)
        )
    })

    ## DT table observations
    instances_table <- reactive({
        indicators <- base::rep(TRUE, nrow(caret$dataset))
        for(key in context$values$role_info){
            if(is.null(input[[key]])) next
            indicators <- caret$dataset[[key]] %in% input[[key]] & indicators
        }

        datatable(
            data = caret$dataset[indicators, ],
            extensions = "Scroller",
            style = "bootstrap",
            class = "compact",
            selection = list(mode = "single", selected = 1, target = 'row'),
            width = "100%",
            options = list(
                deferRender = TRUE, dom = 't',
                scrollY = "66vh", scrollCollapse = TRUE, paging = FALSE,
                autoWidth = TRUE,
                columnDefs = Dashboard$DT$col_to_show(caret$dataset, caret$role_pk)
            ),
            editable = FALSE
        )
    })

    ## Wrap data frame in SharedData
    output$instances_table <- renderDataTable(instances_table(), server = TRUE)

    # Break Down Plot
    output$break_down <- renderPlot({
        selected_row <- input$instances_table_rows_selected
        new_observation <- if(length(selected_row) == 0) NULL else caret$dataset[selected_row, ]
        explanations$plot_break_down(new_observation = new_observation)
    })

    # Ceteris Paribus Plot
    output$ceteris_paribus <- renderPlot({
        selected_row <- input$instances_table_rows_selected
        new_observation <- if(length(selected_row) == 0) NULL else caret$dataset[selected_row, ]
        explanations$plot_ceteris_paribus(
            new_observation = new_observation,
            variables = input$what_if_vars
        )
    })
}

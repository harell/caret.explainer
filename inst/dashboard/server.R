shinyServer(function(input, output, session) {
    # Instance Analysis -------------------------------------------------------
    callModule(InstanceAnalysisServer, id = "InstanceAnalysis")
})

source(list.files(path = dirname(getwd()), pattern = "testthat-helpers.R$", recursive = TRUE, full.names = TRUE))

# Mocks -------------------------------------------------------------------
MockModelDecomposition <- R6::R6Class(
    inherit = ModelDecomposition,
    classname = "MockModelDecomposition",
    public = list(
        # Public Fields
        model_object = lm(mpg ~ ., mtcars),
        historical_data = mtcars,
        new_data = NULL,
        role_target = "mpg",
        role_input = colnames(mtcars)[-1],
        # Public Methods
        predict_function = function(object, newdata = NULL) predict(object, newdata),
        initialize = function(object = NULL) invisible()
    )
)


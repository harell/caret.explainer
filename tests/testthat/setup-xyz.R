# caret model -------------------------------------------------------------
caret <- new.env()
local({
    utils::data('titanic_imputed', package = "DALEX")
    dataset <- titanic_imputed
    dataset$survived <- factor(dataset$survived, levels = 1:0, c("Survived", "Perished"))
    role_target <- "survived"
    role_input <- c("gender", "age", "class", "embarked", "fare", "sibsp", "parch")
    model_formula <- formula(paste(role_target, "~" , paste(role_input, collapse = " + ")))

    set.seed(1546)
    suppressWarnings({
        caret_ctrl <- caret::trainControl(method = "none", classProbs = TRUE, summaryFunction = caret::twoClassSummary)
        caret_train <- caret::train(survived ~ ., data = dataset, method = "glm", trControl = caret_ctrl)
        caret_predict <- predict(caret_train, newdata = dataset)
    })

    caret$role_input <- role_input
    caret$role_target <- role_target
    caret$model <- caret_train
})

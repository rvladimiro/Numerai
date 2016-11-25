# Boot -------------------------------------------------------------------------

# Clean the workspace
rm(list = ls())

# Load packages into library
require(caret)

# Set random seed
set.seed(0958)

# Load data and create small sample to prototype
prototype_sample = dplyr::sample_n(tbl = readr::read_csv('data/numerai_training_data.csv'),
                                   size = 5000)

# Change the target to a factor
prototype_sample$target = as.factor(prototype_sample$target)

# Create training and test sets
is_train = createDataPartition(y = prototype_sample$target, p = 0.8, list = F)
trn = prototype_sample[is_train, ]
tst = prototype_sample[-is_train, ]

#' Create function to produce model and output. This function throws all
#' features in and doesn't perform any feature engineering or selection.
train_5_fold_cv_model = function(method) {
    set.seed(1625)
    model = train(target ~ .,
                  data = trn,
                  method = method,
                  trControl = trainControl(method = 'cv',
                                           number = 5,
                                           trim = T))
    print(confusionMatrix(predict(model, tst), tst$target))
    return(model)
}

# Quick and dirty random forest 50/48/52 ---------------------------------------
qad_rf = train_5_fold_cv_model('rf')

# Quick and dirty radial SVM 50/45/55 ------------------------------------------
qad_radial_svm = train_5_fold_cv_model('svmRadial')

# Quick and dirty linear XGBoost 50/46/53 --------------------------------------
qad_linear_xg = train_5_fold_cv_model('xgbLinear')

# Quick and dirty tree XGBoost 48/38/57 ----------------------------------------
qad_tree_xg = train_5_fold_cv_model('xgbTree')

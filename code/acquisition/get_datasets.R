##### CHANGE TARGET TO YES/NO FACTOR



get_bulk_data = function(n) {
    
    # Get the full training data
    td = suppressMessages(readr::read_csv(file = 'data/numerai_training_data.csv'))
    
    # Define training and test sets
    set.seed(0950)
    is_train = caret::createDataPartition(y = td$target, p = 0.8, list = F)
    # By default nothing is training...
    td$is_train = F
    # ...except the rows explicitly defined in the data partition
    td$is_train[is_train] = T
    
    # Get a sample of size n
    td = dplyr::sample_n(tbl = td, size = n)
    
    # Return training data
    return(td)
    
}



get_trn_data = function(n) {
    
    # Get n rows of the training data
    td = get_bulk_data(n)
    # Filter training rows only
    td = dplyr::filter(td, is_train)
    # Remove the is_train column
    td = dplyr::select(td, -is_train)
    
    # Return the final training dataset
    return(td)
    
}



get_tst_data = function(n) {
    
    # Get n rows of the training data
    td = get_bulk_data(n)
    # Filter training rows only
    td = dplyr::filter(td, !is_train)
    # Remove the is_train column
    td = dplyr::select(td, -is_train)
    
    # Return the final training dataset
    return(td)
    
}

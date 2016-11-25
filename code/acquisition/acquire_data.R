# Boot -------------------------------------------------------------------------

dafR::Say('Cleaning Workspace...')
rm(list = ls())



#' Check if there are datasets for today already. I never want to get datasets
#' that I already have.

dafR::Say('Establish current date...')
currentDate <- stringr::str_replace_all(string = Sys.Date(), 
                                        pattern = '-', 
                                        replacement = '')



# Download training data -------------------------------------------------------

if(paste0('train', currentDate, '.csv') %in% list.files('data/')) {
    dafR::Shout('Training data for', as.character(Sys.Date()), 'found!')
} else {
    dafR::Say('Downloading training data')
    download.file(url = 'http://datasets.numer.ai/numerai_training_data.csv',
                  destfile = paste0('data/train', currentDate, '.csv'),
                  quiet = T)
    
}



# Download prediction data -----------------------------------------------------

if(paste0('predict', currentDate, '.csv') %in% list.files('data/')) {
    dafR::Shout('Prediction data for', as.character(Sys.Date()), 'found!')
} else {
    dafR::Say('Downloading prediction data')
    download.file(url = 'http://datasets.numer.ai/numerai_tournament_data.csv',
                  destfile = paste0('data/predict', currentDate, '.csv'),
                  quiet = T)
}

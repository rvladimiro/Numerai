#' @description  This function downloads the current Numerai datasets and saves
#' them with a name that includes the download date.
download_data = function() {
    
    #' Get the response from the API. This response includes the S3 URL for the
    #' latest datasets zip file
    dafR::Say('Get S3 URL for datasets')
    download.file(url = 'https://api.numer.ai/competitions/current/dataset',
                  destfile = paste0('data/response.txt'),
                  quiet = T,
                  method = 'curl')
    
    #' Extract the S3 URL from the response file.
    s3_url =suppressWarnings(
        stringr::str_replace(string = readLines('data/response.txt'),
                             pattern = 'Found. Redirecting to ',
                             replacement = '')
    )
    
    #' Download the current datasets.
    dafR::Say('Download datasets')
    download.file(url = s3_url,
                  destfile = 'data/numerai_datasets.zip',
                  quiet = T,
                  method = 'curl')
    
    #' Unzip the two relevant files
    dafR::Say('Unzip datasets')
    unzip(zipfile = 'data/numerai_datasets.zip',
          files = c('numerai_tournament_data.csv', 'numerai_training_data.csv'),
          exdir = 'data/')
    
    #' Rename the files to include the date of the download
    dafR::Say('Rename CSVs to include download date')
    results = file.rename(from = c('data/numerai_training_data.csv',
                                   'data/numerai_tournament_data.csv'),
                          to = c(paste0('data/numerai_training_data_', Sys.Date(), '.csv'),
                                 paste0('data/numerai_tournament_data_', Sys.Date(), '.csv')))
    
    #' Remove the unnecessary files
    dafR::Say('Remove unnecessary files')
    file.remove(c('data/numerai_datasets.zip',
                  'data/response.txt'))
    
    dafR::Shout('Processed completed successfuly!')
}


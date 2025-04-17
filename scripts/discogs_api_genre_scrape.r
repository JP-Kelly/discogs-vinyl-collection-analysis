# This code will use the Discogs API to extract genre information for all records in an exported Discogs collection (using release_id field)

# Load required packages
library(httr)
library(jsonlite)
library(dplyr)
library(purrr)
library(readr)
library(ratelimitr)

# Set your Discogs API token (you'll need to register at https://www.discogs.com/settings/developers)
discogs_token <- "enter token here"


# Main processing function with progress tracking
get_discogs_genres_api <- function(release_ids, output_file = NULL, resume = FALSE) {
  # If resuming, load already processed IDs
  processed_ids <- c()
  if (resume && !is.null(output_file) && file.exists(output_file)) {
    existing_data <- read_csv(output_file, show_col_types = FALSE)
    processed_ids <- existing_data$release_id
    release_ids <- setdiff(release_ids, processed_ids)
    message(paste("Resuming from", length(processed_ids), "already processed releases"))
  }
  
  # Initialize results
  results <- if (resume && exists("existing_data")) existing_data else NULL
  
  # Process with progress bar
  pb <- progress_estimated(length(release_ids))
  for (i in seq_along(release_ids)) {
    id <- release_ids[i]
    pb$tick()$print()
    
    result <- tryCatch({
      get_discogs_release_limited(id)
    }, error = function(e) {
      message(paste("Error processing release", id, ":", e$message))
      data.frame(
        release_id = id,
        genre = NA,
        style = NA,
        stringsAsFactors = FALSE
      )
    })
    
    # Append result
    results <- bind_rows(results, result)
    
    # Periodically save progress
    if (!is.null(output_file)) {
      if (i %% 50 == 0 || i == length(release_ids)) {
        write_csv(results, output_file)
        message(paste("Saved progress after", i, "releases"))
      }
    }
  }
  
  return(results)
}

# Example usage:
# 1. Read your data
discogs_data <- read_csv("/pathway/to/your/discogs_export.csv")

# 2. Get unique release IDs
release_ids <- unique(discogs_data$release_id)

# 3. Run with periodic saving (will create/update the output file)
output_path <- "/pathway/to/your/save/directory/discogs_genres_api_results.csv"
genre_data <- get_discogs_genres_api(
  release_ids,
  output_file = output_path,
  resume = TRUE  # Set to FALSE on first run
)

# 4. OPTIONAL - Merge with original data
final_data <- left_join(discogs_data, genre_data, by = "release_id")

# 5. Save final results
write_csv(final_data, "/pathway/to/your/save/directory/discogs_with_genres_final.csv") # Once you verify the data rename to discogs_export.csv

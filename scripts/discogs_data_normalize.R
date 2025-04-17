# This script will normalise genre and style data
# It uses the dataframe made in the previous "discogs_api_genrescrape.R" script

library(tidyverse)

# Your dataframes:
# genre_data (from API): release_id | genre | style
# discogs_data (original export): release_id | other columns...

normalize_discogs_data <- function(genre_data) {
  # Split comma-separated genres
  genres_normalized <- genre_data %>%
    select(release_id, genre) %>%
    mutate(genre = strsplit(genre, ",\\s*")) %>%
    unnest(genre) %>%
    filter(!is.na(genre) & genre != "") %>%
    distinct()
  
  # Split comma-separated styles
  styles_normalized <- genre_data %>%
    select(release_id, style) %>%
    mutate(style = strsplit(style, ",\\s*")) %>%
    unnest(style) %>%
    filter(!is.na(style) & style != "") %>%
    distinct()
  
  # Create unique reference tables
  genre_lookup <- data.frame(genre_name = unique(genres_normalized$genre)) %>%
    mutate(genre_id = row_number())
  
  style_lookup <- data.frame(style_name = unique(styles_normalized$style)) %>%
    mutate(style_id = row_number())
  
  # Create junction tables with IDs
  release_genres <- genres_normalized %>%
    inner_join(genre_lookup, by = c("genre" = "genre_name")) %>%
    select(release_id, genre_id)
  
  release_styles <- styles_normalized %>%
    inner_join(style_lookup, by = c("style" = "style_name")) %>%
    select(release_id, style_id)
  
  return(list(
    genres = genre_lookup,
    styles = style_lookup,
    release_genres = release_genres,
    release_styles = release_styles
  ))
}

# Run normalization
normalized_tables <- normalize_discogs_data(genre_data)

# Export all normalized tables
setwd("/path/to/your/save/directory/")
write_csv(normalized_tables$genres, "discogs_genres.csv")
write_csv(normalized_tables$styles, "discogs_styles.csv")
write_csv(normalized_tables$release_genres, "discogs_release_genres.csv")
write_csv(normalized_tables$release_styles, "discogs_release_styles.csv")

# Optional: Export merged data
write_csv(final_data, "discogs_full_normalized.csv")

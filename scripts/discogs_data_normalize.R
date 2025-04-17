# This script will normalise genre and style data
# It uses the "genre_data" dataframe made in the previous "discogs_api_genrescrape.R" script

library(tidyverse)

normalize_discogs_data <- function(genre_data) {
  # Split comma-separated genres and track position
  genres_normalized <- genre_data %>%
    select(release_id, genre) %>%
    mutate(genre = strsplit(genre, ",\\s*")) %>%
    unnest_longer(genre, indices_to = "position") %>%
    filter(!is.na(genre) & genre != "") %>%
    rename(genre_name = genre)

  # Split comma-separated styles and track position
  styles_normalized <- genre_data %>%
    select(release_id, style) %>%
    mutate(style = strsplit(style, ",\\s*")) %>%
    unnest_longer(style, indices_to = "position") %>%
    filter(!is.na(style) & style != "") %>%
    rename(style_name = style)

  # Create unique reference tables
  genre_lookup <- genres_normalized %>%
    distinct(genre_name) %>%
    mutate(genre_id = row_number())

  style_lookup <- styles_normalized %>%
    distinct(style_name) %>%
    mutate(style_id = row_number())

  # Create junction tables with IDs and positions
  release_genres <- genres_normalized %>%
    inner_join(genre_lookup, by = "genre_name") %>%
    select(release_id, genre_id, position)

  release_styles <- styles_normalized %>%
    inner_join(style_lookup, by = "style_name") %>%
    select(release_id, style_id, position)

  return(list(
    genres = genre_lookup,
    styles = style_lookup,
    release_genres = release_genres,
    release_styles = release_styles
  ))
}

# Your dataframes:
# genre_data (from API): release_id | genre | style
# discogs_data (original export): release_id | other columns...

# Run normalization
normalized_tables <- normalize_discogs_data(genre_data)

# Export all normalized tables
setwd("/path/to/your/save/directory/")
write_csv(normalized_tables$genres, "discogs_genres.csv")
write_csv(normalized_tables$styles, "discogs_styles.csv")
write_csv(normalized_tables$release_genres, "discogs_release_genres.csv")
write_csv(normalized_tables$release_styles, "discogs_release_styles.csv")

# Optional: Export merged data
# write_csv(final_data, "discogs_full_normalized.csv")

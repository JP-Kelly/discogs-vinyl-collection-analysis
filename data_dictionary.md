# Data Dictionary

This document provides a detailed description of the data fields used in the Discogs vinyl collection analysis project. It outlines the purpose and format of each column across the different datasets.

## Datasets Overview

The project uses the following datasets:

1.  `discogs_export.csv`: Original export of collection data from Discogs, enhanced with record value information.
2.  `discogs_genres.csv`: Mapping of genre names to genre IDs.
3.  `discogs_styles.csv`: Mapping of style names to style IDs.
4.  `discogs_release_genres.csv`: Junction table linking releases to genres and their positions.
5.  `discogs_release_styles.csv`: Junction table linking releases to styles and their positions.

## Data Field Descriptions

### 1. `discogs_export.csv`

| Field Name         | Description                                                                                                                               | Data Type   | Example(s)         |
|--------------------|-----------------------------------------------------------------------------------------------------------------------------------------|-------------|--------------------|
| `Catalog#`         | The catalogue number of the release, as listed on the vinyl record.                                                                    | TEXT        | EMI 225, CBS 82659 |
| `Artist`           | The primary artist(s) of the release.                                                                                                    | TEXT        | The Beatles, David Bowie |
| `Title`            | The title of the album or single.                                                                                                       | TEXT        | Abbey Road, Ziggy Stardust |
| `Label`            | The record label that released the vinyl.                                                                                               | TEXT        | Parlophone, RCA    |
| `Format`           | The format of the release (e.g., Vinyl, LP, 7", Album).                                                                                 | TEXT        | Vinyl, LP, 7"      |
| `Rating`           | Your personal rating for the release (if you provided one on Discogs).                                                                 | INTEGER     | 5, 3, NULL         |
| `Released`         | The year the release was originally released.                                                                                             | INTEGER     | 1967, 1972         |
| `release_id`       | The unique identifier for this specific release on Discogs. This is the primary key for linking to other datasets.                      | INTEGER     | 123456, 789012     |
| `CollectionFolder` | The folder(s) within your Discogs collection where this record is stored.                                                              | TEXT        | Main, New Arrivals |
| `Date Added`       | The date when you added this record to your Discogs collection.                                                                         | TEXT/DATE   | 2023-10-26         |
| `lowest_price`     | The lowest estimated market value (in Euros) for the release, obtained from the Discogs marketplace.                                    | DECIMAL     | 5.00, 10.00        |
| `median_price`     | The median estimated market value (in Euros) for the release, obtained from the Discogs marketplace.                                   | DECIMAL     | 12.00, 20.00       |
| `highest_price`    | The highest estimated market value (in Euros) for the release, obtained from the Discogs marketplace.                                   | DECIMAL     | 25.00, 50.00       |

### 2. `discogs_genres.csv`

| Field Name   | Description                                                                    | Data Type | Example(s) |
|--------------|--------------------------------------------------------------------------------|-----------|------------|
| `genre_name` | The name of the genre (as provided by the Discogs API).                          | TEXT      | Rock, Electronic |
| `genre_id`   | A unique identifier for each genre. This is the primary key. | INTEGER   | 1, 2         |

### 3. `discogs_styles.csv`

| Field Name   | Description                                                                    | Data Type | Example(s)      |
|--------------|--------------------------------------------------------------------------------|-----------|-----------------|
| `style_name` | The name of the style (as provided by the Discogs API).                          | TEXT      | Indie Rock, Techno |
| `style_id`   | A unique identifier for each style. This is the primary key. | INTEGER   | 101, 202        |

### 4. `discogs_release_genres.csv`

| Field Name   | Description                                                                                                | Data Type | Example(s) |
|--------------|------------------------------------------------------------------------------------------------------------|-----------|------------|
| `release_id` | Foreign key referencing the `release_id` in the `discogs_export.csv` table.                               | INTEGER   | 123456, 789012 |
| `genre_id`   | Foreign key referencing the `genre_id` in the `discogs_genres.csv` table.                                  | INTEGER   | 1, 2         |
| `position`   | The order in which this genre was listed for the release in the Discogs API data (1 being the primary genre). | INTEGER   | 1, 2         |

### 5. `discogs_release_styles.csv`

| Field Name   | Description                                                                                                | Data Type | Example(s)          |
|--------------|------------------------------------------------------------------------------------------------------------|-----------|--------------------|
| `release_id` | Foreign key referencing the `release_id` in the `discogs_export.csv` table.                               | INTEGER   | 123456, 789012      |
| `style_id`   | Foreign key referencing the `style_id` in the `discogs_styles.csv` table.                                  | INTEGER   | 101, 202            |
| `position`   | The order in which this style was listed for the release in the Discogs API data.                          | INTEGER   | 1, 3                |

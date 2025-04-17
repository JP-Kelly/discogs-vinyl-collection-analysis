# 🎵 Discogs Vinyl Collection Analysis

This project documents the process of converting my personal vinyl record collection into a structured database and analyzing its characteristics using R, SQL, and Tableau. The goal is to gain insights into the collection's genre distribution, value, and other trends.

## 🛠️ Key Technologies

* **R:** For data extraction from the Discogs API, data cleaning, and data transformation.
* **Discogs API:** For programmatically retrieving genre and style information.
* **Excel:** For manual data cleaning and transformation.
* **SQL (MySQLWorkbench):** For creating a relational database, loading data, and performing exploratory data analysis [EDA].
* **Tableau (Coming soon...):** For creating interactive visualisations of the collection.

## 💾 Data Sources

* **Discogs Export:** A CSV export of my collection from Discogs, containing basic record information.
* **Discogs API:** Used to retrieve genre and style information based on release IDs.
* **Manual Price Data:** Manually collected data on record values (low, median, high) from the Discogs marketplace.

## 📊 Data Processing Workflow

1.  **Collection Export:** My vinyl collection was exported from Discogs as a CSV file.
2.  **Genre Data Retrieval (R):** An R script (`discogs_api_genre_scrape.R`) was used to query the Discogs API and retrieve genre and style information for each record.
3.  **Data Normalization (R):** The retrieved data was further normalised using R scripts (`discogs_data_normalize.R`) to create a relational database structure.
4.  **Database Creation and Loading (SQL):** A MySQL database was created using the `discogs_db_setup.sql` script, and the CSV data was loaded into the database tables.
5.  **Price Data Merging (R):** Manually collected price data was merged with the main dataset using an R script (`discogs_merge_prices.R`).
6.  **Data Analysis (R/SQL):** R and SQL queries were used to analyse the collection's characteristics.
7.  **Visualisation (Tableau - Future):** (Planned) Interactive visualisations will be created in Tableau to explore the data.

## 🗄️ Database Schema

```mermaid
erDiagram
    releases {
        int release_id PK
        varchar artist
        varchar title
        varchar label
        varchar format
        decimal rating
        int released
        varchar collection_folder
        datetime date_added
        decimal lowest_price
        decimal median_price
        decimal highest_price
    }
    genres {
        int genre_id PK
        varchar genre_name
    }
    styles {
        int style_id PK
        varchar style_name
    }
    release_genres {
        int release_id FK
        int genre_id FK
        int position
        string composite_pk PK
    }
    release_styles {
        int release_id FK
        int style_id FK
        int position
        string composite_pk PK
    }
    releases ||--o{ release_genres : ""
    releases ||--o{ release_styles : ""
    genres ||--o{ release_genres : ""
    styles ||--o{ release_styles : ""
```


## ⚙️ Database Setup

The database schema for this project is defined in the `scripts/discogs_db_setup.sql` file. This file contains the SQL commands to create the necessary tables and relationships in a MySQL database.

To set up the database:

1.  Ensure you have MySQL installed and running.
2.  Execute the SQL commands in `scripts/discogs_db_setup.sql` using a MySQL client (e.g., MySQL Workbench). This will create the tables: `releases`, `genres`, `styles`, `release_genres`, and `release_styles`.

## 💾 Data Loading

After creating the database and tables, you need to load the data from the CSV files (located in the `data/` directory) into the database.

You can do this using several methods:

* **MySQL Workbench Import Wizard:** This is a user-friendly way to import CSV data. Follow the instructions within MySQL Workbench to select your CSV files and map the columns to the corresponding tables.
* **`LOAD DATA INFILE` SQL Statement:** For more efficient loading, you can use the `LOAD DATA INFILE` statement within MySQL. For example, to load data from `data/discogs_genres.csv` into the `genres` table, you could use a command similar to this (adjust the file path as needed):

    ```sql
    LOAD DATA INFILE '/path/to/your/DiscogsVinylCollection/data/discogs_genres.csv'
    INTO TABLE genres
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;  -- If the CSV has a header row
    ```

    Repeat this `LOAD DATA INFILE` command (with appropriate adjustments) for each of the CSV files.

* **Scripting Languages (R or Python):** You can also write scripts in R or Python to read the CSVs and insert the data into the database.

## 🔍 Example SQL Queries

```sql
-- What are the top 5 most frequent primary genres?
SELECT genre_name, COUNT(*) AS genre_count
FROM discogs_genres dg
JOIN discogs_release_genres drg ON dg.genre_id = drg.genre_id
WHERE drg.position = 1
GROUP BY genre_name
ORDER BY genre_count DESC
LIMIT 5;

-- What is the average median value of records in the "Jazz" genre?
SELECT AVG(d.median) AS avg_jazz_value
FROM discogs_export d
JOIN discogs_release_genres drg ON d.release_id = drg.release_id
JOIN discogs_genres dg ON drg.genre_id = dg.genre_id
WHERE dg.genre_name = 'Jazz';

-- (More examples to be added...)
```


CREATE TABLE releases (
    release_id INT PRIMARY KEY,
    artist VARCHAR(255),
    title VARCHAR(255),
    label VARCHAR(255),
    format VARCHAR(255),
    rating DECIMAL(10,2),
    released INT,
    collection_folder VARCHAR(255),
    date_added DATETIME,
    lowest_price DECIMAL(10,2),
    median_price DECIMAL(10,2),
    highest_price DECIMAL(10,2)
);

CREATE TABLE genres (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR(255)
);

CREATE TABLE styles (
    style_id INT PRIMARY KEY,
    style_name VARCHAR(255)
);

CREATE TABLE release_genres (
    release_id INT,
    genre_id INT,
    position INT,
    composite_pk VARCHAR(255),
    FOREIGN KEY (release_id) REFERENCES releases(release_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
    PRIMARY KEY (composite_pk)
);

CREATE TABLE release_styles (
    release_id INT,
    style_id INT,
    position INT,
    composite_pk VARCHAR(255),
    FOREIGN KEY (release_id) REFERENCES releases(release_id),
    FOREIGN KEY (style_id) REFERENCES styles(style_id),
    PRIMARY KEY (composite_pk)
);

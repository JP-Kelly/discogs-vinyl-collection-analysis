SQL

CREATE TABLE release_genres (
    release_id INT,
    genre_id INT,
    position INT,
    composite_pk VARCHAR(255),  -- Adjust VARCHAR length as needed
    FOREIGN KEY (release_id) REFERENCES releases(release_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
    PRIMARY KEY (composite_pk)
);

CREATE TABLE release_styles (
    release_id INT,
    style_id INT,
    position INT,
    composite_pk VARCHAR(255),  -- Adjust VARCHAR length as needed
    FOREIGN KEY (release_id) REFERENCES releases(release_id),
    FOREIGN KEY (style_id) REFERENCES styles(style_id),
    PRIMARY KEY (composite_pk)
);
And when you insert data, you'll need to generate the value for composite_pk:

SQL

INSERT INTO release_genres (release_id, genre_id, position, composite_pk)
VALUES (1, 101, 1, '1-101-1');  -- Example: release_id-genre_id-position

INSERT INTO release_styles (release_id, style_id, position, composite_pk)
VALUES (1, 201, 1, '1-201-1');  -- Example: release_id-style_id-position

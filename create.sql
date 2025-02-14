CREATE TABLE IF NOT EXISTS Artists(
id_artist SERIAL PRIMARY KEY,
name VARCHAR(200) NOT NULL
);


CREATE TABLE IF NOT EXISTS Genres(
id_genre SERIAL PRIMARY KEY,
name VARCHAR(200) NOT NULL
);


CREATE TABLE IF NOT EXISTS Albums(
id_album SERIAL PRIMARY KEY,
title VARCHAR(200) NOT NULL,
release_year Integer 
);


CREATE TABLE IF NOT EXISTS Tracks(
id_track SERIAL PRIMARY KEY,
track_name VARCHAR(200) NOT NULL,
duraton INTEGER,
id_album INTEGER REFERENCES Albums(id_album)
);

CREATE TABLE IF NOT EXISTS Genre_artist(
id_genre INTEGER REFERENCES Genres(id_genre),
id_artist INTEGER REFERENCES Artists(id_artist)
);

CREATE TABLE IF NOT EXISTS Collections(
id_collection SERIAL PRIMARY KEY,
title VARCHAR NOT NULL,
release_year DATA 
);

CREATE TABLE IF NOT EXISTS Collection_track(
id_track INTEGER REFERENCES Tracks(id_track),
id_collection INTEGER REFERENCES Collections(id_collection)
);

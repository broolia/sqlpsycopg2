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
release_year INTEGER 
);


CREATE TABLE IF NOT EXISTS Tracks(
id_track SERIAL PRIMARY KEY,
title VARCHAR(200) NOT NULL,
duration INTEGER,
id_album INTEGER REFERENCES Albums(id_album)
);

CREATE TABLE IF NOT EXISTS Genre_artist(
id_genre INTEGER REFERENCES Genres(id_genre),
id_artist INTEGER REFERENCES Artists(id_artist)
);

CREATE TABLE IF NOT EXISTS Collections(
id_collection SERIAL PRIMARY KEY,
title VARCHAR(200) NOT NULL,
release_year INTEGER 
);

CREATE TABLE IF NOT EXISTS Collection_track(
id_track INTEGER REFERENCES Tracks(id_track),
id_collection INTEGER REFERENCES Collections(id_collection)
);

CREATE TABLE IF NOT EXISTS artist_album(
id_artist INTEGER REFERENCES Artists(id_artist),
id_album INTEGER REFERENCES Albums(id_album)
);



INSERT INTO Artists(name)
VALUES('Maddona'),
('Sting'),
('Alicia Keys'),
('Beyonce');


INSERT INTO Albums(title,release_year)
VALUES('MDNA',2012),
('The Bridge',2021),
('HERE',2016),
('B day',2006);


INSERT INTO artist_album (id_artist,id_album)
VALUES(1,1),
(2,2),
(3,3),
(4,4);

INSERT INTO tracks (track_name,duration,id_album)
VALUES('Suga Mama', make_interval(mins => 5),4),
      ('The Gospil', make_interval(mins => 4),3),
      ('Loving You', make_interval(mins => 6),2),
      ('Super Star', make_interval(mins => 4),4),
      ('Gang Bang', make_interval(mins => 8),1),
      ('Turn Up The Radio', make_interval(mins => 7),1),
      ('Rushing Water', make_interval(mins => 5),2);

INSERT INTO genres (name)
VALUES('Pop'),
('Pop-Rock'),
('Soul');



INSERT INTO genre_artist (id_artist,id_genre)
VALUES(1,1),
(2,2),
(3,3),
(4,1),
(4,3);

INSERT INTO collections (title, release_year)
VALUES('Happy MOOD', 2021),
('Relations', 2019);


INSERT INTO collection_track (id_track, id_collection)
VALUES(1,1),
(4,1),
(5,1),
(6,1),
(2,1),
(3,2),
(6,2),
(7,2);



SELECT track_name, duration
FROM tracks 
WHERE duration = (SELECT MAX(duration) FROM Tracks);


SELECT track_name,duration 
FROM tracks 
WHERE duration >= INTERVAL '3.5 minutes';

SELECT pg_typeof(duration)
FROM tracks;


SELECT title,release_year 
FROM collections  
WHERE release_year BETWEEN 2018 AND 2020;

SELECT name 
FROM artists  
WHERE name  NOT LIKE '% %';




INSERT INTO tracks (track_name,duration,id_album)
VALUES('My one', make_interval(mins => 5),4),
('Oh, my God',make_interval(mins => 3),4),
('myself',make_interval(mins => 3),4);

SELECT track_name
FROM tracks
WHERE track_name ~* '[[:<:]]мой[[:>:]]' OR track_name ~* '[[:<:]]my[[:>:]]';


SELECT * FROM tracks; 



SELECT g.name AS genre_name, COUNT(ga.id_artist) AS artist_count
FROM genres g
LEFT JOIN genre_artist ga ON g.id_genre = ga.id_genre
GROUP BY g.name
ORDER BY artist_count DESC;

SELECT COUNT(t.id_track) AS track_count
FROM Tracks t
JOIN Albums a ON t.id_album = a.id_album
WHERE a.release_year BETWEEN 2019 AND 2020; 

SELECT AVG(t.duration)AS average_duraton ,a.title AS album_title
FROM albums a 
LEFT JOIN tracks t ON a.id_album = t.id_album 
GROUP BY a.title ;

SELECT name
FROM  artists
WHERE id_artist NOT IN (
    SELECT aa.id_artist
    FROM albums a
    JOIN artist_album aa ON a.id_album = aa.id_album
    WHERE a.release_year = 2020
    );

SELECT DISTINCT c.title
FROM collections c
JOIN  collection_track ct  ON c.id_collection = ct.id_collection 
JOIN tracks t ON ct.id_track = t.id_track 
JOIN albums a ON t.id_album = a.id_album 
JOIN artist_album aa ON a.id_album = aa.id_album 
JOIN artists ar ON aa.id_artist = ar.id_artist 
WHERE ar.name = 'Sting';

SELECT DISTINCT c.title
FROM collections c
JOIN  collection_track ct  ON c.id_collection = ct.id_collection 
JOIN tracks t ON ct.id_track = t.id_track 
JOIN albums a ON t.id_album = a.id_album 
JOIN artist_album aa ON a.id_album = aa.id_album 
JOIN artists ar ON aa.id_artist = ar.id_artist 
WHERE ar.name = 'Maddona';
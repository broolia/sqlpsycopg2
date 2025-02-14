

INSERT INTO Artists(name)
VALUES('Maddona');

INSERT INTO Artists(name)
VALUES('Sting');

INSERT INTO Artists(name)
VALUES('Beyonce');

INSERT INTO Artists(name)
VALUES('Alicia Keys');

INSERT INTO Albums(title,release_year)
VALUES('MDNA',2012);

INSERT INTO Albums(title,release_year)
VALUES('The Bridge',2021);

INSERT INTO Albums(title,release_year)
VALUES('B day',2006);

INSERT INTO Albums(title,release_year)
VALUES('HERE',2016);

INSERT INTO artist_album (id_artist,id_album)
VALUES(5,7);

INSERT INTO artist_album (id_artist,id_album)
VALUES(6,8);

INSERT INTO artist_album (id_artist,id_album)
VALUES(7,9);

INSERT INTO artist_album (id_artist,id_album)
VALUES(8,10);

INSERT INTO tracks (track_name,duraton,id_album)
VALUES('Suga Mama',5,7);

UPDATE tracks 
SET id_album = 9
WHERE id_album IN (7)

INSERT INTO tracks (track_name,duraton,id_album)
VALUES('The Gospil',4,10);

INSERT INTO tracks (track_name,duraton,id_album)
VALUES('Loving You',6,8);

INSERT INTO tracks (track_name,duraton,id_album)
VALUES('Suga Mama',5,7);

INSERT INTO tracks (track_name,duraton,id_album)
VALUES('Super Star',4,7);

INSERT INTO tracks (track_name,duraton,id_album)
VALUES('Gang Bang',8,7);

INSERT INTO tracks (track_name,duraton,id_album)
VALUES('Turn Up The Radio',7,7);

 INSERT INTO genres (name)
VALUES('Pop');

INSERT INTO genres (name)
VALUES('Pop-rock');

INSERT INTO genres (name)
VALUES('Soul');

INSERT INTO genre_artist (id_genre,id_artist)
VALUES(3,7);

INSERT INTO genre_artist (id_genre,id_artist)
VALUES(3,8);

INSERT INTO genre_artist (id_genre,id_artist)
VALUES(2,6);

INSERT INTO genre_artist (id_genre,id_artist)
VALUES(1,5);


INSERT INTO collections (title, release_year)
VALUES('Happy MOOD', '2021-01-20');


INSERT INTO collections (title, release_year)
VALUES('Relations', '2019-04-11');


INSERT INTO collection_track (id_track, id_collection)
VALUES(9,2);

INSERT INTO collection_track (id_track, id_collection)
VALUES(10,2);

INSERT INTO collection_track (id_track, id_collection)
VALUES(7,2);

UPDATE collection_track 
SET id_track = 8
WHERE id_track IN (10)





INSERT INTO collection_track (id_track, id_collection)
VALUES(10,1);


INSERT INTO collection_track (id_track, id_collection)
VALUES(9,1);

INSERT INTO collection_track (id_track, id_collection)
VALUES(11,1);


INSERT INTO collections (title, release_year)
VALUES('Pop', '2010-06-21');

INSERT INTO collections (title, release_year)
VALUES('Rock', '2015-08-21');

INSERT INTO tracks (track_name,duraton,id_album)
VALUES('Deja Vu',9,7);

INSERT INTO tracks (track_name,duraton,id_album)
VALUES('Suga Mama',5,7);

UPDATE tracks 
SET id_album = 9
WHERE id_album IN (7)


INSERT INTO tracks (track_name,duraton,id_album)
VALUES('Pawn It All',5,10);




INSERT INTO collection_track (id_track, id_collection)
VALUES(13,3);

INSERT INTO collection_track (id_track, id_collection)
VALUES(12,3);

INSERT INTO collection_track (id_track, id_collection)
VALUES(9,3);

INSERT INTO collection_track (id_track, id_collection)
VALUES(9,4);

INSERT INTO collection_track (id_track, id_collection)
VALUES(9,3);


ALTER TABLE collection_track 
ADD CONSTRAINT id PRIMARY KEY (id_track, id_collection);

DELETE FROM collection_track
WHERE (id_track, id_collection) IN (
    SELECT id_track, id_collection
    FROM (
        SELECT
            id_track,
            id_collection,
            ROW_NUMBER() OVER (PARTITION BY id_track, id_collection ORDER BY id_track, id_collection) AS row_num
        FROM
            collection_track
    ) AS row_numbers
    WHERE row_num > 1
);

ALTER TABLE collection_track
ADD CONSTRAINT id PRIMARY KEY (id_track, id_collection);

SELECT id_genre, id_artist, COUNT(*)
FROM genre_artist
GROUP BY id_genre, id_artist
HAVING COUNT(*) > 1;

ALTER TABLE genre_artist
ADD CONSTRAINT ID_genre_artist PRIMARY KEY (id_genre, id_artist);



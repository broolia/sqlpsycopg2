
SELECT track_name, duraton
FROM tracks 
WHERE duraton = (SELECT MAX(duraton) FROM Tracks);


SELECT track_name,duraton 
FROM tracks 
WHERE duraton >= 3.5;


SELECT title,release_year 
FROM collections  
WHERE release_year BETWEEN '2018-01-01' AND '2020-12-31';

SELECT name 
FROM artists  
WHERE name NOT LIKE '% %';

SELECT track_name 
FROM tracks  
WHERE track_name LIKE '%мой%' OR track_name LIKE '%my%';

SELECT g.name AS genre_name, COUNT(ga.id_artist) AS artist_count
FROM genres g
LEFT JOIN genre_artist ga ON g.id_genre = ga.id_genre
GROUP BY g.name
ORDER BY artist_count DESC;

SELECT COUNT(t.id_track) AS track_count
FROM Tracks t
JOIN Albums a ON t.id_album = a.id_album
WHERE a.release_year BETWEEN 2020 AND 2025; 

SELECT AVG(t.duraton)AS average_duraton ,a.title AS album_title
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

SELECT c.title
FROM collections c
JOIN  collection_track ct  ON c.id_collection = ct.id_collection 
JOIN tracks t ON ct.id_track = t.id_track 
JOIN albums a ON t.id_album = a.id_album 
JOIN artist_album aa ON a.id_album = aa.id_album 
JOIN artists ar ON aa.id_artist = ar.id_artist 
WHERE ar.name = 'Sting';



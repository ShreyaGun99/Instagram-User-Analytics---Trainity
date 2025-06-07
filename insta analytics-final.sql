SELECT * from users;

# Identify 5 oldest instagram users.
SELECT 
    id, 
    username, 
    created_at, 
    row_number() over(order by created_at) as rank_by_date
FROM
    users
LIMIT 5;
    
# Identify inactive users who have not posted any photos

CREATE VIEW photos_by_user AS
    (SELECT 
        user_id, COUNT(image_url) AS photo_count
    FROM
        photos
    GROUP BY user_id);
            
CREATE VIEW inactive_users AS
    (SELECT 
        *
    FROM
        photos_by_user
            RIGHT JOIN
        users ON photos_by_user.user_id = users.id
    WHERE
        photos_by_user.photo_count IS NULL);
        

SELECT 
     users.username, users.id
FROM    
     users
         LEFT JOIN photos
	ON users.id = photos.user_id 
WHERE 
     photos.user_id IS NULL
;

# Determine user with most likes on a single photo
 
SELECT 
    users.username, 
    photos.id,
    photos.image_url, 
    COUNT(*) AS like_count
FROM photos
INNER JOIN likes
    ON likes.photo_id = photos.id
INNER JOIN users
    ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY like_count DESC
LIMIT 1;

# Identify and suggest the top five most commonly used hashtags on the platform.

SELECT
  id,
  tag_name,
  count(photo_tags.photo_id) AS photo_count,
  row_number () OVER (ORDER BY count(photo_tags.photo_id) DESC) as tag_rank
FROM
  tags
JOIN photo_tags
ON tags.id = tag_id
GROUP BY
 tags.id 
 LIMIT 5;
 
 # Day of the week when most users register on Instagram
 
 SELECT  
   COUNT(id) as registered_count, 
   DAYNAME(created_at) as week_day,
   Dense_rank () OVER (ORDER BY COUNT(id) DESC) as weekday_rank
 from users
 Group by week_day
 ;
 
 #Calculate the average number of posts per user on Instagram. 
 #Also, provide the total number of photos on Instagram divided by the total number of users.
 
 SELECT ROUND(SUM(photo_count)/COUNT(user_id), 2) as avg_posts_per_user
 FROM photos_by_user;
 SELECT SUM(photo_count), COUNT(user_id)
 FROM photos_by_user;
 
 CREATE VIEW photocount_for_user AS
    (SELECT * FROM users
        LEFT JOIN photos_by_user ON photos_by_user.user_id = users.id
        );
 
 SELECT ROUND(SUM(photo_count)/COUNT(id), 2) as Avg_posts
 FROM photocount_for_user;
 SELECT SUM(photo_count), COUNT(id)
 FROM photocount_for_user;
  
 CREATE VIEW inactive_users1 AS
    (SELECT 
        *
    FROM
        users
        LEFT JOIN photos_by_user ON photos_by_user.user_id = users.id
        );
  
#Identify users (potential bots) who have liked every single photo on the site, as this is not typically possible for a normal user.

SELECT users.id,username, COUNT(likes.user_id) As likes_by_user
FROM users
JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING likes_by_user = (SELECT COUNT(*) FROM photos);

# username with most followers
 SELECT followee_id, COUNT(follower_id) as followers_count
 FROM follows
 GROUP BY followee_id;

# find users who have made no comments

SELECT 
    users.id, users.username
FROM
    users
        LEFT JOIN
    comments ON users.id = comments.user_id
WHERE
    comments.user_id IS NULL;


SELECT 
     users.username, users.id
FROM    
     users
         LEFT JOIN photos
	ON users.id = photos.user_id 
WHERE 
     photos.user_id IS NULL
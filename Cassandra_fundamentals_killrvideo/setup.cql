-- ======================
-- Cassandra Fundamentals Tutorial (Killrvideo)
-- ======================

-- 1. Drop Keyspace Killrvideo if it exists
DROP KEYSPACE IF EXISTS killrvideo;

-- 2. Create KEYSPACE Killrvideo
CREATE KEYSPACE killrvideo WITH REPLICATION = {
    'class': 'NetworkTopologyStrategy',
    'DC1': 3  -- Replication for each of the 3 nodes
};

-- 3. Create Tables

-- 3.1 - user_by_email
CREATE TABLE killrvideo.user_by_email(
    userid UUID,
    email TEXT,
    password UUID,
    PRIMARY KEY((email))
);

-- 3.2 - users
CREATE TABLE killrvideo.users(
    userid UUID,
    firstname TEXT,
    lastname TEXT,
    email TEXT,
    created_date TIMESTAMP,
    PRIMARY KEY((userid))
);

-- 3.3 - videos_by_user
CREATE TABLE killrvideo.videos_by_user(
    userid UUID,
    videoid UUID,
    video_name TEXT,
    image_prev TEXT,
    added_date TIMESTAMP,
    PRIMARY KEY ((userid), added_date, videoid)
) WITH CLUSTERING ORDER BY (added_date DESC, videoid ASC);

-- 3.4 - ratings_by_user
CREATE TABLE killrvideo.ratings_by_user(
    userid UUID,
    videoid UUID,
    video_name TEXT,
    image_prev TEXT,
    rating SMALLINT,
    rated_date TIMESTAMP,
    PRIMARY KEY ((userid), rated_date, videoid)
) WITH CLUSTERING ORDER BY (rated_date DESC, videoid ASC);

-- 3.5 - comments_by_user
CREATE TABLE killrvideo.comments_by_user(
    userid UUID,
    videoid UUID,
    commentid UUID,
    comment TEXT,
    comment_ts TIMESTAMP,
    PRIMARY KEY ((userid), comment_ts, commentid)
) WITH CLUSTERING ORDER BY (comment_ts DESC, commentid ASC);

-- 3.6 - videos_by_tag
CREATE TABLE killrvideo.videos_by_tag(
    videoid UUID,
    userid UUID,
    video_name TEXT,
    image_prev TEXT,
    added_date TIMESTAMP,
    tag TEXT,
    PRIMARY KEY ((tag), added_date, videoid)
) WITH CLUSTERING ORDER BY (added_date DESC, videoid ASC);

-- 3.7 - latest_videos
CREATE TABLE killrvideo.latest_videos(
    videoid UUID,
    added_date TIMESTAMP,
    userid UUID,
    video_name TEXT,
    image_prev TEXT,
    PRIMARY KEY ((videoid), added_date)
) WITH CLUSTERING ORDER BY (added_date DESC);

-- 3.8 - videos
CREATE TABLE killrvideo.videos(
    videoid UUID,
    userid UUID,
    video_name TEXT,
    image_prev TEXT,
    added_date TIMESTAMP,
    tags SET<TEXT>,
    location TEXT,
    description TEXT,
    PRIMARY KEY ((videoid))
);

-- 3.9 - comments_by_video
CREATE TABLE killrvideo.comments_by_video(
    videoid UUID,
    userid UUID,
    commentid UUID,
    comment TEXT,
    PRIMARY KEY ((videoid))
);

-- 3.10 - ratings_by_video
CREATE TABLE killrvideo.ratings_by_video(
    userid UUID,
    videoid UUID,
    video_name TEXT,
    image_prev TEXT,
    rating SMALLINT,
    rated_date TIMESTAMP,
    added_date TIMESTAMP,
    PRIMARY KEY ((videoid), rated_date, rating)
) WITH CLUSTERING ORDER BY (rated_date DESC, rating ASC);

-- 4. Test values insertion

-- 4.1 - user_by_email

INSERT INTO killrvideo.user_by_email (userid,  email, password)
VALUES (d0f60aa8-54a9-4840-b70c-fe562b68842b,'bobesponja@usp.br',5f4dcc3b-5aa7-65d6-1d83-27deb882cf99);

INSERT INTO killrvideo.user_by_email (userid,  email, password)
VALUES (522b1fe2-2e36-4cef-a667-cd4237d08b89,'estrella@usp.br',6cb75f65-2a9b-5279-8eb6-cf2201057c73);

INSERT INTO killrvideo.user_by_email (userid,  email, password)
VALUES (9761d3d7-7fbd-4269-9988-6cfd4e188678,'calamardo@datastax.com',ba27e03f-d95e-507d-af29-37c937d499ab);

-- 4.2 - users

INSERT INTO killrvideo.users (userid, firstname, lastname, email, created_date)
VALUES (d0f60aa8-54a9-4840-b70c-fe562b68842b,'Bob','Esponja', 'bobesponja@usp.br','2011-06-01 08:00:00');

INSERT INTO killrvideo.users (userid, firstname, lastname, email, created_date)
VALUES (522b1fe2-2e36-4cef-a667-cd4237d08b89,'Patricio','Estrella', 'estrella@usp.br','2011-06-20 13:50:00');

INSERT INTO killrvideo.users (userid, firstname, lastname, email, created_date)
VALUES (9761d3d7-7fbd-4269-9988-6cfd4e188678,'Calamardo','Tentáculos', 'calamardo@usp.br','2011-06-20 13:50:00');

-- 4.3 -- videos_by_user

INSERT INTO killrvideo.videos_by_user (userid, videoid, added_date, video_name, image_prev)
VALUES (d0f60aa8-54a9-4840-b70c-fe562b68842b,99051fe9-6a9c-46c2-b949-38ef78858dd0,'2012-06-01 08:00:00','My funny cat','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.videos_by_user (userid, videoid, added_date, video_name, image_prev)
VALUES (d0f60aa8-54a9-4840-b70c-fe562b68842b,b3a76c6b-7c7f-4af6-964f-803a9283c401,'2012-08-30 16:50:00','Now my dog plays piano!','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.videos_by_user (userid, videoid, added_date, video_name, image_prev)
VALUES (522b1fe2-2e36-4cef-a667-cd4237d08b89,0c3f7e87-f6b6-41d2-9668-2b64d117102c,'2013-05-02 12:30:29','An Introduction to Database Systems','/us/vid/0c/0c3f7e87-f6b6-41d2-9668-2b64d117102c');

INSERT INTO killrvideo.videos_by_user (userid, videoid, added_date, video_name, image_prev)
VALUES (522b1fe2-2e36-4cef-a667-cd4237d08b89,416a5ddc-00a5-49ed-adde-d99da9a27c0c,'2012-12-01 11:29:00','Intro to CAP theorem','/us/vid/41/416a5ddc-00a5-49ed-adde-d99da9a27c0c');

INSERT INTO killrvideo.videos_by_user (userid, videoid, added_date, video_name, image_prev)
VALUES (9761d3d7-7fbd-4269-9988-6cfd4e188678,06049cbb-dfed-421f-b889-5f649a0de1ed,'2013-05-02 12:30:29','The data model is dead. Long live the data model.','http://www.youtube.com/watch?v=px6U2n74q3g');

INSERT INTO killrvideo.videos_by_user (userid, videoid, added_date, video_name, image_prev)
VALUES (9761d3d7-7fbd-4269-9988-6cfd4e188678,873ff430-9c23-4e60-be5f-278ea2bb21bd,'2013-05-16 16:50:00','Become a Super Modeler','http://www.youtube.com/watch?v=qphhxujn5Es');

INSERT INTO killrvideo.videos_by_user (userid, videoid, added_date, video_name, image_prev)
VALUES (9761d3d7-7fbd-4269-9988-6cfd4e188678,49f64d40-7d89-4890-b910-dbf923563a33,'2013-06-11 11:00:00','The World''s Next Top Data Model','http://www.youtube.com/watch?v=HdJlsOZVGwM');

-- 4.4 -- ratings_by_user

INSERT INTO killrvideo.ratings_by_user (userid, videoid, video_name, image_prev, rating, rated_date)
VALUES (9761d3d7-7fbd-4269-9988-6cfd4e188678, 99051fe9-6a9c-46c2-b949-38ef78858dd0, 'My funny cat', '/us/vid/cat.png', 3, '2013-06-01 10:00:00');

INSERT INTO killrvideo.ratings_by_user (userid, videoid, video_name, image_prev, rating, rated_date)
VALUES (9761d3d7-7fbd-4269-9988-6cfd4e188678, b3a76c6b-7c7f-4af6-964f-803a9283c401, 'Now my dog plays piano!', '/us/vid/dog.png', 5, '2013-06-02 11:15:00');

INSERT INTO killrvideo.ratings_by_user (userid, videoid, video_name, image_prev, rating, rated_date)
VALUES (9761d3d7-7fbd-4269-9988-6cfd4e188678, 0c3f7e87-f6b6-41d2-9668-2b64d117102c, 'An Introduction to Database Systems', '/us/vid/db.png', 4, '2013-06-03 14:30:00');

-- 4.5 -- comments_by_user

INSERT INTO killrvideo.comments_by_user (userid, videoid, comment, commentid, comment_ts) VALUES (d0f60aa8-54a9-4840-b70c-fe562b68842b, b3a76c6b-7c7f-4af6-964f-803a9283c401, 'VERY Helpful thanks!!', d6177351-f97e-11ed-b9cb-07c3a76482fb, '2012-08-30 18:10:00');
INSERT INTO killrvideo.comments_by_user (userid, videoid, comment, commentid, comment_ts) VALUES (d0f60aa8-54a9-4840-b70c-fe562b68842b, 99051fe9-6a9c-46c2-b949-38ef78858dd0, 'I am always follow your channel and watch later in YT.',d6177350-f97e-11ed-b9cb-07c3a76482fb, '2012-06-03 09:35:00');

INSERT INTO killrvideo.comments_by_user (userid, videoid, comment, commentid, comment_ts) VALUES (522b1fe2-2e36-4cef-a667-cd4237d08b89, 0c3f7e87-f6b6-41d2-9668-2b64d117102c, 'It is amazing',d618d2e1-f97e-11ed-b9cb-07c3a76482fb, '2013-05-02 12:45:29');
INSERT INTO killrvideo.comments_by_user (userid, videoid, comment, commentid, comment_ts) VALUES (522b1fe2-2e36-4cef-a667-cd4237d08b89, 06049cbb-dfed-421f-b889-5f649a0de1ed, 'let me cover it when i get a break',d618d2e0-f97e-11ed-b9cb-07c3a76482fb, '2013-05-05 19:55:29');

-- 4.6 -- videos_by_tag

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('cats',99051fe9-6a9c-46c2-b949-38ef78858dd0, 6b2a4f1a-8c3d-492a-b7e1-8f5c3a6b9d4e, '2012-06-01 08:00:00','My funny cat','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('piano',99051fe9-6a9c-46c2-b949-38ef78858dd0, a1e8f3c7-9520-4b6d-a3f8-2c7e1b9d4a6f, '2012-05-25 08:30:29','My funny cat','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('lol',99051fe9-6a9c-46c2-b949-38ef78858dd0, f4b9c2a8-3d71-4e0a-b582-9f6c3a1b7e4d, '2012-05-25 08:30:29','My funny cat','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('dogs',b3a76c6b-7c7f-4af6-964f-803a9283c401, 7c1e5f8a-92b0-4c3d-a6f4-1e8b9d3c2a5f, '2012-08-30 16:50:00','Now my dog plays piano!','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('piano',b3a76c6b-7c7f-4af6-964f-803a9283c401, 3a9b7c4d-1e5f-4a2b-b8c3-9d6e2f1a5b8c, '2012-08-30 16:50:00','Now my dog plays piano!','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('lol',b3a76c6b-7c7f-4af6-964f-803a9283c401, c8f2a1b9-4d3e-4f5a-b6c2-7e1b9d4a3f5b, '2012-08-30 16:50:00','Now my dog plays piano!','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('database',0c3f7e87-f6b6-41d2-9668-2b64d117102c, 2e9f4a1b-8c3d-4e5a-b7f2-1c6b9d4a3e5f, '2012-09-03 10:30:00','An Introduction to Database Systems','/us/vid/0c/0c3f7e87-f6b6-41d2-9668-2b64d117102c');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('relational',0c3f7e87-f6b6-41d2-9668-2b64d117102c, 9a3b7c4d-5e1f-4a2b-b6c8-9d2e1f5a4b3c, '2012-09-03 10:30:00','An Introduction to Database Systems','/us/vid/0c/0c3f7e87-f6b6-41d2-9668-2b64d117102c');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('book',0c3f7e87-f6b6-41d2-9668-2b64d117102c, 5f1e8a9b-2c3d-4e4a-b5f7-2c1b9d4a3e6f, '2012-09-03 10:30:00','An Introduction to Database Systems','/us/vid/0c/0c3f7e87-f6b6-41d2-9668-2b64d117102c');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('database',416a5ddc-00a5-49ed-adde-d99da9a27c0c, b3c7a1d9-4e5f-4a2b-b8c4-1e9d2f5a3b6c, '2012-12-01 11:29:00','Intro to CAP theorem','/us/vid/41/416a5ddc-00a5-49ed-adde-d99da9a27c0c');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('cap',416a5ddc-00a5-49ed-adde-d99da9a27c0c, e4a1b9c2-3d7e-4f5a-b6c8-2f1a9d4e3b5c, '2012-12-01 11:29:00','Intro to CAP theorem','/us/vid/41/416a5ddc-00a5-49ed-adde-d99da9a27c0c');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('brewer',416a5ddc-00a5-49ed-adde-d99da9a27c0c, 8c2d4e1f-9a3b-4c5d-a6f8-1b9d4a3e2f5c, '2012-12-01 11:29:00','Intro to CAP theorem','/us/vid/41/416a5ddc-00a5-49ed-adde-d99da9a27c0c');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('cassandra',06049cbb-dfed-421f-b889-5f649a0de1ed, d1f5a9b3-2c4d-4e6a-b7f8-3e1b9d4a2c5f, '2013-05-02 12:30:29','The data model is dead. Long live the data model.','http://www.youtube.com/watch?v=px6U2n74q3g');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('data model',06049cbb-dfed-421f-b889-5f649a0de1ed, 4a2b8c3d-7e1f-4a5b-b6c9-2f1e9d4a3b5c, '2013-05-02 12:30:29','The data model is dead. Long live the data model.','http://www.youtube.com/watch?v=px6U2n74q3g');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('relational',06049cbb-dfed-421f-b889-5f649a0de1ed, f7c1e5a9-3b2d-4c4e-a6f8-9b3d2a5f1e4c, '2013-05-02 12:30:29','The data model is dead. Long live the data model.','http://www.youtube.com/watch?v=px6U2n74q3g');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('instruction',06049cbb-dfed-421f-b889-5f649a0de1ed, 1a9b3c7d-5e4f-4a2b-b6c8-2d1e5f4a3b9c, '2013-05-02 12:30:29','The data model is dead. Long live the data model.','http://www.youtube.com/watch?v=px6U2n74q3g');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('cassandra',873ff430-9c23-4e60-be5f-278ea2bb21bd, a6f2b1c9-4d3e-4f5a-b7c8-1e9b4d3a2f5c, '2013-05-16 16:50:00','Become a Super Modeler','http://www.youtube.com/watch?v=qphhxujn5Es');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('data model',873ff430-9c23-4e60-be5f-278ea2bb21bd, 3e5f1a9b-2c4d-4e3a-b6f7-8d2c1b4a9e5f, '2013-05-16 16:50:00','Become a Super Modeler','http://www.youtube.com/watch?v=qphhxujn5Es');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('relational',873ff430-9c23-4e60-be5f-278ea2bb21bd, 9c4d2a8b-7e1f-4a5b-b6c3-1f9e8d4a2b7c, '2013-05-16 16:50:00','Become a Super Modeler','http://www.youtube.com/watch?v=qphhxujn5Es');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('instruction',873ff430-9c23-4e60-be5f-278ea2bb21bd, d5f1e9a3-2b4c-4e6a-b7f8-4c2b1d9a3e5f, '2013-05-16 16:50:00','Become a Super Modeler','http://www.youtube.com/watch?v=qphhxujn5Es');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('cassandra',49f64d40-7d89-4890-b910-dbf923563a33, 7e1f5a9b-3c2d-4e4a-b6f8-3d2c1b9a5e4f, '2013-06-11 11:00:00','The World''s Next Top Data Model','http://www.youtube.com/watch?v=HdJlsOZVGwM');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('data model',49f64d40-7d89-4890-b910-dbf923563a33, c3d7a1b9-5e4f-4a2b-b8c6-1d9e2f5a4b3c, '2013-06-11 11:00:00','The World''s Next Top Data Model','http://www.youtube.com/watch?v=HdJlsOZVGwM');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('examples',49f64d40-7d89-4890-b910-dbf923563a33, 4f1e9a3b-2c5d-4e6a-b7f8-2b1c9d4a3e5f, '2013-06-11 11:00:00','The World''s Next Top Data Model','http://www.youtube.com/watch?v=HdJlsOZVGwM');

INSERT INTO killrvideo.videos_by_tag (tag, videoid, userid, added_date, video_name, image_prev)
VALUES ('instruction',49f64d40-7d89-4890-b910-dbf923563a33, a9b3c7d1-4e5f-4a2b-b6c8-5f1e9d4a3b2c, '2013-06-11 11:00:00','The World''s Next Top Data Model','http://www.youtube.com/watch?v=HdJlsOZVGwM');

-- 4.7 - latest_videos

INSERT INTO killrvideo.latest_videos (videoid, added_date, userid, video_name, image_prev)
VALUES (99051fe9-6a9c-46c2-b949-38ef78858dd0,'2012-06-01 08:00:00', 6b2a4f1a-8c3d-492a-b7e1-8f5c3a6b9d4e, 'My funny cat','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.latest_videos (videoid, added_date, userid, video_name, image_prev)
VALUES (b3a76c6b-7c7f-4af6-964f-803a9283c401,'2012-08-30 16:50:00', a1e8f3c7-9520-4b6d-a3f8-2c7e1b9d4a6f, 'Now my dog plays piano!','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401');

INSERT INTO killrvideo.latest_videos (videoid, added_date, userid, video_name, image_prev)
VALUES (0c3f7e87-f6b6-41d2-9668-2b64d117102c,'2013-05-02 12:30:29', f4b9c2a8-3d71-4e0a-b582-9f6c3a1b7e4d, 'An Introduction to Database Systems','/us/vid/0c/0c3f7e87-f6b6-41d2-9668-2b64d117102c');

INSERT INTO killrvideo.latest_videos (videoid, added_date, userid, video_name, image_prev)
VALUES (416a5ddc-00a5-49ed-adde-d99da9a27c0c,'2012-12-01 11:29:00', 7c1e5f8a-92b0-4c3d-a6f4-1e8b9d3c2a5f, 'Intro to CAP theorem','/us/vid/41/416a5ddc-00a5-49ed-adde-d99da9a27c0c');

INSERT INTO killrvideo.latest_videos (videoid, added_date, userid, video_name, image_prev)
VALUES (06049cbb-dfed-421f-b889-5f649a0de1ed,'2013-05-02 12:30:29', 3a9b7c4d-1e5f-4a2b-b8c3-9d6e2f1a5b8c, 'The data model is dead. Long live the data model.','http://www.youtube.com/watch?v=px6U2n74q3g');

INSERT INTO killrvideo.latest_videos (videoid, added_date, userid, video_name, image_prev)
VALUES (873ff430-9c23-4e60-be5f-278ea2bb21bd,'2013-05-16 16:50:00', c8f2a1b9-4d3e-4f5a-b6c2-7e1b9d4a3f5b, 'Become a Super Modeler','http://www.youtube.com/watch?v=qphhxujn5Es');

INSERT INTO killrvideo.latest_videos (videoid, added_date, userid, video_name, image_prev)
VALUES (49f64d40-7d89-4890-b910-dbf923563a33,'2013-06-11 11:00:00', 2e9f4a1b-8c3d-4e5a-b7f2-1c6b9d4a3e5f, 'The World''s Next Top Data Model','http://www.youtube.com/watch?v=HdJlsOZVGwM');

-- 4.8 - Videos

INSERT INTO killrvideo.videos (videoid, video_name, userid, description, location, image_prev, tags, added_date)
VALUES (99051fe9-6a9c-46c2-b949-38ef78858dd0,'My funny cat',d0f60aa8-54a9-4840-b70c-fe562b68842b,'My cat likes to play the piano! So funny.','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401',{'cats','piano','lol'},'2012-06-01 08:00:00');

INSERT INTO killrvideo.videos (videoid, video_name, userid, description, location, image_prev, tags, added_date)
VALUES (b3a76c6b-7c7f-4af6-964f-803a9283c401,'Now my dog plays piano!',d0f60aa8-54a9-4840-b70c-fe562b68842b, 'My dog learned to play the piano because of the cat.','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401','/us/vid/b3/b3a76c6b-7c7f-4af6-964f-803a9283c401',{'dogs','piano','lol'},'2012-08-30 16:50:00');

INSERT INTO killrvideo.videos (videoid, video_name, userid, description, location, image_prev, tags, added_date)
VALUES (0c3f7e87-f6b6-41d2-9668-2b64d117102c,'An Introduction to Database Systems',522b1fe2-2e36-4cef-a667-cd4237d08b89,'An overview of my book','/us/vid/0c/0c3f7e87-f6b6-41d2-9668-2b64d117102c','/us/vid/0c/0c3f7e87-f6b6-41d2-9668-2b64d117102c',{'database','relational','book'},'2012-09-03 10:30:00');

INSERT INTO killrvideo.videos (videoid, video_name, userid, description, location, image_prev, tags, added_date)
VALUES (416a5ddc-00a5-49ed-adde-d99da9a27c0c,'Intro to CAP theorem',522b1fe2-2e36-4cef-a667-cd4237d08b89, 'I think there might be something to this.','/us/vid/41/416a5ddc-00a5-49ed-adde-d99da9a27c0c','/us/vid/41/416a5ddc-00a5-49ed-adde-d99da9a27c0c',{'database','cap','brewer'},'2012-12-01 11:29:00');

INSERT INTO killrvideo.videos (videoid, video_name, userid, description, location, image_prev, tags, added_date)
VALUES (06049cbb-dfed-421f-b889-5f649a0de1ed,'The data model is dead. Long live the data model.',9761d3d7-7fbd-4269-9988-6cfd4e188678, 'First in a three part series for Cassandra Data Modeling','http://www.youtube.com/watch?v=px6U2n74q3g','http://www.youtube.com/watch?v=px6U2n74q3g',{'cassandra','data model','relational','instruction'},'2013-05-02 12:30:29');

INSERT INTO killrvideo.videos (videoid, video_name, userid, description, location, image_prev, tags, added_date)
VALUES (873ff430-9c23-4e60-be5f-278ea2bb21bd,'Become a Super Modeler',9761d3d7-7fbd-4269-9988-6cfd4e188678, 'Second in a three part series for Cassandra Data Modeling','http://www.youtube.com/watch?v=qphhxujn5Es','http://www.youtube.com/watch?v=qphhxujn5Es',{'cassandra','data model','cql','instruction'},'2013-05-16 16:50:00');

INSERT INTO killrvideo.videos (videoid, video_name, userid, description, location, image_prev, tags, added_date)
VALUES (49f64d40-7d89-4890-b910-dbf923563a33,'The World''s Next Top Data Model',9761d3d7-7fbd-4269-9988-6cfd4e188678, 'Third in a three part series for Cassandra Data Modeling','http://www.youtube.com/watch?v=HdJlsOZVGwM','http://www.youtube.com/watch?v=HdJlsOZVGwM',{'cassandra','data model','examples','instruction'},'2013-06-11 11:00:00');

-- 4.9 - comments_by_video

INSERT INTO killrvideo.comments_by_video (videoid, userid, commentid, comment)
VALUES (99051fe9-6a9c-46c2-b949-38ef78858dd0,d0f60aa8-54a9-4840-b70c-fe562b68842b,now(), 'VERY Helpful thanks!!');

INSERT INTO killrvideo.comments_by_video (videoid, userid, commentid, comment)
VALUES (99051fe9-6a9c-46c2-b949-38ef78858dd0,d0f60aa8-54a9-4840-b70c-fe562b68842b,now(), 'I am always follow your channel and watch later in YT.');

INSERT INTO killrvideo.comments_by_video (videoid, userid, commentid, comment)
VALUES (99051fe9-6a9c-46c2-b949-38ef78858dd0,522b1fe2-2e36-4cef-a667-cd4237d08b89,now(), 'let me cover it when i get a break');

INSERT INTO killrvideo.comments_by_video (videoid, userid, commentid, comment)
VALUES (99051fe9-6a9c-46c2-b949-38ef78858dd0,522b1fe2-2e36-4cef-a667-cd4237d08b89,now(), 'It is amazing');

-- 4.10 - ratings_by_video

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (6b2a4f1a-8c3d-492a-b7e1-8f5c3a6b9d4e, a1e8f3c7-9520-4b6d-a3f8-2c7e1b9d4a6f, 'Tutorial de Cassandra Basico', 'https://images.com/prev1.png', 5, '2015-04-12 14:22:00', '2015-04-12 14:00:00');

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (f4b9c2a8-3d71-4e0a-b582-9f6c3a1b7e4d, 7c1e5f8a-92b0-4c3d-a6f4-1e8b9d3c2a5f, 'Modelagem de Dados Avancada', 'https://images.com/prev2.png', 4, '2017-08-24 09:15:30', '2017-08-23 18:30:00');

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (3a9b7c4d-1e5f-4a2b-b8c3-9d6e2f1a5b8c, c8f2a1b9-4d3e-4f5a-b6c2-7e1b9d4a3f5b, 'Entendendo Arquitetura Distribuida', 'https://images.com/prev3.png', 5, '2019-11-03 21:45:12', '2019-11-01 10:00:00');

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (2e9f4a1b-8c3d-4e5a-b7f2-1c6b9d4a3e5f, 9a3b7c4d-5e1f-4a2b-b6c8-9d2e1f5a4b3c, 'Como funciona o Gossip Protocol', 'https://images.com/prev4.png', 3, '2020-05-18 16:20:00', '2020-05-18 15:00:00');

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (5f1e8a9b-2c3d-4e4a-b5f7-2c1b9d4a3e6f, b3c7a1d9-4e5f-4a2b-b8c4-1e9d2f5a3b6c, 'Cassandra vs SQL Tradicional', 'https://images.com/prev5.png', 4, '2021-01-30 11:05:45', '2021-01-28 09:00:00');

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (e4a1b9c2-3d7e-4f5a-b6c8-2f1a9d4e3b5c, 8c2d4e1f-9a3b-4c5d-a6f8-1b9d4a3e2f5c, 'Configurando Cluster com Docker', 'https://images.com/prev6.png', 5, '2022-07-14 23:50:00', '2022-07-14 22:15:00');

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (d1f5a9b3-2c4d-4e6a-b7f8-3e1b9d4a2c5f, 4a2b8c3d-7e1f-4a5b-b6c9-2f1e9d4a3b5c, 'Estrategias de Replicacao', 'https://images.com/prev7.png', 2, '2023-10-09 13:10:22', '2023-10-05 14:00:00');

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (f7c1e5a9-3b2d-4c4e-a6f8-9b3d2a5f1e4c, 1a9b3c7d-5e4f-4a2b-b6c8-2d1e5f4a3b9c, 'O que sao LSM Trees', 'https://images.com/prev8.png', 5, '2024-03-22 18:02:10', '2024-03-20 11:30:00');

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (a6f2b1c9-4d3e-4f5a-b7c8-1e9b4d3a2f5c, 3e5f1a9b-2c4d-4e3a-b6f7-8d2c1b4a9e5f, 'Performance e Heap Size', 'https://images.com/prev9.png', 4, '2025-06-05 08:40:00', '2025-06-01 09:00:00');

INSERT INTO killrvideo.ratings_by_video (videoid, userid, video_name, image_prev, rating, rated_date, added_date)
VALUES (9c4d2a8b-7e1f-4a5b-b6c3-1f9e8d4a2b7c, d5f1e9a3-2b4c-4e6a-b7f8-4c2b1d9a3e5f, 'Criando Queries Otimizadas em CQL', 'https://images.com/prev10.png', 5, '2026-02-17 10:30:15', '2026-02-15 16:45:00');
create database Election;
create TABLE hashtag (name CHARACTER VARYING(30) PRIMARY KEY NOT NULL);
create TABLE tweet (
id INT PRIMARY KEY NOT NULL,
text CHARACTER VARYING(160) NOT NULL,
handle CHARACTER VARYING(30),
retweetCount INT,
favoriteCount INT,
time timestamp);
create TABLE contains (
id INT NOT NULL,
name CHARACTER VARYING(30) NOT NULL,
PRIMARY KEY(name,id));

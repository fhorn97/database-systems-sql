CREATE TABLE Users(
user_id int NOT NULL UNIQUE,
first_name varchar(200) NOT NULL,
last_name varchar(200) NOT NULL,
email varchar(200) NOT NULL,
dob DATE NOT NULL,
hometown varchar(200),
gender char(1) enum('m','f'),
password varchar(200) NOT NULL,
PRIMARY KEY (user_id)
);


CREATE TABLE Friends(
requesterId int NOT NULL UNIQUE, 
recipientId int NOT NULL UNIQUE, 
status enum('0', '1') NOT NULL, 
PRIMARY KEY (requesterId, recipientId), 
FOREIGN KEY (requesterId) REFERENCES Users(user_id),
FOREIGN KEY (recipientId) REFERENCES Users(user_id)
);


CREATE TABLE Albums(
album_id int NOT NULL UNIQUE, 
album_name varchar(200) NOT NULL, 
created_on DATE NOT NULL, 
user_id int NOT NULL UNIQUE, 
PRIMARY KEY (album_id),
FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Photos(
photo_id int NOT NULL UNIQUE,  
caption varchar(200), 
data varchar(200) NOT NULL, 
album_id int NOT NULL UNIQUE, 
PRIMARY KEY (photo_id),
FOREIGN KEY (album_id) REFERENCES Albums(album_id)
);

CREATE TABLE Tags(
tag_word varchar(200) NOT NULL
photo_id int NOT NULL UNIQUE, 
PRIMARY KEY (tag_word),
FOREIGN KEY (photo_id) REFERENCES Photos(photo_id)
);

CREATE TABLE Comments(
comment_id int NOT NULL UNIQUE, 
comment_text varchar(200) NOT NULL, 
comment_date DATE NOT NULL, 
user_id int NOT NULL UNIQUE,
photo_id int NOT NULL UNIQUE, 
PRIMARY KEY (comment_id),
FOREIGN KEY (user_id) REFERENCES Users(user_id),
FOREIGN KEY (photo_id) REFERENCES Photos(photo_id)
);



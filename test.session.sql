-- @block Small Airnb Replica and some Queries fro understanding the Schema

-- @block Creating Users Table
CREATE TABLE Users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    bio TEXT,
    country VARCHAR(3)
);

-- @block Inserting into Users
INSERT INTO Users(email, bio, country)
VALUES
    ('john@example.com', 'Software engineer passionate about building innovative solutions. Coffee lover and amateur guitarist. Based in the USA.', 'USA'),
    ('emily@example.com', 'Marketing professional with a knack for creativity and storytelling. Bookworm and nature enthusiast. Proud Canadian.', 'CAN'),
    ('david@example.com', 'Adventurous traveler exploring the world one city at a time. Food lover and outdoor enthusiast. Proud Aussie!', 'AUS'),
    ('sarah@example.com', 'Tech geek with a passion for coding. Always seeking new challenges. Based in the vibrant city of London, UK.', 'GBR'),
    ('alex@example.com', 'Art enthusiast and photography aficionado. Love capturing moments and expressing creativity. Proud French!', 'FRA'),
    ('lisa@example.com', 'Curious soul with a passion for learning. Writer and aspiring novelist. Embracing life in sunny Barcelona, Spain.', 'ESP'),
    ('tom@example.com', 'Sports fanatic and football lover. Business entrepreneur and dreamer. Enjoying la dolce vita in Rome, Italy.', 'ITA'),
    ('anna@example.com', 'Design enthusiast and architecture admirer. Creative thinker with an eye for aesthetics. Proud German!', 'DEU'),
    ('mike@example.com', 'Anime geek and gaming enthusiast. Web developer by day, gamer by night. Embracing Japanese culture in Tokyo, Japan.', 'JPN'),
    ('laura@example.com', 'Nature lover and beach enthusiast. Happiest when exploring the outdoors. Enjoying the beautiful beaches of Brazil.', 'BRA');


-- @block Creating and index on email for  faster queries
CREATE INDEX email_index ON Users(email);

-- @block Searching for users based on country and email
SELECT email, id, country FROM users
WHERE country = 'BRA'
AND email LIKE '%example%'
ORDER BY id DESC
LIMIT 5

-- @block Creating Rooms table
CREATE TABLE Rooms(
    id INT AUTO_INCREMENT,
    street VARCHAR(255),
    owner_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (owner_id) REFERENCES Users(id)
);

-- @block Inserting into rooms Table
INSERT INTO Rooms(street, owner_id)
VALUES
    ('123 Main St', 1),
    ('456 Elm St', 2),
    ('789 Oak St', 2),
    ('321 Pine St', 3),
    ('654 Maple St', 4),
    ('987 Cedar St', 4),
    ('135 Walnut St', 4),
    ('246 Birch St', 5),
    ('579 Cherry St', 6),
    ('864 Spruce St', 6),
    ('111 Willow St', 6),
    ('222 Oak St', 7),
    ('333 Pine St', 8),
    ('444 Maple St', 8),
    ('555 Cedar St', 8),
    ('666 Walnut St', 8),
    ('777 Birch St', 9),
    ('888 Cherry St', 9),
    ('999 Spruce St', 10),
    ('000 Willow St', 10);

-- @block Checking how many rooms own some of the users
SELECT r.street, r.owner_id, u.email
FROM Rooms AS r
JOIN Users AS u ON r.owner_id = u.id
WHERE r.owner_id BETWEEN 1 AND 5;

-- @block Checking users and their rooms
SELECT 
    Users.id AS  user_id,
    Rooms.id AS rooms_id,
    email,
    street
FROM Users
LEFT JOIN Rooms ON Rooms.owner_id = Users.id
ORDER BY user_id;

-- @block Counting how many rooms each user has
SELECT 
    Users.id AS user_id,
    COUNT(Rooms.id) AS room_count
FROM Users
LEFT JOIN Rooms ON Rooms.owner_id = Users.id
GROUP BY Users.id;

-- @block What is the average number of rooms per user
SELECT 
    AVG(room_count) AS average_room_count
FROM (
    SELECT 
        Users.id AS user_id,
        COUNT(Rooms.id) AS room_count
    FROM Users
    LEFT JOIN Rooms ON Rooms.owner_id = Users.id
    GROUP BY Users.id
) AS subquery;

-- @block Creating Booking Table
CREATE TABLE Bookings(
    id INT AUTO_INCREMENT,
    guest_id INT NOT NUll,
    room_id INT NOT NUll,
    check_in DATETIME,
    PRIMARY KEY(id),
    FOREIGN KEY (guest_id) REFERENCES Users(id),
    FOREIGN KEY (room_id) REFERENCES Rooms(id)
);

-- @block Inserting into bookings
INSERT INTO Bookings (guest_id, room_id, check_in)
VALUES
    (1, 1, '2023-07-17 14:00:00'),
    (1, 3, '2023-07-18 12:00:00'),
    (2, 5, '2023-07-19 15:30:00'),
    (2, 2, '2023-07-20 10:00:00'),
    (3, 4, '2023-07-21 11:45:00'),
    (4, 8, '2023-07-22 09:00:00'),
    (4, 6, '2023-07-23 14:15:00'),
    (5, 7, '2023-07-24 12:30:00'),
    (5, 10, '2023-07-25 16:00:00'),
    (6, 9, '2023-07-26 18:00:00'),
    (7, 12, '2023-07-27 13:00:00');

-- @block Rooms that user 1 has booked
SELECT
    guest_id,
    street,
    check_in
FROM Bookings
INNER JOIN Rooms ON Rooms.owner_id = guest_id
WHERE guest_id = 1;

-- @block Users that stayed in a room of another user
SELECT 
    guest_id,
    room_id,
    email,
    bio
FROM Bookings
INNER JOIN Users ON Users.id = guest_id
WHERE room_id = 5;





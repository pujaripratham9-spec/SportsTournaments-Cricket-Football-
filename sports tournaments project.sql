use V327;
-- DATABASE: SportsTournaments
-- =====================================
CREATE DATABASE IF NOT EXISTS SportsTournaments;
USE SportsTournaments;

-- TABLE 1: Teams

CREATE TABLE Teams (
    TeamID INT PRIMARY KEY AUTO_INCREMENT,
    TeamName VARCHAR(50) NOT NULL,
    Country VARCHAR(50),
    FoundedYear INT
);

INSERT INTO Teams (TeamName, Country, FoundedYear) VALUES
('Mumbai Indians', 'India', 2008),
('Chennai Super Kings', 'India', 2008),
('Manchester United', 'England', 1878),
('Liverpool FC', 'England', 1892),
('FC Barcelona', 'Spain', 1899),
('Real Madrid', 'Spain', 1902);


-- TABLE 2: Players

CREATE TABLE Players (
    PlayerID INT PRIMARY KEY AUTO_INCREMENT,
    PlayerName VARCHAR(50) NOT NULL,
    TeamID INT,
    Sport VARCHAR(20),
    Position VARCHAR(30),
    Age INT,
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);

INSERT INTO Players (PlayerName, TeamID, Sport, Position, Age) VALUES
('Rohit Sharma', 1, 'Cricket', 'Batsman', 36),
('MS Dhoni', 2, 'Cricket', 'Wicketkeeper', 42),
('Cristiano Ronaldo', 3, 'Football', 'Forward', 38),
('Mohamed Salah', 4, 'Football', 'Forward', 31),
('Lionel Messi', 5, 'Football', 'Forward', 36),
('Karim Benzema', 6, 'Football', 'Forward', 35);


-- TABLE 3: Matches

CREATE TABLE Matches (
    MatchID INT PRIMARY KEY AUTO_INCREMENT,
    MatchDate DATE,
    TeamAID INT,
    TeamBID INT,
    Sport VARCHAR(20),
    Venue VARCHAR(50),
    ScoreA VARCHAR(20),
    ScoreB VARCHAR(20),
    FOREIGN KEY (TeamAID) REFERENCES Teams(TeamID),
    FOREIGN KEY (TeamBID) REFERENCES Teams(TeamID)
);

INSERT INTO Matches (MatchDate, TeamAID, TeamBID, Sport, Venue, ScoreA, ScoreB) VALUES
('2025-09-01', 1, 2, 'Cricket', 'Wankhede Stadium', '180/4', '175/6'),
('2025-09-02', 3, 4, 'Football', 'Old Trafford', '2', '1'),
('2025-09-03', 5, 6, 'Football', 'Camp Nou', '3', '2');


-- TABLE 4: Tournaments

CREATE TABLE Tournaments (
    TournamentID INT PRIMARY KEY AUTO_INCREMENT,
    TournamentName VARCHAR(50),
    Sport VARCHAR(20),
    StartDate DATE,
    EndDate DATE,
    WinnerTeamID INT,
    FOREIGN KEY (WinnerTeamID) REFERENCES Teams(TeamID)
);

INSERT INTO Tournaments (TournamentName, Sport, StartDate, EndDate, WinnerTeamID) VALUES
('IPL 2025', 'Cricket', '2025-03-15', '2025-05-30', 1),
('Premier League 2025', 'Football', '2025-08-01', '2026-05-15', 4),
('La Liga 2025', 'Football', '2025-08-15', '2026-05-20', 5);

-- 1] Show all teams
SELECT * FROM Teams;

-- 2] Show all players
SELECT * FROM Players;

-- 3] Show all matches
SELECT * FROM Matches;

-- 4] Show all tournaments
SELECT * FROM Tournaments;

-- 5] List all cricket players
SELECT PlayerName FROM Players WHERE Sport='Cricket';

-- 6] List all football players older than 35
SELECT PlayerName, Age FROM Players WHERE Sport='Football' AND Age > 35;

-- 7] Count total teams
SELECT COUNT(*) AS TotalTeams FROM Teams;

-- 8] Count total players in each sport
SELECT Sport, COUNT(*) AS TotalPlayers FROM Players GROUP BY Sport;

-- 9] Show all matches played in “Old Trafford”
SELECT * FROM Matches WHERE Venue='Old Trafford';

-- 10] List matches along with team names
SELECT m.MatchID, t1.TeamName AS TeamA, t2.TeamName AS TeamB, m.ScoreA, m.ScoreB
FROM Matches m
JOIN Teams t1 ON m.TeamAID = t1.TeamID
JOIN Teams t2 ON m.TeamBID = t2.TeamID;

-- 11] Show players and their team names 
SELECT p.PlayerName, t.TeamName
FROM Players p
JOIN Teams t ON p.TeamID = t.TeamID;

-- 12] Find the winner of IPL 2025
SELECT t.TeamName
FROM Tournaments tr
JOIN Teams t ON tr.WinnerTeamID = t.TeamID
WHERE tr.TournamentName='IPL 2025';

-- 13] List tournaments that started after 2025-01-01
SELECT * FROM Tournaments WHERE StartDate > '2025-01-01';

-- 14] Show average age of players in each team
SELECT t.TeamName, AVG(p.Age) AS AvgAge
FROM Players p
JOIN Teams t ON p.TeamID = t.TeamID
GROUP BY t.TeamName;

-- 15] List matches where TeamA scored more than TeamB
SELECT m.MatchID, t1.TeamName AS TeamA, t2.TeamName AS TeamB, m.ScoreA, m.ScoreB FROM Matches m
JOIN Teams t1 ON m.TeamAID = t1.TeamID
JOIN Teams t2 ON m.TeamBID = t2.TeamID
WHERE CAST(SUBSTRING_INDEX(m.ScoreA,'/',1) AS UNSIGNED) > CAST(SUBSTRING_INDEX(m.ScoreB,'/',1) AS UNSIGNED);

-- 16] List all players from Indian teams
SELECT p.PlayerName, t.TeamName
FROM Players p
JOIN Teams t ON p.TeamID = t.TeamID
WHERE t.Country='India';

-- 17] List all forwards in football teams
SELECT p.PlayerName, t.TeamName
FROM Players p
JOIN Teams t ON p.TeamID = t.TeamID
WHERE p.Sport='Football' AND p.Position='Forward';

-- 18] List football forwards
SELECT PlayerName, TeamID FROM Players WHERE Sport='Football' AND Position='Forward';

-- 19] Show all matches in September 2025
SELECT * FROM Matches WHERE MONTH(MatchDate)=9 AND YEAR(MatchDate)=2025;

-- 20] Count matches per sport
SELECT Sport, COUNT(*) AS TotalMatches FROM Matches GROUP BY Sport;

-- 21] List teams and total players in each
SELECT t.TeamName, COUNT(p.PlayerID) AS TotalPlayers FROM Teams t
LEFT JOIN Players p ON t.TeamID = p.TeamID GROUP BY t.TeamName;

-- 22] Show matches with their tournament name
SELECT m.MatchID, m.MatchDate, t.TeamName AS TeamA, t2.TeamName AS TeamB, tr.TournamentName
FROM Matches m
JOIN Teams t ON m.TeamAID = t.TeamID
JOIN Teams t2 ON m.TeamBID = t2.TeamID
JOIN Tournaments tr ON tr.Sport = m.Sport;

-- 23] List tournaments won by Indian teams
SELECT tr.TournamentName, t.TeamName
FROM Tournaments tr
JOIN Teams t ON tr.WinnerTeamID = t.TeamID
WHERE t.Country='India';

-- 24] List players grouped by sport with their count
SELECT Sport, COUNT(*) AS TotalPlayers
FROM Players
GROUP BY Sport;

-- 25] List players along with their team and sport
SELECT p.PlayerName, t.TeamName, p.Sport
FROM Players p
JOIN Teams t ON p.TeamID = t.TeamID;

-- 26] Find all players not assigned to any team
SELECT * FROM Players WHERE TeamID IS NULL;

-- 27] List all teams along with the number of matches they played
SELECT t.TeamName, COUNT(m.MatchID) AS TotalMatches
FROM Teams t
LEFT JOIN Matches m ON t.TeamID = m.TeamAID OR t.TeamID = m.TeamBID
GROUP BY t.TeamName;

-- 28] Add a new player
INSERT INTO Players (PlayerName, TeamID, Sport, Position, Age)
VALUES ('Virat Kohli', 1, 'Cricket', 'Batsman', 35);

-- 29] Show total runs/goals scored by each team in matches
SELECT t.TeamName,SUM(CAST(SUBSTRING_INDEX(m.ScoreA,'/',1) AS UNSIGNED) * (t.TeamID = m.TeamAID) + CAST(SUBSTRING_INDEX(m.ScoreB,'/',1) AS UNSIGNED) * (t.TeamID = m.TeamBID)) AS TotalScore
FROM Teams t
JOIN Matches m ON t.TeamID = m.TeamAID OR t.TeamID = m.TeamBID
GROUP BY t.TeamName;



-- 30] show all tournaments along with winner country
SELECT tr.TournamentName, t.TeamName, t.Country
FROM Tournaments tr
JOIN Teams t ON tr.WinnerTeamID = t.TeamID;



































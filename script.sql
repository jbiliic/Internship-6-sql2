CREATE TABLE States(
	state_id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Towns(
	town_id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	state_id INT REFERENCES States(state_id) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Teams(
	team_id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	state_id INT REFERENCES States(state_id) NOT NULL, 
	contact_number VARCHAR(15),
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Cups(
	cup_id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	town_id INT REFERENCES Towns(town_id),
	started TIMESTAMP NOT NULL,
	is_finished BOOLEAN NOT NULL,
	winner_id INT REFERENCES Teams(team_id),
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TYPE player_position AS ENUM ('gk' ,'cb' ,'lb','rb','cdm','cm','cam','lw','rw','st');
CREATE TABLE Players(
	player_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birth_date TIMESTAMP NOT NULL CHECK(NOW() >= birth_date),
	field_position player_position NOT NULL,
	team_id INT REFERENCES Teams(team_id),
	is_captain BOOLEAN NOT NULL DEFAULT FALSE,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Referees(
	referee_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birth_date TIMESTAMP NOT NULL CHECK(NOW() >= birth_date),
	years_exp INT NOT NULL CHECK(years_exp >= 0),
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);
CREATE TYPE cup_stage AS ENUM ('gr-g1' ,'gr-g2' ,'gr-g3','gr-g4' ,'gr-g5' ,'gr-g6','ro16-g1','qf-g1','sf-g1','ro16-g2','qf-g2','sf-g2','f');
CREATE TABLE CupStage(
	stage_id SERIAL PRIMARY KEY,
	stage cup_stage NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE Games(
	game_id SERIAL PRIMARY KEY,
	cup_id INT  REFERENCES Cups(cup_id) NOT NULL,
	home_team INT  REFERENCES Teams(team_id) NOT NULL,
	away_team INT REFERENCES Teams(team_id) NOT NULL,
	goals_home INT NOT NULL CHECK(goals_home >= 0),
	goals_away INT NOT NULL CHECK(goals_away >= 0),
	winner_id INT REFERENCES Teams(team_id),
	ref_id INT REFERENCES Referees(referee_id),
	game_date TIMESTAMP NOT NULL CHECK(NOW() >= game_date),
	stadium_name VARCHAR(50) NOT NULL,
	cup_stage_id INT REFERENCES CupStage(stage_id) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TYPE event_type AS ENUM ('foul' , 'out' , 'goal-kick' , 'penalty' , 'goal' , 'hand-ball' , 'offside' , 'indirect','corner');
CREATE TABLE GameEvents(
	event_id SERIAL PRIMARY KEY,
	e_type event_type NOT NULL,
	red_card BOOLEAN DEFAULT FALSE,
	yellow_card BOOLEAN DEFAULT FALSE,
	player_id INT REFERENCES Players(player_id) NOT NULL,
	game_id INT REFERENCES Games(game_id) NOT NULL,
	game_min INT NOT NULL CHECK(game_min >= 0),
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TYPE last_stage AS ENUM ('gr','ro16','qf','sf','f','w');
CREATE TABLE CupTeamRel(
	team_id INT REFERENCES Teams(team_id),
	cup_id INT REFERENCES Cups(cup_id),
	PRIMARY KEY(team_id,cup_id),
	num_goals INT NOT NULL CHECK(num_goals >= 0),
	points INT NOT NULL  CHECK(points >= 0),
	stage last_stage NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	updated_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE IF EXISTS GameEvents CASCADE;
DROP TABLE IF EXISTS Games CASCADE;
DROP TABLE IF EXISTS CupTeamRel CASCADE;
DROP TABLE IF EXISTS Players CASCADE;
DROP TABLE IF EXISTS Referees CASCADE;
DROP TABLE IF EXISTS CupStage CASCADE;
DROP TABLE IF EXISTS Cups CASCADE;
DROP TABLE IF EXISTS Teams CASCADE;
DROP TABLE IF EXISTS Towns CASCADE;
DROP TABLE IF EXISTS States CASCADE;

DROP TYPE IF EXISTS player_position CASCADE;
DROP TYPE IF EXISTS event_type CASCADE;
DROP TYPE IF EXISTS cup_stage CASCADE;
DROP TYPE IF EXISTS last_stage CASCADE;


TRUNCATE TABLE 
    GameEvents,
    Games,
    CupTeamRel,
    Players,
    Referees,
    CupStage,
    Cups,
    Teams,
    Towns,
    States
RESTART IDENTITY CASCADE;

ALTER TABLE Cups
DROP COLUMN started;
ALTER TABLE Cups
ADD COLUMN started TIMESTAMP NOT NULL;
ALTER TABLE Games
DROP COLUMN name;


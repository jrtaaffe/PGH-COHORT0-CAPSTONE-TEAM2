-- *************************************************************************************************
-- This script creates all of the database objects (tables, sequences, etc) for the database
-- *************************************************************************************************

BEGIN;

-- CREATE statements go here
DROP TABLE IF EXISTS app_user, user_game, games, user_game_portfolio, transactions;

CREATE TABLE app_user (
  user_id SERIAL NOT NULL,
  user_name varchar(32) NOT NULL UNIQUE,
  email varchar(64) NOT NULL UNIQUE,
  first_name varchar(64) NOT NULL,
  last_name varchar(64) NOT NULL,
  password varchar(32) NOT NULL,
  role varchar(32),
  salt varchar(255) NOT NULL,
  
  constraint pk_app_user primary key (user_id)
);

CREATE TABLE user_game (
	user_id int,
	game_id int,
	
	constraint fk_user_id foreign key (user_id) references app_user (user_id),
	constraint fk_game_id foreign key (game_id) references games (game_id),
	constraint pk_user_game primary key (game_id, user_id)
);

CREATE TABLE games (
	game_id SERIAL,
	name varchar(32) NOT NULL,
	start_date date NOT NULL,
	end_date date NOT NULL,
	admin int NOT NULL,
	
	constraint pk_games primary key (game_id),
	constraint fk_admin foreign key (admin) references app_user (user_id)
);

CREATE TABLE portfolio

COMMIT;
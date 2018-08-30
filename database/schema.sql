-- *************************************************************************************************
-- This script creates all of the database objects (tables, sequences, etc) for the database
-- *************************************************************************************************

BEGIN;

-- CREATE statements go here
DROP TABLE IF EXISTS app_user, user_game, games, transactions, invited_players;

CREATE TABLE app_user (
  --user_id SERIAL NOT NULL,
  user_name varchar(32) NOT NULL UNIQUE,
  email varchar(64) NOT NULL UNIQUE,
  first_name varchar(64) NOT NULL,
  last_name varchar(64) NOT NULL,
  password varchar(32) NOT NULL,
  salt varchar(255) NOT NULL,
  
  constraint pk_app_user primary key (email)
);

CREATE TABLE games (
	game_id SERIAL,
	name varchar(32) NOT NULL,
	start_date date NOT NULL,
	end_date date NOT NULL,
	admin varchar(64) NOT NULL,
	status varchar(32),
	
	constraint pk_games primary key (game_id),
	constraint fk_admin foreign key (admin) references app_user (email)
);

CREATE TABLE user_game (
	portfolio_id SERIAL,
	user_email varchar(64),
	game_id int,
	wallet_value float,
	
	constraint fk_user_id foreign key (user_email) references app_user (email),
	constraint fk_game_id foreign key (game_id) references games (game_id),
	constraint pk_user_game primary key (portfolio_id)
);

CREATE TABLE transactions (
	ticker_symbol varchar(8),
	portfolio_id int,
	quantity int,
	
	constraint pk_game_stocks primary key (ticker_symbol, portfolio_id),
	constraint fk_portfolio foreign key (portfolio_id) references user_game (portfolio_id)
);

CREATE TABLE invited_players (
	game_id int,
	email varchar(64),
	
	constraint pk_invited_players primary key (game_id, email)
);

COMMIT;
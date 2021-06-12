-- User tables for profiles.
-- Contains join date and last seen date.
CREATE TABLE IF NOT EXISTS 'advisor_users' 
(
    steamid64   VARCHAR(17) NOT NULL,
    joined_at   INTEGER NOT NULL,
    last_seen   INTEGER,

    PRIMARY KEY (steamid64)
);

-- Contains a list of known aliases for a user.
CREATE TABLE IF NOT EXISTS 'advisor_user_aliases'
(
    steamid64   VARCHAR(17) NOT NULL,
    aliases     TEXT NOT NULL,

    FOREIGN KEY (steamid64) REFERENCES advisor_users(steamid64)
);

-- Infractions table, contains all player infractions
CREATE TABLE IF NOT EXISTS 'advisor_user_infractions'
(
    id                  BIGINT AUTO_INCREMENT,
    user_steamid64      VARCHAR(17) NOT NULL,
    issuer_steamid64    VARCHAR(17) NOT NULL,
    type                TINYINT NOT NULL,
    reason              TEXT,
    issued_at           INTEGER NOT NULL,
    expires_at          INTEGER,

    PRIMARY KEY (id)
    FOREIGN KEY (user_steamid64) REFERENCES advisor_users(steamid64)
    FOREIGN KEY (issuer_steamid64) REFERENCES advisor_users(steamid64)
);
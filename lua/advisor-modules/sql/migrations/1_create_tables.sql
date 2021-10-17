-- User tables for profiles.
-- Contains join date and last seen date.
CREATE TABLE IF NOT EXISTS advisor_users
(
    steamid64   VARCHAR(17) NOT NULL PRIMARY KEY,
    joined_at   INTEGER NOT NULL,
    last_seen   INTEGER NOT NULL
);

-- Contains a list of known aliases for a user.
CREATE TABLE IF NOT EXISTS advisor_user_aliases
(
    steamid64   VARCHAR(17) NOT NULL,
    aliases     TEXT NOT NULL,

    FOREIGN KEY (steamid64) 
        REFERENCES advisor_users(steamid64)
        ON DELETE CASCADE
);

-- Infractions table, contains all player infractions
CREATE TABLE IF NOT EXISTS advisor_user_infractions
(
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_steamid64      VARCHAR(17) NOT NULL,
    issuer_steamid64    VARCHAR(17) NOT NULL DEFAULT '0',
    type                TINYINT NOT NULL,
    reason              TEXT,
    issued_at           INTEGER NOT NULL,
    expires_at          INTEGER,

    FOREIGN KEY (user_steamid64) 
        REFERENCES advisor_users(steamid64)
        ON DELETE CASCADE

    FOREIGN KEY (issuer_steamid64) 
        REFERENCES advisor_users(steamid64)
        ON DELETE SET DEFAULT
);

-- Usergroups table
CREATE TABLE IF NOT EXISTS advisor_usergroups
(
    name                TEXT NOT NULL PRIMARY KEY,
    display_name        TEXT,
    color               INTEGER NOT NULL,
    can_delete          BIT NOT NULL,
    inherits            TEXT NOT NULL DEFAULT 'user',

    FOREIGN KEY (inherits)
        REFERENCES advisor_usergroups(name)
        ON DELETE SET DEFAULT
);

-- Contains the permissions assigned to a role.
CREATE TABLE IF NOT EXISTS advisor_usergroup_permissions
(
    usergroup_name      TEXT NOT NULL PRIMARY KEY,
    permission          TEXT NOT NULL,

    FOREIGN KEY (usergroup_name) 
        REFERENCES advisor_usergroups(name)
        ON DELETE CASCADE
);
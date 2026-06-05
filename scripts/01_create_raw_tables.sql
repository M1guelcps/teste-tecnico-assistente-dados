CREATE TABLE raw_usuarios (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    username VARCHAR(20),
    email VARCHAR(250),
    address_street VARCHAR(255),
    address_city VARCHAR(255),
    address_zipcode VARCHAR(255),
    phone VARCHAR(30),
    website TEXT,
    company_name VARCHAR(255),
    company_catchPhrase VARCHAR(255),
    dl_load_timestamp TIMESTAMP

);

CREATE TABLE raw_posts (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    title TEXT,
    body TEXT,
    raw_insert_date TIMESTAMP
);
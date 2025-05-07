CREATE TABLE IF NOT EXISTS birds (
                                     id SERIAL PRIMARY KEY,
                                     name VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL
    );

INSERT INTO birds (name, type) VALUES
                                   ('Polly', 'Parrot'),
                                   ('Tweety', 'Canary');

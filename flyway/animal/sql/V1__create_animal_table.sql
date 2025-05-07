CREATE TABLE IF NOT EXISTS animals (
                                       id SERIAL PRIMARY KEY,
                                       name VARCHAR(100) NOT NULL,
    species VARCHAR(100) NOT NULL
    );

INSERT INTO animals (name, species) VALUES
                                        ('Leo', 'Lion'),
                                        ('Ella', 'Elephant');

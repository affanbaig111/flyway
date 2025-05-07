ALTER TABLE birds
    ADD COLUMN wingspan_cm INT,
  ADD COLUMN can_fly BOOLEAN DEFAULT TRUE,
  ADD COLUMN region VARCHAR(100);

INSERT INTO birds (name, type, wingspan_cm, can_fly, region) VALUES
                                                                 ('Owlbert', 'Owl', 40, TRUE, 'North America'),
                                                                 ('Dodo', 'Dodo', NULL, FALSE, 'Mauritius'),
                                                                 ('EagleEye', 'Eagle', 220, TRUE, 'Asia');

ALTER TABLE animals
    ADD COLUMN age INT,
  ADD COLUMN habitat VARCHAR(100),
  ADD COLUMN endangered BOOLEAN DEFAULT FALSE;

INSERT INTO animals (name, species, age, habitat, endangered) VALUES
                                                                  ('Manny', 'Mammoth', 30, 'Ice Age', TRUE),
                                                                  ('Stripes', 'Zebra', 12, 'Savannah', FALSE),
                                                                  ('Tony', 'Tiger', 9, 'Jungle', TRUE);

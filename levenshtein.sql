-- SQL statements that are used to define the Levenshtein distance function
-- Include all your tried solutions in the SQL file
-- with commenting below the functions the execution times on the tested dictionaries.

-- CREATE OR REPLACE FUNCTION get_distance(word text, word text) RETURNS integer AS $$


CREATE OR REPLACE FUNCTION is_equal(char1 text, char2 text) RETURNS integer AS $$
BEGIN
    IF char1 = char2 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END $$
LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION find_lev_distance(word1 text, word2 text) RETURNS integer AS $$
DECLARE
    i integer;
    j integer;
    matrix double precision[][];
    word1_length integer := char_length(word1);
    word2_length integer := char_length(word2);
BEGIN
    matrix := array_fill(null::double precision, array[word1_length,word2_length]);
    FOR i IN 1..word1_length LOOP
        FOR j IN 1..word2_length LOOP
            IF i = 1 THEN
                IF is_equal(substring(word1, 1, 1), substring(word2, 1, 1)) = 0  THEN
                matrix[i][j] = j-1;
                ELSE
                matrix[i][j] = j;
                END IF;
            ELSEIF j = 1 THEN
                IF is_equal(substring(word1, 1, 1), substring(word2, 1, 1)) = 0  THEN
                matrix[i][j] = i-1;
                ELSE
                matrix[i][j] = i;
                END IF;
            ELSE
            matrix[i][j] = LEAST(
                matrix[i-1][j] + 1,
                matrix[i][j-1] + 1,
                matrix[i-1][j-1] + is_equal(substring(word1, i, 1), substring(word2, j, 1))
            );
            END IF;
        END LOOP;
    END LOOP;
    raise notice 'matrix2: %', matrix;
    RETURN matrix[word1_length][word2_length];
END $$
LANGUAGE plpgsql;






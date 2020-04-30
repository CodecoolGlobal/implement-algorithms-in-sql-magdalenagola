-- SQL statements that are used to define the soundex function
-- Include all your tried solutions in the SQL file
-- with commenting below the functions the execution times on the tested dictionaries.

CREATE OR REPLACE FUNCTION encodeWord(word text) RETURNS text AS $$
DECLARE
    first_letter text := '';
    characters text[] := '{}';
    encoded_characters text[] := '{}';
    temp_encoded_characters text[] := '{}';
    counter integer = 1;
BEGIN
    word = LOWER(word);
    characters := regexp_split_to_array(word, '');
    first_letter := characters[1];
    LOOP
        EXIT WHEN counter = array_length(characters, 1) + 1;
        IF characters[counter] IN ('a', 'e', 'i', 'o', 'u', 'y', 'h', 'w') THEN
            temp_encoded_characters[counter] = '0';
        ELSEIF characters[counter] IN ('b', 'f', 'p', 'v' ) THEN
            temp_encoded_characters[counter] = '1';
        ELSEIF characters[counter] IN ('c', 'g', 'j', 'k', 'q', 's', 'x', 'z' ) THEN
            temp_encoded_characters[counter] = '2';
        ELSEIF characters[counter] IN ('d', 't') THEN
            temp_encoded_characters[counter] ='3';
        ELSEIF characters[counter] = 'l' THEN
            temp_encoded_characters[counter] = '4';
        ELSEIF characters[counter] IN ('m', 'n') THEN
            temp_encoded_characters[counter] = '5';
        ELSEIF characters[counter] = 'r' THEN
            temp_encoded_characters[counter] = '6';
        END IF;
        counter := counter + 1;
    END LOOP ;
        counter := 1;
    LOOP
        IF temp_encoded_characters[counter] = temp_encoded_characters[counter + 1] THEN
            temp_encoded_characters[counter] = '0';
        end if;
        EXIT WHEN counter = array_length(temp_encoded_characters, 1) - 1;
        counter := counter + 1;
    end loop;
    temp_encoded_characters := array_remove(temp_encoded_characters, '0');
    temp_encoded_characters[1] = first_letter;
    if (array_length(temp_encoded_characters, 1)) > 4 THEN
        counter := 1;
        loop
            encoded_characters[counter] = temp_encoded_characters[counter];
            EXIT WHEN counter = 4;
            counter := counter + 1;
        end loop;
    elseif (array_length(temp_encoded_characters, 1)) < 4 THEN
        loop
            EXIT WHEN counter = 5;
            encoded_characters = temp_encoded_characters;
            encoded_characters[counter] = '0';
            counter := counter + 1;
        end loop;
    else
        encoded_characters = temp_encoded_characters;
    end if;
    return array_to_string(encoded_characters, '', ',');
END $$
LANGUAGE plpgsql;
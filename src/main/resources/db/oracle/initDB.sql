DROP TABLE vet_specialties;
DROP TABLE vet_addresses;
DROP TABLE vets;
DROP TABLE specialties;
DROP TABLE visits;
DROP TABLE pets;
DROP TABLE types;
DROP TABLE owners;
DROP SEQUENCE vet_specialties_seq;
DROP SEQUENCE vets_seq;
DROP SEQUENCE specialties_seq;
DROP SEQUENCE visits_seq;
DROP SEQUENCE pets_seq;
DROP SEQUENCE types_seq;
DROP SEQUENCE owners_seq;
DROP SEQUENCE vet_addresses_seq;
/***********************************************************************/
CREATE SEQUENCE vet_specialties_seq MINVALUE 1 INCREMENT BY 1 START WITH 1 noCACHE NOORDER NOCYCLE;
CREATE SEQUENCE vets_seq MINVALUE 1 INCREMENT BY 1 START WITH 1 noCACHE NOORDER NOCYCLE;
CREATE SEQUENCE specialties_seq MINVALUE 1 INCREMENT BY 1 START WITH 1 noCACHE NOORDER NOCYCLE;
CREATE SEQUENCE visits_seq MINVALUE 1 INCREMENT BY 1 START WITH 1 noCACHE NOORDER NOCYCLE;
CREATE SEQUENCE pets_seq MINVALUE 1 INCREMENT BY 1 START WITH 1 noCACHE NOORDER NOCYCLE;
CREATE SEQUENCE types_seq MINVALUE 1 INCREMENT BY 1 START WITH 1 noCACHE NOORDER NOCYCLE;
CREATE SEQUENCE owners_seq MINVALUE 1 INCREMENT BY 1 START WITH 1 noCACHE NOORDER NOCYCLE;
CREATE SEQUENCE vet_addresses_seq MINVALUE 1 INCREMENT BY 1 START WITH 1 noCACHE NOORDER NOCYCLE;
/***********************************************************************/
CREATE TABLE vets (
  id         INTEGER PRIMARY KEY,
  first_name VARCHAR(30),
  last_name  VARCHAR(30)
);
CREATE INDEX vets_last_name ON vets (last_name);
/***********************************************************************/
CREATE TABLE specialties (
  id   INTEGER PRIMARY KEY,
  name VARCHAR(80)
);
CREATE INDEX specialties_name ON specialties (name);
/***********************************************************************/
CREATE TABLE vet_specialties (
  vet_id       INTEGER NOT NULL,
  specialty_id INTEGER NOT NULL
);
ALTER TABLE vet_specialties ADD CONSTRAINT fk_vet_specialties_vets FOREIGN KEY (vet_id) REFERENCES vets (id);
ALTER TABLE vet_specialties ADD CONSTRAINT fk_vet_specialties_specialties FOREIGN KEY (specialty_id) REFERENCES specialties (id);
/***********************************************************************/
CREATE TABLE types (
  id   INTEGER PRIMARY KEY,
  name VARCHAR(80)
);
CREATE INDEX types_name ON types (name);
/***********************************************************************/
CREATE TABLE owners (
  id         INTEGER PRIMARY KEY,
  first_name VARCHAR(30),
  last_name  VARCHAR(30),
  address    VARCHAR(255),
  city       VARCHAR(80),
  telephone  VARCHAR(20)
);
CREATE INDEX owners_last_name ON owners (last_name);
/***********************************************************************/
CREATE TABLE pets (
  id         INTEGER PRIMARY KEY,
  name       VARCHAR(30),
  birth_date DATE,
  type_id    INTEGER NOT NULL,
  owner_id   INTEGER NOT NULL
);
ALTER TABLE pets ADD CONSTRAINT fk_pets_owners FOREIGN KEY (owner_id) REFERENCES owners (id);
ALTER TABLE pets ADD CONSTRAINT fk_pets_types FOREIGN KEY (type_id) REFERENCES types (id);
CREATE INDEX pets_name ON pets (name);
/***********************************************************************/
CREATE TABLE visits (
  id          INTEGER PRIMARY KEY,
  pet_id      INTEGER NOT NULL,
  visit_date  DATE,
  description VARCHAR(255)
);
CREATE INDEX visits_pet_id ON visits (pet_id);
ALTER TABLE visits ADD CONSTRAINT fk_visits_pets FOREIGN KEY (pet_id) REFERENCES pets (id);
/***********************************************************************/
CREATE TABLE vet_addresses (
  id         INTEGER PRIMARY KEY,
  postal_code VARCHAR(10),
  province VARCHAR(30),
  city VARCHAR(100),
  vet_id INTEGER NOT NULL
);
CREATE INDEX vet_addresses_vet_id ON vet_addresses (vet_id);
ALTER TABLE vet_addresses ADD CONSTRAINT fk_vet_addresses_vets FOREIGN KEY (vet_id) REFERENCES vets (id);
/***********************************************************************
Procedure는 별도의 procedure 작성을 지원하는 곳에서 생성해야 한다.
Oracle SQL Developer에 작성 시 Procedures에 작성해도 Triggers에 보인다.
Triggers에 작성해도 된다.
***********************************************************************/
CREATE OR REPLACE TRIGGER insert_vets
BEFORE INSERT ON vets
FOR EACH ROW
DECLARE
  id number;
BEGIN
  SELECT vets_seq.nextval
    INTO id
    FROM dual;
  :new.id := id;
END;
/***********************************************************************/
CREATE OR REPLACE TRIGGER insert_specialties
BEFORE INSERT ON specialties
FOR EACH ROW
DECLARE
  id number;
BEGIN
  SELECT specialties_seq.nextval
    INTO id
    FROM dual;
  :new.id := id;
END;
/***********************************************************************/
CREATE OR REPLACE TRIGGER insert_types
BEFORE INSERT ON types
FOR EACH ROW
DECLARE
  id number;
BEGIN
  SELECT types_seq.nextval
    INTO id
    FROM dual;
  :new.id := id;
END;
/***********************************************************************/
CREATE OR REPLACE TRIGGER insert_owners
BEFORE INSERT ON owners
FOR EACH ROW
DECLARE
  id number;
BEGIN
  SELECT owners_seq.nextval
    INTO id
    FROM dual;
  :new.id := id;
END;
/***********************************************************************/
CREATE OR REPLACE TRIGGER insert_pets
BEFORE INSERT ON pets
FOR EACH ROW
DECLARE
  id number;
BEGIN
  SELECT pets_seq.nextval
    INTO id
    FROM dual;
  :new.id := id;
END;
/***********************************************************************/
CREATE OR REPLACE TRIGGER insert_visits
BEFORE INSERT ON visits
FOR EACH ROW
DECLARE
  id number;
BEGIN
  SELECT visits_seq.nextval
    INTO id
    FROM dual;
  :new.id := id;
END;
/***********************************************************************/
CREATE OR REPLACE TRIGGER insert_vet_addresses
BEFORE INSERT ON vet_addresses
FOR EACH ROW
DECLARE
  id number;
BEGIN
  SELECT vet_addresses_seq.nextval
    INTO id
    FROM dual;
  :new.id := id;
END;
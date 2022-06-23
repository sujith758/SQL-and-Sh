DROP SCHEMA empltab cascade;
CREATE SCHEMA empltab;
CREATE TABLE empltab.Edata(Name varchar(100),Age int,Gender varchar(100));
COPY empltab.Edata(Name,Age,Gender) FROM '/home/deadshot/Desktop/Edata.csv' DELIMITER ',' CSV HEADER;

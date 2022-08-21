create table crashdata.cyclecrashfreq_ref(crashdate varchar(100),
                            crashtime varchar(100),
                            Borough varchar(100),
                            zipcode varchar(100),
                            Lat varchar(100),
                            Longitude varchar(100),
                            Loc varchar(100),
                            onstreetname varchar(100),
                            crossstreetname varchar(100),
                            offstreetname varchar(100),
                            personsinjured varchar(100),
                            personskilled varchar(100),
                            pedsinjured varchar(100),
                            pedskilled varchar(100),
                            cyclistsinjured varchar(100),
                            cyclistskilled varchar(100),
                            motoinjured varchar(100),
                            motokilled varchar(100),
                            CFV1 varchar(100),
                            CFV2 varchar(100),
                            CFV3 varchar(100),
                            CFV4 varchar(100),
                            CFV5 varchar(100),
                            Collision_ID varchar(100),
                            VTC1 varchar(100),
                            VTC2 varchar(100),
                            VTC3 varchar(100),
                            VTC4 varchar(100),
                            VTC5 varchar(100));



\COPY crashdata.cyclecrashfreq(crashdate,crashtime,Borough,zipcode,Lat,Longitude,Loc,onstreetname,crossstreetname,offstreetname,personsinjured,personskilled,pedsinjured,pedskilled,cyclistsinjured,cyclistskilled,motoinjured,motokilled,CFV1,CFV2,CFV3,CFV4,CFV5,Collision_ID,VTC1,VTC2,VTC3,VTC4,VTC5) FROM '/home/deadpool/Documents/crashdata.csv' DELIMITER ',' CSV HEADER;

create or replace function my_to_timestamp(arg text)
returns timestamp language plpgsql
as $$
begin
    begin
        return to_timestamp(arg, 'dd/mm/yyyy HH:MI:SS');
    exception when others then
        return null;
    end;
end $$;

CREATE OR REPLACE FUNCTION isnumeric(text) RETURNS BOOLEAN AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION "isntnumeric"(text)
RETURNS "pg_catalog"."bool" AS $BODY$
DECLARE x TEXT;
BEGIN
    x = $1::TEXT;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT  COST 100
;





























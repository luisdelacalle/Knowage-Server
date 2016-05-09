CREATE TABLE SBI_CACHE_ITEM (
	   SIGNATURE			VARCHAR(100) NOT NULL,
	   NAME					TEXT NOT NULL,
	   TABLE_NAME 			VARCHAR(100) NOT NULL,
	   DIMENSION 			NUMERIC NULL,
	   CREATION_DATE 		DATETIME NULL,
	   LAST_USED_DATE 		DATETIME NULL,
       PROPERTIES			TEXT NULL,
	   USER_IN              VARCHAR(100) NOT NULL,
       USER_UP              VARCHAR(100),
       USER_DE              VARCHAR(100),
       TIME_IN              TIMESTAMP NOT NULL,
       TIME_UP              TIMESTAMP NULL DEFAULT NULL,
       TIME_DE              TIMESTAMP NULL DEFAULT NULL,
       SBI_VERSION_IN       VARCHAR(10),
       SBI_VERSION_UP       VARCHAR(10),
       SBI_VERSION_DE       VARCHAR(10),
       META_VERSION         VARCHAR(100),
       ORGANIZATION         VARCHAR(20),
       UNIQUE XAK1SBI_CACHE_ITEM (TABLE_NAME),
	   PRIMARY KEY (SIGNATURE)
) ENGINE=InnoDB;
commit;

ALTER TABLE SBI_META_MODELS
	ADD COLUMN `MODEL_LOCKED` TINYINT(1) NULL DEFAULT NULL AFTER `DESCR`,
	ADD COLUMN `MODEL_LOCKER` VARCHAR(100) NULL DEFAULT NULL AFTER `MODEL_LOCKED`;
UPDATE SBI_META_MODELS SET MODEL_LOCKED = false WHERE MODEL_LOCKED IS NULL;




CREATE TABLE SBI_OBJ_DATA_SET (
    BIOBJ_DS_ID INT(11) NOT NULL,
    BIOBJ_ID INT(11) NOT NULL,
    DS_ID INT(11) NOT NULL,
    IS_DETAIL BOOLEAN DEFAULT FALSE,
    USER_IN VARCHAR(100) NOT NULL,
    USER_UP VARCHAR(100) DEFAULT NULL,
    USER_DE VARCHAR(100) DEFAULT NULL,
    TIME_IN TIMESTAMP,
    TIME_UP TIMESTAMP NULL DEFAULT NULL,
    TIME_DE TIMESTAMP NULL DEFAULT NULL,
    SBI_VERSION_IN VARCHAR(10) DEFAULT NULL,
    SBI_VERSION_UP VARCHAR(10) DEFAULT NULL,
    SBI_VERSION_DE VARCHAR(10) DEFAULT NULL,
    META_VERSION VARCHAR(100) DEFAULT NULL,
    ORGANIZATION VARCHAR(20) DEFAULT NULL,
    CONSTRAINT XAK1SBI_OBJ_DATA_SET UNIQUE (BIOBJ_ID ,DS_ID, ORGANIZATION),
  PRIMARY KEY (BIOBJ_DS_ID)
);

Alter table `SBI_OBJ_DATA_SET` add Foreign Key (`BIOBJ_ID`) references `SBI_OBJECTS` (`BIOBJ_ID`) on delete  restrict on update  restrict;

 
    SET @row_number:=0;
    insert into SBI_OBJ_DATA_SET(BIOBJ_DS_ID, BIOBJ_ID, DS_ID, IS_DETAIL, USER_IN, TIME_IN, ORGANIZATION)
    select
    @row_number:=@row_number+1 rownum,
    BIOBJ_ID,  DATA_SET_ID, TRUE, 'server', current_timestamp,  ORGANIZATION
    from SBI_OBJECTS where DATA_SET_ID   is not null;
    commit;
 
  ALTER TABLE SBI_OBJECTS DROP COLUMN DATA_SET_ID;


SET @row_number:=0;
insert into SBI_AUTHORIZATIONS (ID, NAME, PRODUCT_TYPE_ID, USER_IN, TIME_IN)
select
(SELECT NEXT_VAL FROM hibernate_sequences WHERE SEQUENCE_NAME='SBI_AUTHORIZATIONS')+rownum-1
, 'ENABLE_FEDERATED_DATASET'
, PRODUCT_TYPE_ID
, 'server'
, current_timestamp
from
(select distinct @row_number:=@row_number+1 rownum, PRODUCT_TYPE_ID from SBI_PRODUCT_TYPE) pt;

update hibernate_sequences set NEXT_VAL = NEXT_VAL
        + (select count(distinct PRODUCT_TYPE_ID) from SBI_PRODUCT_TYPE)
where SEQUENCE_NAME = 'SBI_AUTHORIZATIONS';
commit; 

update hibernate_sequences set NEXT_VAL = NEXT_VAL
        + (select count(distinct BIOBJ_DS_ID)+1 from SBI_OBJ_DATA_SET)
where SEQUENCE_NAME = 'SBI_OBJ_DATA_SET';
commit; 

DROP TABLE SBI_DOSSIER_BIN_TEMP;
DROP TABLE SBI_DOSSIER_PRES;
DROP TABLE SBI_DOSSIER_TEMP;


ALTER TABLE SBI_OBJECTS
    ADD COLUMN LOCKED_BY_USER VARCHAR(100) NULL DEFAULT NULL;

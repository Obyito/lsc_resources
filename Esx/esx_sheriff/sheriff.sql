INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_sheriff', 'Sheriff Department', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_sheriff', 'Sheriff Department', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_sheriff', 'Sheriff Department', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('sheriff','DKSD')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('sheriff',0,'recruit','Recruit',20,'{}','{}'),
	('sheriff',1,'cadet','Cadet',40,'{}','{}'),
	('sheriff',2,'deputy','Deputy',60,'{}','{}'),
	('sheriff',3,'senior','Senior',85,'{}','{}'),
	('sheriff',4,'corporal','Corporal',100,'{}','{}'),
	('sheriff',5,'sergeant','Sergeant',125,'{}','{}'),
	('sheriff',6,'lieutenant','Lieutenant',150,'{}','{}'),
	('sheriff',7,'captain','Captain',175,'{}','{}'),
	('sheriff',8,'deputys','Deputy Sheriff',200,'{}','{}'),
	('sheriff',9,'boss','Sheriff',1,'{}','{}')
;

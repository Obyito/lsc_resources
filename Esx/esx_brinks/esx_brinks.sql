USE `essentialmode`;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
	('brinks', 'Brinks', 0)
;

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_brinks', 'Brinks', 1)
;

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_brinks', 'Brinks', 1),
	('society_taxe_brinks', 'Brinks Taxe', 1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_brinks', 'Brinks', 1)
;

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	('brinks', 0, 'interim', 'Recrue convoyeur', 100, '{}', '{}'),
	('brinks', 1, 'employee', 'Convoyeur de fonds', 100, '{}', '{}'),
	('brinks', 2, 'chief', 'Chef d\'équipe', 100, '{}', '{}'),
	('brinks', 3, 'boss'  , 'Patron', 100, '{}', '{}')
;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('sacbillets', 'Sac de Billets', 1, 0, 1)
;

CREATE TABLE IF NOT EXISTS `weekly_run` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `start_date` int(11) NOT NULL,
  `harvest` int(11) NOT NULL,
  `sell` int(11) NOT NULL,
  `malus` int(11) NOT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `weekly_run` (`company`, `start_date`, `harvest`, `sell`, `malus`) VALUES
	('brinks', 0, 0, 0, 0)
;


CREATE TABLE IF NOT EXISTS `ps_carwash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(100) NOT NULL,
  `name` varchar(25) NOT NULL,
  `balance` int(11) DEFAULT NULL,
  `date` varchar(100) NOT NULL,
  `carwashname` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

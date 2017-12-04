-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le :  lun. 04 déc. 2017 à 01:07
-- Version du serveur :  10.2.8-MariaDB
-- Version de PHP :  7.2.0RC2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `indiek_new`
--

-- --------------------------------------------------------

--
-- Structure de la table `Files`
--

CREATE TABLE `Files` (
  `ID_file` int(11) NOT NULL,
  `ItemID` int(11) NOT NULL,
  `Filename` char(50) NOT NULL,
  `Extension` char(10) NOT NULL,
  `Size` bigint(20) NOT NULL,
  `FileCreationDate` timestamp NULL DEFAULT NULL,
  `FileLastModifDate` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for items of type file';

-- --------------------------------------------------------

--
-- Structure de la table `Items`
--

CREATE TABLE `Items` (
  `ItemID` int(11) NOT NULL,
  `LastModifDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `CreationDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `id_usr` int(11) NOT NULL COMMENT 'FK to Users table',
  `Location_desc` char(255) DEFAULT NULL COMMENT 'plain language description of the location of the physical item',
  `Location_abs` varchar(2000) NOT NULL COMMENT 'absolute location of the physical item',
  `Text_format` set('Plain','Latex') DEFAULT NULL COMMENT 'format of the text content',
  `Text_content` varchar(10000) DEFAULT NULL COMMENT 'content of the item when stored in the db (no file)',
  `Description` varchar(5000) DEFAULT NULL COMMENT 'short description of the item content useful to the user',
  `Item_name` char(80) DEFAULT NULL COMMENT 'Item name chosen by the user',
  `Item_type` set('file','image','text','url') NOT NULL COMMENT 'Item type: file, image, text, url',
  `Url_title` varchar(2000) DEFAULT NULL COMMENT 'Title of the html page'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `item_relation_1`
--

CREATE TABLE `item_relation_1` (
  `relation1ID` int(11) NOT NULL,
  `ParentID` int(11) DEFAULT NULL,
  `ChildID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `Topics`
--

CREATE TABLE `Topics` (
  `TopicID` int(11) NOT NULL,
  `LastModifDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `CreationDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `Author` varchar(30) NOT NULL,
  `TopicName` varchar(30) NOT NULL,
  `TopicDescription` varchar(2000) DEFAULT NULL,
  `Level` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `TopicsElements`
--

CREATE TABLE `TopicsElements` (
  `ElementID` int(11) NOT NULL,
  `TopicID` int(11) DEFAULT NULL,
  `ItemID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `topic_relation_1`
--

CREATE TABLE `topic_relation_1` (
  `rel_t1_ID` int(11) NOT NULL,
  `SupraTopicID` int(11) DEFAULT NULL,
  `SubTopicID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `Users`
--

CREATE TABLE `Users` (
  `id_usr` int(11) NOT NULL,
  `first_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `Files`
--
ALTER TABLE `Files`
  ADD PRIMARY KEY (`ID_file`),
  ADD KEY `Item_File` (`ItemID`);

--
-- Index pour la table `Items`
--
ALTER TABLE `Items`
  ADD PRIMARY KEY (`ItemID`),
  ADD KEY `id_usr` (`id_usr`);

--
-- Index pour la table `item_relation_1`
--
ALTER TABLE `item_relation_1`
  ADD PRIMARY KEY (`relation1ID`),
  ADD UNIQUE KEY `UC_relation1` (`ParentID`,`ChildID`),
  ADD KEY `FK_relation1_child` (`ChildID`);

--
-- Index pour la table `Topics`
--
ALTER TABLE `Topics`
  ADD PRIMARY KEY (`TopicID`),
  ADD UNIQUE KEY `UC_topicname` (`TopicName`);

--
-- Index pour la table `TopicsElements`
--
ALTER TABLE `TopicsElements`
  ADD PRIMARY KEY (`ElementID`),
  ADD UNIQUE KEY `UC_elt` (`TopicID`,`ItemID`),
  ADD KEY `FK_elt_item` (`ItemID`);

--
-- Index pour la table `topic_relation_1`
--
ALTER TABLE `topic_relation_1`
  ADD PRIMARY KEY (`rel_t1_ID`),
  ADD UNIQUE KEY `UC_rel_t1` (`SupraTopicID`,`SubTopicID`),
  ADD KEY `FK_rel_t1_sub` (`SubTopicID`);

--
-- Index pour la table `Users`
--
ALTER TABLE `Users`
  ADD KEY `id_usr` (`id_usr`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `Files`
--
ALTER TABLE `Files`
  MODIFY `ID_file` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `Items`
--
ALTER TABLE `Items`
  MODIFY `ItemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT pour la table `item_relation_1`
--
ALTER TABLE `item_relation_1`
  MODIFY `relation1ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `Topics`
--
ALTER TABLE `Topics`
  MODIFY `TopicID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `TopicsElements`
--
ALTER TABLE `TopicsElements`
  MODIFY `ElementID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `topic_relation_1`
--
ALTER TABLE `topic_relation_1`
  MODIFY `rel_t1_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `Files`
--
ALTER TABLE `Files`
  ADD CONSTRAINT `Item_File` FOREIGN KEY (`ItemID`) REFERENCES `Items` (`ItemID`);

--
-- Contraintes pour la table `Items`
--
ALTER TABLE `Items`
  ADD CONSTRAINT `Item_usr` FOREIGN KEY (`id_usr`) REFERENCES `Users` (`id_usr`);

--
-- Contraintes pour la table `item_relation_1`
--
ALTER TABLE `item_relation_1`
  ADD CONSTRAINT `FK_relation1_child` FOREIGN KEY (`ChildID`) REFERENCES `Items` (`ItemID`),
  ADD CONSTRAINT `FK_relation1_parent` FOREIGN KEY (`ParentID`) REFERENCES `Items` (`ItemID`);

--
-- Contraintes pour la table `TopicsElements`
--
ALTER TABLE `TopicsElements`
  ADD CONSTRAINT `FK_elt_item` FOREIGN KEY (`ItemID`) REFERENCES `Items` (`ItemID`),
  ADD CONSTRAINT `FK_elt_topic` FOREIGN KEY (`TopicID`) REFERENCES `Topics` (`TopicID`);

--
-- Contraintes pour la table `topic_relation_1`
--
ALTER TABLE `topic_relation_1`
  ADD CONSTRAINT `FK_rel_t1_sub` FOREIGN KEY (`SubTopicID`) REFERENCES `Topics` (`TopicID`),
  ADD CONSTRAINT `FK_rel_t1_supra` FOREIGN KEY (`SupraTopicID`) REFERENCES `Topics` (`TopicID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

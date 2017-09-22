/*
REMAINING PROBLEMS:

*/


-- TABLE 1 -- old tA files

CREATE TABLE Items ( 
    ItemID int NOT NULL AUTO_INCREMENT,
    /*
    the following column will get updated to current timestamp at each 
    modification of 
    the row, but must remain the first timestamp column in the table 
    definition for that!
    */
    LastModifDate timestamp, 
    CreationDate timestamp DEFAULT CURRENT_TIMESTAMP,
    Author nvarchar(30) NOT NULL,
    Latex boolean DEFAULT 0,
    Content varchar(10000),  -- did not accept syntax varchar(MAX)
    CONSTRAINT PK_item PRIMARY KEY (ItemID)
); 

-- TABLE 2 -- old pA file names

CREATE TABLE Topics (
    TopicID int NOT NULL AUTO_INCREMENT,
    LastModifDate timestamp,
    CreationDate timestamp DEFAULT CURRENT_TIMESTAMP,
    Author nvarchar(30) NOT NULL,
    TopicName varchar(30) NOT NULL,
    TopicDescription nvarchar(2000),
    CONSTRAINT PK_topic PRIMARY KEY (TopicID),
    CONSTRAINT UC_topicname UNIQUE (TopicName)
); 

-- TABLE 3 -- old rel.1.txt file

CREATE TABLE item_relation_1 (
	relation1ID int NOT NULL AUTO_INCREMENT,
	ParentID int,
	ChildID int,
	CONSTRAINT PK_relation1 PRIMARY KEY (relation1ID),
    CONSTRAINT FK_relation1_parent FOREIGN KEY (ParentID)
    REFERENCES Items(ItemID),
    CONSTRAINT FK_relation1_child FOREIGN KEY (ChildID)
    REFERENCES Items(ItemID),
    CONSTRAINT UC_relation1 UNIQUE (ParentID,ChildID) -- forbid two or more records with same pair (ParentID,ChildID)
);

-- TABLE 4 -- old pA files

CREATE TABLE TopicsElements (
    ElementID int NOT NULL AUTO_INCREMENT,
    TopicID int,
    ItemID int,
    CONSTRAINT PK_element PRIMARY KEY (ElementID),
    CONSTRAINT FK_elt_topic FOREIGN KEY (TopicID)
    REFERENCES Topics(TopicID),
    CONSTRAINT FK_elt_item FOREIGN KEY (ItemID)
    REFERENCES Items(ItemID),
    CONSTRAINT UC_elt UNIQUE (TopicID,ItemID) -- forbid two or more records with same pair (ProjectID,ItemID)
);


/*
The following is the SQL command that can be used to add a ShellID column to the Items table
This is needed when the SQL database contains some items that also exist in the Shell version of 
our software. For instance, it is needed for an import Shell --> SQL 

ALTER TABLE Items
ADD COLUMN ShellID int UNIQUE
AFTER Content;
*/

-- TABLE 5 -- new concept of subproject

CREATE TABLE topic_relation_1 (
	rel_t1_ID int NOT NULL AUTO_INCREMENT,
	SupraTopicID int,
	SubTopicID int,
	CONSTRAINT PK_rel_t1 PRIMARY KEY (rel_t1_ID),
	CONSTRAINT FK_rel_t1_supra FOREIGN KEY (SupraTopicID)
	REFERENCES Topics(TopicID),
	CONSTRAINT FK_rel_t1_sub FOREIGN KEY (SubTopicID)
	REFERENCES Topics(TopicID),
	CONSTRAINT UC_rel_t1 UNIQUE (SupraTopicID,SubTopicID) 
);	 

ALTER TABLE Topics
ADD COLUMN Level int DEFAULT 1
AFTER TopicDescription;

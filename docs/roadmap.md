# ROADMAP
This document sets the official future development goals of *IndieK* *v0.1.0*  
**Date:** December 22, 2017   
**Author:** Adrian Ernesto Radillo  

# Vision

This is a link to the [VISION.md](https://github.com/aernesto/IndieK/blob/5e8323d09fed119220dab3e7fbe8ec622af0c906/VISION.md) document.

# Development

Core developers as of today are Adrian Radillo and Ernesto Radillo (yes, the latter is the father of the former).

Disclaimer: Because IndieK is a FOSS, we greatly encourage public debate and discussions about IndieK’s development and design questions. However, as head developer of the project, I (the author of this document) make all the final decisions about the IndieK’s official directions of development. Of course, I shall always justify my decisions publicly, as best as I can.

# Needed collaborators

We need developers with knowledge in one of the following fields. If you are one of them and like IndieK’s vision, please fork our repo and start coding, following our guidelines. You may start a pull request at any time to ask questions or submit your work for review.

- Python GUI specialist (especially for freehand drawings)
- Computer vision / OCR Python specialist
# Current architecture of IndieK
![Arch](/images/IndieK_arch_0.1.0.png)

# Immediate development goals
## 1. Port existing code to Python

**Why python?**
We want a GUI
We will use machine learning algorithms in the future, and computations on graphs

One aspect of this migration involves reproducing the existing CLI with pure Python / SQL code. A good source of inspiration is [this tutorial](https://stormpath.com/blog/building-simple-cli-interfaces-in-python).

Two important points about the upcoming version of IndieK (v0.2.0) are described below.
 
**Enhance architecture**
Make use of Object Oriented (OO) capabilities of Python.

**Object / Classes**:

- Item

*Attributes:* (The list below is merely reporting the info contained in the SQL DB)

  - ItemID
  - Created
  - LastModifDate
  - Author
  - Content
  - Latex
  - Parents
  - Children
  - InTopics

*Methods:* 

  - query_db — fills Python object with data fetched from SQL DB
  - save_db — writes Python item to SQL DB
  - delete_db — removes item from DB
  - plot — sends item to GUI for graphical interaction
  - edit — edits item properties in Python workspace (without writing to SQL DB)
  - delete — destructor, may not be needed


- Topic

*Attributes:* 

  - TopicID
  - TopicName
  - TopicDescription
  - Created
  - LastModifDate
  - Author
  - ItemList
  - SupraTopics
  - SubTopics
  

*Methods:* 


- Graph

Contains (and fetches if needed) required info to produce GraphViz output


- Query

*Attributes*:

  - Author

*Methods*:
All the possible queries that the user might make with the software. Also, internal queries corresponding to graph computations, such as:

  - GetTopicAncestors
  - GetTopicDescendents
  - GetItemAncestors
  - GetItemDescendents
  
- Workspace

The workspace is the place where most of the interaction with the user will take place. This interaction will happen via the freehand drawing module of the GUI. Whenever the user will work on some project, he/she will use the workspace as a whiteboard.
Also, the GUI will allow for dragging-dropping objects from the graphical results windows into the workspace window.

Workspace should allow import of external images.
Should also provide a scanning option, to run OCR on images.

**Adopt coding guidelines**
Mainly, use a specific template for class and function definitions **.** 

**Hunt for bugs**
We will start to systematically document the application’s bugs.

## 2. Start developing a GUI

Note that developing a GUI *will not* render the CLI obsolete. We will keep the CLI development ongoing.
The GUI will have two aspects.
 
All URLs should be clickable
**Standard button-fields-display GUI**

For the graphs, keep using GraphViz

Window 1: Queries

Window 2: CLI output

Window 3: Graphical results (to display GraphViz graphs). Will offer minimal interaction (mainly translation, zoom in and zoom out).

Window 4: Workspace 

**Touch-screen freehand drawing GUI**
This part of the interface will receive freehand drawings and freehand writings as input from the user. The input device will most probably be a drawing tablet or a touch screen.
This part of the GUI will need to send its produced images to the OCR module of IndieK for further processing.

A GUI development tool must be chosen. PyQt5?

**Important question**: Do we go for vector graphics or raster images?

**OCR**
The main goal is to convert:

- handwritten letters to their UTF-8 counterpart
- handwritten mathematical symbols to their $$\LaTeX$$ counterpart

A pre-processing of the image, before the actual OCR operation, will be needed. Ideally we seek automatic image segmentation, where the different parts of the handwriting area are classified into one of the following:

- word sequence → UTF-8
- mathematical expression → $$\LaTeX$$
- freehand drawing → Possible image file OR vector graphics file
- noise / unclassified

Convnets are the best for handwritten digits classification. Maybe start with one of these trained CNN.

## 3. Database

**Extending SQL support**
We want to develop the support for IndieK to the following widely used SQL frameworks:

- PostgreSQL
- SQLite

Recall that the FOSS nature of IndieK restricts our choice of databases to pure FOSS (AGPL 3 compatible).

A promising module for SQL is [*dataset*](https://github.com/pudo/dataset) **(I started using it with PostgreSQL for school).

**Start experimenting with NoSQL**
We also want to start experimenting with NoSQL databases, to comparatively weigh the benefits and drawbacks with SQL, as far as IndieK’s goals are concerned.

## 4. Automatic search

The search capabilities of IndieK are crucial to the usefulness of the software. There is no point in using IndieK, if finding back stored information is a pain. A powerful Open Source engine is [PyLucene](https://lucene.apache.org/pylucene/).

## 5. Markdown export

IndieK should also facilitate the publication process. A quickly attainable goal is to write a function that allows the export of a topic to a MarkDown document.

## 6. Write new functions for IndieK

**To-do module**
I want to incorporate into IndieK a functionality for handling TO-DO lists.

https://www.dropbox.com/s/ey790ohq75bik7v/Archi_draft_V0.2.key?dl=0




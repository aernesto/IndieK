"""
The aim of this script is to:
    1. connect to ArangoDB with credentials fetched from a .json config file
    2. check whether the 'ikdev' database and the 'topics' and 'links' collections exist; offer to create them if not
    3. offer a basic API to 
           a) create topics and links between them
           b) gather topics and links into arbitrary graphs
"""
import pyArango.connection as pyconn
from pyArango.document import Document
from pyArango.collection import Collection #, Field
from pyArango.graph import Graph, EdgeDefinition
import json

PATH_TO_CONFIG = '/home/adrian/.ikconfig'

COLL_NAMES = {'topics': 'topics',
              'subtopic_links': 'subtopic_links'}

def ik_connect():
    with open(PATH_TO_CONFIG) as f:
        conf = json.load(f)
    conn = pyconn.Connection(username=conf['username'], password=conf['password'])
    db_name = conf['database']

    # check appropriate db and collections exist; offer to create them if they don't
    if not conn.hasDatabase(db_name):
        print(f"database {db_name} not found")
        ans = input("would you like to create it? (y + ENTER for yes) ")
        if ans == 'y':
            db.createDatabase(name=db_name)
        print(f"database {db_name} created")

    db = conn[db_name]

    if not db.hasCollection(COLL_NAMES['topics']):
        print(f"collection {COLL_NAMES['topics']} not found in db {db.name}")
        ans = input("would you like to create it? (y + ENTER for yes) ")
        if ans == 'y':
            db.createCollection(name=COLL_NAMES['topics'], className='Collection')
        print(f"collection {COLL_NAMES['topics']} created")

    if not db.hasCollection(COLL_NAMES['subtopic_links']):
        print(f"collection {COLL_NAMES['subtopic_links']} not found in db {db.name}")
        ans = input("would you like to create it? (y + ENTER for yes) ")
        if ans == 'y':
            db.createCollection(name=COLL_NAMES['subtopic_links'], className='Edges')
        print(f"collection {COLL_NAMES['subtopic_links']} created")

    return db



if __name__ == "__main__":
    db = ik_connect()

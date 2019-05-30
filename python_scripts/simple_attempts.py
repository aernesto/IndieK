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

# keys are what I use in the code, values are what is used in the database
COLL_NAMES = {'topics': 'topics',
              'subtopic_links': 'subtopic_links'}
TOPIC_FIELDS = {'name': 'name', 'description': 'description'} 

def ik_connect():
    with open(PATH_TO_CONFIG) as f:
        conf = json.load(f)
    conn = pyconn.Connection(username=conf['username'], password=conf['password'])
    db_name = conf['database']

    # check appropriate db and collections exist; offer to create them if they don't
    # note that creation might fail if proper permissions aren't set for the user
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

#    db[COLL_NAMES['topics']].ensureFulltextIndex(list(TOPIC_FIELDS.values())) # somehow this fails

    if not db.hasCollection(COLL_NAMES['subtopic_links']):
        print(f"collection {COLL_NAMES['subtopic_links']} not found in db {db.name}")
        ans = input("would you like to create it? (y + ENTER for yes) ")
        if ans == 'y':
            db.createCollection(name=COLL_NAMES['subtopic_links'], className='Edges')
            print(f"collection {COLL_NAMES['subtopic_links']} created")

    return db

def get_topic_by_name(db, topic_name):
    """
    fetches topic if exists, false otherwise

    todo: figure out what batchSize does

    Args:
        db: DBHandle
        topic_name: string, name of topic

    Returns:
        pyArango.query.SimpleQuery
    """
    return db[COLL_NAMES['topics']].fetchByExample({TOPIC_FIELDS['name']: topic_name}, batchSize=100)
    
def list_topics(db):
    return db[COLL_NAMES['topics']].fetchAll()


def create_topic(db, name, descr):
    if get_topic_by_name(db, name):
        print(f"topic '{name}' already exists")
    else:
        doc = db[COLL_NAMES['topics']].createDocument({
            TOPIC_FIELDS['name']: name,
            TOPIC_FIELDS['description']: descr})
        doc.save()


if __name__ == "__main__":
    db = ik_connect()
    print('list topics')
    print(list_topics(db))

    print('checking emptyness in if statement')
    t = get_topic_by_name(db, 'salut')
    if t:
        print('topic found!')
    else:
        print('topic not found!')

    print('creating topic "salut"')
    create_topic(db, 'salut', 'premier topic')
    
    print('list topics')
    print(list_topics(db))

    print('checking emptyness in if statement')
    t = get_topic_by_name(db, 'salut')
    if t:
        print('topic found!')
    else:
        print('topic not found!')

    print('trying to re-create same topic')
    create_topic(db, 'salut', 'premier topic')
    
    print('list topics')
    print(list_topics(db))


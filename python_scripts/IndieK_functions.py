# requires the following imports
from pyArango.connection import *
from pyArango.document import Document
# from pyArango.collection import Collection
import uuid
# connection = Connection(username="root", password="l,.7)OCR")
# sys.path.extend(['/home/radillo/programming/Python/PyArangoTests'])
# from IndieK_functions import *


class Workspace:
    """Main user interface. Items, topics and graphs are loaded from and saved the db from this class"""
    # todo: check method add_item()
    # todo: consider making all the methods private with prefix _
    def __init__(self, connection, items_dict=None, topics_dict=None, graphs_dict=None, dbname="test", interactive=True):
        self.conn = connection
        # opens DB test
        self.db = self.conn[dbname]
        # instantiate collections
        # todo: all these collections should be defined in IndieK's BLL
        self.items_collection = self.db["items"]
        self.topics_collection = self.db["topics"]
        self.topics_elements_relation_collection = self.db["topics_elements_relation"]
        self.items_relation_1_collection = self.db["items_relation_1"]
        self.subtopics_relation_collection = self.db["subtopics_relation"]
        if items_dict is None:
            self.items = {}
        else:
            self.items = items_dict
        if topics_dict is None:
            self.topics = {}
        else:
            self.topics = topics_dict
        if graphs_dict is None:
            self.graphs = {}
        else:
            self.graphs = graphs_dict
        self.interactive = interactive

    def summary(self):
        print('workspace contains:')
        print('%i graphs' % len(self.graphs))
        print('%i topics' % len(self.topics))
        print('%i items' % len(self.items))

    def list_items(self, content=False):
        print('List of workspace items')
        for item in self.items.values():
            print('item _key: %s' % item["_key"])
            print('item wid: %s' % item.wid)
            if content:
                item.display_item_content()

    def generate_item_id(self):
        """generates a new unique workspace item id"""
        workspace_item_id = str(uuid.uuid4())[0:6]
        while workspace_item_id in self.items.keys():
            workspace_item_id = str(uuid.uuid4())[0:6]
        return workspace_item_id

    def fetch_item(self, key, rawResults=False, rev=None):
        """
        function based on pyArango.collection.Collection.fetchDocument()
        fetches item from db and tries to insert it into workspace.
        returns string to stdout if item already in workspace
        """
        # todo: figure out what to do if item is already loaded in workspace
        url = "%s/%s/%s" % (self.items_collection.documentsURL, self.items_collection.name, key)
        if rev is not None:
            r = self.items_collection.connection.session.get(url, params={'rev': rev})
        else:
            r = self.items_collection.connection.session.get(url)
        if (r.status_code - 400) < 0:
            if rawResults:
                return r.json()
            wid = self.generate_item_id()
            item = Item(wid, self.items_collection, r.json())
            self.add_item(item)
        else:
            raise KeyError("Unable to find document with _key: %s" % key, r.json())

    def create_new_item(self, item_content=None, save_to_db=False):
        """
        Creates new item and saves it to db if save_to_db=True.
        :return: save to db + stdout
        """
        # todo: add automatic timestamp fields for creation and last modification dates

        # 1. get item content from user
        # the following is a chunk copied from this link in order to get multiline text input
        # https://stackoverflow.com/a/11664675/8787400
        if self.interactive:
            print('Enter content of new item: ')
            sentinel = ''  # ends when the empty string is seen
            new_item_string = '\n'.join(iter(input, sentinel))
            # to check what has been inputted:
            # for x in new_item_string.split('\n'):
            #    print(x)
        else:
            new_item_string = item_content

        # 2. generate workspace id
        wid = self.generate_item_id()

        # 3. create item according to collection's method
        new_item = Item(wid, self.items_collection, {"content": new_item_string})
        print('newly created item with workspace id: ' + new_item.wid)

        # 4. update workspace
        self.items[wid] = new_item

        # 5. save to db if requested
        if save_to_db:
            self.items[wid].save_item_to_db()

    def is_in_workspace(self, obj):
        """
        checks whether object obj is already in workspace
        :param obj: either an Item, or a Topic, or a Graph
        :return: True or False
        """
        # create list of object _id's in workspace
        all_obj_dict = {**self.items, **self.topics, **self.graphs}
        all_obj_ids = [o["_id"] for o in all_obj_dict.values()]
        return obj["_id"] in all_obj_ids

    def add_item(self, item):
        """
        adds an existing Item object to the self.items dict
        :param item: an Item object
        :return:
        """
        # check that item is not already in workspace
        # todo: think whether we might want to duplicate items within workspace
        if self.is_in_workspace(item):
            print('Warning: item with _key ' + item['_key'] + ' already in workspace')
        else:
            # check wid is not already used
            if item.wid in self.items.keys():
                item.wid = self.generate_item_id()
            # add item to workspace
            self.items[item.wid] = item

    def remove_item(self, item_wid, delete_from_db=False):
        """remove item from workspace, and deletes it from db if requested"""
        if item_wid in self.items.keys():
            if delete_from_db:
                self.items[item_wid].delete_item_from_db()
            del self.items[item_wid]
        else:
            print('item not in workspace. Nothing done')

    def diagnostic(self):
        # todo: show for each object whether it is saved to db or not (or maybe changed since fetched)
        self.summary()
        self.list_items(content=True)


class Item(Document):
    """
    item object in IndieK's BLL
    """
    def __init__(self, wid, collection, jsonFieldInit={}):
        # todo: is the empty dict default argument best practice here?
        # todo: I don't know if this use of super() is best practice
        super().__init__(collection, jsonFieldInit)
        self.wid = wid

    def display_item_content(self):
        """
        fetches and displays content field from the item specified by the arguments
        :return: stdout
        """
        content_separator = '-------'
        print("content:\n%s\n%s" % (content_separator, self['content']))
        print(content_separator)

    def delete_item_from_db(self):
        """
        removes item specified by arguments from ArangoDB
        :return: delete from db + stdout
        """
        key = self['_key']
        self.delete()
        print('item ' + key + ' has been deleted from db %s' % self.collection.database)

    def save_item_to_db(self):
        """save item to db"""
        self.save()
        print('item with workspace id %s got assigned _key %s: ' % (self.wid, self["_key"]))

    def edit_item(self, item_content=None, save_to_db=False, interactive=True):
        # todo: run some validation on item_content
        # todo: think of an interactive way of editing existing content
        if interactive:
            print('Enter new content for item: ')
            sentinel = ''  # ends when the empty string is seen
            item_content = '\n'.join(iter(input, sentinel))
        if item_content is not None:
            self['content'] = item_content
        else:
            print('no content was provided, item left unchanged')
        if save_to_db:
            self.save_item_to_db()


"""
The following are functions to consult the database. Not clear yet how to include them into a class.
"""


def search_and_item_string(db, *args):
    """
    performs a full match of all the strings (not case sensitive). Uses AND connector.
    :param db: database object from PyArango driver
    :param args: strings to match in content fields from items in db.
          !NOTE! beginning and end of each string must match beginning and end of words in field
    :return: stdout
    """
    words = ','.join(args)
    aql = 'FOR item IN FULLTEXT(items, "content", "' + words + '") ' \
          'RETURN {key: item._key, content: item.content}'
    query_result = db.AQLQuery(aql, rawResults=True, batchSize=100)
    for item in query_result:
        print("item: %s" % item['key'])
        content_separator = '-------'
        print("content:\n%s\n%s" % (content_separator, item['content']))
        print(content_separator)


def search_or_item_string(db, *args):
    """
    performs a full match of all the strings (not case sensitive). Uses OR connector.
    :param db: database object from PyArango driver
    :param args: strings to match in content fields from items in db.
          !NOTE! beginning and end of each string must match beginning and end of words in field
    :return: stdout
    """
    words = ',|'.join(args)
    aql = 'FOR item IN FULLTEXT(items, "content", "' + words + '") ' \
          'RETURN {key: item._key, content: item.content}'
    query_result = db.AQLQuery(aql, rawResults=True, batchSize=100)
    for item in query_result:
        print("item: %s" % item['key'])
        content_separator = '-------'
        print("content:\n%s\n%s" % (content_separator, item['content']))
        print(content_separator)


def list_topics(collection):
    """
    list topic names and descriptions that are stored in db
    :param collection: topics collection from db
    :return: stdout
    """
    for topic in collection.fetchAll():
        print(topic['name'])
        print(topic['description'])
        print('----------')


if __name__ == "__main__":
    conn = Connection(username="root", password="l,.7)OCR")
    # create workspace
    w1 = Workspace(conn, interactive=False)

    # create new item
    # new_item_content = 'hello\nyou world'
    # w1.create_new_item(new_item_content)

    # fetch existing item from db
    item_key = '174480'
    w1.fetch_item(item_key)

    # save item to db
    item_id = list(w1.items.keys())[0]
    w1.items[item_id].save_item_to_db()
    w1.list_items(content=True)
    w1.diagnostic()
    # create new topic

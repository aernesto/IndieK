# requires the following imports
from pyArango.connection import *
from pyArango.document import Document
import uuid
# connection = Connection(username="root", password="l,.7)OCR")
# sys.path.extend(['/home/radillo/programming/Python/PyArangoTests'])
# from IndieK_functions import *


class Workspace:
    """Main user interface. Items, topics and graphs are loaded from and saved the db from this class"""
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

    def create_new_item(self, item_content=None):
        """
        creates new item and saves it to db.
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
        # 4. update workspace attributes
        self.items[wid] = new_item


class Item(Document):
    """
    item object in IndieK's BLL
    """
    def __init__(self, wid, collection, jsonFieldInit={}):
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

    def delete_item_db(self):
        """
        removes item specified by arguments from ArangoDB
        :return: delete from db + stdout
        """
        item_key = self['_key']
        self.delete()
        print('item ' + item_key + ' has been deleted from db %s' % self.collection.database)

    def save_item_to_db(self):
        # todo: check that with such static method, the item's _key from the workspace gets updated
        self.save()
        print('item with workspace id %s got assigned _key %s: ' % (self.wid, self["_key"]))

    def edit_item(self, item_content, save=False):
        # todo: run some validation on item_content
        self['content'] = item_content
        if save:
            self.save_item_to_db()


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
    new_item_content = 'hello\nyou world'
    w1.create_new_item(new_item_content)

    # checks
    w1.list_items(content=True)

    # save item to db
    item_id = list(w1.items.keys())[0]
    w1.items[item_id].save_item_to_db()
    w1.list_items(content=True)

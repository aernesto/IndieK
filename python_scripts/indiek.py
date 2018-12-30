class Item:
    p1 = 3

    def __init__(self, item_creation_mode):
        """

        :param item_creation_mode: 'interactiveConsole'
        """
        self.content = None  # attribute set by self.create_item()
        self.create_item(item_creation_mode)

    def create_item(self, item_creation_mode):
        if item_creation_mode == "interactiveConsole":
            content = input('please enter item Content: ')
            if self.check_content_input(content):
                self.content = content
        else:
            raise ValueError("item creation mode '{}' not recognized".format(item_creation_mode))

    def check_content_input(self, content):
        """
        todo: write this function
        :param content: item content
        :return: boolean
        """
        return True

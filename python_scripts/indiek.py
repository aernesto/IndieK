class Item:
    def __init__(self, item_creation_mode):
        """
        Item creation
        :param item_creation_mode: 'interactiveConsole'
        """
        self.allowed_creation_modes = {'interactiveConsole'}
        if item_creation_mode not in self.allowed_creation_modes:
            raise ValueError("item creation mode '{}' not recognized".format(item_creation_mode))

        self.content = None  # attribute set by self.create_item()
        self.create_item(item_creation_mode)

    def create_item(self, item_creation_mode):
        if item_creation_mode == "interactiveConsole":
            content = input('please enter item Content: ')
            if self.check_content_input(content):
                self.content = content

    def check_content_input(self, content):
        """
        todo: write this function
        :param content: item content
        :return: boolean
        """
        return True

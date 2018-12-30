if __name__ == '__main__':
    # import sys
    # sys.path.extend(['/home/adrian/Git/GitHub/IndieK/python_scripts'])
    from indiek import *

    # todo: write decorator for all the tests

    # create item with unknown item creation mode
    print('\nentering test 1\n')
    try:
        i1 = Item('blablabla')
    except ValueError as err:
        print(err)
    print('\nexiting test 1\n')

    # create item with known item creation mode
    i2 = Item('interactiveConsole')
    print(i2.content)

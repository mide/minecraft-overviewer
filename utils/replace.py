#python2

import re
import os
from overviewer_core import configParser

if __name__ == '__main__':
    # Parse the overviewer's config file
    my_parser = configParser.MultiWorldParser()
    try:
        my_parser.parse(os.path.expanduser('config.py'))
    except configParser.MissingConfigException as e:
        os.exit(-1)
    config = my_parser.get_validated_config()

    # Open the index.html in the output directory and add the key
    with open(os.path.join(config['outputdir'], 'index.html'), 'r+') as fd:
        content = fd.read()
        replaced = re.sub(r'(https://maps.google.com/maps/api/js)', r'\1' + '?key=' + os.environ['API_KEY'], content)
        fd.seek(0)
        fd.write(replaced)
        fd.truncate()


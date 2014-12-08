import subprocess
import re
import json
from collections import namedtuple

def is_valid(author):
    if 'fail@studentrobotics.org' in author.email:
        return False
    if 'BRIAN' in author.name:
        return False
    return True

DATA_REGEX = re.compile('^\s*(\d+)\t(.*) <(.*)>$')
Author = namedtuple('Author', 'commits name email')

authors = subprocess.check_output(('git', 'shortlog', '-sne'),
                                   universal_newlines=True).splitlines()
authors = [DATA_REGEX.match(line).groups() for line in authors]
authors = [Author(int(commits), name, email)
             for commits, name, email in authors]

authors = [author for author in authors if is_valid(author)]

with open('AUTHORS', 'w') as f:
    for author in authors:
        f.write("{} <{}>\n".format(author.name, author.email))

with open('_data/authors.yml', 'w') as f:
    json.dump([dict(author._asdict()) for author in authors],
              f)


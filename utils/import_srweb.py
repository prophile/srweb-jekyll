import argparse
import yaml
import sys
import re
from itertools import islice

parser = argparse.ArgumentParser()
parser.add_argument('source', help='Path to source file',
                              type=argparse.FileType('r'))
parser.add_argument('-o', '--output', type=argparse.FileType('w'),
                    default=sys.stdout, help='Output file')
parser.add_argument('-l', '--layout', help='Page layout',
                    default='main')
parser.add_argument('-s', '--strip-header', help='Strip header',
                    action='store_true')
arguments = parser.parse_args()

def extract_language(line):
    elements = line.rstrip().split('.')
    if len(elements) > 1:
        return elements[-1]
    return 'python'

PRE_START_REGEX = re.compile('^<pre><code class="override-lang ([a-z0-9_-]+)">(.*)')
def transliterate_markdown(src, dst):
    in_code_block = False
    if arguments.strip_header:
        src = islice(src, 3, None)
    for line in src:
        if line.startswith('~~~'):
            in_code_block = not in_code_block
            if in_code_block:
                language = extract_language(line)
                dst.write('{% highlight ' + language + ' %}\n')
            else:
                dst.write('{% endhighlight %}\n')
        elif line.startswith('</code></pre>'):
            dst.write('{% endhighlight %}\n')
        else:
            ps = PRE_START_REGEX.match(line)
            if ps is not None:
                dst.write('{{% highlight {} %}}\n'.format(ps.group(1)))
                dst.write(ps.group(2))
                dst.write('\n')
            else:
                dst.write(line)

# Parse metadata
metadata = {}
MD_REGEX = re.compile('^//([A-Z_]+)\s*:\s*(.*)\s*$')
while True:
    md_line = arguments.source.readline()
    match = MD_REGEX.match(md_line)
    if match is None:
        break
    if match.group(2):
        metadata[match.group(1)] = match.group(2)

content_type = metadata.get('CONTENT_TYPE', 'markdown')
if content_type not in ('markdown', 'md'):
    print("Tool can only convert Markdown source.", file=sys.stdout)
    exit(1)

yaml_data = {'layout': arguments.layout}
yaml_data['title'] = metadata.get('TITLE', 'Website')
if 'DESCRIPTION' in metadata:
    yaml_data['description'] = metadata['DESCRIPTION']
arguments.output.write('---\n')
yaml.dump(yaml_data, arguments.output, default_flow_style=False)
arguments.output.write('---\n')
transliterate_markdown(arguments.source, arguments.output)


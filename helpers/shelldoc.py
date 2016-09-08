#!/usr/bin/env python3
from __future__ import print_function
import sys
import argparse
import re
import os

# Define a function to print to stderr
def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

class Token(object):
  """
  A class to model a shell construct
  """

  def __init__(self, name, source):
    self.name = name
    self.source = source

  @staticmethod
  def indent(txt, what='  '):
    lines = txt.split('\n')
    lines = [what + line for line in lines if line != '']
    return '\n'.join(lines) + "\n"

  def to_rst(self):
    raise NotImplementedError()

  # Make sorting work
  def __lt__(self, other):
    return self.name < other.name

  # Make uniqueness work
  def __eq__(self, other):
    return self.name == other.name

  def __hash__(self):
    return self.name.__hash__()

class Function(Token):
  """
  A class to model a shell function
  """
  def __init__(self, name, source):
    super(self.__class__, self).__init__(name, source)
    self.args = []
    self.desc = ""
    self.example = ""
    self.code = ""

  def to_rst(self, include_code=True):
    # Set heading
    r = self.name + "()\n" + "#" * (len(self.name) + 2) + "\n\n"
    # Set location
    r += "Defined in ``" + self.source +"``.\n\n"
    # Append description
    r += self.desc
    # Append arguments
    if self.args:
      r += "\nArguments:\n\n"
      for arg in self.args:
        #Insert comma after first word
        words = arg.split(' ')
        words[0] +=","
        arg = ' '.join(words)
        r += "- " + arg + "\n"
    # Append example
    if self.example:
      r += "\nExample::\n\n"
      r += self.indent(self.example)

    # Append code
    #~ if self.code:
      #~ r += "\nImplementation::\n\n"
      #~ r += self.indent(self.code)
    return r

class Global(Token):
  """
  A class to model a shell global variable
  """
  def __init__(self, name, source):
    super(self.__class__, self).__init__(name, source)
    self.desc = ""
    self.defined_in = set()
    self.used_in = set()

  def to_rst(self):
    r = "$" + self.name + "\n" + "#" * (len(self.name) + 1) + "\n\n"
    if self.desc:
      r += self.desc
    else:
      r += "**THIS VARIABLE IS UNDOCUMENTED**"
    if self.source:
      r += ", defined in ``" + self.source +"``.\n\n"
    else:
      r += ".\n\n"
    ref = set()
    ref.update(self.used_in)
    ref.update(self.defined_in)
    ref.discard(self.source)
    if ref:
      r += "Referenced in: \n\n"
      for use in ref:
        r += "- " + use + "\n"
    return r

def parse_args():
  """
  Setup argparse & parse arguments
  """
  parser = argparse.ArgumentParser(description="Extract docstrings from shell scripts. A docstring starts with '##'.")
  parser.add_argument('what', metavar='TYPE', choices=['globals', 'functions'], help="Document 'globals' or 'functions'")
  parser.add_argument('files', metavar='FILE', type=argparse.FileType('r'), nargs='+', help='files to be parsed')
  parser.add_argument('-r', '--regex', help="A regex which specify the valid targets for docstrings")
  parser.add_argument('-p', '--prefix', help="The prefix which should be ignored in referencing the source")
#  parser.add_argument('-o', '--outputformat', metavar='FORMAT', default="rst", choices=['rst'], help='Output format, only the default "rst" is currently supported')
#  parser.add_argument('-i', '--index', type=argparse.FileType('w'), help='Path to where the index should be written, if omitted write to STDOUT.')
  return parser.parse_args()

def parse_globals(tokens, fil, path_ignore, regex="[a-zA-Z_]\w*"):
  """
  Parse all global docsrings
  """

  regex_global_def = ".*\s+(" + regex + ")="
  regex_global_use = ".*\$\{?(" + regex + ")[\}:\"\s]"
  regex_global_doc = "\s*##\$(" + regex + ")\s+(.*)"

  filename = os.path.abspath(fil.name)[path_ignore:]

  for line in fil.readlines():
    is_global_def = re.match(regex_global_def, line)
    is_global_use = re.match(regex_global_use, line)
    is_global_doc = re.match(regex_global_doc, line)

    if is_global_doc:
      if not is_global_doc.group(1) in tokens:
        tokens[is_global_doc.group(1)] = Global(is_global_doc.group(1), filename)
      if tokens[is_global_doc.group(1)].desc:
        eprint("WARNING: redefined '%s'. Skipping a definiton." % is_global_doc.group(1))
        return
      tokens[is_global_doc.group(1)].desc = is_global_doc.group(2)
      tokens[is_global_doc.group(1)].source = filename
    if is_global_def:
      if not is_global_def.group(1) in tokens:
        tokens[is_global_def.group(1)] = Global(is_global_def.group(1), '')
      tokens[is_global_def.group(1)].defined_in.add(filename)
    if is_global_use:
      if not is_global_use.group(1) in tokens:
        tokens[is_global_use.group(1)] = Global(is_global_use.group(1), '')
      tokens[is_global_use.group(1)].used_in.add(filename)

  # Remove the global variables defined by the shell
  for k in ['PATH', 'PWD', 'LANG', 'LC_ALL', 'USER']:
    if k in tokens:
      del tokens[k]

def parse_functions(tokens, fil, path_ignore, regex="\w+"):
  """
  Parse all function docstrings
  """

  regex_begin = r"(" + regex + ")\(\)\s+[\{\(]\s*$"
  regex_end = r'[\}\)]\s*$'
  regex_doc = r'\s*##(.*)$'

  filename = os.path.abspath(fil.name)[path_ignore:]

  this_function = None
  for line in fil.readlines():
    is_begin = re.match(regex_begin, line)
    is_end = re.match(regex_end, line)
    is_doc = re.match(regex_doc, line)
    is_empty = re.match(r"\s*$", line)

    if is_empty:
      continue
    elif is_begin:
      this_function = Function(is_begin.group(1), filename)
      this_function.code += line
    elif is_end and this_function:
      this_function.desc.strip()
      this_function.example.strip()
      this_function.code += line
      tokens[this_function.name] = this_function
      this_function = None
    elif is_doc and this_function:
      identifier = is_doc.group(1)[0]
      if identifier == '>': # Must be an example
        this_function.example += is_doc.group(1)[1:].strip() + "\n"
      elif re.match(r"\$\d+", is_doc.group(1)): # Must be an argument
        this_function.args.append(is_doc.group(1))
      elif identifier != '$': # it's the description
        this_function.desc += is_doc.group(1).strip() + "\n"
    elif this_function: #It's must be code
        this_function.code += line

def main():
  """
  Main function
  """
  args = parse_args()

  tokens = dict()

  prefix_len = 0
  if args.prefix:
    prefix_len = len(os.path.abspath(args.prefix)) + 1

  parse=None
  if args.what == 'functions':
    parse = parse_functions
  elif args.what == 'globals':
    parse = parse_globals

  # Process inputs
  for fil in args.files:
    if args.regex:
      parse(tokens, fil, prefix_len, args.regex)
    else:
      parse(tokens, fil, prefix_len)

  # Generate output
  for key in sorted(tokens.keys()):
    print(tokens[key].to_rst())

#  # Generate output using source/function
#  sources = set([token.source for token in tokens.values()])
#  for source in sorted(sources):
#    if source:
#      title = "Defined in %s" % source
#    else:
#      title = "Unknown definitions"
#    title += '\n' + '-' * len(title) +"\n"
#    print(title)
#    for key in sorted(tokens.keys()):
#      if tokens[key].source == source:
#        print(tokens[key].to_rst())

if __name__ == '__main__':
  main()

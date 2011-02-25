#  WhatsApp History
#  Copyright (C) 2010, Stefan Graupner
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os, sys, re, zipfile, tempfile, time, codecs, shutil
from datetime import datetime
from mako.template import Template
from mako.lookup import TemplateLookup

class Message:
  def __init__(self, timestamp, author, text):
    self.timestamp = timestamp
    self.author    = author
    self.text      = text

class Month:
  days = []

  def __init__(self, number, year, name):
    self.number = number
    self.year   = year
    self.name   = name

  def day(self, d):
    self.days.append(d)

class Day:
  messages = []

  def __init__(self, number):
    self.number = number

  def message(self, m):
    self.messages.append(m)

# get folder or zip file
if len(sys.argv) >= 2:
  base=sys.argv[1]
else:
  print 'Usage: ./whatsapphistory.py <whatsappfolderorzipfile> [destinationfolder]'
  sys.exit()

# determine destination
if len(sys.argv) == 3:
  dest = os.path.realpath(sys.argv[2])
else:
  dest = os.path.join(os.getcwd(), 'dest')
if os.path.exists(os.path.join(dest, 'assets')) == False:
  os.makedirs(os.path.join(dest, 'assets'))

# check for zip and unpack into temp folder
isZip = False
if base.endswith('.zip'):
  print 'Extracting Zip File.'
  isZip = True
  temp = tempfile.mkdtemp()
  zip = zipfile.ZipFile(base)
  zip.extractall(temp)
  zip.close()
else:
  temp = base

print 'Generating refurbished WhatsApp History in',dest

# find the chatlog and parse it line-by-line
print 'Locating the chatlog file and parsing it...'
dirlist = os.listdir(temp)
messages = []
for file in dirlist:
  if file.endswith('.txt'):
    log = codecs.open(os.path.join(temp, file), encoding='utf-8', mode='r')
    lines = log.readlines()
    log.close()

    for line in lines:
      linedata = re.split('^.*?(?=[0-9/: a-zA-Z]+)((?:[0-9/]*) (?:[0-9:]+ (?:AM|PM))): ([a-zA-Z ]+): (.*\n)', line, re.DOTALL)

      """
      lineData[0]: empty
      lineData[1]: timestamp
      lineData[2]: author
      lineData[3]: message
      lineData[4]: empty
      """

      if len(linedata) == 5:
        stamp = re.sub(r'^((?:[0-9]?)(?=/)(?:[0-9/]+))', r'0\1', linedata[1])
        stamp = re.sub(r'^([0-9]{2})/((?:[0-9]?)(?=/)(?:[0-9/]+))', r'\1/0\2', stamp)
        stamp = re.sub(r'^((?:[0-9/]*)) ([0-9]?)(?=:)((?:[0-9:]+ (?:AM|PM)))', r'\1 0\2\3', stamp)
        timestamp = datetime.strptime(stamp, '%m/%d/%y %I:%M:%S %p')

        messages.append(Message(timestamp, linedata[2].strip(), linedata[3].strip()))
print 'Done.'

# parse messages into history
print 'Rendering the messages and attachments...'
messages.reverse()

pmessages = ''
copy = []

tlookup  = TemplateLookup(['templates'], output_encoding='utf-8', encoding_errors='replace')
for message in messages:
  tmessage = tlookup.get_template('message.mako')
  mcontent = ''

#  if (message.text.find('vCard attached') > 0):
#    # insert vcard info
#    vcard = message.text.replace('vCard attached: ', '')
#    print vcard

  if (message.text.find('.jpg <attached>') > 0):
    # copy image and replace <attached> string with image link
    image = re.sub(r'^([a-zA-Z0-9]+\.jpg) <attached>', r'\1', message.text)
    copy.append(image)
    mcontent = '<img src="assets/{0}" />'.format(image)
  else:
    mcontent  = message.text

  pmessages += tmessage.render_unicode(author=message.author, \
                                       timestamp=message.timestamp, \
                                       text=mcontent)
print 'Done.'

print 'Copying assets...'
for f in copy:
  shutil.copy(os.path.join(temp, f), os.path.join(dest, 'assets'))

shutil.copy(os.path.join('templates', 'style.css'), os.path.join(dest, 'assets'))
print 'Done'

print 'Generating the final html...'
tout = tlookup.get_template('full.mako')
of = codecs.open(os.path.join(dest, 'index.htm'), encoding='utf-8', mode='w')
of.write(tout.render_unicode(messages=pmessages))
of.close()
print 'Done.'

# clean temp folder
if isZip:
  print 'Cleaning Zip-Temp'
  for f in os.listdir(temp):
    fp = os.path.join(temp, f)
    try:
      if os.path.isfile(fp):
          os.unlink(fp)
    except:
      print 'Could not completely delete temporary files. Temp folder was',temp


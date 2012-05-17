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
import vobject
from datetime import datetime
from mako.template import Template
from mako.lookup import TemplateLookup
import Image

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

    i = 0
    for line in lines:
      if line != u'\r\n':
        linedata = re.split('^.*?([0-9/]{10}\s+?[0-9:]{8}):\s+?([\w ]+):\s+?(.*?)$', line, re.DOTALL)
        if len(linedata) != 5 and i > 0:
          messages[i-1].text += u'<br /><br />' + line
        else:
          timestamp = datetime.strptime(linedata[1].strip(), '%d/%m/%Y %H:%M:%S')
          current = Message(timestamp, linedata[2].strip(), linedata[3].strip())
          messages.append(current)
          i+=1

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

  if (re.match(r'vCard attached: ', message.text) != None):
    vcfile = re.sub(r'^vCard attached: (.*)$', r'\1', message.text)
    copy.append(vcfile)
    vcfd = codecs.open(os.path.join(temp, vcfile), encoding='utf-8', mode='r')

    vcard = vobject.readOne(vcfd.read())
    tvcard = tlookup.get_template('vcard.mako')

    try:
      vemail = vcard.email.value
    except:
      vemail = ''

    mcontent = tvcard.render_unicode(name=vcard.fn.value, email=vemail, card=vcfile)
    vcfd.close()

  elif (message.text.find('.jpg <attached>') > 0):
    image = re.sub(r'^([a-zA-Z0-9]+\.jpg) <attached>', r'\1', message.text)
    copy.append(image)

    imeta = Image.open(os.path.join(temp, image))
    width, height = imeta.size

    mcontent = '<div class="img" style="width:{1}px;height:{2}px;">'
    mcontent+= '<a href="assets/{0}" class="thickbox">'
    mcontent+= '<img src="assets/{0}" width="{1}" height="{2}" /></a></div>'
    mcontent = mcontent.format(image, int(width*0.33), int(height*0.33))

  # quicktime movies, need to use embed
  elif (message.text.find('.MOV <attached>') > 0) or (message.text.find('.mov <attached>') > 0):
    movie = re.sub(r'^([a-zA-Z0-9]+\.(mov|MOV)) <attached>', r'\1', message.text)
    copy.append(movie)

    mcontent  = '<embed src="assets/{0}" loop="false" pluginspage="http://www.apple.com/quicktime/" />'
    mcontent += '<br /><br /><a href="assets/{0}" target="_blank">Open video in new window.</a>'
    mcontent = mcontent.format(movie)

  else:
    mcontent  = message.text

  pmessages += tmessage.render_unicode(author=message.author, \
                                       timestamp=message.timestamp, \
                                       text=mcontent)
print 'Done.'

print 'Copying assets...'
for f in copy:
  shutil.copy(os.path.join(temp, f), os.path.join(dest, 'assets'))

shutil.copy(os.path.join('templates', 'jquery.pack.js'), os.path.join(dest, 'assets'))
shutil.copy(os.path.join('templates', 'thickbox-compressed.js'), os.path.join(dest, 'assets'))
shutil.copy(os.path.join('templates', 'loadingAnimation.gif'), os.path.join(dest, 'assets'))
shutil.copy(os.path.join('templates', 'thickbox.css'), os.path.join(dest, 'assets'))

shutil.copy(os.path.join('templates', 'vcard.png'), os.path.join(dest, 'assets'))

shutil.copy(os.path.join('templates', 'bg.png'), os.path.join(dest, 'assets'))
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


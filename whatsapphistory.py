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

import os, sys, re, zipfile, tempfile, time
from datetime import datetime
from mako.template import Template

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
  if os.path.exists(dest) == False:
    os.makedirs(dest)
else:
  dest = os.getcwd()

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
dirlist = os.listdir(temp)
for file in dirlist:
  if file.endswith('.txt'):
    log = open(os.path.join(temp, file), 'r')
    lines = log.readlines()
    log.close()
    messages = []
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

        messages.append(Message(timestamp, linedata[2], linedata[3]))

    # break messages into months and days
    months = []
    for message in messages:
      if len(months) == 0:
        nmonth = Month(message.timestamp.month, message.timestamp.year, datetime.strftime(message.timestamp, '%B'))
        nday   = Day(message.timestamp.day)

        nday.message(message)
        nmonth.day(nday)
        months.append(nmonth)
      else:
        for month in months:
          if month.number == message.timestamp.month & month.year == message.timestamp.year:
            for day in month.days:
              if day.number == message.timestamp.day:
                day.message(message)
              else:
                nday = Day(message.timestamp.day)
                nday.message(message)
                month.day(nday)
              break
          else:
            nmonth = nday = None
            nmonth = Month(message.timestamp.month, message.timestamp.year, datetime.strftime(message.timestamp, '%B'))
            nday = Day(message.timestamp.day)
            nday.message(message)
            nmonth.day(nday)
            months.append(nmonth)
          break

    # parse into templates
    monthfiles = []
    for month in months:
      dayfiles = []


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


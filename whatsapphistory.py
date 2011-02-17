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
from mako.template import Template

class Message:
  pass

class Month:
  pass

class Day:
  pass

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
    for line in lines:
      lineData = re.split('^((?:[0-9/]*) (?:[0-9:]+ (?:AM|PM))): ([a-zA-Z ]+): (.*\n)', line, re.DOTALL)

      """
      lineData[0]: empty
      lineData[1]: timestamp
      lineData[2]: author
      lineData[3]: message
      lineData[4]: empty
      """

      messages = []
      for index, data in enumerate(lineData):
        message = Message()
        if index == 1:
          # fix date format
          data = re.sub(r'^((?:[0-9]?)(?=/)(?:[0-9/]+))', r'0\1', data)
          data = re.sub(r'^([0-9]{2})/((?:[0-9]?)(?=/)(?:[0-9/]+))', r'\1/0\2', data)
          data = re.sub(r'^((?:[0-9/]*)) ([0-9]?)(?=:)((?:[0-9:]+ (?:AM|PM)))', r'\1 0\2\3', data)

          message.timestamp = time.strptime(data, '%m/%d/%y %I:%M:%S %p')

        if index == 2:
          message.author = data

        if index == 3:
          message.text = data

        messages.append(message)

      # break messages into months and days
      months = []
      for message in messages:
        for month in months:
          if month.number == message.timestamp.monthinyear():
            for day in month.days
              if day.number == message.timestamp.dayinmonth():
                day.messages.append(message)
              else:
                nday = Day()
                nday.messages = []
                nday.number = message.timestamp.dayinmonth()

                nday.messages.append(message)
                month.days.append(day)
          else:
            nmonth = Month()
            nday   = Day()

            nmonth.number = message.timestamp.monthinyear()
            nmonth.name   = time.strftime(message.timestamp, '')
            nmonth.days   = []

            nday.messages = []
            nday.number   = message.timestamp.dayinmonth()

            nday.messages.append(message)
            nmonth.days.append(day)
            months.append(nmonth)


      #for message in messages:


# clean temp folder
if isZip:
  for f in os.listdir(temp):
    fp = os.path.join(temp, f)
    try:
      if os.path.isfile(fp):
          os.unlink(fp)
    except:
      print 'error.'

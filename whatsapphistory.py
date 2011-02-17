#!/usr/bin/python
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

import os, sys, re, zipfile, tempfile, datetime, time

# get folder or zip file
if len(sys.argv) >= 2:
  base=sys.argv[1]
else:
  print "Usage: ./whatsapphistory.py <whatsappfolderorzipfile> [destinationfolder]",
  sys.exit()

# determine destination
if len(sys.argv) == 3:
  dest=sys.argv[2]
else:
  dest=""

# check for zip and unpack into temp folder
# if base.find(".zip", len(base)-5) > 0:
#   print "Extracting Zip File."
#   isZip = True
#   temp = tempfile.mkdtemp()
#   zip = zipfile.ZipFile(base)
#   zip.extractall(temp)
#   zip.close()
# else:
#   temp = base

temp = os.getcwd()

# find the chatlog and parse it line-by-line
dirlist = os.listdir(temp)
for file in dirlist:
  if file.find('.txt', len(file)-5) > 0:
    log = open(os.path.join(temp, file), 'r')
    lines = log.readlines()
    log.close()
    for line in lines:
      lineData = re.split('^((?:[0-9/]*) (?:[0-9:]+ (?:AM|PM))): ([a-zA-Z ]+): (.*\n)', line, re.DOTALL)
      # lineData[0]: empty
      # lineData[1]: timestamp
      # lineData[2]: author
      # lineData[3]: message
      # lineData[4]: empty

      for index, data in enumerate(lineData):
        timestamp, author, message = 0, 0, 0
        if index == 1:
          # fix date format
          data = re.sub(r'^((?:[0-9]?)(?=/)(?:[0-9/]+))', r'0\1', data)
          data = re.sub(r'^([0-9]{2})/((?:[0-9]?)(?=/)(?:[0-9/]+))', r'\1/0\2', data)
          data = re.sub(r'^((?:[0-9/]*)) ([0-9]?)(?=:)((?:[0-9:]+ (?:AM|PM)))', r'\1 0\2\3', data)

          timestamp = time.strptime(data, '%m/%d/%y %I:%M:%S %p')
        if index == 2:
          author = data

        if index == 3:
          message = data


# clean temp folder
#if isZip:
#  for f in os.listdir(temp):
#    fp = os.path.join(temp, f)
#    try:
#      if os.path.isfile(fp):
#          os.unlink(fp)

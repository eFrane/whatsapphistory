#!/usr/bin/python
import os, sys, re, zipfile, tempfile

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
if base.find(".zip", len(base)-5) > 0:
  print "Extracting Zip File."
  isZip = True
  temp = tempfile.mkdtemp()
  zip = zipfile.ZipFile(base)
  zip.extractall(temp)
  zip.close()
else:
  temp = base

# find the chatlog and parse it line-by-line
dirlist = os.listdir(temp)
for file in dirlist:
  if file.find(".txt", len(file)-5) > 0:
    log = open(os.path.join(temp, file), 'r')
    lines = log.readlines()
    log.close()
    for line in lines:
      print line

# clean temp folder
#if isZip:
#  for f in os.listdir(temp):
#    fp = os.path.join(temp, f)
#    try:
#      if os.path.isfile(fp):
#          os.unlink(fp)

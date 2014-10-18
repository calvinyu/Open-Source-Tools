#!/usr/bin/python

import csv
with open("WebExtract.txt") as csvfile:
  r = csv.reader(csvfile)
  for row in r:
    for (i, c) in enumerate(row):
      row[i] = c.strip().replace(',', ';')
    print ','.join(row)

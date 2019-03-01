from os import walk
import csv

mypath = "pre_process"

for root, dirs, files in walk(mypath):
   files.sort()
   for file in files:
        print(file +", ," )
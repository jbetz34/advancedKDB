import csv
from pyq import q

file_input= input("Enter path to csv: ")
table= input("Enter table name: ")

with open(file_input) as csv_file:
    csv_reader = csv.reader(csv_file,delimiter=',')
    for row in csv_reader:
        print(row);


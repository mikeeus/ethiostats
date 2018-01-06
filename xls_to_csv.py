import xlrd
import csv
import sys
import string

# Converts xls and xlsx spreadsheets from 'static/records/source/` to csv
def csv_from_excel():
    source_path = 'static/records/source/'
    csv_path = 'static/records/csv/'

    args_length = len(sys.argv)

    if args_length == 1:
        print("Error: must provide at least source filename as an argument.")
        return

    source_filename = sys.argv[1]
    ext = source_filename.split('.')[1]
    if ext != 'xls' and ext != 'xlsx':
        print(string.Template("Error: expecting .xls or .xlsx file extension, but got '$ext'.").substitute(ext=ext))
        return

    # sheet name
    if args_length > 2:
        sheet_name = sys.argv[2]
    else:
        sheet_name = 'Sheet1'

    # output filename
    if args_length > 3:
        output_filename = sys.argv[3]
    else:
        output_filename = source_filename.replace(ext, 'csv')

    # open file and convert to csv
    workbook = xlrd.open_workbook(source_path + source_filename)
    sheet = workbook.sheet_by_name(sheet_name)
    csv_file = open(csv_path + output_filename, 'w')
    writer = csv.writer(csv_file, quoting=csv.QUOTE_ALL)

    for rownum in range(sheet.nrows):
        writer.writerow(sheet.row_values(rownum))

    csv_file.close()

csv_from_excel()
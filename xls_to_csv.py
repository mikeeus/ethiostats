import xlrd
import csv
import sys

# Converts xls and xlsx spreadsheets from 'static/records/source/` to csv
def csv_from_excel():
    source_path = 'static/records/source/'
    csv_path = 'static/records/csv/'

    args_length = len(sys.argv)

    if args_length == 1:
        print("Error: must provide at least source filename as an argument.")
        return

    source_filename = sys.argv[1]

    if args_length > 2:
        sheet_name = sys.argv[2]
        if args_length > 3:
            output_filename = sys.argv[3]
        else:
            ext = source_filename.split('.')[1]
            output_filename = source_filename.replace(ext, 'csv')
    else:
        sheet_name = 'Sheet1'

    workbook = xlrd.open_workbook(source_path + source_filename)
    sheet = workbook.sheet_by_name(sheet_name)
    csv_file = open(csv_path + output_filename, 'w')
    writer = csv.writer(csv_file, quoting=csv.QUOTE_ALL)

    for rownum in range(sheet.nrows):
        writer.writerow(sheet.row_values(rownum))

    csv_file.close()

csv_from_excel()
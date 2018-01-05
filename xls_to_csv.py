import xlrd
import csv

def csv_from_excel():
  wb = xlrd.open_workbook('static/records/source/HSProducts.xls')
  sh = wb.sheet_by_name('HS Nomenclature')
  csv_file = open('static/records/csv/hscodes.csv', 'w')
  wr = csv.writer(csv_file, quoting=csv.QUOTE_ALL)

  for rownum in range(sh.nrows):
      wr.writerow(sh.row_values(rownum))

  csv_file.close()

csv_from_excel()
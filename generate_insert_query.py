#Aid used to extract data from files and to prepare SQL insert values queries.

import os              

def check_column(msg, column_mapping, key, delimiter = ":"):
    '''
    Given a string (msg) verify that it contains data (key - value separated by delimiter) 
    and if it starts with desired value (column_mapping[key])
    Output value that is stored in that string
    '''
    if delimiter in msg:
        if msg[0:len(column_mapping[key])] == column_mapping[key]:
            return msg[len(column_mapping[key])+2:].replace('\n', '')
    return False

def gen_sql_query(file_path, table_name, column_mapping, column_trim, column_with_qm):
    '''
    Function that goes through all files in location given by relative path (file_path) and compiles from each file row to be inserted into desired table
    '''
    wd = os.path.abspath(os.getcwd())
    wd += file_path

    sql_query  = f"""INSERT INTO {table_name} ({','.join(column_mapping.keys())}) 
    VALUES"""
    vals = []
    for file in os.listdir(wd):
        f = open(f"{wd}/{file}", "r")
        val = {}
        for line in f:
            for k in column_mapping.keys(): 
                if check_column(line, column_mapping, k):
                    val[k] = check_column(line, column_mapping, k)
        vals.append(val)
        f.close()
    print(vals)
    for val in vals:
        sql_query += f"""
("""
        for k in column_mapping.keys():
            column_value = val[k]

            if k in column_with_qm:
                column_value = column_value.replace("'", "''")
                sql_query += "'"

            
            if k in  column_trim:
                column_value = val[k].split(" ")[0] 
            sql_query += column_value 

            if k in column_with_qm:
                sql_query += "'"
            
            sql_query += ","

        sql_query = sql_query[:-1]
        sql_query += f"),"
    sql_query = sql_query[:-1] + ';'
    return sql_query



file_path = "/finance/receipts_from_last_night"
table_name = "EXPENSES_tmp"
column_mapping = { "employee_name": "Employee"
                  ,"unit_price": "Unit Price"
                  ,"quantity": "Quantity"   
                    } 
column_trim = []
column_with_qm = ["employee_name"] 

print(gen_sql_query(file_path, table_name, column_mapping, column_trim, column_with_qm))



file_path = "/finance/invoices_due"
table_name = "INVOICE_tmp"
column_mapping = { "supplier": "Company Name"
                  ,"invoice_ammount": "Invoice Amount"
                  ,"months_due": "Due Date"   
                }
column_trim = ["months_due"]
column_with_qm = ["supplier"] 

print(gen_sql_query(file_path, table_name, column_mapping, column_trim, column_with_qm))

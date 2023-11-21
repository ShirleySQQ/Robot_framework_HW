*** Settings ***
Resource  ../resources/common.robot

#Suite Setup  Connect To Database  pymssql  ${DB_NAME}  integrated_security='sspi' server=${DB_SERVER}
Library  DatabaseLibrary
#Library  OperatingSystem
#Library  PythonLibrary

*** Test Cases ***
Simple Test Case
    Log  This is a simple test case
DB Test HR.Employees
   Connect To SQL Server With Windows Authentication
   #Checking HR.Employees table records count is Correct
   #${result} =
   Checking HR.Employees table  ${sql_str_empOne}[0]  ${sql_str_empOne}[1]
   #should be equal as strings  ${result}  40
   #Checking hr.employees table's column number is 10
   Checking HR.Employees table  ${sql_str_empTwo}[0]  ${sql_str_empTwo}[1]
   #should be equal as strings  ${result}  10
   Disconnect From SQL Server

DB Test HR.Departments One
   Connect To SQL Server With Windows Authentication
   ${get_all} =  Checking department_id is unique  ${sql_str_depOne}
   ${get_distinct} =  Checking department_id is unique  ${sql_str_deptwo}
   should be equal as strings  ${get_all}  ${get_distinct}
   Disconnect From SQL Server

DB Test HR.Departments Two
   Connect To SQL Server With Windows Authentication
   run keyword and ignore error  Checking cannot insert column value more than max length
   Disconnect From SQL Server

DB Test HR.sales_data One
   Connect To SQL Server With Windows Authentication
   ${get_negative_sum} =  Checking sales_data negagive  ${sql_str_SalesOne}
   ${get_distinct} =  Checking sales_data negagive   ${sql_str_SalesTwo}
   should be true  ${get_negative_sum}/${get_distinct} < ${sales_negative_rate_up}
   Disconnect From SQL Server

DB Test HR.sales_data Two
   Connect To SQL Server With Windows Authentication
   Checking sales_data dollerSign
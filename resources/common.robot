*** Keywords ***
Common Keyword
    Log  This is common Keyword
Connect To SQL Server With Windows Authentication
    ${connection}=  evaluate  pymssql.connect(server='${DB_SERVER}', database='${DB_NAME}')
    Set Global Variable  ${connection}

Checking HR.Employees table
    [Arguments]  ${query}  ${expected_result}
    ${cursor}=  Call Method  ${connection}  cursor
    Call Method  ${cursor}  execute  ${query}
    ${results}=  Call Method  ${cursor}  fetchone
    Log  ${results}
    should be equal as strings  ${results}[0]  ${expected_result}
    #[Return]  ${results}[0]

Checking department_id is unique
    [Arguments]  ${query}
    ${cursor}=  Call Method  ${connection}  cursor
    Call Method  ${cursor}  execute  ${query}
    ${result}=  Call Method  ${cursor}  fetchone
    Log  ${result}
    [Return]  ${result}[0]


Checking cannot insert column value more than max length
    ${cursor}=  Call Method  ${connection}  cursor
    Call Method  ${cursor}  execute  ${sql_insert_dep_fail}
    ${result} =  Call Method  ${cursor}
    Log  ${result}


Checking sales_data negagive
  [Arguments]  ${query}
  ${cursor} =  Call Method  ${connection}  cursor
  Call Method  ${cursor}  execute  ${query}
  ${result} =  Call Method  ${cursor}  fetchone
  Log  ${result}
  [Return]  ${result}[0]

Checking sales_data dollerSign
  ${cursor} =  Call Method  ${connection}  cursor
  Call Method  ${cursor}  execute   ${sql_srt_Sales_Three}
  ${result} =  Call Method  ${cursor}  fetchone
  Log  ${result}
  should be equal as strings  ${result}[0]  ${sales_amount_expectedChar}

Disconnect From SQL Server
    Call Method  ${connection}  close

*** Variables ***
${COMMON_VARIABLE}  This is a commom variable
${DB_SERVER}       EPCNSZXW0007\\SQLEXPRESS        # Replace 'server' with your SQL Server address or hostname
${DB_NAME}         TRN                            # Replace 'database_name' with the name of the database you want to connect to
${schema}    hr
@{table_name}  employees  |   sales
${sql_str_depOne}  select count(department_id) as all_count from HR.Departments
${sql_str_deptwo}  select count(distinct department_id) as dis_count from HR.Departments
@{sql_str_empOne}  SELECT count(*) as emoloyee_count FROM hr.employees  40
@{sql_str_empTwo}  SELECT count(*) as row_num from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA='hr' and TABLE_NAME='employees'  10
${sql_insert_dep_fail}  insert into HR.Departments values('A data organization leader is upset ',1800)
${sql_str_SalesOne}  select count(distinct customerId) as neg_count from HR.sales_data group by customerId having sum(cast(replace(amount,'$','') as int))<0
${sql_str_SalesTwo}  select count(distinct customerId) as all_count from HR.sales_data
${sales_negative_rate_up}  0.1
${sql_srt_Sales_Three}  select distinct (right(amount,1)) as end_char from HR.sales_data
${sales_amount_expectedChar}  $
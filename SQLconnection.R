#install.packages("odbc")
con <- DBI::dbConnect(odbc::odbc(),
                      Driver   = "SQL Server",
                      Server   = "ber-rest-aloha-data-sql.database.windows.net",
                      Database = "ber-rest-aloha-data-db",
                      UID      = rstudioapi::askForPassword("Database user"),
                      PWD      = rstudioapi::askForPassword("Database password"),
                      Port     = 1433)
#install.packages("dbplyr")

#setting up the environment
library(dplyr)
library(DBI)
library(dplyr)
library(dbplyr)
library(odbc)

#list of all tables
dbListTables(con)

#more documentation avilable at https://db.rstudio.com/odbc/


#query using DBI
#dbSendQuery(con, "SELECT COUNT (*) FROM Address")
#data <- dbReadTable(con, "Guest")


#complete List of tables & schemas

rs <- dbSendQuery(con, "SELECT SCHEMA_NAME(schema_id) As SchemaName, name As TableName FROM sys.tables;")
dbFetch(rs)

#trying with the Aloha Rest table
#DF_db <- tbl(con, SQL("dbo.Ber_Aloha_Rest_data_Log"))
dbGetQuery(con, "SELECT COUNT(*) FROM dbo.Ber_Aloha_Rest_data_Log")

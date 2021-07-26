# DataFlowAnalyzer
Collects the end-to-end column-level data lineage in the Data Warehouses environment 
by analyzing SQL script especially stored procedure like PL/SQL.

This tool introduces a new [data lineage model](sqlflow-data-lineage-model-reference.pdf) 
that is compatible with the Apache Atlas type system to describle the data flow of table/columns. 

This tool is built from the scratch, it is the main part of the backend of [the SQLFlow Cloud](https://sqlflow.gudusoft.com).


## Usage
```
Usage: java DataFlowAnalyzer [/f <path_to_sql_file>] [/d <path_to_directory_includes_sql_files>] [/stat] [/s [/text] ] [/i] [/ic] [/lof] [/j] [/json] [/traceView] [/t <database type>] [/o <output file path>] [/version] [/h <host> /P <port> /u <username> /p <password> /db <database> [/metadata]]
/f: Optional, the full path to SQL file.
/d: Optional, the full path to the directory includes the SQL files.
/j: Optional, return the result including the join relation.
/s: Optional, simple output, ignore the intermediate results.
/i: Optional, the same as /s option, but will keep the resultset generated by the SQL function.
/if: Optional, keep all the intermediate resultset, but remove the resultset generated by the SQL function
/ic: Optional, ignore the coordinates in the output.
/lof: Option, link orphan column to the first table.
/traceView: Optional, only output the name of source tables and views, ignore all intermedidate data.
/text: Optional, this option is valid only /s is used, output the column dependency in text mode.
/json: Optional, print the json format output.
/stat: Optional, output the analysis statistic information.
/tableLineage: Optional, output tabel level lineage.
/t: Option, set the database type. Support access,bigquery,couchbase,dax,db2,greenplum,hana,hive,impala,informix,mdx,mssql,
sqlserver,mysql,netezza,odbc,openedge,oracle,postgresql,postgres,redshift,snowflake,
sybase,teradata,soql,vertica
, the default value is oracle
/o: Optional, write the output stream to the specified file.
/log: Optional, generate a dataflow.log file to log information.
/h: Optional, specify the host of jdbc connection
/P: Optional, specify the port of jdbc connection, note it's capital P.
/u: Optional, specify the username of jdbc connection.
/p: Optional, specify the password of jdbc connection, note it's lowercase P.
/db: Optional, specify the database of jdbc connection.
/schema: Optional, specify the schema which is used for extracting metadata.
/metadata: Optional, output the database metadata information to the file metadata.json.
```


Here is the list of available database after /t option:
```
access,bigquery,couchbase,dax,db2,greenplum,hana,hive,impala,informix,mdx,mssql,
sqlserver,mysql,netezza,odbc,openedge,oracle,postgresql,postgres,redshift,snowflake,
sybase,teradata,soql,vertica
```

## Binary version
https://www.gudusoft.com/gsp_java/dlineage.zip

In order to run this utility, please install Oracle JDK1.8 or higher on your computer correctly.
Then, run this utility like this:

```
java -jar gudusoft.dlineage.jar /t mssql /f path_to_sql_file
```
	
## Resolve the ambiguous columns in SQL query
```sql
select ename
from emp, dept
where emp.deptid = dept.id
```

column `ename` in the first line is not qualified by table name `emp`, so it’s ambiguous to know which table this column belongs to?

If we already created table `emp`, `dept` in the database using this DDL.
```sql
create table emp(
	id int,
	ename char(50),
	deptid int
);

create table dept(
	id int,
	dname char(50)
);
```

By connecting to the database to fetch metadata, column `ename` should be linked to the table `emp` correctly.

This is a list of arguments used when connect to a database:
```
/h: Optional, specify the host of jdbc connection
/P: Optional, specify the port of jdbc connection
/u: Optional, specify the username of jdbc connection.
/p: Optional, specify the password of jdbc connection
/db: Optional, specify the database of jdbc connection
/schema: Optional, specify the schema which is used for extracting metadata.
```

When you use this feature, you should put the jdbc driver to your java classpath, and use java -cp command to load the jdbc driver jar.

Currently, gsp able to connect to the following databases with the proper JDBC driver
```
azuresql, greenplum, mysql, netezza, oracle, postgresql, redshift, snowflake, sqlserver, teradata
```



### connect to SQL Server
Tables are under this schema: `AdventureWorksDW2019/dbo`.

```sh
java -cp .;lib/*;external_lib/* demos.dlineage.DataFlowAnalyzer /t mssql /h localhost /P 1433 /u root /p password /schema AdventureWorksDW2019/dbo /f sample.sql /s /json 
```

### connect to Oracle
Tables are under `HR` schema and connect to database using `orcl` instance.

```sh
java -cp .;lib/*;external_lib/* demos.dlineage.DataFlowAnalyzer /t oracle /h localhost /P 1521 /u root /p password /db orcl /schema HR /f sample.sql /s /json 
```

### connect to MySQL
Tables are under `employees` database.

```sh
java -cp .;lib/*;external_lib/* demos.dlineage.DataFlowAnalyzer /t mysql /h localhost /P 3306 /u root /p password /db employees /f sample.sql /s /json 
```


### Releases
- [Ver2.1.2, 2021/07/13] Update readme, illustrates how to connect to database instance in command line.
- [Ver2.1.1, 2021/07/12] Update download, data lineage model document.
- [Ver2.1.0, 2021/07/11] Release gsp core 2.3.1.5

### Links
- [First version, 2017-8](https://github.com/sqlparser/wings/issues/494)
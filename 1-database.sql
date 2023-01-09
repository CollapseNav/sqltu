/*markdown
连接数据库之后的第一步应该是查看有那些库(database)  
使用 `show databases` 可以列出所有数据库
*/

show databases;

/*markdown
出于学习目的, 最好不要修改上面列出的库  
所以我们最好自己建一个新的, 不影响已有的    
使用 `create database 你的数据库名字` 即可创建新的数据库
*/

create database mydb;

/*markdown
建完库之后先使用 `use 数据库名字` 切换到指定的数据库    
然后才能对这个指定的数据库进行更进一步的操作
*/

use mydb;

/*markdown
切换到数据库后可以使用 `show tables` 查看所有的数据表
*/

show tables

/*markdown
如果是新建的数据库, 上面的命令执行之后将不会看到任何数据表  
所以接下来我们使用 `create table` 语句新建一个
*/

create table table1(
    id int PRIMARY KEY,
    name nvarchar(10),
    age int,
    birthday datetime,
    gender bit comment '性别'
)

/*markdown
建表成功后可以再次使用 `show tables` 进行确认
*/

-- show tables
desc table1

/*markdown
在表中没有数据的情况下, 使用 `drop table 需要删除的表名` 可以移除(有数据也可以移除,但是生产环境操作需谨慎)
*/

drop table table1
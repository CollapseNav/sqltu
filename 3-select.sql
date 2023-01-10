use mydb;

/*markdown
查询可能是sql中使用频率最高的操作,这节主要简单介绍下这一点      
查询语句的格式      
```sql
SELECT {需要展示的字段} FROM {表名} WHERE {查询条件}
```
在此之前先创建一个表,并且填充一部分数据
*/

CREATE TABLE userinfo
(
    -- INT 类型的主键, 并且自增
    id INT PRIMARY KEY AUTO_INCREMENT,
    -- 最大20长度的字符串,并且非空必填不能重复
    name VARCHAR(20) NOT NULL UNIQUE KEY,
    -- 短整数类型,默认可为空并且由注释
    age TINYINT COMMENT '人的年龄有限,可以使用短整数',
    -- 日期类型,可为空
    birthday DATE,
    gender TINYINT DEFAULT 0 COMMENT '0 未设置,1 男,2 女',
    -- 高精度类型,总长度18,小数点之前14位,小数点后4位,默认值为0
    money DECIMAL(18,4) DEFAULT 0 COMMENT '默认财产数额为0'
);
INSERT INTO userinfo(name,age,birthday,gender,money) VALUES
                    ('用户名0',10,'2022-01-01',1,23330.0001),
                    ('用户名1',11,'2022-01-01',1,23331.0001),
                    ('用户名2',12,'2022-01-02',1,23332.0001),
                    ('用户名3',13,'2022-01-03',1,23333.0001),
                    ('用户名4',14,'2022-01-04',1,23334.0001),
                    ('用户名5',15,'2022-01-05',1,23335.0001),
                    ('用户名6',16,'2022-01-06',1,23336.0001),
                    ('用户名7',17,'2022-01-07',1,23337.0001),
                    ('用户名8',18,'2022-01-07',1,23338.0001),
                    ('用户名9',19,'2022-01-06',1,23339.0001),
                    ('用户名10',110,'2022-01-01',2,233340.0001),
                    ('用户名11',111,'2022-01-11',2,233341.0001),
                    ('用户名12',112,'2022-01-11',2,233342.0001),
                    ('用户名13',113,'2022-01-13',2,233343.0001),
                    ('用户名14',114,'2022-01-01',2,233344.0001),
                    ('用户名15',115,'2022-01-15',2,233345.0001),
                    ('用户名16',116,'2022-01-06',2,233346.0001);

/*markdown
## 基础使用
*/

/*markdown
使用 * 代表展示所有字段
*/

SELECT * FROM userinfo

/*markdown
使用 `COUNT(1)` 可以**统计**查询出的结果的数量
*/

SELECT COUNT(1) FROM userinfo

/*markdown
可以自己选择需要展示的字段数据      
减少查询返回的数据量        
在数据比较多的情况下可以提升返回结果的速度      
并且可以排除多余字段对视觉的干扰
*/

SELECT name,age FROM userinfo

/*markdown
查询结果的展示列名为建表时设置的字段列,可能不够直观     
自定义字段列名可以有效改善观感      
可以使用 `{字段名} {自定义列名}` 或者 `{字段名} AS {自定义列名}` 进行修改
*/

SELECT name 姓名,age AS 年龄 FROM userinfo

/*markdown
## 添加筛选
*/

/*markdown
很多时候我们并不需要查询出所有数据      
只需要查询满足条件的数据即可        
这时就可以通过 `WHERE` 对查询的数据进行筛选     
多个条件可以用 `AND` `OR` 连接
*/

-- 筛选 年龄 > 15 并且 年龄 < 112 的数据
SELECT name 姓名,age AS 年龄 FROM userinfo
WHERE
    age > 15
AND age < 112

-- 筛选 年龄 > 15 并且 年龄 < 112 或者 金钱 > 233340 的数据
SELECT name 姓名,age AS 年龄 FROM userinfo
WHERE
    age > 15
AND age < 112
OR  money > 233340

/*markdown
## 添加排序
*/

/*markdown
如果对于排序有要求, 可以通过添加 `ORDER BY` 设置排序的依据和升序降序
*/

-- 筛选 年龄 > 15 并且 年龄 < 112
-- 根据 年龄 升序
SELECT name 姓名,age AS 年龄 FROM userinfo
WHERE
    age > 15
AND age < 112
ORDER BY age ASC

-- 筛选 年龄 > 15 并且 年龄 < 112
-- 根据 年龄 降序
SELECT name 姓名,age AS 年龄 FROM userinfo
WHERE
    age > 15
AND age < 112
ORDER BY age DESC

-- 筛选 年龄 > 15 并且 年龄 < 112
-- 根据 金钱 降序
SELECT name 姓名,age AS 年龄,money 金钱 FROM userinfo
WHERE
    age > 15
AND age < 112
ORDER BY money DESC

/*markdown
## 使用分组
*/

/*markdown
有些时候需要对数据进行分组统计,比如对 **性别** 进行分组     
这时候可以使用 `GROUP BY` 分组      
然后可以使用 `COUNT(1)` 统计数量
*/

SELECT name,gender AS 性别 FROM userinfo
WHERE
    age > 15
AND age < 112;
-- 根据 性别 分组统计
SELECT gender AS 性别,COUNT(1) AS 数量 FROM userinfo
WHERE
    age > 15
AND age < 112
GROUP BY gender

/*markdown
需要注意的是,在使用 `GROUP BY` 时只能展示 `GROUP BY` 后面跟着的字段     
比如下面的写法就会产生错误
*/

SELECT name AS 姓名,gender AS 性别,COUNT(1) AS 数量 FROM userinfo
WHERE
    age > 15
AND age < 112
GROUP BY gender

/*markdown
name没有包含在 `GROUP BY` 后面,所以执行失败     
这是由于在对 gender(性别) 进行分组后,无法知道任何与 name 有关的信息     
想象每个 gender 值都有一个箱子,以现有的数据来看就是存在 gender=1 和 gender=2 这两个箱子     
`GROUP BY` 就是将符合条件的数据丢到箱子里       
能够通过 `SELECT` 展示的数据仅仅只有 `GROUP BY` 之后箱子的信息      
比如 其中一个箱子叫1的箱子里面 有几个数据 那些数据相加的和 等
*/

SELECT gender AS 性别,money 金钱 FROM userinfo
WHERE
    age > 15
AND age < 112;
-- 根据 性别 分组统计, 并且展示每个分类中的 money 的和
-- SUM 函数可以可用来求和
SELECT gender AS 性别,COUNT(1) AS 数量,SUM(money) AS 金钱 FROM userinfo
WHERE
    age > 15
AND age < 112
GROUP BY gender

/*markdown
`GROUP BY` 也可以使用多字段分组     
*/

SELECT gender AS 性别,birthday 生日 FROM userinfo
WHERE
    age > 15
AND age < 112;
-- 根据 性别,生日 分组统计
SELECT gender AS 性别,birthday 生日,COUNT(1) AS 数量 FROM userinfo
WHERE
    age > 15
AND age < 112
GROUP BY gender,birthday

drop table userinfo
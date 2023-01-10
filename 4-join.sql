use mydb;

/*markdown
一张表能存的字段是有限的, 而且由于需要根据具体业务来建表, 所以每个表的字段都应该有限且有业务上的意义
*/

-- 用户信息表
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
INSERT INTO userinfo(name,age,birthday,gender,money) 
              VALUES('用户名0',10,'2022-01-01',1,23330.0001),
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
-- 商品表
CREATE TABLE product
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL COMMENT '商品名称',
    price FLOAT NOT NULL COMMENT '单价'
);
INSERT INTO product(name,price) 
              VALUES('农夫山泉',2),
                    ('可口可乐',3),
                    ('百事可乐',3),
                    ('崂山白花蛇草水',4);
-- 用户订单表
CREATE TABLE orders
(
    -- INT 类型的主键, 并且自增
    id INT PRIMARY KEY AUTO_INCREMENT,
    userid INT NOT NULL COMMENT '用户id 根据用户表定',
    productid INT NOT NULL COMMENT '商品id 根据商品表定',
    amount INT NOT NULL COMMENT '数量',
    ordertime DATETIME NOT NULL COMMENT '下单日期'
);
INSERT INTO orders(userid,productid,amount,ordertime)
                VALUES(1,1,10,'2023-01-01 10:00:00')

/*markdown
创建三张表 userinfo:用户表 product:商品表 orders:订单表     
并且初始化了一些数据 
*/

SELECT * FROM userinfo;
SELECT * FROM product;
SELECT * FROM orders;

/*markdown
直接查询得到的结果看起来非常多, 但如果现在只需要获取订单相关的信息, 比如下单人的姓名, 下单的商品名称, 这种单表的查询方式就非常不够了,此时就需要用到联表查询     
在实际使用中, 联表是个非常常用的操作, 有 `inner join` `left join` `right join` 三种, 下面细说
*/

/*markdown
联表语句的格式比较简单
```sql
SELECT {查询的字段} FROM {表1} {INNER JOIN/LEFT JOIN/RIGHT JOIN 三选一} {表2} ON {联表条件} WHERE {筛选条件} {其他} 
```
*/

SELECT * FROM orders INNER JOIN product ON orders.productid = product.id;
SELECT * FROM orders LEFT JOIN product ON orders.productid = product.id;
SELECT * FROM orders RIGHT JOIN product ON orders.productid = product.id;

/*markdown
以上面三条语句为例, 由于查询的主体是订单, 所以将orders表放在前作为 `表1`, `product` 商品表作为 `表2`        
两个表通过 商品表的id 关联, 订单表中的 `productid` 字段是 商品表 的主键值           
*/
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
    amount INT NOT NULL COMMENT '下单数量',
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
直接查询得到的结果看起来非常多, 但如果现在只需要获取订单相关的信息, 比如下单人的姓名, 下单的商品名称, 这种单表的查询方式就非常不够用了,此时就需要用到联表查询     
在实际使用中, 联表是个非常常用的操作, 有 `inner join`/`left join`/`right join` 三种, 下面细说
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
以上面三条语句为例, 由于查询的主体是订单, 所以将orders表放在前作为 `表1`, product商品表作为 `表2`        
两个表通过 `商品表的id` 关联, 订单表中的 `productid` 字段是 商品表 的主键值           
*/

/*markdown
当使用 `RIGHT JOIN` 右联接时, 会以右表(商品表)为基础, 根据 `ON` 后面跟着的条件, 尝试将左表(订单表)的数据和右表(商品表)拼起来          
在现在的这个例子中, 由于只有 **农夫山泉** 有订单, 所以农夫山泉那一行会有订单相关数据, 其他的商品则没有      
下面新增一条其他商品的订单再次测试
*/

INSERT INTO orders(userid,productid,amount,ordertime)
                VALUES(1,2,10,'2023-01-01 10:00:00');
SELECT * FROM orders RIGHT JOIN product ON orders.productid = product.id;

/*markdown
当增加了 **可口可乐** 的订单后, `RIGHT JOIN` 查出的数据中就有对应的订单信息了
*/

/*markdown
如果同一个商品有多个订单, 也是类似的显示
*/

INSERT INTO orders(userid,productid,amount,ordertime)
                VALUES(1,2,10,'2023-01-01 10:00:00'),
                      (2,2,11,'2023-01-01 10:00:00');
SELECT * FROM orders RIGHT JOIN product ON orders.productid = product.id;

/*markdown
`LEFT JOIN` 为左联接, 作用与 `RIGHT JOIN` 相反, 是以左表为主, 将右表拼到左表中
*/

INSERT INTO orders(userid,productid,amount,ordertime)
                VALUES(1,22,10,'2023-01-01 10:00:00'),
                      (2,22,11,'2023-01-01 10:00:00');
SELECT * FROM orders LEFT JOIN product ON orders.productid = product.id;
SELECT * FROM orders RIGHT JOIN product ON orders.productid = product.id;

/*markdown
刚增加的两条订单数据使用的订单id为22, 这个id在商品表中不存在, 所以左联之后的这两条数据没有商品信息      
同理, 在右联接时不会显示新增的两条订单数据
*/

/*markdown
`INNER JOIN` 内联接, 只会显示左表和右表都能匹配的数据
*/

SELECT * FROM orders INNER JOIN product ON orders.productid = product.id;

/*markdown
`商品id=22` 在右表中不存在, 被排除, `商品id=3,商品id=4` 在左表中不存在, 被排除
*/

/*markdown
可以使用多表联接, 新的联表条件接在 `ON` 的条件之后即可
*/

SELECT * FROM orders INNER JOIN product ON orders.productid = product.id
                     INNER JOIN userinfo ON orders.userid = userinfo.id;
SELECT * FROM orders LEFT JOIN product ON orders.productid = product.id
                     LEFT JOIN userinfo ON orders.userid = userinfo.id;
SELECT * FROM orders RIGHT JOIN product ON orders.productid = product.id
                     RIGHT JOIN userinfo ON orders.userid = userinfo.id;

SELECT * FROM orders INNER JOIN product ON orders.productid = product.id
                     LEFT JOIN userinfo ON orders.userid = userinfo.id;
SELECT * FROM orders RIGHT JOIN product ON orders.productid = product.id
                     LEFT JOIN userinfo ON orders.userid = userinfo.id;
SELECT * FROM orders RIGHT JOIN product ON orders.productid = product.id
                     LEFT JOIN userinfo ON orders.userid = userinfo.id;

/*markdown
根据上面的结果可以发现, 不同的联表方式查出来的数据可能会有非常大的差距, 需要根据实际情况合理编排 ~~虽然我基本上没有用过右联接~~
*/

/*markdown
每个表都会有很多字段, 所以在联表查询时可以使用上一节提到的方法, 自定义查询返回的字段
*/

SELECT  orders.id 订单主键
       ,orders.ordertime 下单时间
       ,userinfo.name AS 用户名
       ,product.name  AS 商品名称
       ,orders.amount AS 下单数量
       ,product.price AS 商品单价
FROM orders
INNER JOIN product ON orders.productid = product.id
INNER JOIN userinfo ON orders.userid = userinfo.id;

/*markdown
可以看到, 重新自定义查询字段之后, 输出的结果相对来说更加 **美观**
*/

/*markdown
有些表的名称会非常长, 具体编写的时候会很麻烦      
查询时的字段可以自定义名称, 联表的时候也可以给表自定义别名      
给表加上别名之后的查询语句更加精简, 并且结果不变
*/

SELECT  o.id 订单主键
       ,o.ordertime 下单时间
       ,u.name AS 用户名
       ,p.name  AS 商品名称
       ,o.amount AS 下单数量
       ,p.price AS 商品单价
FROM orders o
INNER JOIN product p ON o.productid = p.id
INNER JOIN userinfo u ON o.userid = u.id;

/*markdown
筛选,分组 之类的功能也可以配合使用
*/

SELECT   p.id AS 商品Id
        ,p.name AS 商品名称
        ,COUNT(1) AS 订单数量
        ,SUM(o.amount) AS 下单总数
        ,SUM(o.amount * p.price) AS 下单总金额
FROM orders o
INNER JOIN product p ON o.productid = p.id
INNER JOIN userinfo u ON o.userid = u.id
WHERE   o.amount <= 10
AND     p.price > 0
GROUP BY p.id,p.name;

/*markdown
上面根据 `商品id` 和 `商品名称` 分组        
使用 `COUNT(1)` 统计每种商品分类的订单数量      
使用 `SUM(o.amout)` 将每种商品分类中所有订单的下单数量相加求和      
使用 `SUM(o.amount * p.price)` 将每种商品分类中所有订单先求出单个订单的金额, 然后将所有订单的金额相加求和
*/

/*markdown
最后删除本节创建的表, 恢复数据库的状态
*/

drop table userinfo;
drop table product;
drop table orders;
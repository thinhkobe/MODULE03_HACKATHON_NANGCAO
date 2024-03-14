create database QUANLYBANHANG;
use QUANLYBANHANG;
create table CUSTOMERS
(
    customer_id varchar(4) primary key,
    name        varchar(100) not null,
    email       varchar(100) not null,
    phone       varchar(25)  not null,
    address     varchar(255)
);
create table ORDERs
(
    order_id     varchar(4) primary key,
    customer_id  varchar(4) not null,
    foreign key (customer_id) references CUSTOMERS (customer_id),
    order_date   date       not null,
    total_amount double
);
create table PRODUCTS
(
    product_id  varchar(4) primary key,
    name        varchar(255) not null,
    description text,
    price       double       not null,
    status      bit(1)       not null
);
create table ORDERS_DETAILS
(
    order_id   varchar(4),
    product_id varchar(4),
    primary key (order_id, product_id),
    foreign key (order_id) references ORDERs (order_id),
    foreign key (product_id) references PRODUCTS (product_id),
    quantity   int(11) not null,
    price      double  not null
);
INSERT INTO CUSTOMERS (customer_id, name, email, phone, address)
VALUES ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

INSERT INTO PRODUCTS (product_id, name, description, price, status)
VALUES ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999, 1),
       ('P002', 'Dell Vostro V3510', 'Core 5, RAM 8GB', 14999999, 1),
       ('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999, 1),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
       ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000, 1);
INSERT INTO ORDERS (order_id, customer_id, order_date, total_amount)
VALUES ('H001', 'C001', '2023-02-22', 52999997),
       ('H002', 'C001', '2023-03-11', 80999997),
       ('H003', 'C002', '2023-01-22', 54359998),
       ('H004', 'C003', '2023-03-14', 102999995),
       ('H005', 'C004', '2022-03-12', 80999997),
       ('H006', 'C004', '2023-02-01', 110449994),
       ('H007', 'C004', '2023-03-29', 79999996),
       ('H008', 'C005', '2023-02-14', 29999998),
       ('H009', 'C005', '2023-1-10', 28999999),
       ('H010', 'C005', '2023-04-1', 149999994);


INSERT INTO ORDERS_DETAILS (order_id, product_id, price, quantity)
VALUES ('H001', 'P002', 14999999, 1),
       ('H001', 'P004', 18999999, 2),
       ('H002', 'P001', 22999999, 1),
       ('H002', 'P003', 28999999, 2),
       ('H003', 'P004', 18999999, 2),
       ('H003', 'P005', 4090000, 4),
       ('H004', 'P002', 14299999, 3),
       ('H004', 'P003', 28999999, 2),
       ('H005', 'P001', 22999999, 1),
       ('H005', 'P003', 28999999, 2),
       ('H006', 'P005', 4090000, 5),
       ('H006', 'P002', 14999999, 6),
       ('H007', 'P004', 18999999, 3),
       ('H007', 'P001', 22999999, 1),
       ('H008', 'P002', 14999999, 2),
       ('H009', 'P003', 28999999, 1),
       ('H010', 'P003', 28999999, 2),
       ('H010', 'P001', 22999999, 4);

#Bài 3: Truy vấn dữ liệu [30 điểm]:
#1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
select name, email, phone, address
from CUSTOMERS C;
#2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện
#thoại và địa chỉ khách hàng).
SELECT c.name, c.phone, c.address
FROM CUSTOMERS c
         INNER JOIN ORDERS o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023
  AND MONTH(o.order_date) = 3;

#3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm
#tháng và tổng doanh thu ). [4 điểm]
SELECT YEAR(order_date)  AS năm,
       MONTH(order_date) AS tháng,
       SUM(total_amount) AS 'tổng doanh thu'
FROM ORDERS
WHERE YEAR(order_date) = 2023
GROUP BY YEAR(order_date), MONTH(order_date);

#4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách
#hàng, địa chỉ , email và số điên thoại).
SELECT name,
       address,
       email,
       phone
FROM CUSTOMERS
WHERE customer_id NOT IN
      (SELECT DISTINCT customer_id FROM ORDERS WHERE YEAR(order_date) = 2023 AND MONTH(order_date) = 2);

#5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
#sản phẩm, tên sản phẩm và số lượng bán ra). [4 điểm]
SELECT od.product_id,
       p.name           AS 'tên sản phẩm',
       SUM(od.quantity) AS 'số lượng'
FROM ORDERS_DETAILS od
         INNER JOIN
     PRODUCTS p ON od.product_id = p.product_id
         INNER JOIN
     ORDERS o ON od.order_id = o.order_id
WHERE YEAR(o.order_date) = 2023
  AND MONTH(o.order_date) = 3
GROUP BY od.product_id, p.name;

#6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
#tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). [5 điểm]
SELECT o.customer_id,
       c.name              AS 'tên khách hàng',
       SUM(o.total_amount) AS 'tổng hóa đơn '
FROM ORDERS o
         INNER JOIN
     CUSTOMERS c ON o.customer_id = c.customer_id
WHERE YEAR(o.order_date) = 2023
GROUP BY o.customer_id, c.name
ORDER BY 'tổng hóa đơn ' DESC;

#7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
#tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm)
SELECT c.name           AS customer_name,
       o.total_amount   AS 'tổng tiền',
       o.order_date     AS 'ngày mua',
       SUM(od.quantity) AS "tổng số lượng"
FROM ORDERS o
         JOIN
     ORDERS_DETAILS od ON o.order_id = od.order_id
         JOIN
     CUSTOMERS c ON o.customer_id = c.customer_id
GROUP BY o.order_id, c.name, o.total_amount, o.order_date
HAVING SUM(od.quantity)>=5;


#Bài 4: Tạo View, Procedure [30 điểm]:
#1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
#tiền và ngày tạo hoá đơn . [3 điểm]

CREATE VIEW Invoice_Info AS
SELECT c.name AS customer_name, c.phone, c.address, o.total_amount, o.order_date
FROM CUSTOMERS c
         INNER JOIN ORDERS o ON c.customer_id = o.customer_id;
SELECT *
FROM Customer_Info;

#2. Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
#số đơn đã đặt. [3 điểm]

CREATE VIEW Customer_Info AS
SELECT c.name AS customer_name, c.address, c.phone, COUNT(o.order_id) AS total_orders
FROM CUSTOMERS c
         LEFT JOIN ORDERS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.address, c.phone;

#3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
#bán ra của mỗi sản phẩm.
CREATE VIEW Product_Info AS
SELECT p.name AS product_name, p.description, p.price, SUM(od.quantity) AS total_sold
FROM PRODUCTS p
         INNER JOIN ORDERS_DETAILS od ON p.product_id = od.product_id
GROUP BY p.product_id, p.name, p.description, p.price;

#4. Đánh Index cho trường `phone` và `email` của bảng Customer. [3 điểm]

CREATE INDEX idx_phone ON CUSTOMERS (phone);
CREATE INDEX idx_email ON CUSTOMERS (email);

#5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.[3 điểm]
DELIMITER //
CREATE PROCEDURE GetCustomerInfo(IN customer_id VARCHAR(4))
BEGIN
    SELECT *
    FROM CUSTOMERS
    WHERE customer_id = customer_id;
END;
//DELIMITER ;
#6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm. [3 điểm]
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT *
    FROM PRODUCTS;
END;

#7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng. [3 điểm]
DELIMITER //
CREATE PROCEDURE GetInvoicesByCustomerID(IN customer_id VARCHAR(4))
BEGIN
    SELECT *
    FROM ORDERS
    WHERE customer_id = customer_id;
END;
//DELIMITER ;
#8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
#tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo. [3 điểm]
DELIMITER //
CREATE PROCEDURE CreateOrder(IN customer_id VARCHAR(4), IN total_amount DOUBLE, IN order_date DATE,
                             OUT new_order_id VARCHAR(7))
BEGIN
    DECLARE max_product_id INT;
    DECLARE new_product_id VARCHAR(7);

    -- Tìm số ID lớn nhất trong bảng PRODUCTS
    SELECT MAX(SUBSTRING(order_id, 2)) INTO max_product_id FROM  ORDERs;

    -- Tăng giá trị ID sản phẩm lớn nhất lên 1 để lấy ID mới cho đơn hàng
    SET max_product_id = COALESCE(max_product_id, 0) + 1;

    -- Tạo ID mới
    SET new_product_id = CONCAT('H', LPAD(max_product_id, 3, '0'));

    -- Chèn đơn hàng mới vào bảng ORDERS
    INSERT INTO ORDERS (order_id, customer_id, order_date, total_amount)
    VALUES (new_product_id, customer_id, order_date, total_amount);

    SET new_order_id = new_product_id;
    SELECT new_product_id;
END;
//
DELIMITER ;

CALL CreateOrder('C001', 1000000, '2024-03-14', @new_order_id);



#9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
#thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. [3 điểm]
DELIMITER //
CREATE PROCEDURE SalesByProductInPeriod(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT p.name AS product_name, SUM(od.quantity) AS total_sold
    FROM PRODUCTS p
             INNER JOIN ORDERS_DETAILS od ON p.product_id = od.product_id
             INNER JOIN ORDERS o ON od.order_id = o.order_id
    WHERE o.order_date BETWEEN start_date AND end_date
    GROUP BY p.product_id, p.name;
END;
//DELIMITER ;
CALL SalesByProductInPeriod('2023-03-01', '2023-03-31');

#10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ t
#giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê
DELIMITER //
CREATE PROCEDURE SalesByProductInMonth(IN month INT, IN year INT)
BEGIN
    SELECT p.name AS product_name, SUM(od.quantity) AS total_sold
    FROM PRODUCTS p
             INNER JOIN ORDERS_DETAILS od ON p.product_id = od.product_id
             INNER JOIN ORDERS o ON od.order_id = o.order_id
    WHERE MONTH(o.order_date) = month
      AND YEAR(o.order_date) = year
    GROUP BY p.product_id, p.name
    ORDER BY total_sold DESC;
END;
//DELIMITER ;

CALL SalesByProductInMonth(3,2023)

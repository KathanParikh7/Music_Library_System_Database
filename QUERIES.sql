/* QUERY 1 */
SELECT CustomerTable.customerFirstName, CustomerTable.customerID,OrderTable.orderDate,
ProductTable.productCost
FROM musicstore.customer AS CustomerTable
INNER JOIN musicstore.order AS OrderTable 
ON  OrderTable.orderID = CustomerTable.customerID
INNER JOIN musicstore.product AS ProductTable
ON  OrderTable.orderID = ProductTable.orderID
WHERE ((ProductTable.productCost) > (SELECT AVG(productCost) FROM musicstore.product)) 
AND MONTH(OrderTable.orderDate) =  MONTH(CURRENT_DATE() - INTERVAL 1 MONTH) 
AND YEAR(OrderTable.orderDate) =  YEAR(CURRENT_DATE());
 

/* QUERY 2 */
/* (TOP SOLD) */
SELECT musicstore.order.orderID, SUM(quantity), musicstore.order.orderDate,
musicstore.customer.customerFirstName
FROM musicstore.order
INNER JOIN musicstore.customer ON musicstore.order.customerID=musicstore.customer.customerID
WHERE musicstore.order.orderDate BETWEEN "2020-06-01" AND "2020-06-07"
GROUP BY musicstore.order.orderID
ORDER BY sum(quantity) DESC
LIMIT 3;

/* (LEAST SOLD) */
SELECT musicstore.order.orderID, SUM(quantity), musicstore.order.orderDate,
musicstore.customer.customerFirstName
FROM musicstore.order
INNER JOIN musicstore.customer ON musicstore.order.customerID=musicstore.customer.customerID
WHERE musicstore.order.orderDate BETWEEN "2020-06-01" AND "2020-06-07"
GROUP BY musicstore.order.orderID
ORDER BY SUM(quantity) ASC
LIMIT 3;

/* QUERY 3 */
SELECT P.productCategory, P.productPrice 
FROM musicstore.product P
JOIN   (SELECT musicstore.product.productCategory,MAX(musicstore.product.productPrice) AS Price
         FROM musicstore.product
         GROUP BY musicstore.product.productCategory) a
ON     P.productCategory=a.productCategory
AND    P.productPrice=a.Price;


/* QUERY 4 */
SELECT COUNT(musicstore.customer.customerID), musicstore.customer.customerCountry
FROM musicstore.customer 
GROUP BY musicstore.customer.customerCountry;



/* QUERY 5 */
SELECT COUNT(musicstore.product.productID) AS products
FROM musicstore.product
INNER JOIN musicstore.order ON musicstore.product.orderID=musicstore.order.orderID
WHERE MONTH(musicstore.order.orderDate) = 7
GROUP BY musicstore.product.productID AND musicstore.order.orderDate;


/* QUERY 6 */
SELECT DISTINCT musicstore.album.albumName, musicstore.artist.artistName
FROM musicstore.album
INNER JOIN musicstore.artist ON musicstore.album.artistID=musicstore.artist.artistID;

/* QUERY 7 */
SELECT musicstore.album.albumName, musicstore.artist.artistName,
SUM(musicstore.album.albumCopies)
FROM musicstore.album
INNER JOIN musicstore.artist ON musicstore.album.artistID=musicstore.artist.artistID
WHERE musicstore.artist.artistName = "Freddy"
GROUP BY musicstore.album.albumName;


/* QUERY 8 */
/* Find which artist has maximum number of streams. */
SELECT musicstore.artist.artistName, MAX(musicstore.artist.artistStreams)
FROM musicstore.artist
GROUP BY musicstore.artist.artistName;

/* QUERY 9 */
/* Find albums for each genre. */
SELECT musicstore.genres.genreName, musicstore.album.albumName
FROM musicstore.album
INNER JOIN musicstore.genres ON musicstore.album.genreID=musicstore.genres.genreID;


/* STORE PROCEDURES */
/* (MySQL procedure for getting all products) 
DELIMITER 

CREATE PROCEDURE GetAllProducts() 
BEGIN
	SELECT *  FROM musicstore.product;
END //

DELIMITER  
CALL GetAllProducts(); 
*/

/* TRIGGER 
(MySQL trigger before product insertion)

DELIMITER $$
CREATE TRIGGER before_product_insert
    BEFORE INSERT ON musicstore.product
    FOR EACH ROW
 BEGIN
 SET new.productReleaseDate = NOW();
 SET new.productCost = new.productQuantity * new.productPrice;
END$$

DROP TRIGGER before_product_insert(for dropping the trigger)

INSERT INTO `musicstore`.`product` (`productID`, `productName`, `productInStock`, `productPrice`, 
`productReleaseDate`, `artistID`, `orderID`, `productCategory`, `productQuantity`, `productCost`) 
VALUES (15, 'These things happen', 1, 10, '2020-04-28 13:32:29.000000', 5, 8, 'hip-hop',10, 800); 
*/





-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
				Book_ID SERIAL PRIMARY KEY,
				Title VARCHAR(100),
				Author VARCHAR(100),
				Genre VARCHAR(50),
				Published_Year INT,
				Price NUMERIC(10,2),
				Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
				Customer_ID SERIAL PRIMARY KEY,
				Name VARCHAR(100),
				Email VARCHAR(100),
				Phone VARCHAR(15),
				City VARCHAR(50),
				Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
				Order_ID SERIAL PRIMARY KEY,
				Customer_ID INT REFERENCES Customers(Customer_ID),
				Book_ID INT REFERENCES Books(Book_ID),
				Order_Date DATE,
				Quantity INT,
				Total_Amount NUMERIC(10,2)
);

-- Import Data into Books Table
-- Imported Books data !
SELECT * FROM Books;

-- Imported Customers Table
SELECT * FROM Customers;

-- Imported Orders Table
SELECT * FROM Orders;

-- Basic Questions:
-- 1. Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
WHERE genre = 'Fiction';

-- 2. Find books published after the year 1950.
SELECT * FROM Books
WHERE published_year>1950;

-- 3. List all the customers from the Canada.
SELECT * FROM customers
WHERE country = 'Canada';

-- 4. Show orders placed in November 2023.
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5. Retrieve the total stock of books available.
SELECT SUM(stock) AS Total_Stock
FROM Books;

-- 6. Find the details of the most expensive book.
SELECT * FROM Books ORDER BY price DESC LIMIT 1;

-- 7. Show all customers who order more than 1 quantity of book.
SELECT * FROM orders
WHERE quantity>1;

-- 8. Retrieve all the orders where the total amount exceeds $20.
SELECT * FROM orders
WHERE total_amount>20;

-- 9. List all the genres available in the books table.
SELECT DISTINCT genre FROM books;

-- 10. Find the book with the lowest stock.
SELECT * FROM Books ORDER BY stock LIMIT 1;

-- 11. Calculate the total Revenue generarted frm all the orders.
SELECT SUM(total_amount) AS Revenue
FROM Orders ;

-- Advance Questions:

-- 1. Retrieve the total number of books sold for each genre.
SELECT b.genre, SUM(o.quantity ) AS Books_sold
FROM orders o
JOIN Books b
ON o.book_id=b.book_id
GROUP BY b.genre;

-- 2. Find the average price of books in the "Fantasy" genre.
SELECT AVG(price) AS Average_price
FROM Books
WHERE genre = 'Fantasy';

-- 3. List customers who have placed at least 2 orders.
SELECT o.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id) >=2;

-- 4. Find the most frequently order book.
SELECT o.book_id, b.title, COUNT(o.order_id) AS order_count
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.Book_id,b.title
ORDER BY order_count DESC LIMIT 1;

-- 5. Show the top 3 most expensive books of 'Fantasy' gene.
SELECT * FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6. Retrieve the total quantity of books sold by each author.
SELECT b.author, SUM(o.quantity) AS total_books_sold
FROM orders o 
JOIN books b ON o.book_id=b.book_id
GROUP BY b.author;

-- 7. Liist the cities where customers who spent over $30 are located.
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;

-- 8. Find the customers who spent most on orders.
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_Spent DESC;

-- 9. Calculate the stock remaining after fulfilling all orders.
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS order_quantity,
		b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;
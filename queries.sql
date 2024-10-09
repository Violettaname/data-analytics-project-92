SELECT
    COUNT(customer_id) customers_count
FROM customers;

/* Запрос считает общее количество покупателей из таблицы customers 
и присваивает псевдоним customers_count */

SELECT
    e.first_name || ' ' || e.last_name seller,
    COUNT(s.sales_id) operations,
    FLOOR(SUM(s.quantity * p.price)) income
FROM employees e 
INNER JOIN sales s ON e.employee_id = s.sales_person_id 
INNER JOIN products p ON s.product_id = p.product_id 
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

/* С помощью данного запроса нашли топ-10 продавцов с наибольшей выручкой:
* вывели данные о продавце из таблицы employees, используя оператор || для склейки значений
и дали псевдоним seller
* с помощью COUNT нашли количество проведенных сделок,
присовили псевдоним operations
* посчитали суммарную выручку продавца за все время, используя SUM и
FLOOR - присвоили псевдоним income
* также здесь соединяются таблицы с помощью операторов INNER JOIN и ON,
группирует по 1ому столбцу, сортирует по 3 столбцу и выводит 10 записей с помощью LIMIT */

SELECT 
	  e.first_name || ' ' || e.last_name seller,
	  FLOOR(AVG(s.quantity * p.price)) average_income
FROM employees e 
INNER JOIN sales s ON e.employee_id = s.sales_person_id 
INNER JOIN products p ON s.product_id = p.product_id 
GROUP BY 1
HAVING FLOOR(AVG(s.quantity * p.price)) < (
		SELECT 
			  FLOOR(AVG(s2.quantity * p2.price))
		FROM sales s2 
		INNER JOIN products p2 ON s2.product_id = p2.product_id
)
ORDER BY 2;

/* данный запрос выводит отчет с продавцами, чья средняя выручка
ниже общей средней выручки, среднее значение в этом запросе считали с помощью функции AVG,
с помощью оператора HAVING произвели фильтрацию после группировки, 
затем отсортировали по полю average_income по возрастанию */

SELECT 
	  e.first_name || ' ' || e.last_name seller,
	  TO_CHAR(s.sale_date, 'day') day_of_week,
	  FLOOR(SUM(s.quantity * p.price)) income
FROM employees e
INNER JOIN sales s ON e.employee_id = s.sales_person_id 
INNER JOIN products p ON s.product_id = p.product_id 
GROUP BY 1, 2
ORDER BY MIN(EXTRACT(ISODOW FROM s.sale_date)), 1;

/* запрос выводит отчет с данными по выручке по каждому продавцу и дню недели,
здесь использовали функции TO_CHAR, чтобы проеобразовать значение даты sale_date в 
строку 'day' и EXTRACT для извлечения дня недели, чтобы по нему сделать сортировку
с понедельника по воскресенье */

SELECT
	  CASE
		  WHEN age BETWEEN 16 AND 25 THEN '16-25'
		  WHEN age BETWEEN 26 AND 40 THEN '26-40'
		  ELSE '40+'
	  END age_category,
	  COUNT(age) age_count
FROM customers
GROUP BY 1
ORDER BY 1;

/* запрос выводит отчет с возрастными группами покупателей,
для формирования групп использовали оператор CASE, с помощью COUNT 
посчитали количество человек в каждой группе */

SELECT
	  TO_CHAR(s.sale_date, 'yyyy-mm') selling_month,
	  COUNT(DISTINCT s.customer_id) total_customers,
	  FLOOR(SUM(s.quantity * p.price)) income
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY 1
ORDER BY 1;

/* запрос выводит отчет по количеству уникальных покупателей 
и выручке, которую они принесли, сгруппировав данные по дате
* для выборки уникальных значений использовали DISTINCT */

SELECT DISTINCT
	  c.first_name || ' ' || c.last_name customer,
	  s.sale_date,
	  e.first_name || ' ' || e.last_name seller
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
INNER JOIN employees e ON s.sales_person_id = e.employee_id
INNER JOIN products p ON s.product_id = p.product_id 
WHERE p.price = 0 
AND (s.customer_id, s.sale_date) IN (
				SELECT
					s2.customer_id,
					MIN(s2.sale_date) first_date
				FROM sales s2
				GROUP BY 1
)
ORDER BY 1;

/* запрос выводит данные о покупателях, первая покупка которых
пришлась на время проведения акций (акционные товары отпускали со стоимостью равной 0)
* оператор || использовался для склейки first_name и last_name 
в полях customer и seller
* оператор WHERE использовался для фильтрации
* в фильтрации применили подзапрос, который находит первую дату покупки */

-- SQL Questions - Classification
-- (Use sub queries or views wherever necessary)

-- 1. Create a database called credit_card_classification.
-- 2. Create a table credit_card_data with the same columns as given in the csv file. You can find the names of the headers for the table in the creditcardmarketing.xlsx file. Use the same column names as the names in the excel file. Please make sure you use the correct data types for each of the columns.
-- 3. Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. (in this case we have already deleted the header names from the csv files). To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:
-- 4. Select all the data from table credit_card_data to check if the data was imported correctly.
select * from credit_card_data;

-- 5. Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE credit_card_data 
DROP COLUMN q4_balance;
select * from credit_card_data limit 10;

-- 6. Use sql query to find how many rows of data you have.
select count(*) from credit_card_data;

-- 7. Now we will try to find the unique values in some of the categorical columns:
-- - What are the unique values in the column `Offer_accepted`?
select distinct offer_accepted
from credit_card_data;

-- - What are the unique values in the column `Reward`?
select distinct reward
from credit_card_data;

-- - What are the unique values in the column `mailer_type`?
select distinct mailer_type
from credit_card_data;

-- - What are the unique values in the column `credit_cards_held`?
select distinct n_credit_cards_held
from credit_card_data;

-- - What are the unique values in the column `household_size`?
select distinct household_size
from credit_card_data;

-- 8. Arrange the data in a decreasing order by the average_balance of the house. Return only the customer_number of the top 10 customers with the highest average_balances in your data.
select customer_number
from credit_card_data
order by average_balance desc
limit 10;

-- 9. What is the average balance of all the customers in your data?
select round(avg(average_balance),2) as 'average balance of all the customers'
from credit_card_data;

-- 10. In this exercise we will use group by to check the properties of some of the categorical variables in our data. Note wherever average_balance is asked in the questions below, please take the average of the column average_balance:
-- - What is the average balance of the customers grouped by `Income Level`? The returned result should have only two columns, income level and `Average balance` of the customers. Use an alias to change the name of the second column.
select income_level, round(avg(average_balance),1) as 'average balance'
from credit_card_data
group by income_level;

-- - What is the average balance of the customers grouped by `number_of_bank_accounts_open`? The returned result should have only two columns, `number_of_bank_accounts_open` and `Average balance` of the customers. Use an alias to change the name of the second column.
select n_bank_accounts_open, round(avg(average_balance),1) as 'average balance'
from credit_card_data
group by n_bank_accounts_open;

-- - What is the average number of credit cards held by customers for each of the credit card ratings? The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.
select credit_rating, round(avg(average_balance),1) as 'average balance'
from credit_card_data
group by credit_rating;

-- - Is there any correlation between the columns `credit_cards_held` and `number_of_bank_accounts_open`? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
select n_credit_cards_held, round(sum(n_bank_accounts_open),1) as 'total balance'
from credit_card_data
group by n_credit_cards_held
order by round(sum(n_bank_accounts_open),1) asc;
-- Slightly correlated; the more credit cards, the lesser the total balance.

-- You might also have to check the number of customers in each category (ie number of credit cards held) to assess if that category is well represented in the dataset to include it in your analysis. For eg. If the category is under-represented as compared to other categories, ignore that category in this analysis
select n_credit_cards_held, count(*) as 'number of customers'
from credit_card_data
group by n_credit_cards_held;
-- customers holding 4 cards are under represented, we should ignore it

-- 11. Your managers are only interested in the customers with the following properties:
-- - Credit rating medium or high
-- - Credit cards held 2 or less
-- - Owns their own home
-- - Household size 3 or more
-- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? Can you filter the customers who accepted the offers here?
with cte1 as
(select * from credit_card_data
where n_credit_cards_held <= 2)
,cte2 as
(select * from cte1
where credit_rating = 'Medium' 
or credit_rating = 'High')
,cte3 as
(select * from cte2
where own_your_home = 'Yes')
,cte4 as
(select * from cte3
where household_size >=3)
select * from cte4
where offer_accepted = 'Yes';

-- 12. Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. Write a query to show them the list of such customers. You might need to use a subquery for this problem.
select customer_number, average_balance
from credit_card_data
where average_balance < (select avg(average_balance) from credit_card_data)
order by average_balance desc;

-- 13. Since this is something that the senior management is regularly interested in, create a view called Customers__Balance_View1 of the same query.
select customer_number, average_balance
from credit_card_data
where average_balance < (select avg(average_balance) from credit_card_data)
order by average_balance desc;
-- 14. What is the number of people who accepted the offer vs number of people who did not?
CREATE VIEW Customers__Balance_View1 AS 
select customer_number, average_balance
from credit_card_data
where average_balance < (select avg(average_balance) from credit_card_data)
order by average_balance desc;
select * from Customers__Balance_View1;

-- 15. Your managers are more interested in customers with a credit rating of high or medium. What is the difference in average balances of the customers with high credit card rating and low credit card rating?
with _cte1 as(
select avg(average_balance) as high_avg_balance
from credit_card_data
where credit_rating = 'High')
,_cte2 as(
select avg(average_balance) as low_avg_balance
from credit_card_data
where credit_rating = 'Low')
select round((_cte1.high_avg_balance - _cte2.low_avg_balance),1) as 'difference: high - low'
from _cte1, _cte2;

-- 16. In the database, which all types of communication (mailer_type) were used and with how many customers?
select distinct mailer_type, count(*)
from credit_card_data
group by mailer_type;

-- 17. Provide the details of the customer that is the 11th least Q1_balance in your database.
with __cte as(
select customer_number, offer_accepted, reward, mailer_type, income_level, n_bank_accounts_open, overdraft_protection, credit_rating, n_credit_cards_held, n_homes_owned, household_size, own_your_home, average_balance, q1_balance, q2_balance, q3_balance, row_number() over( order by q1_balance asc) as ranking
from credit_card_data)
select * from __cte where ranking =11;

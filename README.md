# Pizza Sales Analysis using SQL

## Overview

This repository contains a comprehensive analysis of pizza sales data using SQL. The project involves various SQL queries to analyze total revenue, order trends, pizza types, sizes, and more. The analysis also includes revenue growth, popular pizzas, and ingredient usage.

## Project Structure

- `pizza_sales.sql`: SQL script for database creation, table creation, data insertion, and analysis queries.
- `README.md`: This documentation file.

## Database Schema

The database `pizza_sales` includes the following tables:

1. **pizzas**: Contains information about different pizzas.
   - `pizza_id`: Unique identifier for each pizza
   - `pizza_type_id`: Foreign key linking to the pizza type
   - `size`: Size of the pizza
   - `price`: Price of the pizza

2. **pizza_types**: Contains details about pizza types.
   - `pizza_type_id`: Unique identifier for each pizza type
   - `name`: Name of the pizza type
   - `category`: Category of the pizza type (e.g., vegetarian, non-vegetarian)
   - `ingredients`: List of ingredients used in the pizza type

3. **orders**: Contains information about customer orders.
   - `order_id`: Unique identifier for each order
   - `date`: Date of the order
   - `time`: Time of the order

4. **order_details**: Contains details about each item in an order.
   - `order_details_id`: Unique identifier for each order detail
   - `order_id`: Foreign key linking to the order
   - `pizza_id`: Foreign key linking to the pizza
   - `quantity`: Quantity of the pizza ordered


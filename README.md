# Retail Business Intelligence Dashboard

An end-to-end Business Intelligence project built using PostgreSQL, SQL, and Power BI on the Olist Brazilian E-Commerce dataset. The project transforms raw transactional data into interactive dashboards and business insights for executive decision-making.
##  Live Resources



## Project Overview

This project demonstrates a complete Business Intelligence workflow, including:

- Data import and database setup
- Data quality assessment
- SQL-based business analysis
- Customer and sales analytics
- Creation of optimized SQL views
- Interactive Power BI dashboard development

The objective is to convert raw retail data into meaningful KPIs and visual reports that help analyze sales performance, customer behavior, product performance, payment trends, and regional performance.

## Technology Stack

- PostgreSQL
- SQL
- Power BI
- Git & GitHub

## SQL Analysis

The project contains more than 35 business-oriented SQL queries covering:

- Revenue Analysis
- Order Analysis
- Customer Analysis
- Product Performance
- Category Performance
- Seller Performance
- Payment Analysis
- Customer Segmentation
- Window Functions
- Common Table Expressions (CTEs)
- Ranking Functions
- Running Totals

## SQL Views

The following analytical views were created for dashboard development:

- vw_sales_master
- vw_monthly_sales
- vw_category_performance
- vw_payment_analysis
- vw_state_performance
- vw_customer_segments
- vw_executive_summary

## Dashboard Features

The Power BI dashboard includes:

- Executive KPI Summary
- Revenue Trend Analysis
- Customer Insights
- Product Category Performance
- State-wise Sales Analysis
- Payment Analysis
- Interactive Filters

## Repository Structure

```
Retail-Business-Intelligence-Dashboard/
│
├── dashboard/
│   └── Retail_Business_Intelligence_Dashboard.pbix
│
├── sql/
│   ├── 01-dataimport.sql
│   ├── 02-dataquality.sql
│   ├── 03-business_analysis.sql
│   ├── 04-advancedsql.sql
│   ├── 05-customer_analysis.sql
│   └── 06-analytics_views.sql
│
├── screenshots/
│
└── README.md
```

## Dataset

Olist Brazilian E-Commerce Public Dataset

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

## Future Improvements

- Additional DAX measures
- Drill-through reports
- Forecasting
- Customer cohort analysis
- Profitability dashboard

## Author

Tushar Vaidya

B.Tech, Mining Engineering  
IIT (ISM) Dhanbad

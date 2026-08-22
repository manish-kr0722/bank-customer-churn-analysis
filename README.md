# Bank Customer Churn Analysis

An end-to-end data analytics project that analyzes bank customer data to identify the key drivers of customer churn, combining SQL-based business analysis and Python-based machine learning with a multi-page, interactive Power BI dashboard.

# Overview

This project analyzes 10,000 bank customers across France, Germany, and Spain to answer:

Which customer segments are most likely to churn?
What factors most strongly predict churn?
Which currently active customers are highest-risk and worth prioritizing for retention outreach?

The workflow covers SQL segmentation analysis, Python-based predictive modeling, and a 4-page Power BI dashboard for exploring the results interactively.

# Dataset
Attribute	Detail
Records	10,000 bank customers
Countries	France, Germany, Spain
Target variable	Exited (1 = churned, 0 = retained)

# Key columns: 
CustomerId, Surname, Geography, Gender, Age, Tenure, Balance, NumOfProducts, HasCrCard, IsActiveMember, EstimatedSalary, CreditScore, Exited

# SQL Analysis

Business questions answered using CTEs, window functions, and subqueries in SQLite:

Segmentation — churn rate by geography, gender, and age bracket
Product engagement — churn rate by number of products and active membership status
Financial profile — average balance and credit score for churned vs. retained customers
At-risk prioritization — a CTE + RANK() window function query identifying the highest-balance, inactive, single-product customers per country
Benchmarking — each country's churn rate compared against the overall average using a CTE + subquery
Outlier detection — identifying the single most extreme segment (age × geography, product count × activity) using ABS() deviation ranking
Modeling

# Two models were trained and directly compared to predict Exited:

Random Forest was selected as the final model — it more than doubled recall on the churned class compared to Logistic Regression, likely due to its ability to capture non-linear interactions (e.g., a customer who is inactive and single-product and high-balance) that a linear model can't represent without manual feature engineering.

Key Model Findings (Logistic Regression coefficients)
Feature	Coefficient	Direction
Age	+0.74	Older customers → higher churn risk (strongest driver)
Geography (Germany)	+0.36	Being in Germany → higher churn risk
Balance	+0.16	Higher balance → slightly higher churn risk
IsActiveMember	−0.52	Active members → substantially lower churn risk (strongest protective factor)
Power BI Dashboard

# A 4-page interactive dashboard with persistent sidebar navigation:

Overview — KPI cards, churn rate by age group/geography/product count, and a live "Top 5 At-Risk Customers" table
Customer Details — a searchable, full customer table with a conditionally formatted Risk Level column (High / Medium / Low)
Geography Breakdown — country-level churn comparison with gender and risk-level splits
Insights — key findings connecting SQL analysis and model results to plain-language, actionable takeaways

# Headline KPIs:

Total Customers: 10,000
Churn Rate: 20.37%
Average Balance: $76.49K
Average Credit Score: 651
Average Tenure: 5.01 years

# Tools Used
SQL: SQLite (CTEs, window functions, subqueries, segmentation queries)
Python: Pandas, NumPy, scikit-learn, Matplotlib, Seaborn
Power BI: Power Query, DAX, multi-page navigation, conditional formatting

# Author

Manish Kumar | LinkedIn- https://www.linkedin.com/in/manish071096 | GitHub- https://github.com/manish-kr0722/

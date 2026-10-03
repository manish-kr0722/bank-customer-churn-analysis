# Bank Customer Churn Analysis

**SQL • Python • Power BI | Public-dataset portfolio project**

A customer-retention case study combining SQL segmentation, baseline classification models and a four-page Power BI dashboard.

## Business question

Which customer segments have higher observed churn, and where should a bank investigate retention opportunities?

## Dataset

The included dataset contains **10,000 customers** across France, Germany and Spain. The target is Exited: 1 indicates churn and 0 indicates retention. Other fields cover age, credit score, balance, product count and active membership.

This is a practice analysis, not a report on ICICI Bank or HDFC Bank customers.

## Approach

- Analysed churn by geography, age, product count, balance and activity.
- Used SQL CTEs, subqueries and window functions for segment comparisons and ranking.
- Trained Random Forest and Logistic Regression on a stratified 80/20 split.
- Built report pages for overview, customer details, geography and insights.

## Key findings

Figures below were recalculated from the included CSV.

| Measure | Result |
|---|---:|
| Overall churn | 20.37% |
| Germany churn | 32.44% |
| France churn | 16.15% |
| Spain churn | 16.67% |
| Inactive-member churn | 26.85% |
| Active-member churn | 14.27% |
| One-product customer churn | 27.71% |
| Two-product customer churn | 7.58% |

The three- and four-product groups also have high churn, but contain only 266 and 60 customers respectively. Product relationships should be examined by segment rather than interpreted as a simple linear trend.

## Model comparison

Saved notebook results on 2,000 test customers:

| Model | Accuracy | Churn precision | Churn recall | Churn F1 |
|---|---:|---:|---:|---:|
| Random Forest | 0.86 | 0.77 | 0.45 | 0.57 |
| Logistic Regression | 0.81 | 0.59 | 0.19 | 0.28 |

Random Forest identifies more churned customers, but still misses about 55% at the evaluated threshold. These are exploratory results, not evidence of production readiness.

## Business recommendations

- Investigate the higher churn observed in Germany.
- Test outreach to disengaged customers and monitor response and retention.
- Evaluate interventions through controlled measurement rather than assuming the observed associations are causal.

No retention campaign was implemented or measured in this project.

## How to inspect the work

1. Review the SQL script and notebook through the file links below.
2. Open the PBIX file in Power BI Desktop. Update source paths if prompted.
3. For the notebook, install pandas, numpy, matplotlib, seaborn, scikit-learn and Jupyter. Update its Colab-specific CSV path to the included Dataset folder.
4. For SQL, import the CSV into SQL Server and confirm the database, table and column types before running queries.

## Technical notes

- The SQL script contains SQL Server-style statements; it is not a SQLite script.
- Some percentage expressions currently use integer arithmetic. Change the leading multiplier from 100 to 100.0 before relying on SQL percentage outputs.
- The displayed model metrics come from saved notebook outputs; they should be regenerated after further modelling changes.

## Dashboard preview

![Dashboard 1](Dashboard%20Image/Dashboard%201.jpg)

![Dashboard 2](Dashboard%20Image/Dashboard%202.jpg)

![Dashboard 3](Dashboard%20Image/Dashboard%203.jpg)

![Dashboard 4](Dashboard%20Image/Dashboard%204.jpg)

## Repository files

- [Customer Churn Analysis- Dashboard.pbix](Customer%20Churn%20Analysis-%20Dashboard.pbix)
- [Customer Churn Analysis.sql](Customer%20Churn%20Analysis.sql)
- [Customer_Churn_Analysis.ipynb](Customer_Churn_Analysis.ipynb)
- [Dataset/customer_churn.csv](Dataset/customer_churn.csv)

## Author

**Manish Kumar** — banking professional transitioning into Data Analytics.

[LinkedIn](https://www.linkedin.com/in/manish071096/) · [GitHub](https://github.com/manish-kr0722)

create database customer_churn
use customer_churn
select * from customer_churn

-- COUNTRY WISE CHURNED RATE OF THE CUSTOMER

select Geography, count (*) as Total_Customer, 
sum(cast(Exited as int)) as churned_customer,
round(100* sum(cast(Exited as int))/count(*),2) as Churned_rate
from customer_churn
group by Geography

-- GENDER WISE CHURNED RATE OF THE CUSTOMER

select Gender, count(*) as Total_Customer,
round(100* sum(cast(Exited as int))/count(*),2) as Churned_rate
from customer_churn
group by Gender
order by Churned_rate

-- AGE GROUP CHURNED RATE OF THE CUSTOMER

with age_category_group as(
select
case
when Age<=30 then '18-30'
when Age<=45 then '31-45'
when Age<=60 then '46-60'
else '60+'
end as age_group,
Exited
from customer_churn
)
select age_group,
count(*) as total_customer,
round(100* sum(cast(Exited as int))/count(*),2) as Churned_rate
from age_category_group
group by age_group
order by Churned_rate desc

-- CHURN TIED TO PRODUCT ENGAGEMENT 
--(single-product customers churn more than multi-product customers)

select NumOfProducts,
count(*) as Total_customers,
round(100* sum(cast(Exited as int))/count(*),2) as churn_rate
from customer_churn 
group by NumOfProducts
order by NumOfProducts desc


-- CHURN RATE ACCORDING TO ACTIVE/INACTIVE CUSTOMERS

select 
IsActiveMember,
count(*) as Total_customers,
round(100* sum(cast(Exited as int))/count(*),2) as churn_rate
from customer_churn
group by IsActiveMember

-- HIGH-BALANCE CUSTOMERS CHURN LESS OR MORE THAN LOW-BALANCE

with balance_group as ( 
select 
Exited, Balance,
case 
when Balance = 0 then 'Zero Balance'
when Balance > 0 and Balance <=50000 then 'Low Balance'
when Balance > 50000 and Balance<=100000 then 'Medium Balance'
else 'High Balance'
end as balance_tier
from customer_churn
)
select 
balance_tier,
count (*) as total_customers,
sum(cast (Exited as int)) as churned_customer,
round(100* sum(cast(Exited as int))/count(*),2) as churn_rate
from balance_group
group by balance_tier

-- IS THERE A CREDIT SCORE THRESHOLD BELOW WHICH CHURN SPIKES

with credit_scores as(
select Exited,
case
when CreditScore<500 then '<500'
when CreditScore<650 then '500-649'
when CreditScore<750 then '650-749'
else '750+'
end as credit_score_bucket
from customer_churn
)
select credit_score_bucket,
round(100* sum(cast(Exited as int))/count(*),2) as churn_rate
from credit_scores
group by credit_score_bucket


-- COMPARE AVERAGE BALANCE AND CREDIT SCORE OF CHURNED VS RETAINED CUSTOMER

select
Exited,
round (avg(Balance),2) as avg_balance,
round (avg(CreditScore),2) as avg_credit_score
from customer_churn
group by Exited


-- FLAG CUSTOMERS with HIGH BALANCE + INACTIVE STATUS + SINGLE PRODUCT

with balance_group as ( 
select 
Exited, Balance, IsActiveMember,NumOfProducts,CustomerId, Surname,
case 
when Balance = 0 then 'Zero Balance'
when Balance > 0 and Balance <=50000 then 'Low Balance'
when Balance > 50000 and Balance<=100000 then 'Medium Balance'
else 'High Balance'
end as balance_tier
from customer_churn
)
select CustomerId, Surname,round(Balance,2) as Balance
from balance_group
where balance_tier='High Balance' and NumOfProducts=1 and IsActiveMember=0 and Exited=0


-- CHURN SPIKE IN EARLY TENURE OR LATE TENURE

with tenure_group as(
select
Exited,
case 
when Tenure<=2 then '0-2 yrs'
when Tenure<=5 then '3-5 yrs'
when Tenure<=8 then '6-8 yrs'
else '9+ yrs'
end as tenure_bucket
from customer_churn
)
select 
tenure_bucket,
count (*) as total_customer,
round(100* sum(cast(Exited as int))/count(*),2) as churn_rate
from tenure_group
group by tenure_bucket
order by tenure_bucket


-- HOW DOES EACH COUNTRY'S CHURN RATE COMPARE TO THE OVERALL AVERAGE (SUBQUERY)?

with global_stats as (
select avg(cast (Exited as float)) * 100 as Overall_avg 
from customer_churn
)
select Geography,
count(*) as Total_Customer,
sum(cast(Exited as int)) as Churned_customer,
round(100 * sum(cast (Exited as float))/ count(*),2) as country_churn_rate,
(select Overall_avg from global_stats) as Overall_avg_churn,
round((100 * sum(cast (Exited as float))/count(*))-(select Overall_avg from global_stats),2) 
as Difference_from_Average
from customer_churn
group by Geography
order by country_churn_rate


-- WHICH SINGLE SEGMENT (AGE * GEOGRAPHY, OR PRODUCT count * ACTIVITY ) IS THE BIGGEST OUTLIER?

with global_stats as (
select avg(cast(Exited as float))*100 as overall_churn_rate
from customer_churn
),
segment_stats as (
select NumOfProducts,IsActiveMember, count(*) as Total_customer,
round(100*(sum(cast(Exited as float))/count(*)),2) as segment_churn_rate
from customer_churn
group by NumOfProducts, IsActiveMember
having count(*) > 30
)
select 
NumOfProducts,IsActiveMember, Total_customer,segment_churn_rate,
round((select overall_churn_rate from global_stats),2) as overall_churn_rate,
round(segment_churn_rate-(select overall_churn_rate from global_stats),2) as avg_diff
from segment_stats
order by abs(segment_churn_rate-(select overall_churn_rate from global_stats)) desc



with global_stats as (
select avg(cast(Exited as float))*100 as overall_churn_rate
from customer_churn
),
segment_stats as (
select Geography,
case 
when Age <=30 then '18-30'
when Age <=45 then '31-45'
when Age <=60 then '46-60'
else '60+'
end as age_group,
count(*) as total_customer,
round(100*sum(cast (Exited as float))/count(*),2) as segment_churn_rate
from customer_churn
group by Geography,
case 
when Age <=30 then '18-30'
when Age <=45 then '31-45'
when Age <=60 then '46-60'
else '60+'
end
having count(*)>30
)

select
Geography,age_group,total_customer,
segment_churn_rate,
round((select overall_churn_rate from global_stats), 2) as overall_churn_rate,
round(segment_churn_rate - (select overall_churn_rate from global_stats), 2) as deviation_from_avg
from segment_stats
order by abs(segment_churn_rate - (select overall_churn_rate from global_stats)) desc



--rank all segments by churn rate to find the top 3 highest-risk combinations
--RANK ALL SEGMENTS BY CHURN RATE TO FIND TOP 3 HIGHEST RISK COMBINATON


with segment_stats as (
    select
        Geography,
        NumOfProducts,
        count(*) as total_customers,
        round(100.0 * SUM(CasT(Exited as float)) / count(*), 2) as segment_churn_rate
    from customer_churn
    group by Geography, NumOfProducts
    having count(*) > 30
),
ranked_segments as (
    select *,
           rank() over (order by segment_churn_rate desc) as churn_risk_rank
    from segment_stats
)
select *
from ranked_segments
where churn_risk_rank <= 3

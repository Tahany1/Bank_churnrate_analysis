SELECT * FROM Tahanydb1.bank_churn;
/*total customers and churn rate*/
SELECT 
    COUNT(*) AS total_customers,
    SUM(Exited) AS total_churned,
    ROUND(100 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
    FROM Tahanydb1.bank_churn
/*churn rate by gender */
SELECT 
    Gender,
    COUNT(*) AS total,
    SUM(Exited) AS churned,
    ROUND(100 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
FROM Tahanydb1.bank_churn
GROUP BY Gender;
/*churn by geopgraphy*/
SELECT 
    Geography,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned,
    ROUND(100 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
FROM Tahanydb1.bank_churn
GROUP BY Geography
ORDER BY churn_rate_percent DESC;
/* average balance and salary by churn status*/
SELECT 
    Exited,
    ROUND(AVG(Balance), 2) AS avg_balance,
    ROUND(AVG(EstimatedSalary), 2) AS avg_salary
FROM Tahanydb1.bank_churn
GROUP BY Exited;
/*churn rate by age group*/
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS total,
    SUM(Exited) AS churned,
    ROUND(100 * SUM(Exited) / COUNT(*), 2) AS churn_rate_percent
FROM Tahanydb1.bank_churn
GROUP BY age_group
ORDER BY churn_rate_percent DESC;
/*top 5 churn proneprofiles based on balance and inactivity*/
SELECT *
FROM Tahanydb1.bank_churn
WHERE Exited = TRUE
  AND IsActiveMember = FALSE
  AND Balance > 100000
ORDER BY Balance DESC
LIMIT 5;
/*high risk churn profiles*/
WITH high_risk AS (
  SELECT *
  FROM Tahanydb1.bank_churn
  WHERE IsActiveMember = FALSE AND CreditScore < 600 AND Balance > 100000
)
SELECT 
    Geography,
    COUNT(*) AS high_risk_customers,
    SUM(Exited) AS churned_high_risk
FROM high_risk
GROUP BY Geography;

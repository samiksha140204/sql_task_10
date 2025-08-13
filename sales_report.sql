select * from sales;

CREATE or replace PROCEDURE yearly_sales_report()
LANGUAGE plpgsql
AS $$
BEGIN
create table yearly_sales_report as
select extract(year from order_date) as year_report,round(sum(sales)) as total_sales,
sum(qty) as total_quantity,round(sum(profit))as total_profit,
avg(sales) as avg_sales from sales
group by year_report order by year_report asc;
END;
$$;

call yearly_sales_report ();

SELECT * FROM yearly_sales_report;

-------------------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS monthly_sales_report (
    year_report INT,
    month_report INT,
    total_sales NUMERIC(12,2),
    total_quantity INT,
    total_profit NUMERIC(12,2),
    avg_sales NUMERIC(12,2),
    PRIMARY KEY (year_report, month_report)
);


CREATE OR REPLACE PROCEDURE insert_monthly_sales_report()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert monthly aggregated sales data
    INSERT INTO monthly_sales_report (year_report, month_report, total_sales, total_quantity, total_profit, avg_sales)
    SELECT
        EXTRACT(YEAR FROM order_date)::INT AS year_report,
        EXTRACT(MONTH FROM order_date)::INT AS month_report,
        ROUND(SUM(sales)::numeric, 2) AS total_sales,
        SUM(qty) AS total_quantity,
        ROUND(SUM(profit)::numeric, 2) AS total_profit,
        ROUND(AVG(sales)::numeric, 2) AS avg_sales
    FROM sales
    GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
    ORDER BY year_report, month_report;
END;
$$;


CALL insert_monthly_sales_report();

select * from monthly_sales_report;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ship_mode_sales_report (
    ship_mode TEXT PRIMARY KEY,
    total_sales NUMERIC(12,2),
    total_quantity INT,
    total_profit NUMERIC(12,2),
    avg_sales NUMERIC(12,2)
);


CREATE OR REPLACE PROCEDURE insert_ship_mode_sales_report()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert aggregated data by ship_mode
    INSERT INTO ship_mode_sales_report (ship_mode, total_sales, total_quantity, total_profit, avg_sales)
    SELECT
        ship_mode,
        ROUND(SUM(sales)::numeric, 2) AS total_sales,
        SUM(qty) AS total_quantity,
        ROUND(SUM(profit)::numeric, 2) AS total_profit,
        ROUND(AVG(sales)::numeric, 2) AS avg_sales
    FROM sales
    GROUP BY ship_mode
    ORDER BY ship_mode;
END;
$$;

CALL insert_ship_mode_sales_report();

select * from ship_mode_sales_report; 

------------------------------------------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS yearly_monthly_sales_report (
    year_report INT,
    month_report INT,
    total_sales NUMERIC(12,2),
    total_quantity INT,
    total_profit NUMERIC(12,2),
    avg_sales NUMERIC(12,2),
    PRIMARY KEY (year_report, month_report)
);

CREATE OR REPLACE PROCEDURE insert_yearly_monthly_sales_report()
LANGUAGE plpgsql
AS $$
BEGIN

    -- Insert aggregated yearly+monthly sales data
    INSERT INTO yearly_monthly_sales_report (year_report, month_report, total_sales, total_quantity, total_profit, avg_sales)
    SELECT
        EXTRACT(YEAR FROM order_date)::INT AS year_report,
        EXTRACT(MONTH FROM order_date)::INT AS month_report,
        ROUND(SUM(sales)::numeric, 2) AS total_sales,
        SUM(qty) AS total_quantity,
        ROUND(SUM(profit)::numeric, 2) AS total_profit,
        ROUND(AVG(sales)::numeric, 2) AS avg_sales
    FROM sales
    GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
    ORDER BY year_report, month_report;
END;
$$;

CALL insert_yearly_monthly_sales_report();

select * from yearly_monthly_sales_report;

------------------------------------------------------------------------------------------------------------------
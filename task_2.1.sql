
select * from dm.client limit 10;

SELECT *
FROM dm.client
WHERE (client_rk, effective_from_date) IN (
    SELECT client_rk, effective_from_date
    FROM dm.client
    GROUP BY client_rk, effective_from_date
    HAVING COUNT(*) > 1
)
ORDER BY client_rk, effective_from_date;


SELECT client_rk, effective_from_date, COUNT(*) AS repeat
FROM dm.client
GROUP BY client_rk, effective_from_date
HAVING COUNT(*) > 1
ORDER BY repeat DESC;

 WITH ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY client_rk, effective_from_date ORDER by client_rk) AS rn
    FROM dm.client
)
DELETE FROM dm.client
WHERE (client_rk, effective_from_date) IN (
    SELECT client_rk, effective_from_date
    FROM ranked
    WHERE rn > 1
);




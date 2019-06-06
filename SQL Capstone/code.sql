/* 
How many campaigns and sources does CoolTShirts use? Which source is used for each campaign? */

SELECT
	COUNT(DISTINCT utm_campaign) AS 'Campaign'
FROM page_visits;

SELECT
	COUNT(DISTINCT utm_source) AS 'Source'
FROM page_visits;

SELECT 
	DISTINCT utm_campaign, utm_source
FROM page_visits;

/* What pages are on the CoolTShirts website? */

SELECT 
	DISTINCT page_name
FROM page_visits;

/* How many first touches is each campaign responsible for? */

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
        pv.utm_campaign,
        COUNT(utm_campaign)
FROM first_touch AS ft
JOIN page_visits AS pv
	ON ft.user_id = pv.user_id
AND ft.first_touch_at = pv.timestamp
GROUP BY 4
ORDER BY 5 DESC;
	
/* How many last touches is each campaign responsible for? */

WITH last_touch AS (
    SELECT user_id,
        Max(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
        pv.utm_campaign,
        COUNT(utm_campaign)
FROM last_touch AS lt
JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
	AND lt.last_touch_at = pv.timestamp
GROUP BY 4
ORDER BY 5 DESC;
	
/* How many visitors make a purchase? */

SELECT COUNT(DISTINCT user_id) AS Purchase_Count 
FROM page_visits
WHERE page_name = '4 - purchase';

/* How many last touches on the purchase page is each campaign responsible for? */

WITH last_touch AS (
    SELECT user_id,
        Max(timestamp) as last_touch_at
    FROM page_visits
  	WHERE page_name = '4 - purchase'
    GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
        pv.utm_campaign,
        COUNT(utm_campaign)
FROM last_touch AS lt
JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 4
ORDER BY 5 DESC;

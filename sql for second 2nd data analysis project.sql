SELECT COUNT(*) FROM shipments;
SELECT * FROM shipments LIMIT 5;
SELECT 
    COUNT(*) AS total_shipments,
    ROUND(AVG(transport_cost)::numeric, 2) AS average_transport_cost,
    ROUND(AVG(spoiled_quantity_kg)::numeric, 2) AS average_spoilage_kg
FROM shipments;
SELECT 
    c.crop_name,
    COUNT(s.shipment_id) AS total_shipments,
    ROUND(AVG(s.spoiled_quantity_kg)::numeric, 2) AS avg_spoiled_kg
FROM shipments s
JOIN crops c ON s.crop_id = c.crop_id
GROUP BY c.crop_name
ORDER BY avg_spoiled_kg DESC;
SELECT 
    s.route_id,
    COUNT(s.shipment_id) AS total_shipments,
    ROUND(AVG(s.transport_cost)::numeric, 2) AS avg_transport_cost,
    ROUND(AVG(r.distance_km)::numeric, 2) AS avg_distance_km
FROM shipments s
JOIN routes r ON s.route_id = r.route_id
GROUP BY s.route_id
ORDER BY avg_transport_cost DESC
LIMIT 5;
SELECT 
    sf.facility_name,
    ROUND(AVG(so.utilization_pct)::numeric, 2) AS avg_utilization_pct,
    ROUND(AVG(so.avg_temp_c)::numeric, 2) AS avg_temperature_c
FROM storage_observations so
JOIN storage_facilities sf ON so.facility_id = sf.facility_id
GROUP BY sf.facility_name
ORDER BY avg_utilization_pct DESC
LIMIT 5;
WITH avg_market_prices AS (
    SELECT crop_id, AVG(price_per_kg) AS avg_price
    FROM market_prices
    GROUP BY crop_id
)
SELECT 
    c.crop_name,
    SUM(s.spoiled_quantity_kg) AS total_spoiled_kg,
    ROUND(amp.avg_price::numeric, 2) AS avg_price_per_kg,
    ROUND(SUM(s.spoiled_quantity_kg * amp.avg_price)::numeric, 2) AS estimated_financial_loss
FROM shipments s
JOIN crops c ON s.crop_id = c.crop_id
JOIN avg_market_prices amp ON s.crop_id = amp.crop_id
GROUP BY c.crop_name, amp.avg_price
ORDER BY estimated_financial_loss DESC
LIMIT 5;
SELECT 
    r.route_id,
    ROUND(AVG(r.distance_km)::numeric, 2) AS distance_km,
    ROUND(AVG(s.transport_cost)::numeric, 2) AS avg_transport_cost,
    RANK() OVER (ORDER BY AVG(s.transport_cost) DESC) as cost_rank
FROM shipments s
JOIN routes r ON s.route_id = r.route_id
GROUP BY r.route_id, r.distance_km
ORDER BY cost_rank
LIMIT 10;
SELECT 
    c.crop_name,
    COUNT(s.shipment_id) AS total_shipments,
    SUM(s.spoiled_quantity_kg) AS total_spoiled_kg,
    ROUND(AVG(s.transport_cost)::numeric, 2) AS avg_transport_cost,
    CASE 
        WHEN SUM(s.spoiled_quantity_kg) > 10000 THEN 'Critical Spoilage Risk'
        WHEN SUM(s.spoiled_quantity_kg) BETWEEN 5000 AND 10000 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM shipments s
JOIN crops c ON s.crop_id = c.crop_id
GROUP BY c.crop_name
ORDER BY total_spoiled_kg DESC;
SELECT 
    shipment_id,
    route_id,
    transport_cost,
    spoiled_quantity_kg
FROM shipments
WHERE transport_cost > (
    SELECT AVG(transport_cost) 
    FROM shipments
)
ORDER BY transport_cost DESC
LIMIT 10;
SELECT 
    c.crop_name,
    COUNT(s.shipment_id) AS total_shipments,
    SUM(s.spoiled_quantity_kg) AS total_spoiled_kg,
    ROUND(AVG(r.distance_km)::numeric, 2) AS avg_distance_km,
    ROUND(AVG(s.transport_cost)::numeric, 2) AS avg_transport_cost
FROM shipments s
JOIN crops c ON s.crop_id = c.crop_id
JOIN routes r ON s.route_id = r.route_id
GROUP BY c.crop_name
ORDER BY total_spoiled_kg DESC
LIMIT 5;
CREATE OR REPLACE VIEW executive_supply_summary AS
SELECT 
    c.crop_name,
    COUNT(s.shipment_id) AS total_shipments,
    SUM(s.spoiled_quantity_kg) AS total_spoiled_kg,
    ROUND(AVG(r.distance_km)::numeric, 2) AS avg_distance_km,
    ROUND(AVG(s.transport_cost)::numeric, 2) AS avg_transport_cost
FROM shipments s
JOIN crops c ON s.crop_id = c.crop_id
JOIN routes r ON s.route_id = r.route_id
GROUP BY c.crop_name;
CREATE INDEX IF NOT EXISTS idx_shipments_crop ON shipments(crop_id);
CREATE INDEX IF NOT EXISTS idx_shipments_route ON shipments(route_id);
CREATE INDEX IF NOT EXISTS idx_market_prices_crop ON market_prices(crop_id);

CREATE OR REPLACE VIEW executive_supply_summary AS
SELECT 
    c.crop_name,
    COUNT(s.shipment_id) AS total_shipments,
    ROUND(AVG(s.spoiled_quantity_kg)::numeric, 2) AS avg_spoiled_kg
FROM shipments s
JOIN crops c ON s.crop_id = c.crop_id
GROUP BY c.crop_name
ORDER BY avg_spoiled_kg DESC;
DROP VIEW IF EXISTS executive_supply_summary;

DROP VIEW IF EXISTS executive_supply_summary CASCADE;



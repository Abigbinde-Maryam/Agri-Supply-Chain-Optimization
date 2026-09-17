
# Agri-Supply Chain & Post-Harvest Loss Optimization (Capstone)

## 📌 Project Overview
An enterprise-grade data analysis pipeline built to track post-harvest crop loss, transport logistics efficiency, and financial risk across a network of 370k+ shipments and market price databases using **PostgreSQL**.

## 🛠️ Tech Stack & Advanced SQL Techniques
- **Database:** PostgreSQL & DBeaver
- **Advanced Techniques:** Common Table Expressions (CTEs), Window Functions (`RANK()`), Conditional Logic (`CASE WHEN`), Multi-table Joins, Materialized Views, and Index Optimization.

## 📊 Key Business Insights & Deliverables
1. **Financial Loss Breakdown:** Calculated total revenue leakage by multiplying spoiled crop quantities with real-time market price trends.
2. **Logistics Bottlenecks:** Mapped high-cost transport routes against distance metrics to isolate margin drainers.
3. **Risk Categorization:** Developed automated risk-tiering logic (`CASE WHEN`) to flag high-spoilage crop categories.
4. **Executive Reporting:** Built a persistent SQL View (`executive_supply_summary`) to serve real-time metrics for stakeholder dashboards.
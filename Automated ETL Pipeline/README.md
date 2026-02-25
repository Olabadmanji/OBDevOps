
# Data Lake & Analytics Pipeline (Serverless)

A production-ready, end-to-end data engineering pipeline built on AWS. This project demonstrates the ability to ingest real-time streaming data, manage a multi-tier S3 Data Lake (Raw, Processed, Curated), automate ETL processes with AWS Glue, and deliver actionable insights via Athena and QuickSight.

## Architecture Overview

The pipeline follows the **Modern Data Architecture (MDA)** pattern:

* **Ingestion:** **Amazon Kinesis Data Streams** captures real-time event data.
* **Buffer & Transport:** **Amazon Kinesis Data Firehose** buffers the stream and delivers it to S3 with automated time-based partitioning.
* **Storage (The Data Lake):** **Amazon S3** serves as the centralized store, organized into three zones:
* `raw/`: Original JSON data.
* `processed/`: Cleaned Parquet data.
* `curated/`: Aggregated business-ready data.


* **Cataloging:** **AWS Glue Crawler** automatically infers schemas and populates the **AWS Glue Data Catalog**.
* **Transformation:** **AWS Glue ETL (Spark)** jobs transform raw JSON into optimized Parquet format and perform aggregations.
* **Analytics:** **Amazon Athena** enables serverless SQL queries directly against the S3 data lake.
* **Visualization:** **Amazon QuickSight** provides interactive BI dashboards for data-driven decision-making.

## Tech Stack

* **Cloud Provider:** AWS (Kinesis, S3, Glue, Athena, QuickSight, IAM, CloudWatch)
* **Infrastructure as Code (IaC):** AWS CloudFormation
* **Languages:** Python (PySpark for ETL), SQL (Athena), Shell (AWS CLI)
* **Data Formats:** JSON, Parquet (Snappy Compression)

## Key Features

* **Automated Partitioning:** Firehose automatically organizes data by `year/month/day/hour`, significantly reducing Athena query costs and improving performance.
* **Schema Evolution:** The Glue Crawler detects changes in the incoming data stream and updates the Data Catalog automatically.
* **Cost Optimization:** Uses **Parquet** columnar storage to reduce data scanned by Athena by up to 90% compared to JSON.
* **Full Serverless Lifecycle:** No servers to manage; the entire pipeline scales automatically based on data volume.


## Results & Artifacts

* **Real-time Dashboards:** Built a QuickSight visualization showing event distributions and unique user trends.
* **Optimized Storage:** Achieved significant storage savings and faster query times by transitioning from raw JSON to partitioned Parquet files.

🧹

## Project Cleanup
Automated stack deletion via CloudFormation for all compute and networking resources.

Manual S3 bucket purging and QuickSight account termination to ensure zero ongoing costs.
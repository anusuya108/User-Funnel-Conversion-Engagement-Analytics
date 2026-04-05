# User Funnel, Conversion & Engagement Analytics

## Project Overview
This project analyzes user behavior across a digital customer journey to identify drop-off points, conversion patterns, and engagement differences between purchasing and non-purchasing sessions.

The analysis was built using **Python, SQL Server, Excel, and Power BI** and focuses on answering key business questions such as:

- Where are users dropping off in the conversion funnel?
- Which acquisition sources drive the most purchases?
- How does user engagement differ between converted and non-converted sessions?
- Which device, country, and referral segments perform best?

---

## Tools & Technologies Used
- **Python** (Pandas, NumPy, Matplotlib, Seaborn)
- **SQL Server (SSMS)**
- **Excel**
- **Power BI**

---

## Dataset
The dataset simulates customer journey behavior and includes:

- Session ID
- User ID
- Timestamp
- Page Type
- Device Type
- Country
- Referral Source
- Time on Page
- Items in Cart
- Purchase Flag

---

## Project Workflow

### 1. Data Cleaning & Preparation (Python)
- Cleaned raw customer journey data
- Standardized column names and formats
- Converted timestamps
- Built session-level summary tables
- Created funnel stage flags

### 2. Exploratory Data Analysis (Python)
- Funnel stage analysis
- Device-wise conversion
- Referral source conversion
- Country-wise conversion
- Engagement comparison
- Drop-off analysis

### 3. SQL Analysis (SQL Server)
- Built session-level analysis table
- Calculated KPIs and conversion metrics
- Performed funnel analysis
- Segment analysis by device, source, and country
- Drop-off and high-intent user analysis

### 4. Dashboard Development (Power BI)
Built a 4-page interactive dashboard:
- Executive Overview
- Funnel & Conversion Analysis
- Engagement Analysis
- Drop-off & Segment Insights

---

## Key Insights
- Major user drop-offs occur in the middle funnel stages.
- Certain referral sources generate traffic but underperform in conversion.
- Purchased sessions generally show higher engagement levels.
- Some high-intent users abandon before completing conversion.

---

## Folder Structure

```bash
User-Funnel-Conversion-Engagement-Analytics/
│
├── data/
├── notebooks/
├── sql/
├── powerbi/
├── outputs/
├── README.md
└── requirements.txt
```

---

## Dashboard Screenshots

### Executive Overview
![Executive Overview](outputs/dashboard_screenshots/page1_executive_overview.png)

### Funnel & Conversion Analysis
![Funnel & Conversion Analysis](outputs/dashboard_screenshots/page2_funnel_conversion.png)

### Engagement Analysis
![Engagement Analysis](outputs/dashboard_screenshots/page3_engagement_analysis.png)

### Drop-off & Segment Insights
![Drop-off & Segment Insights](outputs/dashboard_screenshots/page4_dropoff_segments.png)

---

## How to Run This Project

### Python
1. Clone the repository
2. Install dependencies:
```bash
pip install -r requirements.txt
```
3. Run notebooks in order:
- `01_data_cleaning.ipynb`
- `02_eda_funnel_analysis.ipynb`

### SQL
1. Open SQL Server Management Studio
2. Run:
- `sql/01_user_funnel_analysis.sql`

### Power BI
1. Open:
- `powerbi/User_Funnel_Dashboard.pbix`

---

## Author
**Anusuya Moorthy**

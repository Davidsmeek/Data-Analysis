# CafeNova Sales Performance Analysis

## 📌 Project Overview
CafeNova is a casual dining chain whose management knew sales were growing but not **which items, categories and customer segments drive value, or where money is being lost**. This project cleans two years of raw order data, builds calculated business metrics and pivot-table analysis, and presents the results in a one-page **Excel dashboard** with KPI cards and slicers, plus a short PowerPoint of insights and recommendations.

The project was completed as the final project of the **Learn with George** data analytics course, working as a "Junior Data Analyst" on the brief provided.

---

## 🛠️ Tools & Technologies
- **Microsoft Excel**: Data cleaning, calculated columns, pivot tables, pivot charts, slicers and the dashboard
- **Microsoft PowerPoint**: Insights and recommendations deck

---

## 📁 Data Source
- **Dataset**: Raw restaurant order data supplied with the Learn with George final project brief (fictional restaurant chain scenario)
- **Workbook**: `CafeNova_David_Solomon_Dashboard.xlsx`, with sheets *Raw Data*, *Cleaned data1*, *Pivot Table* and *DashBoard*
- **Presentation**: `CafeNova_Insights_David_Solomon.pptx`

- **Raw records**: 17,541 rows (including 3 blank rows)
- **Cleaned records**: 17,104 orders
- **Period**: 1 January 2022 – 31 December 2023
- **Fields**: Order ID, Customer ID, Category, Item, Price per unit, Quantity, Total Sales, Order Date, Payment Method

---

## 🧹 Data Cleaning & Preparation
Raw data compared with the cleaned sheet shows these steps:

| Issue in raw data | Action | Rows affected |
|---|---|---|
| Blank rows and an empty column | Removed | 3 rows, 1 column |
| Exact duplicate orders | Removed | 4 |
| Missing **Quantity** and **Total Sales** (also missing item and unit price), so the order value could not be recovered | Removed | 430 |
| Missing **Price per unit** | Recalculated as `Total Sales / Quantity` | 446 |
| Missing **Item** | Filled by matching **Category + Price per unit** to the menu | 1,328 |
| Missing **Payment Method** | Filled with **Cash** | 943 |

**Result:** 17,541 → **17,104** rows with no missing values. Every order has a unique Order ID, and `Price × Quantity = Total Sales` holds for all 17,104 rows.

**Calculated columns added** (Excel table `Cleaned data1`):
- **Price per unit** = `Total Sales / Quantity`
- **Order Month** = `TEXT(Order Date, "MMM")`
- **Order Day** = `TEXT(Order Date, "DDD")`
- **Order Year** = `TEXT(Order Date, "YYYY")`

---

## 📊 Exploratory Data Analysis (EDA)

### 💵 Headline Metrics
- **Total Revenue**: $340,617.50
- **Number of Orders**: 17,104
- **Average Order Value**: $19.91
- **Unique Customers**: 100
- **Best-Selling Item (by revenue)**: Pasta Alfredo, $40,332 (11.8% of revenue)

### 🍽️ Sales by Category
| Category | Sales | Share of revenue | Orders | Avg. unit price |
|---|---|---|---|---|
| Main Dishes | $160,553.00 | 47.1% | 3,461 | $15.23 |
| Starters | $60,044.00 | 17.6% | 3,445 | $5.80 |
| Desserts | $56,883.00 | 16.7% | 3,403 | $5.56 |
| Side Dishes | $40,549.00 | 11.9% | 3,397 | $4.00 |
| Drinks | $22,588.50 | 6.6% | 3,398 | $2.21 |

### 📅 Sales Over Time
- **2022**: $174,102.00 | **2023**: $166,515.50 (**−4.4%**)
- Strongest month: **March** ($30,681.50 across both years) | Weakest: **September** ($26,839.00)
- Biggest single-month drop: **October 2023** vs October 2022 (−16.3%)
- Sales by day of week are fairly even: highest **Tuesday** ($49,723.00), lowest **Wednesday** ($47,013.50)

### 💳 Sales by Payment Method
| Method | Sales (dashboard) |
|---|---|
| Cash | $129,374.00 |
| Credit Card | $106,586.50 |
| Digital Wallet | $104,657.00 |

> The Cash figure includes 943 orders ($18,906.50) whose payment method was blank in the raw data and was set to Cash. Using only orders with a recorded method, the three methods are almost level: Cash 34.3%, Credit Card 33.1%, Digital Wallet 32.5%.

### 👥 Customers
- Top 5 customers by sales: CUST_089 ($4,112.00), CUST_020 ($4,064.50), CUST_028 ($4,056.00), CUST_017 ($4,041.50), CUST_066 ($4,032.50)
- The top 5 make up only **6.0%** of revenue, so sales are spread evenly across customers rather than concentrated in a few

---

## 📈 Key Insights & Analysis

### ✅ What's Working Well
- **Main Dishes** are the clear revenue driver: $160,553, or 47.1% of sales, from a similar number of orders to every other category
- **Pasta Alfredo** is the best-selling item by revenue
- No dependence on a few big customers: the top 5 are only 6.0% of revenue

### ⚠️ What Should Be Improved
- **Drinks** earn the least ($22,589, 6.6%). Order volume is in line with other categories (3,398 orders), so the gap comes from the low price per item ($2.21 average), not weak demand
- **Revenue fell 4.4% in 2023**, driven by Friday (−7.1%), Saturday (−12.4%) and Sunday (−7.6%), while Monday rose 2.6%
- All sales come from just **100 customers**, so growth depends on bringing in new ones

---

## 🧩 Interactive Dashboard Features
![CafeNova Sales Performance Analysis dashboard](images/dashboard.jpeg)

The one-page dashboard includes:
- **KPI cards**: Revenue, Orders, Customers, Best-Selling Item
- **Pivot charts**: Sales by Category, Sales by Month, Sales by Day, Sales by Payment Method, Orders by Category, Top 5 Customers
- **Slicers**: Category and Year

---

## ✅ Recommendations

### 1. Launch Drink and Dessert Promotions
- Bundle a drink with a main dish to lift the low-value drinks category
- Promote desserts to raise the value of each order

### 2. Introduce Mid-Week Offers
- Wednesday and Thursday are the two lowest-selling days ($47,013.50 and $47,992.50)
- Targeted offers can smooth weekday fluctuations

### 3. Run Customer Acquisition Campaigns
- Orders come from only 100 customers, so growth needs new buyers
- Loyalty offers can keep existing customers ordering

### 4. Investigate the 2023 Friday–Sunday Decline
- Compare staffing, menu and promotions between 2022 and 2023 on those days

---

## ⚠️ Limitations
- **Missing payment methods** (943) were filled with Cash, which overstates Cash sales
- **Missing item names** (1,328) were filled by Category + Price. Six category-and-price combinations are shared by two menu items (for example, Drinks at $3.00 are either Orange Juice or Lemonade), so some item-level counts may be wrong. Category totals, total revenue and the Main Dishes ranking are not affected
- **430 orders** with no quantity or value were removed, so true revenue may be slightly higher
- **No cost data**, so profit and margin cannot be analysed
- **One item per order**, so basket or combo analysis is not possible
- **No outlet or location field**, although the brief describes multiple outlets
- Only two years of data, so seasonality cannot be confirmed

---

## 📌 Conclusion
CafeNova earned **$340,617.50** from **17,104 orders** over two years. **Main Dishes** generate 47.1% of revenue and **Drinks** just 6.6%, mainly because of price rather than demand. Revenue fell **4.4%** in 2023, led by weaker Fridays, Saturdays and Sundays. Targeted drink and dessert promotions, mid-week offers and customer acquisition can lift sales, and the dashboard lets management filter by category and year to track the results.

---

## 📁 Additional Assets
- 📊 Excel dashboard with slicers by Category and Year: `CafeNova_David_Solomon_Dashboard.xlsx`
- 🖥️ Insights presentation: `CafeNova_Insights_David_Solomon.pptx`

---

> 📬 *Feel free to reach out if you'd like help building a dashboard, SQL queries, or a presentation deck!*

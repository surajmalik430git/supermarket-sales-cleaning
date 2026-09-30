# supermarket-sales-cleaning
# Supermarket Sales Data Cleaning (PostgreSQL)

## Problem
A raw sales dataset had duplicate orders, inconsistent spellings, five different date formats, and text mixed into number columns, so it could not be used for analysis as-is.

## What I fixed
- Removed duplicate orders and blank rows (352 rows -> 350 clean rows)
- Standardized `region` (23 inconsistent spellings -> 5 clean values: North, South, East, West, Central)
- Standardized `category` (20 inconsistent spellings -> 4 clean values: Furniture, Electronics, Appliances, Office Supplies)
- Cleaned `product` names (fixed inconsistent capitalization and spacing)
- Standardized `sales_rep` names (matched by last name to merge abbreviations and inconsistent casing into 10 clean full names)
- Converted `quantity` and `unit_price` from text (e.g. "22 units", "$117.00") into real numeric columns, and removed invalid negative quantities
- Converted `order_date` from 5 different text formats (YYYY-MM-DD, MM/DD/YYYY, DD-MM-YYYY, MM.DD.YY, Month DD, YYYY) into one consistent DATE column
- Replaced placeholder values ("N/A", blank text) in `notes` with proper NULL values
- Filled missing `channel` values with "Unknown" instead of leaving them blank
- Added a calculated `revenue` column (quantity × unit_price)

## Result
**352 messy rows -> 350 clean, analysis-ready rows**

## Before / After

**Region — before:**
<img width="416" height="370" alt="Screenshot 2026-09-30 123017" src="https://github.com/user-attachments/assets/c988e7b4-7e55-42b6-8968-3bfabe2c6d6b" />

**Region — after:**
<img width="499" height="385" alt="Screenshot 2026-09-30 123049" src="https://github.com/user-attachments/assets/6c4fa5f6-559a-495c-bc86-8c46a892dc76" />


**Order date — before:**
<img width="502" height="386" alt="Screenshot 2026-09-30 123144" src="https://github.com/user-attachments/assets/543339b6-d442-4cc4-b0b5-f9ab23071ff4" />

**Order date — after:**
<img width="430" height="383" alt="Screenshot 2026-09-30 123248" src="https://github.com/user-attachments/assets/7c273197-21b5-45d7-8a75-dd6e917ea1ed" />



## Sample of cleaned data
<img width="728" height="248" alt="Screenshot 2026-09-30 131146" src="https://github.com/user-attachments/assets/3268b8bc-0265-4a11-ba57-a4583425b88b" />


## Assumptions
- `/` dates were read as MM/DD/YYYY (US style)
- `-` dates were read as DD-MM-YYYY
- `.` dates were read as MM.DD.YY
- Negative quantities were treated as data entry errors and set to NULL rather than guessed at

## Tools
PostgreSQL, pgAdmin

## Files
- `supermarket_cleaning.sql` — full cleaning script, one section per fix
- Screenshots — before/after proof of the cleaning

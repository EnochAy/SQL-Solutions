import re
import csv

with open('C:/Users/ayomi/Documents/SQL Solutions/adashi_assessment.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# Pattern for plans_plan INSERT (20 columns)
insert_pattern = r"INSERT INTO `plans_plan` VALUES \('([^']+)','([^']*)','([^']*)',(\d+),([^,]*),([^,]*),([^,]*),'([^']+)',(\d+),'([^']+)',(\d+),([\d.]+),([^,]*),(\d+),(\d+),([\d.]+),(\d+),'([^']+)','([^']+)',(\d+)\);"
matches = re.findall(insert_pattern, sql)

with open('C:/Users/ayomi/Documents/SQL Solutions/plans_plan.csv', 'w', encoding='utf-8', newline='') as f:
    writer = csv.writer(f, quoting=csv.QUOTE_MINIMAL)
    writer.writerow(['id', 'name', 'description', 'amount', 'start_date', 'last_charge_date', 'next_charge_date', 'created_on', 'frequency_id', 'owner_id', 'status_id', 'interest_rate', 'withdrawal_date', 'default_plan', 'plan_type_id', 'goal', 'locked', 'next_returns_date', 'last_returns_date', 'cowry_amount'])
    for match in matches:
        row = [val if val != 'NULL' else '' for val in match]
        row = [val.replace('"', '""') if isinstance(val, str) else val for val in row]
        writer.writerow(row)

print("Created: plans_plan.csv")
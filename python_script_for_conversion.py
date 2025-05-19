import re

with open('C:/Users/ayomi/Documents/SQL Solutions/adashi_assessment.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# Replace backticks with double quotes
sql = re.sub(r'`([^`]+)`', r'"\1"', sql)
# Remove LOCK TABLES
sql = re.sub(r'LOCK TABLES .*?;\n', '', sql)
# Fix escaped apostrophes
sql = re.sub(r'\\\'', r"''", sql)
# Remove MySQL-specific SET statements
sql = re.sub(r'SET (SQL_MODE|FOREIGN_KEY_CHECKS).*?;\n', '', sql)
# Fix \n in strings (basic approach)
sql = re.sub(r'\\n', ' ', sql)

with open('C:/Users/ayomi/Documents/SQL Solutions/adashi_assessment_fixed.sql', 'w', encoding='utf-8') as f:
    f.write(sql)
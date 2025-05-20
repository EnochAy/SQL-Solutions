import re

with open('C:/Users/ayomi/Documents/SQL Solutions/adashi_assessment.sql', 'r', encoding='utf-8') as f:
    sql = f.read()

# Remove MySQL-specific comments
sql = re.sub(r'/\*!.*?;\n', '', sql)
# Remove ENGINE and CHARSET
sql = re.sub(r'ENGINE\s*=\s*\w+\s*(DEFAULT\s*CHARSET\s*=\s*\w+\s*)?;', ';', sql)
# Replace AUTO_INCREMENT with SERIAL
sql = re.sub(r'(\w+\s*)int(\s*NOT\s*NULL\s*)AUTO_INCREMENT', r'\1SERIAL PRIMARY KEY', sql)
# Fix UNIQUE KEY
sql = re.sub(r'UNIQUE\s*KEY\s*"\w+"\s*\("(\w+)"\)', r'UNIQUE ("\1")', sql)
# Remove LOCK TABLES and UNLOCK TABLES
sql = re.sub(r'(LOCK TABLES.*?\n|UNLOCK TABLES;\n)', '', sql)
# Remove SET statements
sql = re.sub(r'SET\s*(FOREIGN_KEY_CHECKS|SQL_MODE|UNIQUE_CHECKS).*?;\n', '', sql)
# Fix escaped apostrophes
sql = re.sub(r'\\\'', "''", sql)
# Replace backticks with double quotes (if not already done)
sql = re.sub(r'`([^`]+)`', r'"\1"', sql)
# Fix \n in strings
sql = re.sub(r'\\n', ' ', sql)

with open('C:/Users/ayomi/Documents/SQL Solutions/adashi_assessment_fixed.sql', 'w', encoding='utf-8') as f:
    f.write(sql)
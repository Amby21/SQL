import sqlite3
import csv
from contextlib import closing
from datetime import datetime

# closing() guarantees conn.close() even if something below raises,
# and `with conn:` commits on success / rolls back on error.
with closing(sqlite3.connect("shop.db", timeout=10)) as conn:
    with conn:
        cur = conn.cursor()

        # CREATING TABLE
        cur.execute("""
        CREATE TABLE IF NOT EXISTS leads_new (id INTEGER PRIMARY KEY NOT NULL, name TEXT, email TEXT, country TEXT, signup_date date)
        """)

        # READING CSV (DictReader already consumes the header row)
        to_insert = []
        with open("leads_raw.csv", mode='r', encoding='utf8', newline='') as file:
            reader = csv.DictReader(file)
            for row in reader:
                id = int(row['id'].strip())
                name = row['name'].strip()
                email = row['email'].strip()
                country = row['country'].strip() or None  # blank -> NULL so COALESCE works
                raw_date = row['signup_date'].strip()
                signup_date = datetime.strptime(raw_date, "%Y-%m-%d").strftime("%Y-%m-%d")

                to_insert.append((id, name, email, country, signup_date))

        # INSERT OR REPLACE so re-running the script doesn't hit UNIQUE constraint errors
        cur.executemany("INSERT OR REPLACE INTO leads_new VALUES (?,?,?,?,?)", to_insert)

        cur.execute('''SELECT id, COALESCE(country,'Unknown') AS country FROM leads_new;''')
        cur.execute('''SELECT id, TRIM(LOWER(email)), COUNT(*) AS entries FROM leads_new GROUP BY TRIM(LOWER(email)) HAVING entries > 1; ''')
        for row in cur.fetchall():
            print(row)
    conn.commit()
    conn.close()
import sqlite3
import csv
from contextlib import closing
from datetime import datetime

# closing() guarantees conn.close() even if something below raises,
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
        cur.execute(''' WITH cleaned AS (SELECT id, TRIM(LOWER(email)) AS email_clean, COUNT(*) OVER (PARTITION BY TRIM(LOWER(email))) AS dup_count FROM leads_new) SELECT id, email_clean, dup_count FROM cleaned WHERE dup_count > 1; ''')
        cur.execute(''' WITH cleaned AS (SELECT id, TRIM(LOWER(email)) AS email_clean, ROW_NUMBER() OVER (PARTITION BY TRIM(LOWER(email)) ORDER BY signup_date ASC) AS rank_cust FROM leads_new) SELECT id, email_clean, rank_cust FROM cleaned WHERE rank_cust > 1; ''')
        # Save the inserts first so the rollback below only undoes the DELETE.
        conn.commit()

        # REMOVING THE DUPLICATE (dry run)
        # Python's sqlite3 opens a transaction automatically before the DELETE,
        cur.execute('''
            -- Step 1: number each row within its email group, oldest signup = 1
            WITH ranked AS (
            SELECT id, ROW_NUMBER() OVER ( PARTITION BY TRIM(LOWER(email)) ORDER BY signup_date id ASC ) AS rank_cust
            FROM leads_new),
            -- Step 2: keep only the extra copies (anything after the first)
            duplicates AS (
            SELECT id FROM ranked WHERE rank_cust > 1
            )
            -- Step 3: delete those ids
            DELETE FROM leads_new 
            WHERE id IN (SELECT id FROM duplicates)
            RETURNING id, email
        ''')
        for row in cur.fetchall():
            print("would delete:", row)

        # Undo the DELETE. Swap this for conn.commit() to actually remove duplicates.
        conn.rollback()





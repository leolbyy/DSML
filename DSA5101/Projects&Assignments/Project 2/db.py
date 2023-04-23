import sqlite3
import pandas as pd

con = sqlite3.connect('./db.sqlite3')
cur = con.cursor()



data = pd.read_csv('./IMDB_top250.csv')
data = data.to_numpy()

data = [tuple(i) for i in data]




cur.executemany('INSERT INTO moives_moive VALUES (?,?,?,?,?,?)', data)
con.commit()

con.close()


# cmd = '''INSERT INTO moives_moive VALUES (2, 'test', 'PG13', 'really', '140')'''
# cur.execute(cmd)
# con.commit()


# cur.execute('''drop * from ''')
# print(cur.fetchall())
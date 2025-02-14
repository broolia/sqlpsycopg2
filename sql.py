import psycopg2

conn = psycopg2.connect("dbname=netology_db user=postgres password=postgres")
def create_table():
    with conn.cursor() as cur:
        cur.execute("""CREATE TABLE IF NOT EXISTS clients(id SERIAL PRIMARY KEY,first_name VARCHAR(100) NOT NULL, 
                last_name VARCHAR(100) NOT NULL, 
                email VARCHAR(100) UNIQUE)
                """)
        cur.execute("""CREATE TABLE IF NOT EXISTS phones(id SERIAL PRIMARY KEY,
                client_id INTEGER REFERENCES clients(id),
                phone_number VARCHAR(100) NOT NULL)""") 
    conn.commit()



def add_new_client(conn, first_name, last_name, email):
    with conn.cursor() as cur:
        try:
            cur.execute("INSERT INTO clients(first_name, last_name, email) VALUES (%s, %s, %s) RETURNING id", 
                        (first_name, last_name, email))
            client_id = cur.fetchone()[0]
            conn.commit()
            return client_id
        except psycopg2.errors.UniqueViolation:
            print(f"Error: Email {email} уже существует.  Клиент не добавлен.")  
            conn.rollback()  
            return None  

def add_phone(conn,client_id,phone_number):
    with conn.cursor() as cur:
        cur.execute ('INSERT INTO phones(client_id,phone_number)VALUES(%s,%s)',
                     (client_id,phone_number))
        conn.commit()

def update_client(conn, client_id, first_name=None, last_name=None, email=None):
    if client_id is None:  
        print("Не возможно обновить клиента с ID None.")
        return
    with conn.cursor() as cur:
        updates = []
        values = []
        if first_name:
            updates.append("first_name = %s")
            values.append(first_name)
        if last_name:
            updates.append("last_name = %s")
            values.append(last_name)
        if email:
            updates.append("email = %s")
            values.append(email)

        if updates:
            query = f"UPDATE clients SET {', '.join(updates)} WHERE id = %s"
            values.append(client_id)
            cur.execute(query, tuple(values))  
            conn.commit()
            print(f"Данные о клиенте с ID {client_id} успешно добавлена.")
        else:
            print("Не были переданы данные для обновления записи.")

    
 
def delete_phone_number(conn, client_id):
        with conn .cursor() as cur:
            cur.execute("DELETE FROM phones WHERE client_id = %s",(client_id,))
            conn.commit()   
    
def delete_client(conn, client_id):
        with conn.cursor() as cur:
            cur.execute("DELETE FROM phones  WHERE client_id = %s",(client_id,))
            cur.execute("DELETE FROM clients WHERE id = %s",(client_id,))
            conn.commit()

    

def find_client(conn,query):
        with conn.cursor() as cur:
            cur.execute('''
            SELECT c.id, c.first_name, c.last_name, c.email, p.phone_number
            FROM clients c
            LEFT JOIN phones p ON c.id = p.client_id
            WHERE c.first_name LIKE %s OR c.last_name LIKE %s OR c.email LIKE %s OR p.phone_number LIKE %s
            ''', ('%' + query + '%', '%' + query + '%', '%' + query + '%', '%' + query + '%'))
            return cur.fetchall()
def check_if_client_exists(conn, email):
  with conn.cursor() as cur:
    cur.execute("SELECT id FROM clients WHERE email = %s", (email,))
    result = cur.fetchone()
    return result is not None


if not check_if_client_exists(conn, "zahar@gmail.com"):
    client_id_3 = add_new_client(conn, "Захар", "Иванов", "zahar@gmail.com")
    if client_id_3:
        add_phone(conn, client_id_3, "+7912899789")
        update_client(conn, client_id_3, email="new_zahar@egmail.com")
        print(find_client(conn, "Захар"))
        delete_phone_number(conn, client_id_3)
        print(find_client(conn, "Иванов"))
        delete_client(conn, client_id_3)
        print(find_client(conn, "Захар"))
else:
    print("Клиент Захар уже существует")


if not check_if_client_exists(conn, "joorka@gmail.com"):
    client_id_4 = add_new_client(conn, "Марина", "Тарасова", "joorka@gmail.com")
    if client_id_4:
        add_phone(conn, client_id_4, "+7918856789")
        update_client(conn, client_id_4, email="new_joorka@example.com")
        print(find_client(conn, "Марина"))
        delete_phone_number(conn, client_id_4)
        print(find_client(conn, "Марина"))
        delete_client(conn, client_id_4)
        print(find_client(conn, "Марина"))
else:
     print("Клиент Марина уже существует")

for client in find_client(conn, ""):
    print(client)

conn.close()
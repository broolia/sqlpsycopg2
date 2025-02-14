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
            print(f"Error: Email {email} already exists.  Client not added.")  
            conn.rollback()  
            return None  

def add_phone(conn,client_id,phone_number):
    with conn.cursor() as cur:
        cur.execute ('INSERT INTO phones(client_id,phone_number)VALUES(%s,%s)',
                     (client_id,phone_number))
        conn.commit()

def update_client(conn, client_id, first_name=None, last_name=None, email=None):
    if client_id is None:  
        print("Cannot update client with ID None.")
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
            print(f"Client data with ID {client_id} successfully updated.")
        else:
            print("No data provided for update.")

    
 
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

try:
    create_table()

    client_id_1 = add_new_client(conn, "Иван", "Иванов", "ivan@example.com")
    if client_id_1:
        add_phone(conn, client_id_1, "+79123456789")
        update_client(conn, client_id_1, email="new_ivan@example.com")
        print(find_client(conn, "Иван"))
        delete_phone_number(conn, client_id_1)
        print(find_client(conn, "Иван"))
        delete_client(conn, client_id_1)  
        print(find_client(conn, "Иван")) 

    client_id_2 = add_new_client(conn, "Татьяна", "Иванова", "moorka@gmail.com")
    if client_id_2:
        add_phone(conn, client_id_2, "+7918856789")  
        update_client(conn, client_id_2, email="new_moorka@example.com")  
        print(find_client(conn, "Татьяна"))
        delete_phone_number(conn, client_id_2)
        print(find_client(conn, "Татьяна"))
        delete_client(conn, client_id_2)
        print(find_client(conn, "Татьяна"))

        for client in find_client(conn, ""): 
            print(client)

finally:
    conn.close()
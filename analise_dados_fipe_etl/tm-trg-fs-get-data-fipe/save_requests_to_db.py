import requests

import pyodbc
# Some other example server values are
#server = 'tcp:srv-fipe-server.database.windows.net'
server = 'DESKTOP-GE5SU9S'
database = 'db_fipe'
username = 'dev_user'
password = 'P@ssw0rd'
# ENCRYPT defaults to yes starting in ODBC Driver 18. It's good to always specify ENCRYPT=yes on the client side to avoid MITM attacks.


conn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';ENCRYPT=no;UID='+username+';PWD='+ password)
"""

dados_conexao = (
    "Driver={SQL Server};",
    "Server=localhost;",
    "Database=db_fipe;"
)
conexao =  pyodbc.connect(dados_conexao)
print("Conexao bem sucedida" )


"""


print(conn)
cursor = conn.cursor()
print(cursor)

#Sample select query
cursor.execute("SELECT @@version;")
row = cursor.fetchone()
print(row)

while row:
    print(row[0])
    row = cursor.fetchone()


"""
# Selecionar os parâmetros necessários do banco de dados
cursor.execute('SELECT COD_MODE, modelo, ano FROM minha_tabela')

params = cursor.fetchone()

# Construir a URL da API com base nos parâmetros selecionados
url = f'https://veiculos.fipe.org.br/api/veiculos/motos/marcas/{params[0]}/modelos/{params[1]}/anos/{params[2]}/valores'

# Enviar uma solicitação REST
response = requests.get(url)

# Obter os dados da resposta
data = response.json()

# Salvar os dados no banco de dados
for row in data:
    cursor.execute('INSERT INTO minha_tabela_fipe (marca, modelo, ano, valor) VALUES (?, ?, ?, ?)',
                   params[0], params[1], params[2], row['Valor'])

conn.commit()
"""
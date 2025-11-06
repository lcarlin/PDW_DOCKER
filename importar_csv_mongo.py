import pandas as pd
from pymongo import MongoClient

# Conectar ao MongoDB local
cliente = MongoClient('mongodb://localhost:27017/')

# Criar ou acessar o banco e a coleção
db = cliente['meu_banco']
colecao = db['lancamentos_gerais']

# Ler o CSV usando pandas
arquivo_csv = 'LANCAMENTOS_GERAIS.FULL.v2.csv'
df = pd.read_csv(arquivo_csv, sep=';', encoding='latin1')  # ajuste o separador se necessário
print(len(df))
# Converter para dicionário e inserir no MongoDB

dados = df.to_dict(orient='records')
resultado = colecao.insert_many(dados)

print(f'{len(resultado.inserted_ids)} registros inseridos com sucesso.')


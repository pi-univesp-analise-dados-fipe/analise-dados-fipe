import requests
from tipo_veiculo import TipoVeiculo

url_base_api = "https://parallelum.com.br/fipe/api/v2"
endpoint_marcas = "brands"
endpoint_modelos = "models"
endpoint_referencia = "references"
endpoint_anos = "years"
endpoint_historico = "history"

def get_marcas_por_tipo(tipo_veiculo):
    url_marca = f"{url_base_api}/{tipo_veiculo}/{endpoint_marcas}"
    response = requests.get(url_marca)
    return response.json()


def get_periodo_referencia():
    url_ref = f"{url_base_api}/{endpoint_referencia}"
    response = requests.get(url_ref)
    return response.json()


def get_modelos_por_marca(tipo_veiculo, marca_nome):
    marcas = get_marcas_por_tipo(tipo_veiculo)

    # Encontrar o ID da marca desejada
    marca_id = None
    for marca in marcas:
        if marca["name"].lower() == marca_nome.lower():
            marca_id = marca["code"]
            break

    # Se a marca não for encontrada, retornar None
    if marca_id is None:
        return None

    # Obter a lista de modelos da marca
    response = requests.get(f"{url_base_api}/{tipo_veiculo}/{endpoint_marcas}/{marca_id}/{endpoint_modelos}")
    models = response.json()
    return models, marca


def get_anos_por_modelo(tipo_veiculo, marca_nome, modelo_nome):
    modelos, marca = get_modelos_por_marca(tipo_veiculo, marca_nome)
    marca_id = marca["code"]

    # Encontrar o ID do modelo desejado
    modelo_id = None
    for modelo in modelos:
        if modelo["name"].lower() == modelo_nome.lower():
            modelo_id = modelo["code"]
            break

    # Se a marca não for encontrada, retornar None
    if modelo_id is None:
        return None

    # Obter a lista de anos do modelo
    url_ano_modelo = \
        f"{url_base_api}/{tipo_veiculo}/{endpoint_marcas}/{marca_id}/{endpoint_modelos}/{modelo_id}/{endpoint_anos}"
    response = requests.get(url_ano_modelo)
    ano_modelo = response.json()
    return ano_modelo, modelo, marca

def get_dados_veiculo_por_modelo(tipo_veiculo, marca, modelo, ano):
    #leitura de dados do modelo
    anos, modelo, marca = get_anos_por_modelo(tipo_veiculo, marca, modelo)

    #armazena os ids para composição de endpoint
    modelo_id = modelo["code"]
    marca_id = marca["code"]

    # Obter dados do modelo
    url_dados_veiculo = f"{url_base_api}/{tipo_veiculo}/{endpoint_marcas}/{marca_id}/{endpoint_modelos}/{modelo_id}/{endpoint_anos}/{ano}"
    response = requests.get(url_dados_veiculo)
    dados_modelo = response.json()
    return dados_modelo

def get_anos_por_codigo_FIPE(tipo_veiculo, codigo_FIPE):
    url_anos_veiculo = f"{url_base_api}/{tipo_veiculo}/{codigo_FIPE}/{endpoint_anos}"
    response = requests.get(url_anos_veiculo)
    anos_modelo = response.json()
    return anos_modelo


def get_dados_veiculo_por_codigo_FIPE(tipo_veiculo, codigo_FIPE, ano):
    url_dados_veiculo = f"{url_base_api}/{tipo_veiculo}/{codigo_FIPE}/{endpoint_anos}/{ano}"
    response = requests.get(url_dados_veiculo)
    dados_modelo = response.json()
    return dados_modelo


def get_historico_precos_por_codigo_FIPE(tipo_veiculo, codigo_FIPE, ano):
    url_historico_preco = f"{url_base_api}/{tipo_veiculo}/{codigo_FIPE}/{endpoint_anos}/{ano}/{endpoint_historico}"
    response = requests.get(url_historico_preco)
    historico_preco = response.json()
    return historico_preco

if __name__ == '__main__':
    # Tipos de veículos: "cars" "motorcycles" "trucks"
    print(TipoVeiculo.cars.name) #criada Enumeração para apoiar na chamada das funções de acesso à API
    # print(get_periodo_referencia())
    # print(get_marcas_por_tipo("cars"))
    # print(get_modelos_por_marca("cars", "Fiat"))   #retorna dados do modelo
    # print(get_modelos_por_marca("cars","Fiat")[1]) #retorna dados da marca
    # print(get_anos_por_modelo("cars", "Fiat", "147 C/ CL"))
    # print(get_anos_por_modelo("cars", "Fiat", "147 C/ CL")[1])
    # print(get_anos_por_modelo("cars", "Fiat", "147 C/ CL")[2])
    # print(get_dados_veiculo_por_modelo("cars", "Fiat", "147 C/ CL","1987-1"))
    # print(get_anos_por_codigo_FIPE("cars", "001124-0"))
    # print(get_dados_veiculo_por_codigo_FIPE("cars", "001124-0", "1987-1"))
    #print(get_historico_precos_por_codigo_FIPE("cars", "001124-0", "1987-1"))



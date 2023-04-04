import winsound

import requests
import datetime
import logging
import json
import datetime

from requests import JSONDecodeError

from tipo_veiculo_fipe import TipoVeiculoFipe
from operator import itemgetter

urlBaseAPI = "https://veiculos.fipe.org.br/api/veiculos"
endpoint_marcas = "ConsultarMarcas"
endpoint_modelos = "ConsultarModelos"
endpoint_referencia = "ConsultarTabelaDeReferencia"
endpointDadosModelo = "ConsultarValorComTodosParametros"
endpointAnoModelo = "ConsultarAnoModelo"


def get_periodo_referencia():
    url_ref = f"{urlBaseAPI}/{endpoint_referencia}"
    response = requests.post(url_ref)
    try:
        dados = response.json()
    except JSONDecodeError:
        print(f"Erro ao processar requisição.  Modelo: {url_ref}")
    return dados


def getMaxReferencia():
    listaReferencia = get_periodo_referencia()
    listaCodigosRef = list()
    for item in listaReferencia:
        listaCodigosRef.append(item['Codigo'])
    return max(listaCodigosRef)

def save_json_periodo_referencia():
    data = get_periodo_referencia()
    save_file_json(data, "dados_referencia", False)

def get_marcas_por_tipo(codigoTipoVeiculo, codigoMesReferencia):
    url_marca = f"{urlBaseAPI}/{endpoint_marcas}?codigoTipoVeiculo={codigoTipoVeiculo}&codigoTabelaReferencia={codigoMesReferencia}"
    response = requests.post(url_marca)
    #listaMarcas = list()
    lista_dados_modelo = list()
    try:
        marcas = response.json()
    except JSONDecodeError:
        print(f"Erro ao processar requisição.  Modelo: {url_marca}")
    for marca in marcas:
        marca["codigoMarca"] = int(marca["Value"])
        marca["nomeMarca"] = marca["Label"]
        marca["codigoTipoVeiculo"] = codigoTipoVeiculo
        marca["codigoMesReferencia"] = codigoMesReferencia
        del marca["Value"]
        del marca["Label"]
        #   listaMarcas.append(marca)
    return marcas


def save_json_todas_marcas():
    maxReferencia = getMaxReferencia()
    listaMarcas = list()
    for tipo in TipoVeiculoFipe:
        marcas = get_marcas_por_tipo(tipo.value, maxReferencia)
        for marca in marcas:
            listaMarcas.append(marca)
    #    print(marcas)
    #save_file_json(listaMarcas, f"marcas/marcas_{tipo.name}", False)
    #print(listaMarcas)
    save_file_json(listaMarcas, f"marcas/marcas", False)


def get_modelos_por_marca(codigoTipoVeiculo, codigoMesReferencia, codigoMarca):
    urlModelo = f"{urlBaseAPI}/{endpoint_modelos}?codigoTipoVeiculo={codigoTipoVeiculo}&codigoTabelaReferencia={codigoMesReferencia}&codigoMarca={codigoMarca}"
    response = requests.post(urlModelo)
    try:
        dados_modelo = response.json()
    except JSONDecodeError:
        print(f"Erro ao processar requisição.  Modelo: {urlModelo}")
    dados_modelo["CodigoMarca"] = codigoMarca
    modelos = dados_modelo["Modelos"]
    for modelo in modelos:
        modelo["codigoModelo"] = modelo["Value"]
        modelo["nomeModelo"] = modelo["Label"]
        modelo["codigoTipoVeiculo"] = codigoTipoVeiculo
        modelo["codigoMesReferencia"] = codigoMesReferencia
        modelo["codigoMarca"] = codigoMarca
        del modelo["Value"]
        del modelo["Label"]
    return modelos

def get_todos_modelos():
    maxReferencia = getMaxReferencia()
    listaModelos = list()
    for tipo in TipoVeiculoFipe:
        marcas = get_marcas_por_tipo(tipo.value, maxReferencia)
        for marca in marcas:
            modelos = get_modelos_por_marca(codigoTipoVeiculo=tipo.value, codigoMesReferencia=maxReferencia,
                                            codigoMarca=int(marca["codigoMarca"]))
            for modelo in modelos:
                listaModelos.append(modelo)
    return listaModelos

def get_todos_modelos(tipoVeiculo, codigoMesReferencia):
    if (codigoMesReferencia is None):
        codigoMesReferencia = getMaxReferencia()
    listaModelos = list()
    marcas = get_marcas_por_tipo(tipoVeiculo.value, codigoMesReferencia)
    for marca in marcas:
        modelos = get_modelos_por_marca(codigoTipoVeiculo=tipoVeiculo.value, codigoMesReferencia=codigoMesReferencia,
                                            codigoMarca=int(marca["codigoMarca"]))
        for modelo in modelos:
                listaModelos.append(modelo)
    return listaModelos


def save_json_todos_modelos(listaModelos):
    save_file_json(listaModelos, f"modelos/modelos", False)


def save_file_json(data, filename, dated):
    if dated:
        now = datetime.datetime.now()
        file_name = f"json/fipe/{filename}_" + now.strftime("%Y%m%d") + ".json"
    else:
        file_name = f"json/fipe/{filename}.json"
    with open(file_name, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False)


def get_dados_modelo(codigoTipoVeiculo, codigoMesReferencia, codigoMarca, codigoModelo, anoModelo, codigoTipoCombustivel):
    tipoConsulta = "tradicional"
    urlDadosModelo = \
                        f"{urlBaseAPI}/{endpointDadosModelo}?" \
                        f"codigoTipoVeiculo={codigoTipoVeiculo}&" \
                        f"codigoTabelaReferencia={codigoMesReferencia}&" \
                        f"codigoMarca={codigoMarca}&" \
                        f"codigoModelo={codigoModelo}&anoModelo={anoModelo}&" \
                        f"codigoTipoCombustivel={codigoTipoCombustivel}&tipoConsulta={tipoConsulta}"
    response = requests.post(urlDadosModelo)
    lista_dados_modelo = list()
    try:
        dados_modelo = response.json()
    except JSONDecodeError:
        print(f"Erro ao processar requisição.  Modelo: {urlDadosModelo}")
    dados_modelo["codigoTipoVeiculo"] = codigoTipoVeiculo
    dados_modelo["codigoMesReferencia"] = codigoMesReferencia
    dados_modelo["codigoMarca"] = codigoMarca
    dados_modelo["codigoModelo"] = codigoModelo
    dados_modelo["codigoTipoCombustivel"] = codigoTipoCombustivel
    return dados_modelo

def get_anos_modelo(codigoTipoVeiculo, codMesReferencia, codigoMarca, codigoModelo):
    urlModelo = f"{urlBaseAPI}/{endpointAnoModelo}?" \
                f"codigoTipoVeiculo={codigoTipoVeiculo}&" \
                f"codigoTabelaReferencia={codMesReferencia}&" \
                f"codigoMarca={codigoMarca}&" \
                f"codigoModelo={codigoModelo}"
    response = requests.post(urlModelo)
    try:
        anosModelo = response.json()
    except JSONDecodeError:
        print(f"Erro ao processar requisição.  Modelo: {urlModelo}")
    return anosModelo

def get_ano_atual():
    return datetime.date.today().year

def get_data_atual():
    return datetime.date.today()

def get_amostra_dados_todos_modelos(tamanhoAmostra, tipoVeiculo, verbose):
    modelos = get_todos_modelos(tipoVeiculo)
    listaDadosModelo = list()
    i = 0
    for modelo in modelos:
        if (verbose and (i % 100 == 0)):
            print(f"Lendo dados de amostra do modelo {i + 1} de {tamanhoAmostra}. Tipo de veiculo: {tipoVeiculo.name}. Modelo: {modelo}")
        codigoTipoVeiculo = int(modelo["codigoTipoVeiculo"])
        codigoMesReferencia = int(modelo["codigoMesReferencia"])
        codigoMarca = int(modelo["codigoMarca"])
        codigoModelo = int(modelo["codigoModelo"])
        anosModelo = get_anos_modelo(codigoTipoVeiculo=codigoTipoVeiculo,
                                    codMesReferencia=codigoMesReferencia,
                                    codigoMarca=codigoMarca,
                                    codigoModelo=codigoModelo
                                    )
        #codTipoVeiculo, codMesReferencia, codigoMarca, codigoModelo
        for anoModelo in anosModelo:
            if len(anoModelo['Label']) >= 2:
                anoModelo["ano"] = numAnoModelo = anoModelo['Label'].split()[0]
                anoModelo["combustivel"] = anoModelo['Label'].split()[1]
                codigoTipoCombustivel = int(get_codigo_tipo_combustivel(anoModelo['Label'].split()[1]))
            else:
                numAnoModelo = get_ano_atual()
                codigoTipoCombustivel = 1
            try:
                dados_modelo = get_dados_modelo(codigoTipoVeiculo, codigoMesReferencia, codigoMarca, codigoModelo, numAnoModelo,
                                     codigoTipoCombustivel)
            except JSONDecodeError:
                print(f"Erro ao processar requisição.  Modelo: {modelo}")
                break
            if ("codigo" not in dados_modelo):
                listaDadosModelo.append(dados_modelo)
        i = i + 1
        if (i >= tamanhoAmostra):
            break
    return listaDadosModelo


def get_dados_todos_modelos(tipoVeiculo, qtdAnosRetroativos, codigoMesReferencia, verbose):
    modelos = get_todos_modelos(tipoVeiculo, codigoMesReferencia)
    listaDadosModelo = list()
    if (codigoMesReferencia is None):
        codigoMesReferencia = getMaxReferencia()
    i = 0
    if (qtdAnosRetroativos is not None):
        anoInicio = get_ano_atual() - qtdAnosRetroativos
    for modelo in modelos:
        if(verbose):
            print(f"Lendo dados de modelo {i + 1} de {len(modelos)}. Codigo Mês Referência: {codigoMesReferencia} "
                  f"Tipo de veiculo: {tipoVeiculo.name}. Modelo: {modelo}")
        codigoTipoVeiculo = int(modelo["codigoTipoVeiculo"])
        modelo["codigoMesReferencia"] = codigoMesReferencia
        codigoMarca = int(modelo["codigoMarca"])
        codigoModelo = int(modelo["codigoModelo"])
        anosModelo = get_anos_modelo(codigoTipoVeiculo=codigoTipoVeiculo,
                                    codMesReferencia=codigoMesReferencia,
                                    codigoMarca=codigoMarca,
                                    codigoModelo=codigoModelo
                                    )
        for anoModelo in anosModelo:

            if (tipoVeiculo.value == 1): #carro
                if ('Label' in anoModelo):
                    anoModelo["ano"] = numAnoModelo = int(anoModelo['Label'].split()[0])
                    anoModelo["combustivel"] = anoModelo['Label'].split()[1]
                    codigoTipoCombustivel = int(get_codigo_tipo_combustivel(anoModelo['Label'].split()[1]))
                else:
                    anoModelo["ano"] = numAnoModelo = get_ano_atual()
                    codigoTipoCombustivel = 1
            elif (tipoVeiculo.value == 2): #moto:
                if ('Label' in anoModelo):
                    anoModelo["ano"] = numAnoModelo = int(anoModelo['Label'])
                else:
                    anoModelo["ano"] = numAnoModelo = get_ano_atual()
                codigoTipoCombustivel = 1
            elif (tipoVeiculo.value == 3): #caminhão
                if ('Label' in anoModelo):
                    anoModelo["ano"] = numAnoModelo = int(anoModelo['Label'])
                else:
                    anoModelo["ano"] = numAnoModelo = get_ano_atual()
                codigoTipoCombustivel = 3
            if (qtdAnosRetroativos is not None):
                if (numAnoModelo < anoInicio ):
                    break
            dados_modelo = get_dados_modelo(codigoTipoVeiculo, codigoMesReferencia, codigoMarca, codigoModelo, numAnoModelo,
                                     codigoTipoCombustivel)
            listaDadosModelo.append(dados_modelo)
        i = i + 1
    return listaDadosModelo


def get_codigo_tipo_combustivel(tipoCombustivel):
    tipoCombustivel = tipoCombustivel.lower()
    return {
            'gasolina': 1,
            'álcool': 2,
            'diesel': 3,
        }.get(tipoCombustivel, 0)


def save_json_dados_todos_modelos(dadosModelo, tipoVeiculo, flgAmostra, codigoMesReferencia):
    if (flgAmostra):
        save_file_json(dadosModelo, f"modelos/amostra_dados_modelo_{tipoVeiculo.name}_{len(dadosModelo)}_{codigoMesReferencia}", False)
    else:
        save_file_json(dadosModelo, f"modelos/dados_modelo_{tipoVeiculo.name}_{codigoMesReferencia}", False)

def save_json_dados_todos_modelos_periodo(minCodigoMesReferencia, maxCodigoMesReferencia, tipoVeiculo, qtdAnosRetroativos):
    # dados = get_amostra_dados_todos_modelos(tamanhoAmostra=tamanho_amostra, verbose=True)
    periodos = get_periodo_referencia()
    for periodo in periodos:
        try:
            if (periodo["Codigo"] >= minCodigoMesReferencia and periodo["Codigo"] < maxCodigoMesReferencia ):
                codigoMesReferencia = periodo["Codigo"]
                dados = get_dados_todos_modelos(tipoVeiculo=tipoVeiculo, verbose=True, qtdAnosRetroativos=qtdAnosRetroativos,
                                                codigoMesReferencia=codigoMesReferencia)
                save_json_dados_todos_modelos(dadosModelo=dados, tipoVeiculo=tipoVeiculo, flgAmostra=False,
                                              codigoMesReferencia=codigoMesReferencia)
                print(f"Salvo os dados dos modelos: {datetime.datetime.now()}")
        except:
            pass

def save_json_dados_todos_modelos_periodo(codigoMesReferencia, tipoVeiculo, qtdAnosRetroativos, verbose):
    dados = get_dados_todos_modelos(tipoVeiculo=tipoVeiculo, verbose=verbose, qtdAnosRetroativos=qtdAnosRetroativos,
                                    codigoMesReferencia=codigoMesReferencia)
    save_json_dados_todos_modelos(dadosModelo=dados, tipoVeiculo=tipoVeiculo, flgAmostra=False,
                                  codigoMesReferencia=codigoMesReferencia)
    print(f"Salvo os dados dos modelos do periodo {codigoMesReferencia}. Tipo de Veiculo: {tipoVeiculo.name}. Data: {datetime.datetime.now()}")


if __name__ == '__main__':

    # save_json_todos_modelos()
    # Chamada 2 - Get Marcas - salva todas as marcas em arquivos json
    # maxReferencia = getMaxReferencia()
    # print(getMaxReferencia())

    #  print(get_modelos_por_marca(1, 295,  1))
    # def get_ano_modelo(tipoVeiculo, mesReferencia, codigoTipoVeiculo, codigoMarca, codigoModelo):
    #    data = get_anos_modelo(tipoVeiculo=1,mesReferencia= 250,codigoTipoVeiculo= 1,codigoMarca= 6,codigoModelo=7727)
    # save_json_dados_todos_modelos()
    # save_json_periodo_referencia()
    # save_json_todas_marcas()
    # save_json_todas_marcas()
    print(f"Início de execucao: {datetime.datetime.now()}")

    # save_json_todos_modelos(get_todos_modelos())
    # print(f"Salva a lista de modelos: {datetime.now()}")
    anos_pendentes = [283, 280, 274, 271, 270, 267, 265, 264, 263, 260, 253, 250]
    for ano in anos_pendentes:
        try:
            save_json_dados_todos_modelos_periodo(codigoMesReferencia=ano, tipoVeiculo=TipoVeiculoFipe.caminhao, qtdAnosRetroativos=15, verbose=False)
        except:
            pass



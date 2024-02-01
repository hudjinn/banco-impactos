# Banco Impactos de Seca

## Requisitos

- Docker instalado na sua máquina local ou em um servidor acessível.


## Como Usar

1. Clone este repositório:

    ```bash
    git clone http://gitlab-ce.funceme.br/jefferson.galvao/banco-impactos-seca.git
    ```

2. Navegue até o diretório do repositório:

    ```bash
    cd banco-impactos-seca
    ```

3. Execute o seguinte comando para construir o contêiner:

    ```bash
    docker compose up -d --build
    ```

4. O Banco PostGRES estará acessível por `PSQL` ou `PgAdmin` com o IP do seu computador

## Estrutura do Banco de Dados

O banco de dados inclui as seguintes tabelas:

- `acesso_agua`
- `de_chuva`
- `dt_chuva`
- `impactos_seca`
- `limites_estaduais_ibge_2022`
- `limites_municipais_ibge_2022`
- `percepcao_seca`
- `problema_restricao`
- `qnt_chuva`
- `sit_cultura`
- `tipo_cultura`

Além disso, há duas visões:

- `view_impactos_seca`: visão com a junção de todas as tabelas, apenas com as descrições textuais das opções.
- `view_impactos_seca_with_values`: visão com a junção de todas as tabelas, contendo código id e descrição textual das opções.

## Funções

- `reset_sequence_trigger`: Função que redefine a sequência de ID na tabela `impactos_seca` com base no código do município e no ano/mês.
- `valida_problema_restricao_func`: Função que valida se os valores em um array de IDs de problemas/restrições existem na tabela `problema_restricao`.
- `valida_tipo_cultura_func`: Função que valida se os valores em um array de IDs de tipos de cultura existem na tabela `tipo_cultura`.

## Personalização

- Certifique-se de ajustar as credenciais do banco de dados e o nome do script SQL conforme necessário.
- Se o script SQL estiver em um local diferente, modifique o caminho montado no comando `docker run`.

## Autores

- [Jefferson Sant'ana Galvão](https://gitlab-ce.com/jefferson.galvao) - Geógrafo, Analista de Sistemas. Especialista em Sistema de Informação Espacial (Geoprocessamento).

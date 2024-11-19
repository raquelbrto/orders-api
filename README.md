# ORDERS API
API desenvolvida para o desafio técnico do LuizaLabs. Foi desenvolvida uma API que recebe e le um arquivo txt e retonar os dados normalizados de acordo com os padrões pedidos. 
## Arquitetura
A arquitetura implementada foi a clean architecture, onde implementi as camadas controllers, use cases, presenters e gateways.
## Versions
    * Ruby (3.1.3)
    * Rails (7.2.x)
    * Redis 
    * PostgreSQL(15+)

## Setup
### 1. Clone o repositorio 
      git clone https://github.com/viniciusborgeis/luizalabs-test
    
### 2. Crie o .env do projeto
      cp .env.sample .env

### Setup docker
Caso tenha o docker instalado, use os seguintes comandos para subir o conteiner da API.

#### 1. Build a aplicação
    docker-compose build

#### 2. Criar databases e migrations
    docker-compose run app rails db:create db:migrate

#### 3. Subir conteiner
    docker-compose up

### Setup rails server

#### 1. Rode o bundle install
    bundle install

#### 2. Crie o banco 
    rake db:create

#### 3. Rode migrations
    rake db:migrate

#### 4. Suba a aplicação 
    rails server 

## Executar testes
### Bundle exec
    bundle exec rspec

### Docer run
    docker-compose run app rspec


## Endpoints
### Transactions

#### Processa o arquivo txt recebido e retorna o json

```http
  GET /api/v1/transactions/process-file
```

| Parâmetro   | Tipo       | Descrição                           |
| :---------- | :--------- | :---------------------------------- |
| `file` | `txt/plain` | **Obrigatório**. Arquivo com dados dos pedidos |

Exemplo de resposta:

    [
        {
            "user_id": 70,
            "name": "Palmer Prosacco",
            "orders": [
                {
                    "order_id": 753,
                    "total": "2836.74",
                    "products": [
                        {
                            "product_id": 3,
                            "value": "2836.74"
                        }
                    ]
                }
            ]
        },
        {
            "user_id": 49,
            "name": "Ken Wintheiser",
            "orders": [
                {
                    "order_id": 523,
                    "total": "586.74",
                    "products": [
                        {
                            "product_id": 3,
                            "value": "586.74"
                        }
                    ]
                }
            ]
        }
    ]

### Orders

#### Retorna um pedido

```http
  GET /api/v1/orders/{id}
```

| Parâmetro   | Tipo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `integer` | **Obrigatório**. O ID do pedido        |

Exemplo resposta:

    {
        "order_id": 0,
        "date": "2024-11-19",
        "total": "string",
        "user": {
            "user_id": 0,
            "name": "string"
        },
        "products": [
            {
                "product_id": 0,
                "value": "string"
            }
        ]
    }

#### Retorna uma lista de pedidos

```http
  GET /api/v1/orders/{id}
```
Exemplo resposta: 

    [
        {
            "order_id": 0,
            "date": "2024-11-19",
            "total": "string",
            "user": {
                "user_id": 0,
                "name": "string"
            },
            "products": [
                {
                    "product_id": 0,
                    "value": "string"
                }
            ]
        }
    ]

#### Retorna uma lista de pedidos por periodo

```http
  GET /api/v1/orders/search?start_date=YYYY-MM-DD&end_date=YYYY-MM-DD
```

| Parâmetro   | Tipo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `start_date`      | `YYYY-MM-DD` | **Obrigatório**. Data de inicio do periodo  |
| `end_date`      | `YYYY-MM-DD` | **Obrigatório**. Data do fim do periodo 

Exemplo resposta: 

    [
        {
            "order_id": 0,
            "date": "2024-11-19",
            "total": "string",
            "user": {
                "user_id": 0,
                "name": "string"
            },
            "products": [
                {
                    "product_id": 0,
                    "value": "string"
                }
            ]
        }
    ]

### Swagger

```http
  GET /api-docs/index.html
```
Rota de acesso ao swagger ui onde é possivel vizualizar e testar os endpoints.

### Products

#### Retorna um produto

```http
  GET /api/v1/products/{id}
```

| Parâmetro   | Tipo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `integer` | **Obrigatório**. O ID do pedido        |

Exemplo resposta:

    {
        "product_id": 0,
        "value": "string"
    }

#### Retorna ums lista de produtos

```http
  GET /api/v1/products/
```
Exemplo resposta:

    [
        {
            "product_id": 0,
            "value": "string"
        }
    ]

    ### Products

#### Retorna um produto

```http
  GET /api/v1/users/{id}
```

| Parâmetro   | Tipo       | Descrição                                   |
| :---------- | :--------- | :------------------------------------------ |
| `id`      | `integer` | **Obrigatório**. O ID do usuario        |

Exemplo resposta:

    {
        "user_id": 0,
        "name": "string"
    }

#### Retorna ums lista de usuarios

```http
  GET /api/v1/users/
```
Exemplo resposta:

    [
        {
            "id": 0,
            "name": "string",
            "created_at": "2024-11-19T03:36:31.073Z",
            "updated_at": "2024-11-19T03:36:31.073Z"
        }
    ]
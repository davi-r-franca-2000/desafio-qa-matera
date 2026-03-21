# Desafio QA — Matera

Repositório com as respostas aos exercícios do desafio técnico para a vaga de QA na Matera. Os exercícios cobrem elaboração de casos de teste (frontend e backend), resolução de problemas em produção e automação de testes com Robot Framework.

## Estrutura do Projeto

```
matera/
├── exercicio01/                          # Testes funcionais de frontend
│   ├── enunciado.png
│   ├── exercicio01.feature               # Cenários Gherkin
│   └── explicacao_casos_de_teste.txt     # Técnicas de teste utilizadas
│
├── exercicio02/                          # Testes funcionais de backend
│   ├── enunciado02.png
│   ├── exercicio02.feature               # Cenários Gherkin + validação de contrato
│   └── explicacao_casos_de_teste.txt     # Técnicas de teste utilizadas
│
├── exercicio03/                          # Resolução de problemas
│   ├── enunciado03.png
│   └── resposta.txt                      # Respostas dissertativas (itens A e B)
│
├── exercicio04/                          # Testes automatizados (Robot Framework)
│   ├── enunciado04.png
│   ├── enunciadoExtra.png
│   ├── README.md                         # Documentação detalhada do projeto
│   ├── requirements.txt                  # Dependências Python
│   ├── tests/                            # Suites de teste (.robot)
│   │   ├── breeds_happy.robot
│   │   ├── breeds_unhappy.robot
│   │   ├── breeds_contract.robot
│   │   └── breeds_data_manipulation.robot
│   ├── resources/                        # Keywords e bibliotecas Python
│   │   ├── common.resource
│   │   ├── breeds_api.resource
│   │   ├── json_schema_validator.py
│   │   └── breeds_data_utils.py
│   └── variables/
│       └── global_variables.py           # URLs, endpoints e JSON Schema
│
└── README.md                             # Este arquivo
```

## Exercício 01 — Testes Funcionais de Frontend

**Contexto:** tela de "Consulta de usuários" em um sistema ERP web, com três campos de filtro — Tipo de pessoa (dropdown), Nome (texto) e E-mail (texto) — e os botões "Filtrar" e "Limpar Filtros".

**Arquivos:**

- `exercicio01.feature` — 11 cenários em Gherkin (Inglês): **6 happy paths** e **5 unhappy paths**.
- `explicacao_casos_de_teste.txt` — justificativa das técnicas de teste aplicadas.

**Cenários felizes:** filtro por tipo de pessoa, por nome, por e-mail, por combinação tipo + nome, nome com comprimento mínimo válido e busca sem filtros (retorna todos).

**Cenários infelizes:** nome inexistente, e-mail inexistente, e-mail com formato inválido, combinação tipo + nome incompatível e nome excedendo o comprimento máximo.

**Técnicas de teste:**

| Técnica | Aplicação |
|---------|-----------|
| Particionamento de Equivalência | Classes válidas e inválidas para cada campo de filtro |
| Análise de Valor Limite | Comprimento mínimo e máximo do campo Nome |
| Combinação de Parâmetros | Filtros aplicados simultaneamente (tipo + nome) |

## Exercício 02 — Testes Funcionais de Backend

**Contexto:** endpoint `GET /breeds` da [Cat Facts API](https://catfact.ninja/), que retorna uma lista paginada de raças de gatos.

**Arquivos:**

- `exercicio02.feature` — 7 cenários em Gherkin (Inglês): **3 happy paths**, **3 unhappy paths** e **1 validação de schema/contrato**.
- `explicacao_casos_de_teste.txt` — justificativa das técnicas de teste aplicadas.

**Cenários felizes:** requisição sem parâmetros, com `limit=5` e com `limit=200` (acima do total de registros).

**Cenários infelizes:** `limit=0`, `limit=-1` e `limit=abc` (não numérico).

**Validação de contrato:** cenário com tabelas Gherkin detalhando os campos e tipos esperados na resposta (paginação e objetos breed), além de uma seção de comentários descrevendo a estratégia completa de validação — JSON Schema, verificação de campos obrigatórios, validação de tipos e uso de ferramentas como Pact/Dredd.

**Técnicas de teste:**

| Técnica | Aplicação |
|---------|-----------|
| Particionamento de Equivalência | Classes do parâmetro `limit` (ausente, válido, zero, negativo, não numérico) |
| Análise de Valor Limite | Valores limítrofes de `limit` (0, -1, acima do total) |
| Validação de Contrato | Estrutura JSON, campos obrigatórios e tipos de dados |

## Exercício 03 — Resolução de Problemas

**Contexto:** um bug foi encontrado em uma API em ambiente de produção, causando dificuldades para o cliente.

**Arquivo:** `resposta.txt`

**Item A — Reporte do bug e uso de logs:**

- Reporte seguindo boas práticas (título, descrição, ambiente, passos de reprodução, resultado esperado vs. obtido, evidências, severidade e prioridade).
- Uso de logs para depuração: correlação por timestamp e request/trace ID, identificação do endpoint e payload, análise do status code e identificação da camada com falha (validação, lógica de negócio ou integração).

**Item B — Prevenção e mitigação:**

- Melhoria na estratégia de testes (unitários, integração, contrato, regressão).
- Integração com CI/CD (testes no pipeline, bloqueio de deploy em caso de falha).
- Priorização por criticidade, uso e impacto no cliente.
- Monitoramento e observabilidade (Grafana, métricas 4xx/5xx, latência, alertas automáticos, tracing distribuído).
- Testes negativos e cenários de borda.

## Exercício 04 — Testes Automatizados (Robot Framework)

**Contexto:** automação de testes para o endpoint `GET /breeds` da [Cat Facts API](https://catfact.ninja/) utilizando **Robot Framework** com sintaxe **Gherkin**.

> Documentação completa de execução e relatórios em [`exercicio04/README.md`](exercicio04/README.md).

### Suites de Teste

| Suite | Arquivo | Descrição |
|-------|---------|-----------|
| Happy Path | `breeds_happy.robot` | 3 cenários: sem parâmetros, `limit=5`, `limit=200` |
| Unhappy Path | `breeds_unhappy.robot` | 3 cenários individuais + 1 data-driven (`[Template]`) com 6 valores inválidos |
| Contrato | `breeds_contract.robot` | Validação do JSON Schema completo e tipos dos campos de cada breed |
| Desafio Adicional | `breeds_data_manipulation.robot` | 6 cenários usando biblioteca Python customizada (Opção C) |

### Organização do Projeto

- **tests/** — suites de teste `.robot` separadas por tipo (happy, unhappy, contract, extra).
- **resources/** — keywords reutilizáveis (`breeds_api.resource`, `common.resource`) e bibliotecas Python (`json_schema_validator.py`, `breeds_data_utils.py`).
- **variables/** — variáveis globais (URLs, endpoints, JSON Schema).

### Desafio Adicional — Biblioteca Python (Opção C)

O arquivo `breeds_data_utils.py` é uma biblioteca Python customizada que expõe keywords para o Robot Framework, permitindo manipulação de strings e listas da resposta da API:

| Keyword | Descrição |
|---------|-----------|
| `Filter Breeds By Field` | Filtra breeds por campo (case-insensitive) |
| `Get Breed Names Sorted` | Retorna nomes ordenados alfabeticamente |
| `Get Unique Values` | Retorna valores únicos de um campo |
| `Format Breed Names Upper` | Retorna nomes em UPPERCASE |
| `Count Breeds By Field` | Retorna contagem por valor de um campo |

### Execução Rápida

```bash
cd exercicio04
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
robot --outputdir results tests/
```

## Tecnologias Utilizadas

- **Gherkin** — linguagem de especificação para os cenários de teste (exercícios 01, 02 e 04)
- **Robot Framework** — framework de automação de testes (exercício 04)
- **Python 3** — bibliotecas customizadas para Robot Framework (exercício 04)
- **RequestsLibrary** — biblioteca Robot Framework para requisições HTTP
- **jsonschema** — validação de contrato JSON Schema via Python

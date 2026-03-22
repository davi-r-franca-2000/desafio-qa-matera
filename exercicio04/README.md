# Exercício 04 - Testes Automatizados com Robot Framework

Testes automatizados para o endpoint **GET /breeds** da [Cat Facts API](https://catfact.ninja/) utilizando **Robot Framework** com sintaxe **Gherkin**.

## Estrutura do Projeto

```
exercicio04/
├── requirements.txt          # Dependências Python
├── README.md                 # Este arquivo
├── tests/                    # Casos de teste (.robot)
│   ├── breeds_happy.robot    # Cenários de caminho feliz
│   ├── breeds_unhappy.robot  # Cenários de caminho infeliz + data-driven
│   ├── breeds_contract.robot # Validação de contrato (JSON Schema)
│   └── breeds_data_manipulation.robot  # Desafio Adicional (Opção C)
├── resources/                # Keywords reutilizáveis
│   ├── common.resource       # Setup de sessão HTTP
│   ├── breeds_api.resource   # Keywords Gherkin do endpoint /breeds
│   ├── json_schema_validator.py  # Validador JSON Schema (Python)
│   └── breeds_data_utils.py      # Desafio Adicional – Lib Python customizada
└── variables/
    └── global_variables.py   # URLs, endpoints e JSON Schema
```

## Pré-requisitos

- Python 3.8+
- pip

## Instalação

Recomenda-se criar um ambiente virtual antes de instalar as dependências:

```bash
cd exercicio04
python -m venv venv

# Linux/macOS
source venv/bin/activate

# Windows (cmd)
venv\Scripts\activate

# Windows (PowerShell)
venv\Scripts\Activate.ps1

pip install -r requirements.txt
```

## Execução dos Testes

Executar todos os testes:

```bash
robot --outputdir results tests/
```

Executar por tag:

```bash
robot --outputdir results --include happy tests/
robot --outputdir results --include unhappy tests/
robot --outputdir results --include contract tests/
```

Executar uma suite específica:

```bash
robot --outputdir results tests/breeds_happy.robot
```

## Relatórios do Robot Framework

Após a execução, o Robot Framework gera automaticamente três arquivos no diretório de saída (`results/`):

| Arquivo       | Descrição |
|---------------|-----------|
| `report.html` | Visão geral dos resultados (pass/fail por suite e por caso de teste) |
| `log.html`    | Log detalhado com cada keyword executada, argumentos e retornos |
| `output.xml`  | Saída em XML para integração com ferramentas externas (CI/CD, dashboards) |

### Customizações Úteis

- **Nível de log**: `--loglevel DEBUG` para capturar informações detalhadas de depuração.
- **Títulos customizados**: `--reporttitle "Breeds API Report"` e `--logtitle "Breeds API Log"` para personalizar os relatórios HTML.
- **Filtro por tags**: Cada caso de teste usa `[Tags]` (`happy`, `unhappy`, `contract`, `data-driven`, `extra`). Isso permite filtrar execuções com `--include` e `--exclude`.
- **Rerun de falhas**: `--rerunfailed output.xml` para reexecutar apenas os testes que falharam.
- **Merge de resultados**: `rebot --merge` para combinar resultados de múltiplas execuções.

## Abordagem de Teste

### Caminhos Felizes (Happy Paths)
- Requisição sem parâmetros retorna lista paginada de breeds
- Requisição com `limit` válido respeita o limite solicitado
- Requisição com `limit` acima do total retorna todas as breeds disponíveis

### Caminhos Infelizes (Unhappy Paths)
- `limit=0`, `limit=-1`, `limit=abc` — validam que a API não retorna erros de servidor (5xx) nem expõe stack traces

### Teste de Contrato
- Valida a resposta completa contra um **JSON Schema** definido em `variables/global_variables.py`
- Verifica que todos os campos obrigatórios estão presentes e com os tipos corretos
- Garante que cada objeto breed possui os campos: `breed`, `country`, `origin`, `coat`, `pattern`

### Testes Data-Driven
- O arquivo `breeds_unhappy.robot` inclui um cenário com `[Template]` que testa múltiplos valores inválidos de `limit` de forma parametrizada, demonstrando como lidar com múltiplos conjuntos de dados.

---

## Desafio Adicional (Python Integration — Opção C)

O arquivo `resources/breeds_data_utils.py` é uma **biblioteca Python customizada** que expõe keywords para o Robot Framework, permitindo manipulação avançada de strings e listas da resposta da API.

### Keywords disponíveis

| Keyword Robot | Função Python | Descrição |
|---------------|---------------|-----------|
| `Filter Breeds By Field` | `filter_breeds_by_field(data, field, value)` | Filtra breeds por campo (case-insensitive) |
| `Get Breed Names Sorted` | `get_breed_names_sorted(data)` | Retorna nomes ordenados alfabeticamente |
| `Get Unique Values` | `get_unique_values(data, field)` | Retorna valores únicos de um campo |
| `Format Breed Names Upper` | `format_breed_names_upper(data)` | Retorna nomes em UPPERCASE |
| `Count Breeds By Field` | `count_breeds_by_field(data, field)` | Retorna dicionário `{valor: contagem}` |

### Cenários de teste

Os 6 cenários estão no arquivo `tests/breeds_data_manipulation.robot`, todos com a tag `extra`:

1. **Filter breeds by coat type** — filtra por `coat=Short` e valida resultados
2. **Filter breeds by country** — filtra por `country=United Kingdom` e valida resultados
3. **Get breed names sorted alphabetically** — verifica ordenação alfabética
4. **Get unique coat types** — verifica lista de valores únicos
5. **Format breed names to uppercase** — valida formatação uppercase
6. **Count breeds by country** — verifica que a soma das contagens iguala o total

### Execução dos testes extras

```bash
robot --outputdir results --include extra tests/
```

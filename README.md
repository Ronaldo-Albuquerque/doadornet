# DoadorNet

## Visão Geral
O **DoadorNet** é um sistema para gestão de dados de doadores de sangue. O backend é desenvolvido em **Spring Boot** com **MySQL**, enquanto o frontend é um aplicativo responsivo feito em **Flutter**. O sistema permite que usuários enviem arquivos JSON contendo informações de doadores para processamento e armazenamento.

## Tecnologias Utilizadas
- **Backend:** Java com Spring Boot
- **Banco de Dados:** MySQL
- **Frontend:** Flutter
- **API REST:** Para comunicação entre o frontend e backend
- **Docker:** Para conteinerização do backend

---

## Backend (Spring Boot + MySQL)
### Configuração
1. Clone o repositório e navegue até a pasta do backend:
   ```sh
   git clone https://github.com/sua-organizacao/doadornet-be.git
   cd doadornet-be
   ```
2. Configure o banco de dados MySQL e atualize `application.properties` com as credenciais corretas:
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/doadornet
   spring.datasource.username=root
   spring.datasource.password=senha
   ```
3. Execute o backend:
   ```sh
   ./mvnw spring-boot:run
   ```
   
---

## Frontend (Flutter)
### Configuração
1. Clone o repositório e navegue até a pasta do frontend:
   ```sh
   git clone https://github.com/sua-organizacao/doadornet-fe.git
   cd doadornet-fe
   ```
2. Instale as dependências:
   ```sh
   flutter pub get
   ```
3. Execute o aplicativo:
   ```sh
   flutter run
   ```

---

## API REST
A API do **DoadorNet** possui um endpoint `/doadores` para gestão dos doadores.

### **1. Obter Todos os Doadores**
- **Endpoint:** `GET /api/doadores`
- **Resposta:** Lista de doadores cadastrados
- **Exemplo de Resposta:**
  ```json
  [
    {
      "nome": "Calebe Roberto Caldeira",
      "cpf": "022.332.330-69",
      "rg": "16.519.545-9",
      "data_nasc": "18/09/1951",
      "sexo": "Masculino",
      "mae": "Letícia Allana",
      "pai": "Augusto Pedro Henrique Caldeira",
      "email": "caleberobertocaldeira__caleberobertocaldeira@hotelruby.com.br",
      "cep": "79106-020",
      "endereco": "Rua Dolcinópolis",
      "numero": 769,
      "bairro": "Jardim Aeroporto",
      "cidade": "Campo Grande",
      "estado": "MS",
      "telefone_fixo": "(67) 3964-7912",
      "celular": "(67) 98598-3073",
      "altura": 1.60,
      "peso": 107,
      "tipo_sanguineo": "B+"
    }
  ]
  ```

### **2. Cadastrar Novo Doador**
- **Endpoint:** `POST /api/doadores`
- **Corpo da Requisição:** JSON contendo os dados do doador
- **Exemplo de Requisição:**
  ```json
  {
    "nome": "João da Silva",
    "cpf": "123.456.789-00",
    "rg": "12.345.678-9",
    "data_nasc": "10/01/1985",
    "sexo": "Masculino",
    "mae": "Maria da Silva",
    "pai": "Carlos da Silva",
    "email": "joao@email.com",
    "cep": "12345-678",
    "endereco": "Rua Exemplo",
    "numero": 100,
    "bairro": "Centro",
    "cidade": "São Paulo",
    "estado": "SP",
    "telefone_fixo": "(11) 4002-8922",
    "celular": "(11) 98888-7777",
    "altura": 1.75,
    "peso": 80,
    "tipo_sanguineo": "O+"
  }
  ```
- **Resposta:**
  ```json
  {
    "mensagem": "Doador cadastrado com sucesso!"
  }
  ```

### **3. Excluir Todos os Doadores**
- **Endpoint:** `DELETE /api/doadores`
- **Ação:** Remove todos os doadores do banco de dados
- **Resposta:**
  ```json
  {
    "mensagem": "Todos os doadores foram removidos!"
  }
  ```

---

## Contribuição
Contribuições são bem-vindas! Para contribuir:
1. Faça um fork do repositório.
2. Crie um branch com a nova feature: `git checkout -b minha-feature`
3. Faça commit das alterações: `git commit -m 'Minha nova feature'`
4. Envie para revisão: `git push origin minha-feature`

---

## Licença
Este projeto está sob a licença MIT. Sinta-se livre para usar e modificar conforme necessário.

---

## Contato
- 📧 Email: ronaldo.aa@gmail.com
- 🔗 GitHub: [Ronaldo-Albuquerque](https://github.com/Ronaldo-Albuquerque)



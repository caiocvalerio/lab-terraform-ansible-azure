# Lab: Deploy de Aplicação Spring Boot no Azure com Terraform e Ansible

Este é um projeto para estudos que demonstra um fluxo de DevOps (IaC e Configuração) para fazer o deploy de uma aplicação Java (Spring Boot) containerizada.

O objetivo é provisionar a infraestrutura na **Azure** usando **Terraform** e, em seguida, usar o **Ansible** para se conectar à VM, instalar o **Docker** e executar a aplicação.

## 🛠️ Tecnologias Utilizadas

* **Cloud:** Azure
* **Aplicação:** Spring Boot (Java)
* **Containerização:** Docker
* **Infraestrutura como Código (IaC):** Terraform
* **Gestão de Configuração:** Ansible

---

## 🏗️ Visão Geral da Arquitetura

Este projeto divide o processo de deploy em três fases principais: a **Preparação Local** (onde construímos o nosso "pacote" de software), o **Deploy na Nuvem** (onde usamos automação para construir a infraestrutura e instalar o pacote) e o **Resultado Final** (onde acessamos a aplicação).

### 📦 Fase 1: Preparação Local

Tudo o que acontece na máquina do desenvolvedor antes de tocar na nuvem.

1.  **Desenvolvimento:** O código-fonte da API REST é escrito em **Spring Boot** (na pasta `/hwa`).
2.  **Containerização:** O **Docker** é usado para compilar o código Java e empacotar a aplicação num único arquivo de imagem (`app-image.tar`).
    * *Nota: Este método de exportar para `.tar` é usado deliberadamente para **evitar** a necessidade de um registo público (como o Docker Hub).*

### ☁️ Fase 2: Deploy Automatizado na Nuvem

Com o "pacote" (`.tar`) pronto, usamos as ferramentas de automação para executar o deploy na Azure.

3.  **Provisionamento (Terraform):** O **Terraform** lê os arquivos de configuração (na pasta `/terraform`) e constrói a "casa" no Azure. Ele cria a VM, Rede Virtual, IP Público e configura o Firewall (NSG) para abrir as portas `22` (para o Ansible) e `8080` (para a aplicação).
4.  **Configuração (Ansible):** O **Ansible** assume o controlo. Ele conecta-se à VM "vazia" (via SSH na porta 22), copia o arquivo `app-image.tar` para a VM, instala o Docker, carrega a imagem e, finalmente, executa o contêiner da aplicação.

### ✅ Fase 3: O Resultado Final

5.  **Acesso Público:** A aplicação Spring Boot está agora a correr dentro do contêiner no Azure, acessível a qualquer pessoa através do IP público na porta `8080`.

## 📋 Pré-requisitos

Para executar este projeto, você precisará ter as seguintes ferramentas instaladas:

* Uma **Conta Azure** com uma Subscrição (Assinatura) ativa.
* **Azure CLI** (para `az login`)
* **Terraform CLI**
* **Ansible**
* **Docker**

---

## ⚙️ Instruções de Execução

Siga estes passos a partir da raiz do projeto (`lab-terraform-ansible-azure/`).

### Passo 1: Configuração Inicial do Azure

1.  **Faça Login no Azure CLI:**
    ```bash
    az login
    ```
2.  **Crie um Grupo de Recursos (Resource Group) manualmente:** O Terraform foi configurado para usar um grupo que já existe. Crie-o manualmente no portal do Azure ou via CLI (use o nome que irá colocar no seu `.tfvars`).

    *Exemplo:* `rg-springboot-app`

### Passo 2: Construir a Aplicação (Docker)

Este projeto é configurado para **não** usar o Docker Hub. Vamos construir e salvar a imagem localmente na pasta raiz para que o Ansible a possa encontrar.

1.  **Construa a Imagem Docker:** (A partir da raiz do projeto)
    * Este comando usa o `Dockerfile` na raiz, que por sua vez compila o código Java da pasta `/hwa`.
    ```bash
    docker build -t meu-app-spring:1.0 .
    ```

2.  **Salve a Imagem num Arquivo .tar:**
    * Isto exporta a sua imagem para um único arquivo. (tam. aproximado de 130MB)
    ```bash
    docker save -o app-image.tar meu-app-spring:1.0
    ```

### Passo 3: Provisionar a Infraestrutura (Terraform)

1.  **Navegue para a pasta do Terraform:**
    ```bash
    cd terraform
    ```
2.  **Crie o seu arquivo de variáveis:**
    * Copie o template de exemplo.
    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```
3.  **Edite o `terraform.tfvars`:**
    * Abra o arquivo e preencha os valores obrigatórios (a sua `azure_subscription_id`, o `resource_group_name` que criou no Passo 1, e defina um `admin_usr` e `admin_pwd` fortes para a VM).

4.  **Execute o Terraform:**
    ```bash
    terraform init
    terraform apply
    ```
5.  Quando o `apply` terminar, ele mostrará os `Outputs`. **Copie o valor do `ip_public`**.

### Passo 4: Configurar a VM (Ansible)

1.  **Da pasta raiz, navegue para a pasta do Ansible:**
    ```bash
    cd ansible
    ```
2.  **Crie o seu arquivo de inventário:**
    ```bash
    cp inventory.ini.example inventory.ini
    ```
3.  **Edite o `inventory.ini`:**
    * Abra o arquivo e cole o `ip_public` que você copiou do Terraform.

4.  **Crie o seu arquivo de segredos:**
    ```bash
    cp group_vars/azurevm.yml.example group_vars/azurevm.yml
    ```
5.  **Edite o `group_vars/azurevm.yml`:**
    * Preencha com o `ansible_user` e `ansible_password` (devem ser os mesmos `admin_usr` e `admin_pwd` que você definiu no Terraform).

6.  **Execute o Playbook!**
    ```bash
    ansible-playbook -i inventory.ini playbook.yml
    ```
O Ansible irá agora conectar-se, instalar o Docker, copiar a sua imagem e iniciar o contêiner.

### Passo 5: Verificação Final

Se o Ansible terminar com `failed=0`, o seu projeto está no ar!

Abra o seu navegador e acesse à sua aplicação:

`http://<O_SEU_IP_PUBLICO>:8080/api/v1/hello`

---

## 🧹 Limpeza

Para evitar custos no Azure, destrua a infraestrutura quando terminar.

1.  Da pasta raiz, execute o comando de destruição:
    ```bash
    terraform destroy
    ```
2.  Apague os recursos restantes pelo portal do Azure.

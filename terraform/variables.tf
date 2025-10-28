variable "resource_group_name" {
  type        = string
  description = "Nome do grupo de recursos já existente no azure"
  sensitive   = true
}

variable "azure_subscription_id" {
  type        = string
  description = "A ID da assinatura do azure a ser usada."
  sensitive   = true
}

/****************************
        VNET
****************************/
variable "vnet_name" {
  type        = string
  description = "Nome da vnet a ser criada."
  default     = "sb-app-vnet"
}

variable "vnet_address" {
  type        = list(string)
  description = "Faixa de IPs da vnet."
  default     = ["10.0.0.0/16"]
}

/****************************
        SUBNET
****************************/
variable "subnet_name" {
  type        = string
  description = "Nome da subnet a ser criada."
  default     = "sb-app-subnet"
}

variable "subnet_address" {
  type        = list(string)
  description = "Faixa de IPs da subnet."
  default     = ["10.0.1.0/24"]
}

/****************************
        PUBLIC IP
****************************/
variable "public_ip_name" {
  type        = string
  description = "Nome do IP Publico para acessar o aplicação Azure."
  default     = "sb-app-pip"
}

variable "network_interface_name" {
  type        = string
  description = "Nome da interface de rede da aplicação."
  default     = "sb-app-nic"

}

/****************************
        VM
****************************/
variable "vm_name" {
  type        = string
  description = "Nome da VM."
  default     = "sb-app-vm"
}

variable "admin_usr" {
  type        = string
  description = "Username da conta Admin."
  sensitive   = true
}

variable "admin_pwd" {
  type        = string
  description = "Senha da conta Admin."
  sensitive   = true
}

/****************************
        FIREWALL
****************************/
variable "nsg_name" {
  type        = string
  description = "Nome do respectivo Network Security Group a ser criado."
  default     = "sb-app-nsg"
}

/****************************
        TAGS
****************************/
variable "common_tags" {
  type        = map(string)
  description = "Tags comuns para aplicar a todos os recursos."
  default = {
    "project"     = "App-SpringBoot"
    "environment" = "dev"
  }
}

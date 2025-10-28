output "vm_name" {
  description = "Nome da maquina virtual"
  value       = azurerm_linux_virtual_machine.app_vm.name
}

output "ip_public" {
  description = "IP publico da maquina virtual"
  value       = azurerm_public_ip.app_public_ip.ip_address
}
output "logcollector_public_ip" {
  description = "The public IP to the Log Collector node"
  value       = "${azurerm_public_ip.logcollector_pip.ip_address}"
}

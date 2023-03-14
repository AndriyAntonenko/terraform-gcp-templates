output minecracft_server_ip {
  value       = google_compute_address.minecraft_server_ip.address
  sensitive   = false
  description = "Public IP address to your Minecraft Server"
}

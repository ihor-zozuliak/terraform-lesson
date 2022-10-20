output "server_ip" {
  value = aws_instance.avenga-server[0].public_ip
}
output "webserver_endpoint" {
  value = "http://${aws_instance.avenga-server[0].public_dns}"
}
output "home" {
  value = chomp(data.http.my_home_ip.response_body)
}

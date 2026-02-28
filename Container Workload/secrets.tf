resource "aws_secretsmanager_secret" "app" {
  name                    = "${var.project_name}/app/credentials"
  description             = "App credentials for Project 3"
  recovery_window_in_days = 7
  tags                    = { Name = "${var.project_name}-secret" }
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id = aws_secretsmanager_secret.app.id
  secret_string = jsonencode({
    DB_PASSWORD = var.app_db_password
    API_KEY     = "my-api-key-value"
  })
}
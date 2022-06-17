
resource "aws_secretsmanager_secret" "example" {
  name = var.example
}

resource "aws_secretsmanager_secret" "secret_example" {
  name = var.secret_example
}

resource "aws_secretsmanager_secret" "hardcoded_example" {
  name = "hardcoded_example"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = var.example
}

resource "aws_secretsmanager_secret_version" "hardcoded_example" {
  secret_id     = aws_secretsmanager_secret.hardcoded_example.id
  secret_string = "hardcoded_example"
}

resource "aws_secretsmanager_secret_version" "secret_example" {
  secret_id     = aws_secretsmanager_secret.secret_example.id
  secret_string = var.secret_example
}

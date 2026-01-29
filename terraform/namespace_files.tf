resource "kestra_namespace_file" "example" {
  namespace = kestra_namespace.acme.id
  filename  = "/path/my-file.sh"
  content   = <<EOT
#!/bin/bash
echo "Hello World"
EOT
}

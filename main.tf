provider "aws" {
    region  = var.region
    profile = var.profile
}

resource "aws_instance" "hogwarts" {
    count           =  3
    ami             =  "ami-064a0193585662d74"
    instance_type   =  "t2.micro"
    key_name        =  "${aws_key_pair.my_key.key_name}" // name resouce, name minha chave, key_name dentro de rosource
    security_groups = ["${aws_security_group.allow_ssh.name}"]
    tags = {
        Name = "Hogwarts0-${count.index + 1}"
    }
}

resource "aws_key_pair" "my_key" {
    key_name   = "my-key"
    public_key = "${file("~/.ssh/awsInstance.pub")}"
  
}

resource "aws_security_group" "allow_ssh" {
    name = "allow_ssh"

    ingress { // REGRAS DE ENTRADA DE REQUISIÇÕES, SÃO MEUS inboundS
        from_port    = 22
        to_port      = 22
        protocol     = "tcp"
        cidr_blocks  = ["0.0.0.0/0"] # é o range de IP que quero liberar
    }
    egress{ # REGRAS DE SAIDA DE REQUISIÇÕES SÃO MEUS outbound, ex: quero fazer um update na maquina, tem que sair a requisição
        from_port     = 0
        to_port       = 0
        protocol      = "-1"
        cidr_blocks   = ["0.0.0.0/0"]
    }
}

// PRINTAR NA TELA O ENDEREÇO DA INSTANCIA QUE VOU ACESSAR A MAQUINA VIA SSH
# output "example_public_dns" { 
#   value = "${aws_instance.example[instance_count.index].public_dns}"
# }
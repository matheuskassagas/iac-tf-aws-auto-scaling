# # Responsavel pelas instancias, decide qual tipo
# # de conexao pode entrar e sair

resource "aws_security_group" "web" { # # responsavel por receber requisicios que seram redirecionadas para as instancias
  name = "Web"
  description = "Allow public inbound traffic"
  vpc_id = aws_vpc.this.id
  
  # # in 
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all http"
    from_port = 80 # http 
    # #ipv6_cidr_blocks = [ "value" ]
    # # prefix_list_ids = [ "value" ]
    protocol = "tcp"
    # #security_groups = [ "value" ]
    # #self = false
    to_port = 80
  } 
  
  # # in
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all https"
    from_port = 443 # https
    # #ipv6_cidr_blocks = [ "value" ]
    # # prefix_list_ids = [ "value" ]
    protocol = "tcp"
    # #security_groups = [ "value" ]
    # #self = false
    to_port = 443
  } 
  
  # # in
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all https"
    from_port = -1 # https
    # #ipv6_cidr_blocks = [ "value" ]
    # # prefix_list_ids = [ "value" ]
    protocol = "icmp"
    # #security_groups = [ "value" ]
    # #self = false
    to_port = -1
  } 

  # # out
  egress { # # allow send connection to data base
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [aws_subnet.this["pvt_a"].cidr_block]
  }

  tags = merge(local.common_tags, {Name = "Web Server"})
}

resource "aws_security_group" "db" { 
  name = "DB"
  description = "Allow incoming database connections"
  vpc_id = aws_vpc.this.id
  
  # # in 
  ingress { # # receive connections on port 3306 
    from_port = 3306 
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.web.id] # # todas a maquinas dentro do secutiry group sera capaz de acessar o db 
  } 
  
  # # in
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  } 
  
  # # in
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  } 

  # # out
  egress { 
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # # out
  egress { 
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {Name = "Database MySql"})
}
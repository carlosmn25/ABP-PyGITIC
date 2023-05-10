data "template_file" "installation_script" {
	template = "${file("./ec2/user_data.sh")}"
}

resource "aws_vpc" "vpc" {
	cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "ig" {
	vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_eip" "nat_eip" {
	vpc        = true
	depends_on = [aws_internet_gateway.ig]
}

resource "aws_nat_gateway" "nat" {
	allocation_id = "${aws_eip.nat_eip.id}"
	subnet_id     = "${element(aws_subnet.public_subnet.*.id, 0)}"
	depends_on    = [aws_internet_gateway.ig]
}

resource "aws_subnet" "public_subnet" {
	vpc_id                  = "${aws_vpc.vpc.id}"
	cidr_block              = "10.0.2.0/24"
	map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
	vpc_id                  = "${aws_vpc.vpc.id}"
	cidr_block              = "10.0.1.0/24"
	map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
	vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "public_internet_gateway" {
	route_table_id         = "${aws_route_table.public.id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id             = "${aws_internet_gateway.ig.id}"
}

resource "aws_route" "private_nat_gateway" {
	route_table_id         = "${aws_route_table.private.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

resource "aws_route_table_association" "public" {
	subnet_id      = aws_subnet.public_subnet.*.id[0]
	route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
	subnet_id      =  aws_subnet.private_subnet.*.id[0]
	route_table_id = "${aws_route_table.private.id}"
}

resource "aws_instance" "statistics-webserver" {
	ami = "ami-02396cdd13e9a1257"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.default.id]
	subnet_id = aws_subnet.public_subnet.id
	associate_public_ip_address = true

	user_data = "${data.template_file.installation_script.rendered}"
				
	tags = {
		Name = "statistics-webserver"
	}
}

resource "aws_security_group" "default" {
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"
  depends_on  = [aws_vpc.vpc]
  ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_eip" "ngw-1a" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "ngw-1c" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw-1a" {
  allocation_id = aws_eip.ngw-1a.id
  subnet_id     = aws_subnet.public-1a.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw-1c" {
  allocation_id = aws_eip.ngw-1c.id
  subnet_id     = aws_subnet.public-1c.id
  depends_on    = [aws_internet_gateway.igw]
}

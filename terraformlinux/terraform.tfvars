access_key              = "xxxx"
secret_key              = "xxxx"

key_name                = "aws-dev"

web_ami                 = "ami-1d9b316e"
web_instance_type       = "t2.medium"

asg_min                 = 1
asg_max                 = 2
asg_desired             = 2

vpc_id                  = "vpc-e6bd6183"
azs                     = "eu-west-1a,eu-west-1b"
public_subnets          = "subnet-68a77031,subnet-b8008add"

db_endpoint             = "mariadb.cwe2ozwnuq5m.eu-west-1.rds.amazonaws.com"
db_instance             = "test"
db_user                 = "test"
db_password             = "testtest"

key_name                = "aws-dev"

web_ami                 = "ami-5d43e82e"
web_instance_type       = "t2.medium"

asg_min                 = 1
asg_max                 = 2
asg_desired             = 2

azs                     = "eu-west-1a,eu-west-1b"
public_subnets          = "subnet-68a77031,subnet-b8008add"
sg_elb                  = "sg-c871b3ac"
sg_web                  = "sg-c871b3ac"

db_endpoint             = "test.cwe2ozwnuq5m.eu-west-1.rds.amazonaws.com"
db_instance             = "test"
db_user                 = "test"
db_password             = "testtest"

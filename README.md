docker-postfix
==============
## Requirement
+ Docker 1.0

## Instance Role
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1447448564000",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::my-mail-bucket/*"
            ]
        }
    ]
}
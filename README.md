docker-postfix
==============
## Requirement
+ Docker 1.0

## Configuration

+ `MAIL_DOMAIN`: The domain to accept mail on (e.g. `inbox.example.org`)
+ `S3_BUCKET`: The bucket name to send mail to (e.g. `my-mail-bucket`)

## Instance Role
```
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
```
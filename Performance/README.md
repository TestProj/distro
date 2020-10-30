## Gatling Execution via Test Containers 

### Prereq 
* Please follow the Readme on InfraProj and have Argo and application setup in your cluster


- Create infra namespace for execution infra-ns
```
  ➜  InfraProj git:(master) ✗ kubectl create ns infra-ns
```
- Execute rbac in namespace 
```
  ➜  InfraProj git:(master) ✗ kubectl apply -f rbac-argo.yaml
```
- Create AWS Setup for your reports infrastrure 
* Create AWS Users
```
perf-user
```
* Create policy 
```
{
    "Statement": [
        {
            "Effect": "Deny",
            "Action": [
                "ec2:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Deny",
            "Action": [
                "iam:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:DeleteObject*",
                "s3:GetObject*",
                "s3:PutObject*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::perf-results-XXXX",
                "arn:aws:s3:::perf-results-XXXX/*"
            ]
        }
    ]
}
```

* Create S3 Bucket and give policy
```
perf-results-XXXX
```

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::233444812205:role/infra-ns"
            },
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject*",
                "s3:PutObject*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::perf-results-XXXX",
                "arn:aws:s3:::perf-results-XXXX/*"
            ]
        }
    ]
}
```
- Execute argo submit in namespace infra-ns
```
  ➜  InfraProj git:(master) ✗ argo submit perf-infra-wf.yaml  --watch 
```
- Execute Locally, make sure you have credentails setup on your shell, for user you have created
```
kubectl create secret generic my-s3-credentials --from-literal=accessKey=<YOUR-ACCESS-KEY> --from-literal=secretKey=<YOUR-SECRET-KEY>
```
- Execute End 2 End 
```
  ➜  InfraProj git:(master) ✗ sh execute.sh 
```
- See the report opened in browser
![](https://github.com/TestProj/InfraProj/blob/ged-2020/Performance/gatling/image/gatling_report.png)

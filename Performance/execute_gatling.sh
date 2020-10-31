# Steps:
# 1) connect to the pfi namespace - ipfmea2-perfinfra-usw2-pfi
# 2) Run this script. This script will take default parameters and uniqueName is generated in this script.
# 3) How to setup your s3 credentials in secret and read from it
# kubectl create secret generic my-s3-credentials --from-literal=accessKey=<YOUR-ACCESS-KEY> --from-literal=secretKey=<YOUR-SECRET-KEY>

datetimeNow=$(date +"%m%d%Y%H%M%S")
echo "Run id is = run_"$datetimeNow
bucket="perf-results-XXXX"
echo "bucket Name = $bucket"
namespace="infra-ns"
echo "namespace name = $namespace"
serviceaccount="argowf-svcacc"
echo "service account=$serviceaccount"
aws_access_key_id="********"
echo "aws_access_key_id=$aws_access_key_id"
aws_secret_access_key="******"
echo "aws_secret_access_key=$aws_secret_access_key"
argo submit gatling/perf-infra-wf.yaml -psimulationClass=Echo.EchoSimulation --generate-name load-test-${datetimeNow}- -plimit=2 -pquery=/health/full -pbaseurl="https://XXX.amazonaws.com" -puniqueName=run_${datetimeNow} -ps3BucketName=${bucket} --serviceaccount ${serviceaccount} --wait
echo "######################################################"

aws configure set aws_access_key_id ${aws_access_key_id}
aws configure set aws_secret_access_key ${aws_secret_access_key}
aws s3 ls
mkdir -p ~/tmp/run_${datetimeNow}/
aws s3 cp s3://${bucket}/results/${namespace}/run_${datetimeNow}/ ~/tmp/${bucket}/${namespace}/run_${datetimeNow} --recursive --exclude 'finalResult/simulations'
open ~/tmp/${bucket}/${namespace}/run_${datetimeNow}/finalResult/perf-in/simulations/index.html
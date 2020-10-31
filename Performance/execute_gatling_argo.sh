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
argo submit gatling/perf-infra-wf-argo.yaml -psimulationClass=Echo.EchoSimulation --generate-name load-test-${datetimeNow}- -plimit=2 -pquery=/health/full -pbaseurl="https://XXX.amazonaws.com" -puniqueName=run_${datetimeNow} -ps3BucketName=${bucket} --serviceaccount ${serviceaccount} --wait
echo "######################################################"

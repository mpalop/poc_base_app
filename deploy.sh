#!/bin/sh
set -e

if [ $# -lt 2 ];then
    echo 'usage: deploy.sh IAM_Profile Action:create|update'
    exit -1
fi

if [ "$2" = "create" ] || [ "$2" = "update" ];then
    ACTION="$2"
else
    echo "wrong Action"
    echo 'usage: deploy.sh IAM_Profile Action:create|update'
    exit -1
fi

S3_CLOUDFORMATION_BUCKET="mpalop-test"
STACK_NAME="test"
STACK_FILE="stack"
STACK_PACKAGE_FILE="tmp/${STACK_FILE}.package"
IAM_PROFILE="$1"
mkdir -p tmp

for TEMPLATE_FILE in *.yaml
do
    echo "### Validating -> ${TEMPLATE_FILE}"

    aws cloudformation validate-template \
            --template-body file://${TEMPLATE_FILE}
    echo
done

aws cloudformation package --template-file ${STACK_FILE}.yaml \
        --output-template-file ${STACK_PACKAGE_FILE}.yaml \
        --s3-bucket ${S3_CLOUDFORMATION_BUCKET} \
        --s3-prefix ${STACK_NAME} --profile ${IAM_PROFILE} \

sed -i -e 's/s3:\/\//https:\/\/s3.amazonaws.com\//g' ${STACK_PACKAGE_FILE}.yaml && rm ${STACK_PACKAGE_FILE}.yaml-e

aws cloudformation validate-template --template-body file://${STACK_PACKAGE_FILE}.yaml
aws cloudformation $ACTION-stack \
        --template-body file://${STACK_PACKAGE_FILE}.yaml \
        --stack-name ${STACK_NAME} --profile ${IAM_PROFILE} \
        --capabilities CAPABILITY_NAMED_IAM

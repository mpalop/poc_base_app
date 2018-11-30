# Cloudformation script

#### Assumptions: 
* I used a substacks approach to make it more clear the code maintenance
* VPC with ELB on public subnetworks and Instances on private ones
* Apache server on the intances that provide the necessary header (The other option IMHO is using cloudfront)

#### Things I haven't done
* HTTPS support. I could create it using cloudformation, but it is necessary to validate the Certificate with a proper Domain Validation, and I haven't anyone.

#### Deployment:
* I prepared a ```deploy.sh``` script to create the stack and update when it is necessary. It uses a bucket "mpalop-test" 
that has to be defined properly. check the code.
```bash
cloudformation ./deploy.sh
usage: deploy.sh IAM_Profile Action:create|update
```
An example of the execution:
```bash
cloudformation ./deploy.sh sistemas create
### Validating -> computing.yaml
{
    "CapabilitiesReason": "The following resource(s) require capabilities: [AWS::IAM::InstanceProfile, AWS::IAM::Role]",
    "Description": "Computing (SNS, LaunchConfiguration, AutoscalingGroup, ScalePolicies)[test]",
    "Parameters": [
        {
            "NoEcho": false,
            "ParameterKey": "KeyName"
        },
        {
            "NoEcho": false,
            "ParameterKey": "TargetGroupArn"
        },
        {
            "NoEcho": false,
            "ParameterKey": "MinSize"
        },
        {
            "NoEcho": false,
            "ParameterKey": "LoadBalancerSgId"
        },
        {
            "NoEcho": false,
            "ParameterKey": "VpcId"
        },
        {
            "NoEcho": false,
            "ParameterKey": "LoadBalancerArn"
        },
        {
            "NoEcho": false,
            "ParameterKey": "Subnetworks"
        },
        {
            "NoEcho": false,
            "ParameterKey": "ImageId"
        },
        {
            "NoEcho": false,
            "ParameterKey": "ServiceNamePrefix"
        },
        {
            "NoEcho": false,
            "ParameterKey": "InstanceType"
        },
        {
            "NoEcho": false,
            "ParameterKey": "MaxSize"
        }
    ],
    "Capabilities": [
        "CAPABILITY_NAMED_IAM"
    ]
}

### Validating -> elb.yaml
{
    "Description": "ELB (Public and Private Subnets, IGW, NatGW, Route Tables)[Assignment]",
    "Parameters": [
        {
            "NoEcho": false,
            "ParameterKey": "VpcId"
        },
        {
            "NoEcho": false,
            "ParameterKey": "Subnetworks"
        },
        {
            "NoEcho": false,
            "ParameterKey": "ServiceNamePrefix"
        }
    ]
}

### Validating -> stack.yaml
{
    "CapabilitiesReason": "The following resource(s) require capabilities: [AWS::CloudFormation::Stack]",
    "Description": "Main File",
    "Parameters": [],
    "Capabilities": [
        "CAPABILITY_NAMED_IAM"
    ]
}

### Validating -> vpc.yaml
{
    "Description": "VPC (Public and Private Subnets, IGW, NatGW, Route Tables)[Assignment]",
    "Parameters": [
        {
            "NoEcho": false,
            "ParameterKey": "ServiceNamePrefix"
        }
    ]
}


Successfully packaged artifacts and wrote output template to file tmp/stack.package.yaml.
Execute the following command to deploy the packaged template
aws cloudformation deploy --template-file /Users/manel/work/glovo/cloudformation/tmp/stack.package.yaml --stack-name <YOUR STACK NAME>
{
    "CapabilitiesReason": "The following resource(s) require capabilities: [AWS::CloudFormation::Stack]",
    "Description": "Main File",
    "Parameters": [],
    "Capabilities": [
        "CAPABILITY_NAMED_IAM"
    ]
}
{
    "StackId": "arn:aws:cloudformation:eu-west-1:885917040675:stack/test/89236910-e60e-11e8-a101-50fae9b818d2"
}
```



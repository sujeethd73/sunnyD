#!bin/bash
COMPONENT=$1
if [ -z "$1" ]; then
    echo -e "\e[31m component name is required \n example usage is: \n\t bash create-server.sh componentname \e[0m"
    exit 1
fi

AMI_ID="$(aws ec2 describe-images --region us-east-1  --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')"
SGID="$(aws ec2 describe-security-groups --filters Name=group-name,values=ds-73-add | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')"

echo "AMI ID used to launch instance : $AMI_ID"
echo "SG ID used to launch instance : $SGID"


aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SGID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" | jq

#aws ec2 run-instances \
   # --image-id ami-0abcdef1234567890 \
   # --instance-type t2.micro \
    #--key-name MyKeyPair
    #Devops-labImage-Centos7
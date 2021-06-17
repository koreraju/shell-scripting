#!/bin/bash

COMPONENT=$1

## -z validates the variable empty , true if it is empty.
if [ -z "${COMPONENT}" ]; then
  echo "Component Input is Needed"
  exit 1
fi

LID=lt-04292ada2a6f67c80
LVER=1

## Validate If Instance is already there

DNS_UPDATE() {
  PRIVATEIP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}"  | jq .Reservations[].Instances[].PrivateIpAddress | xargs -n1)
  sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATEIP}/" record.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id Z07020581SP7KYFC02HM7 --change-batch file:///tmp/record.json | jq
}

INSTANCE_STATE=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=components" | jq .Reservations[].Instances[].state.Name | xargs -n1)
if  [ "${INSTANCE_STATE}" = "running" ]; then
  echo "instance already exist!!"
  DNS_UPDATE
  exit 0
fi
if [ "$INSTANCE_STATE}" = "stopped" ]; then
  echo "instance already exist!!"
  DNS_UPDATE
  exit 0
  fi


aws ec2 run-instances --launch-template LaunchTemplateId=${LID},Version=${LVER}  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq
sleep 30
DNS_UPDATE




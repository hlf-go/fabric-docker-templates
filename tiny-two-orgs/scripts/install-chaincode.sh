#!/bin/bash

. ./scripts/common.sh

function usage(){ 
    echo "Usage: $0 <flags>"
    echo "Mandatory:"
    echo "   -c <cc id>         A unique string identifier"
    echo "   -v <cc version>    A numeric number"
    echo "   -p <cc package>    A name of folder containing chaincodes"
    echo "Optional:"
    echo "   -a <cc constructor>   Must be in the form [\"method\", \"method-arg-1\", \"method-arg-2\"]"
}

if [ "$#" -eq "0" ]; then  
    usage
    exit
fi

while getopts "a:c:p:v:" opt; do
  case $opt in
    a)
      CHAINCODE_CONSTRUCTOR=$OPTARG
      ;;
    c)
      CHAINCODEID=$OPTARG
      ;;
    p)
      CCHAINCODE_PACKAGE=$OPTARG
      ;;
    v)
      CHAINCODE_VERSION=$OPTARG
      ;;
    \?)
      usage
      exit 1
      ;;
    :)
      usage
      exit 1
      ;;
  esac
done

if [ -z $CHAINCODE_CONSTRUCTOR ]; then
    CHAINCODE_CONSTRUCTOR="[]"
fi

if [[ ! -z $CHAINCODEID && ! -z $CHAINCODE_VERSION && ! -z $CCHAINCODE_PACKAGE ]]; then

    path_to_chaincode="github.com/hyperledger/fabric/chaincodes/$CCHAINCODE_PACKAGE"
    echo "INSTALLING chaincode $CHAINCODEID version $CHAINCODE_VERSION in $path_to_chaincode"
    echo
    peer chaincode install -n $CHAINCODEID -v $CHAINCODE_VERSION -p $path_to_chaincode --tls --cafile $ORDERER_CA

else
    usage
fi





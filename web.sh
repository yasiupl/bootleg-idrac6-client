#!/bin/bash

if [ -z "$1" ]; then
	echo "Please specify Jumphost IP in argument 1"
	exit
fi

if [ -z "$2" ]; then
	echo "Please specify SOCKS Proxy port in argument 2"
	exit
fi

ssh -D $2 -N $1 &
PROXY_PID=$!
echo $PROXY_PID
chromium --proxy-server="socks5://localhost:$2" 

kill $PROXY_PID

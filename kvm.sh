#!/bin/sh

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

download() {
  jar=$1
  path=$2
  if [ ! -f "${path}/${jar}" ]; then

	URI="Applications/dellUI/Java/release"

	echo -e "${YELLOW}Downloading... https://${IDRAC_HOST}/${URI}/${jar}${NC}"

	wget -O "${path}/${jar}" https://${IDRAC_HOST}/${URI}/${jar} --no-check-certificate

	if [ ! $? -eq 0 ]; then
	  echo -e "${RED}Failed to download ${jar}, please check your settings${NC}"
	  sleep 2
	  exit 2
	fi
  fi
}

echo -e "${GREEN}Starting${NC}"

if [ -z "${IDRAC_HOST}" ]; then
	read -p "Enter iDRAC IP: " IDRAC_HOST
	#echo -e "${RED}Please set a proper idrac host with IDRAC_HOST${NC}"
	#sleep 2
	#exit 1
fi

if [ -z "${IDRAC_USER}" ]; then
	read -p "Username: " IDRAC_USER
	#echo -e "${RED}Please set a proper idrac user with IDRAC_USER${NC}"
	#sleep 2
	#exit 1
fi

if [ -z "${IDRAC_PASSWORD}" ]; then
	read -sp "Password: " IDRAC_PASSWORD
	#echo -e "${RED}Please set a proper idrac password with IDRAC_PASSWORD${NC}"
	#sleep 2
	#exit 1
fi

echo -e "${GREEN}Environment ok${NC}"

mkdir -p app
cd app
mkdir -p lib
touch cookies

if [ -z "${COOKIE}" ]; then
	echo -e "${GREEN}Obtaining session cookie${NC}"
	COOKIE=$(curl -k --data "WEBVAR_USERNAME=${IDRAC_USER}&WEBVAR_PASSWORD=${IDRAC_PASSWORD}&WEBVAR_ISCMCLOGIN=0" https://${IDRAC_HOST}/Applications/dellUI/RPC/WEBSES/create.asp 2> /dev/null | grep SESSION_COOKIE | cut -d\' -f 4)

	if [[ "$COOKIE" == *"_"* ]]; then

		echo -e "${RED} Error ${COOKIE}, using last saved session cookie${NC}"

		COOKIE=$(tail -1 cookies);
	else
		echo "${COOKIE}" >> cookies
	fi
fi

if [ -z "${COOKIE}" ]; then
	echo -e "${RED} Failed to obtain a cookie, try specifying COOKIE env variable${NC}"
	sleep 2
	exit 1
else
	echo -e "${GREEN}Cookie obtained: ${YELLOW}${COOKIE}${NC}"
fi

echo -e "${GREEN}Downloading required files${NC}"

## KVM App
download JViewer.jar .

## Platform specific libraries
# platform="Win64.jar"
# platform="Win32.jar"
# platform="Linux_x86_32.jar"
platform="Linux_x86_64.jar"

download $platform lib

# Extract libraries
echo -e "${GREEN}Extracting libs${NC}"
cd lib
jar -xf $platform
cd ..

echo -e "${GREEN}Obtaining KVM launch parameters${NC}"

args=$(curl -k --cookie Cookie=SessionCookie=${COOKIE} https://${IDRAC_HOST}/Applications/dellUI/Java/jviewer.jnlp | awk -F '[<>]' '/argument/ { print $3 }')

echo -e "${YELLOW}${args}${NC}"

if [ -z "${args}" ]; then
	echo -e "${RED} Failure obtaining KVM launch parameters${NC}"
	sleep 2
	exit 1
fi

echo -e "${GREEN}Running Java KVM Viewer${NC}"

exec java -Djava.library.path=lib -jar JViewer.jar $args

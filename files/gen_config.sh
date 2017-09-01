#!/bin/bash

if [ -e $1 ];then
  echo "Provide certificate name. Available generated certificates:"
  echo -e
  ls -all /etc/openvpn/easy-rsa/pki/issued/privateVPN-* | cut -d/ -f 7 | cut -d. -f1
  echo -e
  echo "Usage $0 certificate_name"
  exit 1
fi

id_name=$1

is_ios=$(echo "$id_name" | grep -c Mobile)
if [ "$is_ios" == "0" ];then
  echo "Generating config for $id_name (Desktop)..."
  cp /etc/openvpn/easy-rsa/pki/ca.crt privateVPN-Desktop.visc/
  cp /etc/openvpn/easy-rsa/pki/ta.key privateVPN-Desktop.visc/
  cp /etc/openvpn/easy-rsa/pki/issued/$id_name.crt privateVPN-Desktop.visc/cert.crt
  openssl ec -in /etc/openvpn/easy-rsa/pki/private/$id_name.key > privateVPN-Desktop.visc/key.key
  tar -zcvf archives/$id_name.tar.gz privateVPN-Desktop.visc
  rm -f privateVPN-Desktop.visc/cert.crt
  rm -f privateVPN-Desktop.visc/key.key
  echo "Done in: archives/$id_name.tar.gz"
  exit
fi

echo "Generating config for $id_name (Mobile)..."

mkdir -p "$id_name"
sed s/ID_NAME/$id_name/g privateVPN-Mobile.ovpn.template > $id_name/privateVPN-Mobile.ovpn
cp /etc/openvpn/easy-rsa/pki/issued/$id_name.crt $id_name/
openssl rsa -in /etc/openvpn/easy-rsa/pki/private/$id_name.key > $id_name/$id_name.key
cp /etc/openvpn/easy-rsa/pki/ta.key $id_name/
cp /etc/openvpn/easy-rsa/pki/ca.crt $id_name/
tar -zcvf archives/$id_name.tar.gz $id_name
rm -rf $id_name
echo "Done in: archives/$id_name.tar.gz"

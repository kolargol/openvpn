#!/bin/bash

id_name=$1

is_ios=$(echo "$id_name" | grep -c Mobile)
if [ "$is_ios" == "0" ];then
  echo "Generating config for Desktop..."
  cp ca.crt privateVPN-Desktop.visc/
  cp ta.key privateVPN-Desktop.visc/
  cp $id_name.crt privateVPN-Desktop.visc/cert.crt
  openssl ec -in $id_name.key > privateVPN-Desktop.visc/key.key
  tar -zcvf archives/$id_name.tar.gz privateVPN-Desktop.visc
  rm -f privateVPN-Desktop.visc/cert.crt
  rm -f privateVPN-Desktop.visc/key.key
  echo "Done in: archives/$id_name.tar.gz"
  exit
fi

echo "Generating config for Mobile..."

mkdir -p "$id_name"
sed s/ID_NAME/$id_name/g privateVPN-Mobile.ovpn.template > $id_name/privateVPN-Mobile.ovpn
cp $id_name.crt $id_name/
openssl rsa -in $id_name.key > $id_name/$id_name.key
cp ta.key $id_name/
cp ca.crt $id_name/
tar -zcvf archives/$id_name.tar.gz $id_name
rm -rf $id_name
echo "Done in: archives/$id_name.tar.gz"

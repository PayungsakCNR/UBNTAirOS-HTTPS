#!/bin/bash

echo "-----BEGIN CERTIFICATE-----
<your certificate>
-----END CERTIFICATE-----
-----BEGIN RSA PRIVATE KEY-----
<your private key>
-----END RSA PRIVATE KEY-----" > /etc/server.pem

echo "-----BEGIN CERTIFICATE-----
<your ca certificate>
-----END CERTIFICATE-----" > /etc/intermediate.crt

echo 'server.document-root = "/usr/www"
include "/usr/etc/lighttpd/modules.conf"
include "/usr/etc/lighttpd/mimetypes.conf"
include "/usr/etc/lighttpd/lighttpd.conf"
airos.session-timeout = 900
server.port = <HTTP Port ex:80>
$SERVER["socket"] == ":121" {
   ssl.engine = "enable"
   ssl.pemfile = "/etc/server.pem"
   ssl.ca-file = "/etc/intermediate.crt"
   ssl.use-sslv2 = "disable"
   ssl.cipher-list = "TLSv1+HIGH:!SSLv2:RC4+MEDIUM:!aNULL:!eNULL:!3DES:@STRENGTH"
}
$SERVER["socket"] == ":180" {
   ssl.engine = "disable"
   airos.redirect-https-port = 121
}
$SERVER["socket"] == "[::]:121" {
   ssl.engine = "enable"
   ssl.pemfile = "/etc/server.pem"
   ssl.ca-file = "/etc/intermediate.crt"
   ssl.use-sslv2 = "disable"
   ssl.cipher-list = "TLSv1+HIGH:!SSLv2:RC4+MEDIUM:!aNULL:!eNULL:!3DES:@STRENGTH"
}' > /etc/lighttpd.conf

kill $(ps w | grep '[/]bin/lighttpd' | awk '{print $1}')

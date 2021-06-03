myname=anil
s3_bucket=upgrad-anil
timestamp=$(date '+%d%m%Y-%H%M%S')

sudo su
apt-get update -y

if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  apt-get install apache2;
fi

systemctl status apache2
/etc/init.d/apache2 start
service apache2 status

tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
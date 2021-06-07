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

FILE=/var/www/html/inventory.html

if [ ! -f "$FILE" ]; then
    echo 'LogType	TimeCreated		Type	Size' >> $FILE
fi

filesize=$(find "$FILE" -printf "%s")

echo 'httpd-logs	$timestamp		tar		$filesize' >>$FILE

automationfile=/etc/cron.d/automation
if [ ! -f "$automationfile" ]; then
    echo '5 0 * * * root /root/Automation_Project/automation.sh' >> $automationfile
fi
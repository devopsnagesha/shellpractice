source common.sh

mysql_root_password=$1
app_dir=/app
component=backend

if [ -z "${mysql_root_password}" ]; then
    echo "Input password missing"
    exit 1
fi

print_task_heading "disable nodejs"
dnf module disable nodejs -y &>>$LOG
check_status $?

print_task_heading "enable 20V"
dnf module enable nodejs:20 -y &>>$LOG
check_status $?

print_task_heading "Install nodejs"
dnf install nodejs -y &>>$LOG
check_status $?

print_task_heading "add user to app"
id expense &>>$LOG
if [ $? -ne 0 ]; then
  useradd expense &>>$LOG
fi
check_status $?

print_task_heading "copy backend services"
cp backend.service /etc/systemd/system/backend.service &>>$LOG
check_status $?

App_PreReq
print_task_heading "download dependencies"
cd /app &>>LOG
npm install &>>$LOG
check_status $?

print_task_heading "system enable"
systemctl daemon-reload &>>$LOG
systemctl enable backend &>>$LOG
systemctl start backend &>>$LOG
check_status $?

print_task_heading "download mysql"
dnf install mysql -y &>>$LOG
check_status $?

print_task_heading "load schema"
mysql -h mysql-dev.angadicnc.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOG
check_status $?


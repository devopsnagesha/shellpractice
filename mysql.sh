source common.sh
component=mysql

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
   echo Input password is missing
   exit 1
fi

print_task_heading "install mysql server"
dnf install mysql-server -y &>>$LOG
check_status $?

print_task_heading "enable mysql"
syatemctl enable mysqld &>>$LOG
systemctl start mysqld &>>$LOG
check_status $?

Print_Task_Heading "Setup MySQL Password"
 echo 'show databases' |mysql -h mysql-dev.angadicnc.online -uroot -p${mysql_root_password} &>>$LOG
 if [ $? -ne 0 ]; then
   mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOG
 fi
 Check_Status $?
source common.sh

component=frontend
app_dir=/usr/share/nginx/html

print_task_heading "Install Nginx"
dnf install nginx -y &>>$LOG
check_status $?

print_task_heading "Copy expense nginx configuration"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$LOG
check_status $?

App_PreReq

print_task_heading "start nginx service"
systemctl enable nginx &>>$LOG
systemctl restart nginx &>>$LOG
check_status $?


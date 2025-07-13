component=$1
dnf install ansible -y
ansible-pull -U https://github.com/bajibpathan/roboshop-ansible-roles-tf.git -e component=$component -e env=$2 roboshop.yaml
# GCP一键配置
pwd=`date +%s | sha256sum | base64 | head -c 16`
ip=`curl ifconfig.me`

echo -e '\033[32m[info]正在配置Root密码\033[0m'
echo root:$pwd | sudo chpasswd

echo -e '\033[32m[info]正在配置SSH:允许Root登录\033[0m'
sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
sed -i '/^PermitRootLogin/ s/prohibit-password/yes/' /etc/ssh/sshd_config
systemctl restart sshd

echo -e '\033[32m[info]正在配置SSH:配置免密登录\033[0m'
mkdir -p /root/.ssh
cat > /root/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvGEGWvpr/m6chVr4WlexoUvwURLqWDcLf4TxOnGsDgj8TNq116t7zZZyVGAbpPXjbMPsdjq5MPdM+0/nASD3IiBk12eNNJYNPT+mjGR0hfRAiP2syE7ZNB7unWk1qFcCOEbh9/uL9bjc8GTZMbi3L4kBj8Z9Xbh+xJuD6RVkTU9RZt/IKIz0EMIvnV46aoe+dhnClnLbygLVdcVmDg8IGJaIvxqZ8FG5NDuD+L/uPNzs0OMrlYADbLFdPBnVaCkMy4nbuCTbYPhff0JtaCEfb2lGLmCFmwMMFhaesCoAbUDvnK2WomLhviuB//uCMJ1QAp8mvOdkT3RaTVNRPPmPWQ== kkzzhizhou
EOF
chmod 600 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

echo -e '\033[32m[info]正在安装常用工具\033[0m'
yum -y install wget screen vim lrzsz

echo -e '\033[32m[info]正在开启BBR\033[0m'
cd /root
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh
sed -i '/^char=.*/d' ./bbr.sh
sed -i '/^install_bbr/d' ./bbr.sh
echo "install_bbr" >> ./bbr.sh
/bin/rm /root/bbr.sh

echo -e '\033[32m[info]配置完成\033[0m'
echo -e "\033[32m  IP：$ip  \033[0m"
echo -e "\033[32m  Root_Password：$pwd  \033[0m"
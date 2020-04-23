#!/bin/bash


yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-2018.3.el7.noarch.rpm 

yum -y install vim-enhanced fish traceroute epel-release htop nmap-ncat bind-utils wget
chsh -s /usr/bin/fish root

1. 本脚本适用于Centos7系统

2. 使用前先给予脚本可执行权限

   `chmod +x pxe_deploy/pxe_ks_deployOS.sh`

3. 确定需要安装的系统版本并在脚本中修改mount信息，或将系统iso镜像上传至指定目录

   ```shell
   # mount ios image 
   mount /dev/cdrom /var/ftp/centos7  #去掉注释信息 line39
   #mount /dev/cdrom /var/ftp/centos6  # line40
   ```

4. 修改脚本中如下信息

   ```shell
   DHCP_SERVER=192.168.1.130
   DHCP_RANGE="192.168.1.150 192.168.1.160"   #需要与pxe服务器在同一网段
   DHCP_SUBNET=192.168.1.0
   TFTP_SERVER=192.168.1.130
   FTP_SERVER=192.168.1.130
   ```

5. 如需使用ks文件自动化安装，只需将ks文件上传至ftp，并在脚本中修改配置文件即可

   `cp centos7.ks /var/ftp/`

   ```shell
   label linux
     menu label ^Install CentOS 7
     kernel vmlinuz
     append initrd=initrd.img inst.stage2=ftp://$FTP_SERVER/centos7 inst.repo=ftp://$FTP_SERVER/centos7 inst.ks=ftp://$FTP_SERVER/centos7.ks
   ```

   
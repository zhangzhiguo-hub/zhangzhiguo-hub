#2022年3月27日  以下是我以非root用户在linux下安装最新版MRO的过程
cd ~
cat /proc/version #查看系统类型
wget https://mran.blob.core.windows.net/install/mro/4.0.2/Rhel/microsoft-r-open-4.0.2.tar.gz #本系统为红帽，下载对应版本的MRO，官网链接：https://mran.microsoft.com/download
tar -xf microsoft-r-open-4.0.2.tar.gz #解压

#创建虚拟环境用于接下来对MRO和其他R的分开管理
conda create -n MRO
conda activate MRO

#开始手动安装
cd microsoft-r-open
rpm -qp --scripts microsoft-r-open/rpm/rhel/microsoft-r-open-mkl-4.0.2.rpm
rpm -qp --scripts microsoft-r-open/rpm/rhel/microsoft-r-open-mro-4.0.2.rpm
rpm -qp --scripts microsoft-r-open/rpm/rhel/microsoft-r-open-sparklyr-4.0.2.rpm
INSTALL_PREFIX="./opt/microsoft/ropen/4.0.2/" # 从前面解压的路径可以看出来
mkdir -p ${INSTALL_PREFIX}/lib64/R/backup/lib
mv ${INSTALL_PREFIX}/lib64/R/lib/*.so ${INSTALL_PREFIX}/lib64/R/backup/lib
cp ${INSTALL_PREFIX}/lib64/R/backup/lib/libR.so ${INSTALL_PREFIX}/lib64/R/lib
cp ${INSTALL_PREFIX}/stage/Linux/bin/x64/*.so ${INSTALL_PREFIX}/lib64/R/lib

#建立软连接
cd ~/miniconda3/envs/MRO/
ln -s ~/microsoft-r-open/opt/microsoft/ropen/4.0.2/lib64/R/bin

#测试
R

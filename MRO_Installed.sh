#2022年4月4日  以下是我以非root用户在linux下安装最新版MRO的过程
cd ~
cat /proc/version #查看系统类型
wget https://mran.blob.core.windows.net/install/mro/4.0.2/Rhel/microsoft-r-open-4.0.2.tar.gz #本系统为红帽，下载对应版本的MRO，官网链接：https://mran.microsoft.com/download
tar -xf microsoft-r-open-4.0.2.tar.gz #解压

#创建虚拟环境用于接下来对MRO和其他R的分开管理
conda create -n MRO
conda activate MRO

#开始手动安装
cd ~/microsoft-r-open
rpm2cpio rpm/rhel/microsoft-r-open-mkl-4.0.2.rpm|cpio -idmv
rpm2cpio rpm/rhel/microsoft-r-open-mro-4.0.2.rpm|cpio -idmv
rpm2cpio rpm/rhel/microsoft-r-open-sparklyr-4.0.2.rpm|cpio -idmv
INSTALL_PREFIX="./opt/microsoft/ropen/4.0.2/" # 从前面解压的路径可以看出来
mkdir -p ${INSTALL_PREFIX}/lib64/R/backup/lib
mv ${INSTALL_PREFIX}/lib64/R/lib/*.so ${INSTALL_PREFIX}/lib64/R/backup/lib
cp ${INSTALL_PREFIX}/lib64/R/backup/lib/libR.so ${INSTALL_PREFIX}/lib64/R/lib
cp ${INSTALL_PREFIX}/stage/Linux/bin/x64/*.so ${INSTALL_PREFIX}/lib64/R/lib

#配置环境
conda install r-base==4.0.2
cd ~/miniconda3/envs/MRO/lib/R/
cp -r ./etc ./etc_2
cp -r ~/microsoft-r-open/opt/microsoft/ropen/4.0.2/lib64/R/* ./
cp ./etc_2/* ./etc
sed -i -e '12 s/^/#/' etc/ldpaths
sed -i -e '13 s/^/#/' etc/ldpaths
sed -i -e '14 s/^/#/' etc/ldpaths
conda install r-matrixStats
conda install r-polyclip
conda install r-units
conda install r-V8
conda install -c conda-forge r-sf

#测试
R
options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc/")
options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
update.packages()
install.package("pacman")
install.package("BiocManager")
library(BiocManager)
install.package("devtools")#可能报错
BiocManager::install("scRepertoire")#可能报错，此外conda安装的4.0以下的R版本无法安装

#若都不报错则安装成功
####终于成功
ggforce

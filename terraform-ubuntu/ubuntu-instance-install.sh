#!/bin/bash
set -ex

apt-get update
apt -y install awscli curl

mkdir /opt/artifacts
aws s3 sync s3://${s3_bucket}/artifacts/ /opt/artifacts --region ${region}
wait

wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
chmod +x Anaconda3-2021.05-Linux-x86_64.sh
bash Anaconda3-2021.05-Linux-x86_64.sh -b 

export PATH=$PATH:/anaconda3/bin
conda --version

#conda install -c anaconda ipython

jupyter notebook --generate-config
cp -f /opt/artifacts/jupyter_notebook_config.py ~/.jupyter/jupyter_notebook_config.py

#PWD=$(python3 -c "from IPython.lib import passwd; print(passwd('vanGoghArt'))")
#echo $PWD
#sed -i "s/<PWD>/$${PWD}/g" ~/.jupyter/jupyter_notebook_config.py

mkdir notebooks
cd notebooks

conda create -y -n py python
#conda create -y -n tf tensorflow

# source "/anaconda3/etc/profile.d/conda.csh"
conda init --all -v
source /root/.bashrc

conda activate py

jupyter notebook

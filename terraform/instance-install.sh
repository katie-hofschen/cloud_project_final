#!/bin/bash

#set -ex
cd /home/ec2-user/

mkdir /home/ec2-user/artifacts
aws s3 sync s3://${s3_bucket}/artifacts/ /home/ec2-user/artifacts --region ${region}
mkdir /home/ec2-user/notebooks
aws s3 sync s3://${s3_bucket}/ /home/ec2-user/notebooks --region ${region}
wait

cp -f /home/ec2-user/artifacts/jupyter_notebook_config.py /home/ec2-user/.jupyter/jupyter_notebook_config.py

sudo -u ec2-user bash -c 'source activate tensorflow_p37;jupyter notebook'

#sudo -u ec2-user 'source activate tensorflow_p37'
#sudo -u ec2-user 'conda --version'

#cd /home/ec2-user/
#sudo -u 'ec2-user jupyter notebook'



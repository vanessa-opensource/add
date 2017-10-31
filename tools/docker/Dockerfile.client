FROM onec32/client:8.3.10.1981

RUN useradd --create-home --shell /bin/bash --user-group --groups adm,sudo ubuntu
ADD ./ /home/ubuntu/code
RUN chown -R ubuntu:ubuntu /home/ubuntu/code 
WORKDIR /home/ubuntu/code



FROM nginx:1.9.4
RUN sed -i 's/httpredir\.debian\.org/mirrors.163.com/g' /etc/apt/sources.list
RUN sed -i 's/security\.debian\.org/mirrors.163.com\/debian-security/g'  /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install -y vim apt-utils libssl-dev libffi-dev python-dev
RUN apt-get install -y git python-pip cron
RUN pip install -i http://pypi.douban.com/simple -U Sphinx
RUN apt install -y vim
RUN mkdir -p /mnt/readthedoc
RUN sphinx-quickstart -q -p "Elico Corp" -a "Shanghai Elico Limited" --suffix=.rst --master=index --makefile --no-batchfile --ext-autodoc /mnt/readthedoc
RUN mkdir /mnt/readthedoc/source
ADD source /mnt/readthedoc/source
ADD ./conf/conf.py /mnt/readthedoc/conf.py
ADD ./conf/index.hdr /mnt/readthedoc/index.hdr
ADD ./conf/index.ftr /mnt/readthedoc/index.ftr
ADD ./conf/logo.png /mnt/readthedoc/logo.png
ADD ./rtd_build_index.sh /mnt/readthedoc/rtd_build_index.sh
RUN chmod +x /mnt/readthedoc/rtd_build_index.sh
RUN /mnt/readthedoc/rtd_build_index.sh
RUN cd /mnt/readthedoc && make html
RUN rm -rf /usr/share/nginx/html
RUN ln -s /mnt/readthedoc/_build/html /usr/share/nginx/html


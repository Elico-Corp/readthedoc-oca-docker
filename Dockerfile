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
ADD conf.py /mnt/readthedoc/conf.py
ADD index.rst /mnt/readthedoc/index.rst
ADD ./logo.png /mnt/readthedoc/logo.png
ADD ./pull_repos_oca.sh /mnt/readthedoc/pull_repos_oca.sh
RUN chmod +x /mnt/readthedoc/pull_repos_oca.sh
RUN /mnt/readthedoc/pull_repos_oca.sh
RUN cd /mnt/readthedoc && make html
RUN rm -rf /usr/share/nginx/html
RUN ln -s /mnt/readthedoc/_build/html /usr/share/nginx/html


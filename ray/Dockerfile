FROM rayproject/ray:2.2.0-py38-cpu

COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

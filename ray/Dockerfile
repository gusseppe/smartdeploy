FROM rayproject/ray:2.0.0rc1-py310-cpu

COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
RUN rm requirements.txt

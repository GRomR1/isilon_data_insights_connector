FROM python:3.9-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -U pip setuptools
RUN pip3 install -r requirements.txt

COPY . .

ENV CONFIG_FILE_PATH=/app/config/isi_data_insights_d.cfg
EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
CMD [ "debug" ]

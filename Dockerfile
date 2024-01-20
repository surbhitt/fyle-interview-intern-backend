FROM python:3.8

WORKDIR /app

COPY core/ core/
COPY requirements.txt requirements.txt
COPY gunicorn_config.py gunicorn_config.py
COPY run.sh run.sh

RUN pip install --no-cache-dir -r requirements.txt

CMD ["./run.sh"]

EXPOSE 5000

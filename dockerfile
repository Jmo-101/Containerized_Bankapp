FROM python:3.7

RUN git clone https://github.com/Jmo-101/automate_tf_bankapp.git

WORKDIR /automate_tf_bankapp

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y default-libmysqlclient-dev
RUN apt-get install -y python3-dev

RUN pip install -r requirements.txt
RUN pip install gunicorn
RUN pip install mysqlclient

EXPOSE 8000

ENTRYPOINT ["python", "-m", "gunicorn", "app:app", "-b", "0.0.0.0"]

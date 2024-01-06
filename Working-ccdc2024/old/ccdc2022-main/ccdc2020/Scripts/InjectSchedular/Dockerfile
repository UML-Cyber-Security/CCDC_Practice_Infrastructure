FROM python:3-alpine

# required packages for slackclient
RUN apk update && apk --no-cache add gcc musl-dev

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY bin/ ./
COPY src/ ./

ENTRYPOINT [ "python3", "scheduler.py" ]
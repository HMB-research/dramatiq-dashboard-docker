# Use an official Python runtime with amd64 architecture
FROM --platform=linux/amd64 python:3.11.1-slim-buster

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV APP_HOME=/home/app

# User and working dir
RUN mkdir -p $APP_HOME
RUN groupadd -r app && useradd -r -g app app
WORKDIR $APP_HOME

# Needed to build bjoern (install build tools)
RUN apt-get update && apt-get install -y \
    gcc \
    libev-dev \
    && rm -rf /var/lib/apt/lists/*

# Dependencies
RUN pip install --upgrade pip
COPY requirements.txt $APP_HOME/requirements.txt
RUN pip install --no-cache-dir -r $APP_HOME/requirements.txt

COPY app.py $APP_HOME/
RUN chmod +x $APP_HOME/app.py  # Make it executable
RUN chown -R app:app $APP_HOME

USER app

ENTRYPOINT ["python3", "./app.py"]

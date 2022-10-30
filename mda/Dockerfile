FROM alpine:3.15

ENV TZ="Europe/Lisbon"

ENV POSTGRES_USER=user
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_HOST=10.233.8.201
ENV POSTGRES_PORT=5432
ENV POSTGRES_DB=mda
ENV RESET_DB=false
ENV KAFKA_HOST=
ENV KAFKA_PORT=9092
ENV NUM_READING_THREADS=10
ENV NUM_AGGREGATION_THREADS=10
ENV OSM_KEY=
ENV MIN_AVAILABILITY=0.90
ENV MAX_AVAILABILITY=0.99

RUN apk add python3 py3-pip build-base postgresql-libs musl-dev postgresql-dev python3-dev
RUN pip install fastapi uvicorn uuid requests rsa pycryptodome typing kafka-python sqlalchemy==1.3.23 sqlalchemy-utils psycopg2 python-dateutil timeloop

VOLUME /logs

EXPOSE 4000

COPY ./sources/mda/app /app
WORKDIR /
CMD ["python3", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0",  "--port", "4000"]

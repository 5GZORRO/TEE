FROM alpine:3.15

RUN apk add python3 py3-pip build-base musl-dev python3-dev
RUN pip install fastapi uvicorn kafka-python minio numpy pandas

# Copy the entire folder from host OS to container
COPY . /isbp

#VOLUME /shared

# Expose container ports
EXPOSE 8000

WORKDIR /isbp

# Start the app when container starts
CMD ["python3", "-m", "uvicorn", "sla-service:app", "--host", "0.0.0.0", "--port", "8000"]

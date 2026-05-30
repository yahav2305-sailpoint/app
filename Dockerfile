FROM python:3.14-alpine AS builder

WORKDIR /app

COPY app/* /app/

RUN pip install --no-cache-dir --target=/app/dependencies -r /app/requirements.txt

# Rootless + Distroless + no shell!
FROM gcr.io/distroless/python3-debian13

WORKDIR /app

COPY --from=builder /app/dependencies /app/dependencies
COPY --from=builder /app/app.py /app/app.py

ENV PYTHONPATH=/app/dependencies

CMD ["/app/app.py"]
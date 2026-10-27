FROM python:3.12-alpine AS build
WORKDIR /app
COPY requirements.txt .
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt


FROM python:3.12-alpine
RUN adduser -D appuser
COPY --from=build /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /app
RUN chown -R appuser:appuser /app
COPY --chown=appuser:appuser . .
USER appuser
EXPOSE 8000
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]

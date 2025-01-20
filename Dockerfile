FROM python:3.9-slim

# Set build-time variables with default values
ARG APP_USER=theia
ARG APP_UID=1001

# Create working folder and install dependencies
WORKDIR /app

COPY ./requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application contents
COPY service/ ./service/

# Switch to a non-root user
RUN useradd --uid $APP_UID $APP_USER && chown -R $APP_USER /app
USER $APP_USER

# Expose a default port for documentation purposes
EXPOSE 8080

# Run the service
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]

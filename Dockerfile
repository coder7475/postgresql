# Use the official PostgreSQL image as the base
FROM postgres:latest

# Set environment variables for PostgreSQL configuration
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=db_blog

# Expose the PostgreSQL port (this is declarative; actual mapping occurs at runtime)
EXPOSE 5432

# Define a volume for data persistence (this is declarative; actual mounting occurs at runtime)
VOLUME /var/lib/postgresql/data

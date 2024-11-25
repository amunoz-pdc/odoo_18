# Use an official Python image
FROM python:3.12
LABEL authors="amunoz"

# Set environment variables
ENV ODOO_HOME=/opt/odoo
ENV ADDONS_PATH=/opt/odoo/odoo/addons,/opt/odoo/odoo/custom-addons
ENV ODOO_CONF=/opt/odoo/odoo/odoo.conf
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    python3-pip \
    python3-dev \
    python3-venv \
    python3-wheel \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    libsasl2-dev \
    python3-setuptools \
    libjpeg-dev \
    zlib1g-dev \
    libpq-dev \
    libxslt1-dev \
    libldap2-dev \
    libtiff5-dev \
    libopenjp2-7-dev \
    wkhtmltopdf && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create Odoo user and home directory
RUN useradd -m -d $ODOO_HOME -U -r -s /bin/bash odoo

# Copy the Odoo source code from the repository into the container
COPY . /opt/odoo/odoo

# Ensure odoo user has permission to write to the ODOO_HOME directory and all its contents
RUN chown -R odoo:odoo /opt/odoo

# Switch to Odoo user
USER odoo

# Create a Python virtual environment in the home directory of odoo user (avoiding permissions issues in /opt/odoo)
RUN python3 -m venv /opt/odoo/odoo-venv && \
    /opt/odoo/odoo-venv/bin/pip install wheel && \
    /opt/odoo/odoo-venv/bin/pip install -r /opt/odoo/odoo/requirements.txt

# Create custom addons directory
RUN mkdir -p /opt/odoo/odoo/custom-addons

# Expose Odoo port
EXPOSE 8069

# Entry point for the Odoo server (using the correct path to odoo.conf)
CMD ["bash", "-c", "/opt/odoo/odoo-venv/bin/python3 /opt/odoo/odoo/odoo-bin -c $ODOO_CONF"]

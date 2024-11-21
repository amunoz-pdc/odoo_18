# Use official Python image as a base
FROM python:3.12
LABEL authors="amunoz"

# Set working directory
WORKDIR /opt/odoo

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libxml2-dev \
    libssl-dev \
    libsasl2-dev \
    libldap2-dev \
    zlib1g-dev \
    libjpeg-dev \
    liblcms2-dev \
    libblas-dev \
    libatlas-base-dev \
    git \
    npm \
    && apt-get clean

# Copy your Odoo source code
COPY . /opt/odoo/

# Copy the Odoo configuration file
COPY odoo.conf /etc/odoo/odoo.conf

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose the Odoo port
EXPOSE 8069

# Set environment variables for Odoo
ENV ODOO_CONFIG=/etc/odoo/odoo.conf

# Start Odoo
CMD ["python", "odoo-bin", "-c", "/etc/odoo/odoo.conf"]

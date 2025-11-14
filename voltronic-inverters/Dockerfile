# -----------------------------------------------
# Voltronic Inverters Home Assistant Add-on Dockerfile
# -----------------------------------------------

ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/aarch64:stable
FROM ${BUILD_FROM}

# Labels, optional
LABEL maintainer="djramaha <your_email@example.com>"
LABEL version="1.0.1"

# Виконуємо оновлення системи і встановлюємо пакети
# Update system and install dependencies
RUN apt-get update && \
    apt-get install -y git build-essential cmake jq mosquitto-clients && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Створюємо робочу директорію
# Set workdir
WORKDIR /opt

# Клон стороннього репозиторію з Voltronic CLI
# Clone external Voltronic CLI repo
RUN git clone --filter=blob:none --no-checkout https://github.com/catalinbordan/docker-voltronic-homeassistant.git repo && \
    cd repo && \
    git fetch origin a01e305846c697d985847405909e91ba81289a49 && \
    git checkout a01e305846c697d985847405909e91ba81289a49 && \
    git sparse-checkout init --cone && \
    git sparse-checkout set sources config

# Копіюємо скрипт патчу і запускаємо його
# Copy patch script and run it
COPY add_string_include.sh /tmp/add_string_include.sh
RUN bash /tmp/add_string_include.sh

# Копіюємо необхідні файли у контейнер
# Copy required files into container
RUN rm -rf repo
RUN mkdir -p /etc/inverter && cp -r repo/sources/* /opt/ && cp -r repo/config/* /etc/inverter/

# Копіюємо run.sh
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Будуємо inverter_poller
# Build inverter_poller
RUN cd /opt/inverter-cli && mkdir bin && cmake . && make && mv inverter_poller bin/

# Завершуємо
CMD ["/run.sh"]

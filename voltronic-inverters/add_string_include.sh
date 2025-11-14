#!/bin/bash
set -e

# -----------------------------------------------
# Патч для inverter.h для додавання #include <string>
# Patch for inverter.h to add #include <string>
# -----------------------------------------------

# Директорія, куди Docker клонує сторонній репозиторій
# Directory where Docker clones the external repository
REPO_DIR=/opt/repo

# Шлях до файлу inverter.h
# Path to inverter.h file
INVERTER_H="$REPO_DIR/sources/inverter.h"

# Перевіряємо чи вже є #include <string>
# Check if #include <string> is already present
if ! grep -q "#include <string>" "$INVERTER_H"; then
    # Додаємо на початок файлу
    # Insert at the beginning of the file
    sed -i '1i#include <string>\nusing std::string;' "$INVERTER_H"
    echo "[PATCH] Added #include <string> in inverter.h"
else
    echo "[PATCH] inverter.h already has #include <string>"
fi

#!/bin/bash

# Путь к директории с вендорскими DTS
TARGET_DIR="arch/arm64/boot/dts/vendor/"

echo "Начинаю очистку Makefile от оверлеев..."

# Находим все файлы Makefile в подпапках и правим их
find "$TARGET_DIR" -name "Makefile" -type f | while read -r makefile; do
    echo "Обработка: $makefile"
    
    # sed удаляет строки, содержащие .dtbo
    # -i создает бэкап с расширением .bak, чтобы можно было откатиться
    sed -i.bak '/\.dtbo/d' "$makefile"
done

echo "Готово! Бэкапы оригиналов сохранены с расширением .bak"

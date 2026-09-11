#!/usr/bin/env bash

TARGET_DIR="${1:-boot/dts/vendor}"
TARGET_FILE="pmk8350.dtsi"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Ошибка: Директория '$TARGET_DIR' не найдена!"
    exit 1
fi

echo "=== Поиск родительских включений для $TARGET_FILE в $TARGET_DIR ==="

RELATIONS=$(mktemp)
trap 'rm -f "$RELATIONS"' EXIT

echo "[1/2] Сканирование #include зависимостей..."
grep -rnE '^\s*#include\s+["<][^">]+\.dtsi?[">]' "$TARGET_DIR" | while read -r line; do
    parent_file=$(echo "$line" | cut -d: -f1)
    child_file=$(echo "$line" | sed -E 's/.*#include\s+["<]([^">]+)[">].*/\1/' | xargs basename)
    echo "$child_file -> $parent_file" >> "$RELATIONS"
done

trace_parents() {
    local current_child="$1"
    local current_path="$2"
    
    local parents
    parents=$(grep "^$current_child ->" "$RELATIONS" | awk -F' -> ' '{print $2}' | sort -u)
    
    if [ -z "$parents" ]; then
        return
    fi
    
    for parent in $parents; do
        local parent_base
        parent_base=$(basename "$parent")
        
        # Проверка на циклы
        if [[ "$current_path" == *"$parent_base"* ]]; then
            continue
        fi
        
        local new_path="$current_path -> $parent"
        
        if [[ "$parent" =~ \.dts$ ]]; then
            echo -e "  \e[32m[ИТОГОВЫЙ DTS]\e[0m $new_path"
        else
            trace_parents "$parent_base" "$new_path"
        fi
    done
}

echo "[2/2] Построение цепочек включений..."
echo ""
trace_parents "$TARGET_FILE" "$TARGET_FILE" | sort -u

echo ""
echo "=== Поиск завершен ==="

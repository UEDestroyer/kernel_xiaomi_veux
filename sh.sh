#!/usr/bin/env bash

set -euo pipefail

# Массив директорий для поиска инклудов
INCLUDE_DIRS=(".")
# Множество уже посещенных файлов (чтобы не уйти в бесконечную рекурсию при циклических инклудах)
declare -A VISITED

usage() {
    echo "Использование: $0 [-I include_dir] <файл.dts>"
    exit 1
}

# Разбор флагов
while getopts "I:" opt; do
    case "${opt}" in
        I) INCLUDE_DIRS+=("${OPTARG}") ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

MAIN_FILE="${1:-}"
if [[ -z "${MAIN_FILE}" ]]; then
    usage
fi

# Функция поиска абсолютного или относительного пути к файлу
find_include() {
    local target="$1"
    local current_dir="$2"

    # 1. Проверяем относительно текущего разбираемого файла
    if [[ -f "${current_dir}/${target}" ]]; then
        echo "${current_dir}/${target}"
        return 0
    fi

    # 2. Проверяем в переданных -I директориях
    for dir in "${INCLUDE_DIRS[@]}"; do
        if [[ -f "${dir}/${target}" ]]; then
            echo "${dir}/${target}"
            return 0
        fi
    done

    return 1
}

# Рекурсивная функция обхода
parse_includes() {
    local file="$1"
    local indent="$2"

    # Получаем реальный путь к файлу для отслеживания повторов
    local real_path
    real_path=$(readlink -f "$file" 2>/dev/null || echo "$file")

    if [[ -n "${VISITED[$real_path]:-}" ]]; then
        echo "${indent}└── $(basename "$file") (уже разложен выше)"
        return
    fi
    VISITED["$real_path"]=1

    local file_dir
    file_dir=$(dirname "$file")

    # Ищем строки виды #include "..." или #include <...>
    # Парсим только закомментированные отступы, игнорируем комментарии // и /*
    grep -E '^[[:space:]]*#include[[:space:]]+["<][^">]+[">]' "$file" 2>/dev/null | \
    sed -E 's/^[[:space:]]*#include[[:space:]]+["<]([^">]+)[">].*/\1/' | \
    while read -r inc; do
        local resolved
        if resolved=$(find_include "$inc" "$file_dir"); then
            echo "${indent}├── ${inc} (${resolved})"
            parse_includes "${resolved}" "${indent}│   "
        else
            echo "${indent}├── ${inc} [ФАЙЛ НЕ НАЙДЕН]"
        fi
    done
}

if [[ ! -f "${MAIN_FILE}" ]]; then
    echo "Ошибка: файл '${MAIN_FILE}' не найден." >&2
    exit 1
fi

echo "${MAIN_FILE}"
parse_includes "${MAIN_FILE}" ""

#!/usr/bin/env python3
import os
import re
import argparse

# Регулярное выражение для поиска: 
# 1. #include "file" или #include <file>
# 2. /include/ "file"
INCLUDE_PATTERN = re.compile(r'^\s*(?:#include\s+["<](.*?)[">]|/include/\s+"(.*?)")', re.MULTILINE)

def find_file(filename, search_paths):
    """Ищет файл в указанных директориях."""
    for path in search_paths:
        full_path = os.path.join(path, filename)
        if os.path.isfile(full_path):
            return full_path
    return None

def build_tree(file_path, search_paths, visited=None, depth=0, is_last=False, prefix=""):
    """Рекурсивно строит и выводит дерево зависимостей."""
    if visited is None:
        visited = set()

    file_name = os.path.basename(file_path)
    
    # Визуальное оформление веток
    if depth == 0:
        print(f"📦 {file_name}")
    else:
        connector = "└── " if is_last else "├── "
        print(f"{prefix}{connector}{file_name}")

    real_path = os.path.realpath(file_path)
    
    # Защита от бесконечной рекурсии (циклические include)
    if real_path in visited:
        new_prefix = prefix + ("    " if is_last else "│   ")
        print(f"{new_prefix}└── ⚠️ (Уже включен: предотвращение цикла)")
        return

    visited.add(real_path)

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        new_prefix = prefix + ("    " if is_last else "│   ")
        print(f"{new_prefix}└── ❌ Ошибка чтения: {e}")
        return

    # Поиск всех подключений
    matches = INCLUDE_PATTERN.findall(content)
    
    # regex возвращает кортеж из-за двух групп захвата, одна из них будет пустой
    includes = [m[0] if m[0] else m[1] for m in matches]

    new_prefix = prefix + ("    " if is_last else "│   ")
    
    for i, inc_file in enumerate(includes):
        is_last_child = (i == len(includes) - 1)
        
        # Директория текущего файла имеет высший приоритет
        current_dir = os.path.dirname(file_path)
        paths_to_check = [current_dir] + search_paths
        
        found_path = find_file(inc_file, paths_to_check)
        
        if found_path:
            build_tree(found_path, search_paths, set(visited), depth + 1, is_last_child, new_prefix)
        else:
            connector = "└── " if is_last_child else "├── "
            print(f"{new_prefix}{connector}❓ {inc_file} (ФАЙЛ НЕ НАЙДЕН)")

def main():
    parser = argparse.ArgumentParser(description="Построение дерева зависимостей для DTS файлов.")
    parser.add_argument("dts_file", help="Путь к корневому файлу .dts или .dtsi")
    parser.add_argument("-I", "--include", action="append", default=[],
                        help="Дополнительные директории для поиска файлов (можно указывать несколько раз)")
    
    args = parser.parse_args()

    if not os.path.isfile(args.dts_file):
        print(f"Ошибка: Файл '{args.dts_file}' не найден.")
        return

    build_tree(args.dts_file, args.include)

if __name__ == "__main__":
    main()

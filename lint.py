import os
import subprocess
import sys

def lint_files(directory):
    # Проходим по всем файлам в указанной директории
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".py"):
                file_path = os.path.join(root, file)
                print(f"\nLinting {file_path}...")
                # Запускаем Pylint для каждого файла
                result = subprocess.run(['pylint', file_path], capture_output=True, text=True)
                print(result.stdout)
                print(result.stderr)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python lint.py <directory>")
        sys.exit(1)
    
    directory = sys.argv[1]

    if not os.path.isdir(directory):
        print(f"Error: {directory} is not a valid directory.")
        sys.exit(1)

    lint_files(directory)


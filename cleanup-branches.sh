#!/bin/bash

# Имя основной ветки. Измените на 'main', если используется другая ветка.
MAIN_BRANCH="master"

# Флаг для удаления удаленных веток (по умолчанию выключен)
DELETE_REMOTE=false

# Функция для вывода помощи
function show_help() {
    echo "Usage: $0 [-r] [-b main|master]"
    echo ""
    echo "Options:"
    echo "  -r          Delete remote branches after merging (default: false)"
    echo "  -b <branch> Specify the main branch to compare with (default: master)"
    echo "  -h          Show this help message and exit"
    exit 0
}

# Парсинг аргументов командной строки
while getopts "rb:h" opt; do
    case ${opt} in
        r )
            DELETE_REMOTE=true
            ;;
        b )
            MAIN_BRANCH=$OPTARG
            ;;
        h )
            show_help
            ;;
        * )
            show_help
            ;;
    esac
done

# Переключение на основную ветку
echo "Switching to branch $MAIN_BRANCH..."
git checkout $MAIN_BRANCH

# Обновление основной ветки
echo "Pulling the latest changes from the main branch..."
git pull origin $MAIN_BRANCH

# Удаление локальных веток, которые были слиты в основную
echo "Deleting merged local branches..."
for branch in $(git branch --merged $MAIN_BRANCH | grep -vE "(^\*|$MAIN_BRANCH)"); do
    echo "Deleting local branch $branch..."
    git branch -d $branch
done

# Удаление удаленных веток, которые были слиты в основную
if [ "$DELETE_REMOTE" = true ]; then
    echo "Deleting merged remote branches..."
    for branch in $(git branch -r --merged $MAIN_BRANCH | grep -vE "(^\*|/$MAIN_BRANCH|/HEAD)"); do
        remote_branch=$(echo $branch | sed 's/origin\///')
        echo "Deleting remote branch origin/$remote_branch..."
        git push origin --delete $remote_branch
    done
fi

echo "Cleanup completed!"


#!/bin/bash

# Имя пользователя и репозиторий
USER="ms-emily"
REPO="calculator-app"

# Токен для доступа к API GitHub (должен быть задан как переменная среды)
TOKEN=$GITHUB_TOKEN

# Проверка, что токен задан
if [ -z "$TOKEN" ]; then
  echo "Error: GITHUB_TOKEN is not set."
  exit 1
fi

# URL API для репозитория
API_URL="https://api.github.com/repos/$USER/$REPO"

# Функция для закрытия PR
close_pr() {
  pr_number=$1
  echo "Closing PR #$pr_number due to merge conflicts..."

  # Закрытие PR с помощью PATCH-запроса
  response=$(curl -s -X PATCH -H "Authorization: token $TOKEN" \
    -d '{"state":"closed"}' \
    "$API_URL/pulls/$pr_number")

  if [[ "$response" == *"\"state\": \"closed\""* ]]; then
    echo "PR #$pr_number has been closed successfully."
  else
    echo "Failed to close PR #$pr_number. Response: $response"
  fi
}

# Получение списка всех открытых pull request'ов
echo "Fetching open pull requests..."
pull_requests=$(curl -s -H "Authorization: token $TOKEN" \
  "$API_URL/pulls?state=open" | jq -r '.[].number')

# Проверка каждого PR на наличие конфликтов
for pr_number in $pull_requests; do
  echo "Checking PR #$pr_number for conflicts..."

  # Проверка на наличие конфликтов с использованием GitHub API
  pr_data=$(curl -s -H "Authorization: token $TOKEN" \
    "$API_URL/pulls/$pr_number")
  mergeable=$(echo "$pr_data" | jq -r '.mergeable')
  mergeable_state=$(echo "$pr_data" | jq -r '.mergeable_state')

  # Если PR имеет конфликты, он не может быть объединен
  if [ "$mergeable" == "false" ] && [ "$mergeable_state" == "dirty" ]; then
    echo "PR #$pr_number has merge conflicts."
    close_pr $pr_number
  else
    echo "PR #$pr_number is mergeable."
  fi
done

echo "Pull request check completed."


#!/usr/bin/env bash
# Резервная копия DocuSeal: дамп PostgreSQL + файлы приложения + .env. Автор скрипт на живом сервере не запускал.
# Запуск из папки с docker-compose.yml: bash backup.sh
# Правило 3-2-1: 3 копии, 2 носителя, 1 вне сервера. Копию из ./backup перенесите на внешний диск и вне сервера.
set -euo pipefail
cd "$(dirname "$0")"
STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p backup
docker compose exec -T postgres pg_dump -U docuseal docuseal | gzip > "backup/db-$STAMP.sql.gz"
tar czf "backup/files-$STAMP.tar.gz" docuseal .env docker-compose.yml
echo "Готово: backup/db-$STAMP.sql.gz и backup/files-$STAMP.tar.gz"
echo "Проверьте восстановление на тестовой машине, прежде чем удалять оригиналы."

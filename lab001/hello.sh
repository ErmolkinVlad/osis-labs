#!/bin/bash
# ищем пользователя vasya в /etc/passwd,
# весь вывод перенаправляем в /dev/null
grep vasya /etc/passwd > /dev/null 2>&1
# смотрим код завершения и действуем по обстоятельствам:
if [ "$?" -eq 0 ]; then
echo "Пользователь vasya найден"
exit
else
echo "Пользователь vasya не найден"
fi
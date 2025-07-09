# Тестирование BluetoothAutoSleeper

## Быстрый тест новой функциональности

### 1. Подготовка
```bash
./test_daemon.sh start    # Запустить демон
./test_daemon.sh clear    # Очистить логи
```

### 2. Тест быстрого пробуждения (< 5 сек)
1. Закройте MacBook крышкой
2. Сразу откройте (в течение 5 секунд)
3. Проверьте логи: `./test_daemon.sh logs`

**Ожидаемый результат:**
- Увидите сообщение "Sleep timer cancelled - Bluetooth stays connected!"
- Bluetooth остается включенным

### 3. Тест длительного сна (> 5 сек)
1. Закройте MacBook крышкой
2. Подождите больше 5 секунд
3. Откройте MacBook
4. Проверьте логи: `./test_daemon.sh logs`

**Ожидаемый результат:**
- Увидите сообщение "Sleep delay expired - disabling Bluetooth"
- Затем "Bluetooth enabled after wake"

### 4. Просмотр логов
```bash
./test_daemon.sh logs     # Показать последние 20 строк логов
./test_daemon.sh status   # Проверить статус демона
```

### 5. Остановка
```bash
./test_daemon.sh stop     # Остановить демон
```

## Полезные команды

- `./test_daemon.sh start` - Запустить демон
- `./test_daemon.sh stop` - Остановить демон
- `./test_daemon.sh logs` - Показать логи
- `./test_daemon.sh clear` - Очистить логи
- `./test_daemon.sh status` - Проверить статус
- `./test_daemon.sh test` - Полный тест

## Примеры логов

### Быстрое пробуждение:
```
💤 System will sleep - starting 5.0 second countdown...
⏳ Bluetooth will be disabled in 5.0 seconds unless system wakes up...
☀️ System did wake - checking if we need to cancel sleep timer...
✅ Sleep timer cancelled - Bluetooth stays connected!
```

### Длительный сон:
```
💤 System will sleep - starting 5.0 second countdown...
⏳ Bluetooth will be disabled in 5.0 seconds unless system wakes up...
⏰ Sleep delay expired - disabling Bluetooth
🔵 Bluetooth disabled after 5.0 second delay
☀️ System did wake - checking if we need to cancel sleep timer...
⚠️ No active sleep timer found
🔵 Bluetooth enabled after wake
```

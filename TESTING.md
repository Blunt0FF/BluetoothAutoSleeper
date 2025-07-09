# Тестирование BluetoothAutoSleeper v2.0

## 🆕 Что исправлено

1. **✅ Умная задержка 5 секунд** - Bluetooth отключается только если сон длится > 5 сек
2. **✅ Улучшенный Bluetooth контроль** - Поддержка blueutil + диагностика
3. **✅ Исправлен GUI логов** - Добавлена кнопка Close + диагностика чтения логов

## 🧪 Быстрое тестирование

### 1. Подготовка
```bash
# Убедитесь, что вы в папке проекта
cd BluetoothAutoSleeper

# Проверьте статус Bluetooth и подключенные устройства
./test_daemon.sh bluetooth-status

# Если blueutil не установлен:
./test_daemon.sh install-blueutil
```

### 2. Запуск демона
```bash
# Очистите логи и запустите демон
./test_daemon.sh clear
./test_daemon.sh start

# Проверьте, что демон запущен
./test_daemon.sh status
./test_daemon.sh logs
```

### 3. Тестирование GUI
```bash
# Запустите GUI
open BluetoothAutoSleeper.app

# В GUI:
# - Должен показать, что демон запущен (зеленый gear icon)
# - Нажмите "View Logs" - должны появиться логи
# - В окне логов должна быть кнопка "Close"
# - Escape также должен закрывать окно
```

### 4. Тестирование умной задержки

#### Тест 1: Быстрое пробуждение (< 5 сек)
1. **Убедитесь, что Bluetooth включен и устройства подключены**
   ```bash
   ./test_daemon.sh bluetooth-status
   ```

2. **Закройте MacBook крышкой на 2-3 секунды, затем откройте**

3. **Проверьте логи**
   ```bash
   ./test_daemon.sh logs
   ```
   
   **Ожидаемые логи:**
   ```
   💤 System will sleep - starting 5.0 second countdown...
   ⏳ Bluetooth will be disabled in 5.0 seconds unless system wakes up...
   ☀️ System did wake - checking if we need to cancel sleep timer...
   ✅ Sleep timer cancelled - Bluetooth stays connected!
   ```

4. **Проверьте, что устройства остались подключенными**
   ```bash
   ./test_daemon.sh bluetooth-status
   ```

#### Тест 2: Длительный сон (> 5 сек)
1. **Закройте MacBook крышкой на 8-10 секунд**

2. **Откройте MacBook**

3. **Проверьте логи**
   ```bash
   ./test_daemon.sh logs
   ```
   
   **Ожидаемые логи:**
   ```
   💤 System will sleep - starting 5.0 second countdown...
   ⏳ Bluetooth will be disabled in 5.0 seconds unless system wakes up...
   ⏰ Sleep delay expired - disabling Bluetooth
   🔄 Attempting to disable Bluetooth...
   🔧 Executing: blueutil -p 0
   ✅ Command succeeded
   ✅ Bluetooth disabled via blueutil
   🔵 Bluetooth disabled after 5.0 second delay
   ☀️ System did wake - checking if we need to cancel sleep timer...
   ⚠️ No active sleep timer found
   🔄 Attempting to enable Bluetooth...
   🔧 Executing: blueutil -p 1
   ✅ Command succeeded
   ✅ Bluetooth enabled via blueutil
   🔵 Bluetooth enabled after wake
   ```

4. **Проверьте, что Bluetooth снова включен**
   ```bash
   ./test_daemon.sh bluetooth-status
   ```

### 5. Диагностика проблем

#### Если Bluetooth не отключается:
```bash
# Проверьте логи на ошибки
./test_daemon.sh logs | grep -E "(error|failed|❌)"

# Проверьте вручную
blueutil -p 0  # отключить
sleep 2
blueutil -p 1  # включить

# Проверьте разрешения
ls -la /tmp/bluetooth_daemon.*
```

#### Если логи не показываются в GUI:
```bash
# Проверьте файл логов
ls -la /tmp/bluetooth_daemon.log
cat /tmp/bluetooth_daemon.log

# Запустите GUI из терминала для диагностики
./BluetoothAutoSleeper.app/Contents/MacOS/BluetoothAutoSleeper
```

## 🎯 Сценарии использования

### Сценарий 1: Случайное закрытие MacBook
- **Пользователь**: Слушает музыку в наушниках
- **Действие**: Случайно закрывает MacBook на 2 секунды
- **Результат**: ✅ Bluetooth остается включенным, музыка не прерывается

### Сценарий 2: Умышленный переход в сон
- **Пользователь**: Идет обедать, закрывает MacBook
- **Действие**: MacBook в сне > 5 секунд
- **Результат**: ✅ Bluetooth отключается, экономится батарея

### Сценарий 3: Возвращение к работе
- **Пользователь**: Возвращается после обеда
- **Действие**: Открывает MacBook
- **Результат**: ✅ Bluetooth автоматически включается, устройства переподключаются

## 📝 Команды для управления

```bash
./test_daemon.sh start              # Запустить демон
./test_daemon.sh stop               # Остановить демон  
./test_daemon.sh status             # Статус демона
./test_daemon.sh logs               # Показать логи
./test_daemon.sh clear              # Очистить логи
./test_daemon.sh bluetooth-status   # Статус Bluetooth
./test_daemon.sh install-blueutil   # Установить blueutil
./test_daemon.sh test               # Полный тест
```

## 🔧 Требования

- macOS 11.0+
- Homebrew (для blueutil)
- Разрешения Accessibility (для AppleScript)
- Разрешения AppleEvents 
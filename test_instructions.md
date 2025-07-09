# Testing BluetoothAutoSleeper

## Quick Test of New Functionality

### 1. Preparation

```bash
./test_daemon.sh start    # Start the daemon  
./test_daemon.sh clear    # Clear logs  
```

### 2. Quick Wake Test (< 5 sec)

1. Close your MacBook lid  
2. Reopen it within 5 seconds  
3. Check logs:

```bash
./test_daemon.sh logs
```

**Expected result:**

- You’ll see the message: `Sleep timer cancelled - Bluetooth stays connected!`  
- Bluetooth remains enabled  

### 3. Long Sleep Test (> 5 sec)

1. Close your MacBook lid  
2. Wait more than 5 seconds  
3. Open your MacBook  
4. Check logs:

```bash
./test_daemon.sh logs
```

**Expected result:**

- You’ll see: `Sleep delay expired - disabling Bluetooth`  
- Followed by: `Bluetooth enabled after wake`  

### 4. Viewing Logs

```bash
./test_daemon.sh logs     # Show the last 20 log lines  
./test_daemon.sh status   # Check daemon status  
```

### 5. Stopping

```bash
./test_daemon.sh stop     # Stop the daemon  
```

## Useful Commands

- `./test_daemon.sh start` – Start the daemon  
- `./test_daemon.sh stop` – Stop the daemon  
- `./test_daemon.sh logs` – Show logs  
- `./test_daemon.sh clear` – Clear logs  
- `./test_daemon.sh status` – Check status  
- `./test_daemon.sh test` – Run full test  

## Log Examples

### Quick Wake:
```
💤 System will sleep - starting 5.0 second countdown...
⏳ Bluetooth will be disabled in 5.0 seconds unless system wakes up...
☀️ System did wake - checking if we need to cancel sleep timer...
✅ Sleep timer cancelled - Bluetooth stays connected!
```

### Long Sleep:
```
💤 System will sleep - starting 5.0 second countdown...
⏳ Bluetooth will be disabled in 5.0 seconds unless system wakes up...
⏰ Sleep delay expired - disabling Bluetooth
🔵 Bluetooth disabled after 5.0 second delay
☀️ System did wake - checking if we need to cancel sleep timer...
⚠️ No active sleep timer found
🔵 Bluetooth enabled after wake
```

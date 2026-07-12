# SysPilot

A Bash-based Linux System Administration Suite built as a hands-on Linux administration project.

## About the Project

SysPilot is a Linux administration toolkit developed using Bash scripting.

The goal of this project is to automate common system administration tasks such as:

- System Health Monitoring
- Backup Management
- User Management
- Log Analysis
- Service Monitoring
- System Automation

This project is being built step by step while learning Linux from scratch.

## Module 1 – System Health Monitor ✅

**Status:** Completed

### Features

- Reads thresholds from `syspilot.conf`
- Monitors Disk Usage
- Monitors Memory Usage
- Monitors CPU Usage
- Displays Top 5 Memory Consuming Processes
- Logs `[OK]` and `[WARN]` messages
- Runs automatically every 5 minutes using Cron

### Linux Commands Used

- df
- free
- mpstat
- ps
- grep
- awk
- head
- tail
- date
- cron

### Log Example

```
2026-07-12 11:25:01 PM [OK] Disk Usage 1% | Threshold 80%
2026-07-12 11:25:01 PM [OK] Memory Usage 29% | Threshold 85%
2026-07-12 11:25:01 PM [OK] CPU Usage 5% | Threshold 90%
```

### Future Improvements

- Add `--report` option
- Email alerts
- Better report formatting

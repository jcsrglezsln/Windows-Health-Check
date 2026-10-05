Automates Windows health assessments to help administrators identify storage, memory, service, and security issues before they affect users
# Windows Health Check

Automates Windows health assessments to help administrators identify
storage, memory, service, and security issues before they affect users.

The tool provides a consolidated health status for a Windows system
and supports both local and remote assessments through CIM sessions.
## Features

- Disk health assessment
- Memory usage assessment
- Windows service health assessment
- Security health assessment
- Overall system health status
- Local system assessment
- Remote system assessment using CIM
- Controlled error handling
- ## Health Status

The tool classifies system health using three states:

| Status | Description |
|---|---|
| Healthy | No relevant issues detected |
| Warning | A condition requires attention |
| Critical | A condition requires immediate attention |

Architecture
HealthCheck.ps1
      │
      ▼
Get-SystemHealth
      │
      ├── Get-DiskHealth
      ├── Get-MemoryHealth
      ├── Get-ServiceHealth
      └── Get-SecurityHealth
              │
              ▼
          Common.ps1

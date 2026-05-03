# Bug Report Example

**ID:** BR-001

**Title:** Application crashes when opening settings dialog on Windows 10

**Build:** Version 1.2.3 (Build 456)

**OS:** Windows 10 Pro (64-bit, Version 21H2)

## Steps to Reproduce
1. Launch the desktop application.
2. Navigate to the main menu.
3. Click on "Settings" option.
4. Observe the application behavior.

## Actual Result
The application crashes immediately after clicking "Settings", displaying a generic error message: "The application has encountered an unexpected error and needs to close."

## Expected Result
The Settings dialog should open without any issues, allowing the user to modify application preferences.

## Logs
```
[2023-10-01 14:30:15] INFO: Application started
[2023-10-01 14:30:20] INFO: User clicked Settings
[2023-10-01 14:30:20] ERROR: NullPointerException in SettingsDialog.java:45
[2023-10-01 14:30:20] FATAL: Application terminating due to unhandled exception
```


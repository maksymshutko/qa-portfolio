# Test Case Templates

**ID:** TC-001

**Title:** Verify application installation 

**Labels:** Installation, System, Compatibility

**Priority:** High

**Pre-condition:** 
- Installer package (.dmg for macOS or .exe/.msi for Windows) is available.
- User has administrative permissions to install software.

**Steps:**
1. On macOS: Download and open the .dmg file, drag the application to Applications folder.
2. On Windows: Download and run the installer (.exe or .msi), follow the installation wizard.
3. Verify system folders and paths: Check that application files are installed in correct directories (e.g., /Applications on macOS, Program Files on Windows).
4. Launch the application.
5. Check remote logger for any errors.

**Expected Result:** The application installs successfully on both macOS and Windows, 
all necessary files and folders are created in appropriate system paths,
and the remote logger shows no error messages during installation and initial launch.

___

**ID:** TC-002

**Title:** Verify user can create a new document

**Labels:** Functional, UI, Document Management

**Priority:** High

**Pre-condition:** 
- Application is launched and user is logged in.
- User has permissions to create documents.

**Steps:**
1. Click on "File" menu.
2. Select "New Document".
3. Enter a document name in the dialog.
4. Click "Create".

**Expected Result:** A new document is created with the specified name, and the document editor opens displaying a blank canvas.

___

**ID:** TC-003

**Title:** Verify application handles invalid login credentials gracefully

**Labels:** Functional, Security, Error Handling

**Priority:** Medium

**Pre-condition:** 
- Application is installed and running.
- User is on the login screen.

**Steps:**
1. Enter an invalid username in the username field.
2. Enter an invalid password in the password field.
3. Click the "Login" button.

**Expected Result:** The application displays an error message indicating invalid credentials, and does not grant access to the main application features.

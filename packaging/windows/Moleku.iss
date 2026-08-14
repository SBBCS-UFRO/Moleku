; Inno Setup script for the Moleku Windows installer.
; Wraps the PyInstaller onedir build (dist\Moleku\) produced by
; scripts\build_windows_app.ps1 into a friendly Setup.exe: Start Menu
; shortcuts, optional desktop icon, and a proper uninstaller.
;
; Build with the Inno Setup Compiler (ISCC.exe), from the repo root:
;   iscc packaging\windows\Moleku.iss
; Optionally override the version (defaults to 1.1.1):
;   iscc /DMyAppVersion=1.1.1 packaging\windows\Moleku.iss
;
; Requires dist\Moleku\Moleku.exe to already exist (run
; scripts\build_windows_app.ps1 first).

#ifndef MyAppVersion
  #define MyAppVersion "1.1.1"
#endif
#define MyAppName "Moleku"
#define MyAppPublisher "Felipe Lizama Mora"
#define MyAppURL "https://github.com/pipelzm/Moleku"
#define MyAppExeName "Moleku.exe"

[Setup]
; Fixed AppId so upgrades/uninstalls are tracked correctly across versions.
AppId={{6C6C8D3E-6C9A-4B7B-9F2D-6F6E8B5D9A11}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
; Let the user choose "install for me only" (no admin) or "install for
; all users" (admin) at setup time — most lab/shared-PC accounts won't
; have admin rights.
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
LicenseFile=..\..\LICENSE
OutputDir=..\..\dist
OutputBaseFilename=Moleku-Setup-{#MyAppVersion}
SetupIconFile=..\..\images\moleku_simple_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/fast
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\..\dist\Moleku\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent

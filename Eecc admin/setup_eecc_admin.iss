; Script Inno Setup officiel pour EECC Admin (Portail de Gestion & Administration)
#define MyAppName "EECC Admin"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Eglise Evangelique les Coheritiers du Christ"
#define MyAppURL "https://eecc.org"
#define MyAppExeName "eecc_admin.exe"

[Setup]
AppId={{5B2A0F81-8CE1-4478-9B21-B53E9AA1C712}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\EECC\Admin
DefaultGroupName=EECC\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=
OutputDir=..\Distributions_Windows\Installateurs
OutputBaseFilename=EECC_Admin_Setup_v1.0
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=lowest

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Fichiers exécutables, DLLs Flutter et assets sans bibliothèque manquante
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

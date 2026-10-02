; Script Inno Setup officiel pour EECC Regie Studio (Logiciel Broadcast & Diffusion)
#define MyAppName "EECC Regie Studio"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Eglise Evangelique les Coheritiers du Christ"
#define MyAppURL "https://eecc.org"
#define MyAppExeName "eecc_regie_studio.exe"

[Setup]
AppId={{9C4D3E72-5A90-4821-A813-D42E9BF3E824}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\EECC\RegieStudio
DefaultGroupName=EECC\{#MyAppName}
DisableProgramGroupPage=yes
OutputDir=..\Distributions_Windows\Installateurs
OutputBaseFilename=EECC_Regie_Studio_Setup_v1.0
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
; Inclusion intégrale de l'exécutable, de toutes les DLLs (flutter_windows, media_kit, mpv, ffmpeg) et des assets
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Dossiers d'assets overlays, sounds et logos
Source: "assets\*"; DestDir: "{app}\data\flutter_assets\assets"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

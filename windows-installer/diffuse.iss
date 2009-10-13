; Inno Setup file for Diffuse
;
; Copyright (C) 2009 Derrick Moser <derrick_moser@yahoo.com>

[Setup]
AppName=Diffuse Merge Tool
AppVerName=Diffuse 0.4.1
DefaultDirName={pf}\Diffuse
DefaultGroupName=Diffuse
UninstallDisplayIcon={app}\diffusew.exe
Compression=lzma
SolidCompression=yes
OutputDir=.
ShowLanguageDialog=auto

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"

[Files]
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Components]
Name: main; Description: "Main Files"; Types: full compact custom; Flags: fixed
Name: shellintegration; Description: "Windows Shell Integration"; Types: full

[Registry]
Root: HKCR; Subkey: "*\shell"; Flags: uninsdeletekeyifempty; Components: shellintegration
Root: HKCR; Subkey: "*\shell\Open with Diffuse Merge Tool"; Flags: uninsdeletekey; Components: shellintegration
Root: HKCR; Subkey: "*\shell\Open with Diffuse Merge Tool\command"; ValueType: string; ValueData: "{code:GetOpenWithCommand|dummy}"; Flags: uninsdeletekey; Components: shellintegration

[Icons]
Name: "{group}\Diffuse Merge Tool"; Filename: "{app}\diffusew.exe"
Name: "{group}\Uninstall Diffuse Merge Tool"; Filename: "{app}\unins000.exe"

[Run]
Filename: "{app}\add_path.exe"; Parameters: "{app}"; Flags: postinstall; Description: "Add the installation path to the search path"

[UninstallRun]
Filename: "{app}\add_path.exe"; Parameters: "/del {app}"

[Code]
function GetOpenWithCommand(dummy : String): String;
var
    S: String;
begin
    S := ExpandConstant('{app}\diffusew.exe');
    StringChangeEx(S, '\', '\\', True);
    Result := '"' + S + '" "%1"';
end;

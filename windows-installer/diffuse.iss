; Inno Setup file for Diffuse
;
; Copyright (C) 2009 Derrick Moser <derrick_moser@yahoo.com>

[Setup]
AppName=Diffuse Merge Tool
AppVerName=Diffuse 0.2.15
DefaultDirName={pf}\Diffuse
DefaultGroupName=Diffuse Merge Tool
UninstallDisplayIcon={app}\diffusew.exe
Compression=lzma
SolidCompression=yes
OutputDir=.

[Files]
Source: "dist\*.exe"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "dist\*.zip"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "dist\*.dll"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "dist\*.pyd"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "dist\diffuserc"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "dist\diffuse.ico"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "dist\*.html"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "dist\*.css"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "dist\*.txt"; DestDir: "{app}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "dist\etc\*"; DestDir: "{app}\etc"; Flags: ignoreversion recursesubdirs  createallsubdirs
Source: "dist\lib\*"; DestDir: "{app}\lib"; Flags: ignoreversion recursesubdirs  createallsubdirs
Source: "dist\share\*"; DestDir: "{app}\share"; Flags: ignoreversion recursesubdirs  createallsubdirs
Source: "dist\syntax\*"; DestDir: "{app}\syntax"; Flags: ignoreversion recursesubdirs  createallsubdirs

[UninstallDelete]
Type: files; Name: "{app}\diffuserc"

[Registry]
Root: HKCR; Subkey: "*\shell"; Flags: uninsdeletekeyifempty
Root: HKCR; Subkey: "*\shell\Open with Diffuse Merge Tool"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\Open with Diffuse Merge Tool\command"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\Open with Diffuse Merge Tool\command"; ValueType: string; ValueData: "{code:GetOpenWithCommand|dummy}"

[Icons]
Name: "{group}\Diffuse Merge Tool"; Filename: "{app}\diffusew.exe"
Name: "{group}\Uninstall Diffuse Merge Tool"; Filename: "{app}\unins000.exe"

[Code]
function GetOpenWithCommand(dummy : String): String;
var
    S: String;
begin
    S := ExpandConstant('{app}\diffusew.exe');
    StringChangeEx(S, '\', '\\', True);
    Result := '"' + S + '" "%1"';
end;

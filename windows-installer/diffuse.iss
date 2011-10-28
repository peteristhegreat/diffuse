; Inno Setup file for Diffuse
;
; Copyright (C) 2009-2011 Derrick Moser <derrick_moser@yahoo.com>

[Setup]
AppId=Diffuse
AppName={cm:ToolName}
AppVerName=Diffuse 0.4.5
DefaultDirName={pf}\Diffuse
DefaultGroupName=Diffuse
UninstallDisplayIcon={app}\diffusew.exe
Compression=lzma
SolidCompression=yes
OutputDir=.
ShowLanguageDialog=auto

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl,.\en.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl,.\de.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl,.\es.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl,.\it.isl"
Name: "ja"; MessagesFile: "compiler:Languages\Japanese.isl,.\ja.isl"
Name: "ko"; MessagesFile: "compiler:Languages\Korean-5-5.1.11.isl,.\ko.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl,.\ru.isl"
Name: "zh_CN"; MessagesFile: "compiler:Languages\ChineseSimp-12-5.1.11.isl,.\zh_CN.isl"

[Files]
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Components]
Name: main; Description: "{cm:MainFiles}"; Types: full compact custom; Flags: fixed
Name: shellintegration; Description: "{cm:ShellIntegration}"; Types: full

[Registry]
Root: HKCR; Subkey: "*\shell"; Flags: uninsdeletekeyifempty; Components: shellintegration
Root: HKCR; Subkey: "*\shell\{cm:OpenWithTool}"; Flags: uninsdeletekey; Components: shellintegration
Root: HKCR; Subkey: "*\shell\{cm:OpenWithTool}\command"; ValueType: string; ValueData: "{code:GetOpenWithCommand|dummy}"; Flags: uninsdeletekey; Components: shellintegration

[Icons]
Name: "{group}\{cm:ToolName}"; Filename: "{app}\diffusew.exe"
Name: "{group}\{cm:UninstallTool}"; Filename: "{app}\unins000.exe"

[Run]
Filename: "{app}\add_path.exe"; Parameters: "{app}"; Flags: postinstall; Description: "{cm:AddToPath}"

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

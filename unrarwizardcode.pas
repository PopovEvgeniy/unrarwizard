unit unrarwizardcode;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    OpenButton: TButton;
    BrowseButton: TButton;
    ExtractButton: TButton;
    OverwriteCheckBox: TCheckBox;
    ArchiveField: TLabeledEdit;
    DirectoryField: TLabeledEdit;
    OpenDialog: TOpenDialog;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    procedure OpenButtonClick(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure ExtractButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ArchiveFieldChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var MainWindow: TMainWindow;

implementation

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 convert_file_name:=target;
end;

function correct_path(const source:string ): string;
var target:string;
begin
 target:=source;
 if LastDelimiter(DirectorySeparator,source)<>Length(source) then
 begin
  target:=source+DirectorySeparator;
 end;
 correct_path:=target;
end;

procedure execute_program(const executable:string;const argument:string);
begin
 try
  ExecuteProcess(executable,argument,[]);
 except
  ShowMessage('Cant run an external program');
 end;

end;

procedure extract_data(const archive:string;const directory:string;const overwrite:boolean);
var target,work:string;
begin
 target:=ExtractFilePath(Application.ExeName)+'unrar.exe';
 work:='x ';
 if overwrite=true then work:='x -o+ ';
 execute_program(target,work+convert_file_name(archive)+' '+convert_file_name(directory));
end;

procedure window_setup();
begin
 Application.Title:='Unrar wizard';
 MainWindow.Caption:='Unrar wizard 1.2.9';
 MainWindow.BorderStyle:=bsDialog;
 MainWindow.Font.Name:=Screen.MenuFont.Name;
 MainWindow.Font.Size:=14;
end;

procedure dialog_setup();
begin
 MainWindow.SelectDirectoryDialog.InitialDir:='';
 MainWindow.OpenDialog.InitialDir:='';
 MainWindow.OpenDialog.FileName:='*.rar';
 MainWindow.OpenDialog.DefaultExt:='*.rar';
 MainWindow.OpenDialog.Filter:='Rar archive|*.rar';
end;

procedure interface_setup();
begin
 MainWindow.OpenButton.ShowHint:=False;
 MainWindow.BrowseButton.ShowHint:=False;
 MainWindow.BrowseButton.ShowHint:=False;
 MainWindow.ExtractButton.Enabled:=False;
 MainWindow.OverwriteCheckBox.Checked:=True;
 MainWindow.ArchiveField.LabelPosition:=lpLeft;
 MainWindow.DirectoryField.LabelPosition:=lpLeft;
 MainWindow.ArchiveField.Enabled:=False;
 MainWindow.DirectoryField.Enabled:=False;
 MainWindow.ArchiveField.Text:='';
 MainWindow.DirectoryField.Text:='';
end;

procedure language_setup();
begin
 MainWindow.ArchiveField.EditLabel.Caption:='Archive';
 MainWindow.OverwriteCheckBox.Caption:='Overwrite the existing files';
 MainWindow.OpenButton.Caption:='Open';
 MainWindow.BrowseButton.Caption:='Browse';
 MainWindow.ExtractButton.Caption:='Extract';
 MainWindow.OpenDialog.Title:='Open the existing archive';
 MainWindow.SelectDirectoryDialog.Title:='Please select the output directory';
end;

procedure setup();
begin
 window_setup();
 dialog_setup();
 interface_setup();
 language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TMainWindow.ArchiveFieldChange(Sender: TObject);
begin
 MainWindow.ExtractButton.Enabled:=MainWindow.ArchiveField.Text<>'';
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if MainWindow.OpenDialog.Execute()=True then
 begin
  MainWindow.ArchiveField.Text:=MainWindow.OpenDialog.FileName;
  MainWindow.DirectoryField.Text:=ExtractFilePath(MainWindow.OpenDialog.FileName);
 end;

end;

procedure TMainWindow.BrowseButtonClick(Sender: TObject);
begin
 if MainWindow.SelectDirectoryDialog.Execute()=True then
 begin
  MainWindow.DirectoryField.Text:=correct_path(MainWindow.SelectDirectoryDialog.FileName);
 end;

end;

procedure TMainWindow.ExtractButtonClick(Sender: TObject);
begin
 extract_data(MainWindow.ArchiveField.Text,MainWindow.DirectoryField.Text,MainWindow.OverwriteCheckBox.Checked);
end;

{$R *.lfm}

end.

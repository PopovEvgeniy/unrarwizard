unit unrarwizardcode;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, FileUtil, Forms, Controls, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure OpenDialog1CanClose(Sender: TObject; var CanClose: boolean);
    procedure SelectDirectoryDialog1CanClose(Sender: TObject;
      var CanClose: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end; 

  var Form1: TForm1;
  function get_path(): string;
  function convert_file_name(source:string): string;
  procedure execute_program(executable:string;argument:string);
  procedure window_setup();
  procedure dialog_setup();
  procedure interface_setup();
  procedure language_setup();
  procedure common_setup();
  procedure setup();
  procedure extract_data(archive:string;directory:string;overwrite:boolean);

implementation

function get_path(): string;
begin
 get_path:=ExtractFilePath(Application.ExeName);
end;

function convert_file_name(source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 convert_file_name:=target;
end;

procedure execute_program(executable:string;argument:string);
begin
 try
  ExecuteProcess(executable,argument,[]);
 except
  On EOSError do ShowMessage('Cant run an external program');
 end;

end;

procedure window_setup();
begin
 Application.Title:='Unrar wizard';
 Form1.Caption:='Unrar wizard 1.1.8';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure dialog_setup();
begin
 Form1.SelectDirectoryDialog1.InitialDir:='';
 Form1.OpenDialog1.InitialDir:='';
 Form1.OpenDialog1.FileName:='*.rar';
 Form1.OpenDialog1.DefaultExt:='*.rar';
 Form1.OpenDialog1.Filter:='Rar archive|*.rar';
end;

procedure interface_setup();
begin
 Form1.Button1.ShowHint:=False;
 Form1.Button2.ShowHint:=False;
 Form1.Button2.ShowHint:=False;
 Form1.Button3.Enabled:=False;
 Form1.CheckBox1.Checked:=True;
 Form1.LabeledEdit1.LabelPosition:=lpLeft;
 Form1.LabeledEdit2.LabelPosition:=lpLeft;
 Form1.LabeledEdit1.Enabled:=False;
 Form1.LabeledEdit2.Enabled:=False;
 Form1.LabeledEdit1.Text:='';
 Form1.LabeledEdit2.Text:='';
end;

procedure language_setup();
begin
 Form1.LabeledEdit1.EditLabel.Caption:='Archive';
 Form1.CheckBox1.Caption:='Overwrite existing files';
 Form1.Button1.Caption:='Open';
 Form1.Button2.Caption:='Browse';
 Form1.Button3.Caption:='Extract';
 Form1.OpenDialog1.Title:='Open existing archive';
 Form1.SelectDirectoryDialog1.Title:='Please select output directory';
end;

procedure common_setup();
begin
 window_setup();
 dialog_setup();
 interface_setup();
end;

procedure setup();
begin
 common_setup();
 language_setup();
end;

procedure extract_data(archive:string;directory:string;overwrite:boolean);
var target,work:string;
begin
 target:=get_path()+'unrar.exe';
 work:='x ';
 if overwrite=true then work:=work+'-o+ ';
 work:=work+convert_file_name(archive)+' '+convert_file_name(directory);
 execute_program(target,work);
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
 Form1.Button3.Enabled:=Form1.LabeledEdit1.Text<>'';
end;

procedure TForm1.OpenDialog1CanClose(Sender: TObject; var CanClose: boolean);
begin
 Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
 Form1.LabeledEdit2.Text:=ExtractFilePath(Form1.OpenDialog1.FileName);
end;

procedure TForm1.SelectDirectoryDialog1CanClose(Sender: TObject;
  var CanClose: boolean);
begin
 Form1.LabeledEdit2.Text:=Form1.SelectDirectoryDialog1.FileName;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Form1.OpenDialog1.Execute();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Form1.SelectDirectoryDialog1.Execute();
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 extract_data(Form1.LabeledEdit1.Text,Form1.LabeledEdit2.Text,Form1.CheckBox1.Checked);
end;

{$R *.lfm}

end.

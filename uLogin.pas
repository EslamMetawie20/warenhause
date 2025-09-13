unit uLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmLogin = class(TForm)
    pnlMain: TPanel;
    lblTitle: TLabel;
    lblPassword: TLabel;
    edtPassword: TEdit;
    btnLogin: TButton;
    btnExit: TButton;
    procedure btnLoginClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses uDatabase, uMain, uArabicTexts;

{$R *.dfm}

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  // إعدادات النموذج للغة العربية
  BiDiMode := bdRightToLeft;
  Position := poScreenCenter;

  // تعيين النصوص من ملف uArabicTexts
  Caption      := GetArabicText('FORM_LOGIN');
  lblTitle.Caption := GetArabicText('SYSTEM_TITLE');
  lblPassword.Caption := GetArabicText('PASSWORD');
  btnLogin.Caption := GetArabicText('ENTER');
  btnExit.Caption := GetArabicText('EXIT');
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if Trim(edtPassword.Text) = '' then
  begin
    MessageDlg(GetArabicText('MSG_PASSWORD_EMPTY'), mtWarning, [mbOK], 0);
    edtPassword.SetFocus;
    Exit;
  end;

  if DBManager.CheckPassword(edtPassword.Text) then
  begin
    Application.CreateForm(TfrmMain, frmMain);
    frmMain.Show;
    Hide;
  end
  else
  begin
    MessageDlg(GetArabicText('MSG_PASSWORD_WRONG'), mtError, [mbOK], 0);
    edtPassword.Clear;
    edtPassword.SetFocus;
  end;
end;

procedure TfrmLogin.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLogin.edtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // زر Enter
  begin
    btnLoginClick(Sender);
    Key := #0;
  end;
end;

end.


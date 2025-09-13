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
    function ShowArabicMessage(const AText, ACaption: string;
      DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
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
    ShowArabicMessage(GetArabicText('MSG_PASSWORD_EMPTY'), 
      GetArabicText('SYSTEM_TITLE'), mtWarning, [mbOK]);
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
    ShowArabicMessage(GetArabicText('MSG_PASSWORD_WRONG'), 
      GetArabicText('SYSTEM_TITLE'), mtError, [mbOK]);
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

function TfrmLogin.ShowArabicMessage(const AText, ACaption: string;
  DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
var
  MsgForm: TForm;
  MsgLabel: TLabel;
  ButtonPanel: TPanel;
  OKButton, YesButton, NoButton, CancelButton: TButton;
  ButtonWidth, ButtonLeft: Integer;
begin
  MsgForm := TForm.Create(nil);
  try
    MsgForm.Caption := ACaption;
    MsgForm.BiDiMode := bdRightToLeft;
    MsgForm.Position := poScreenCenter;
    MsgForm.BorderStyle := bsDialog;
    MsgForm.Width := 400;
    MsgForm.Height := 200;
    
    // إنشاء التسمية للنص
    MsgLabel := TLabel.Create(MsgForm);
    MsgLabel.Parent := MsgForm;
    MsgLabel.Caption := AText;
    MsgLabel.BiDiMode := bdRightToLeft;
    MsgLabel.Font.Name := 'Arial';
    MsgLabel.Font.Size := 11;
    MsgLabel.WordWrap := True;
    MsgLabel.Left := 20;
    MsgLabel.Top := 40;
    MsgLabel.Width := 340;
    MsgLabel.Height := 60;
    MsgLabel.Alignment := taRightJustify;
    
    // لوحة الأزرار
    ButtonPanel := TPanel.Create(MsgForm);
    ButtonPanel.Parent := MsgForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 50;
    ButtonPanel.BevelOuter := bvNone;
    
    ButtonWidth := 75;
    ButtonLeft := MsgForm.Width - 100;
    
    // إنشاء الأزرار حسب الحاجة
    if mbOK in Buttons then
    begin
      OKButton := TButton.Create(MsgForm);
      OKButton.Parent := ButtonPanel;
      OKButton.Caption := 'موافق';
      OKButton.ModalResult := mrOk;
      OKButton.Width := ButtonWidth;
      OKButton.Left := ButtonLeft;
      OKButton.Top := 10;
      ButtonLeft := ButtonLeft - ButtonWidth - 10;
    end;
    
    if mbYes in Buttons then
    begin
      YesButton := TButton.Create(MsgForm);
      YesButton.Parent := ButtonPanel;
      YesButton.Caption := 'نعم';
      YesButton.ModalResult := mrYes;
      YesButton.Width := ButtonWidth;
      YesButton.Left := ButtonLeft;
      YesButton.Top := 10;
      ButtonLeft := ButtonLeft - ButtonWidth - 10;
    end;
    
    if mbNo in Buttons then
    begin
      NoButton := TButton.Create(MsgForm);
      NoButton.Parent := ButtonPanel;
      NoButton.Caption := 'لا';
      NoButton.ModalResult := mrNo;
      NoButton.Width := ButtonWidth;
      NoButton.Left := ButtonLeft;
      NoButton.Top := 10;
      ButtonLeft := ButtonLeft - ButtonWidth - 10;
    end;
    
    if mbCancel in Buttons then
    begin
      CancelButton := TButton.Create(MsgForm);
      CancelButton.Parent := ButtonPanel;
      CancelButton.Caption := 'إلغاء';
      CancelButton.ModalResult := mrCancel;
      CancelButton.Width := ButtonWidth;
      CancelButton.Left := ButtonLeft;
      CancelButton.Top := 10;
    end;
    
    Result := MsgForm.ShowModal;
  finally
    MsgForm.Free;
  end;
end;

end.


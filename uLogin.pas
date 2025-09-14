unit uLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TfrmLogin = class(TForm)
    pnlMain: TPanel;
    lblTitle: TLabel;
    lblPassword: TLabel;
    edtPassword: TEdit;
    btnLogin: TButton;
    btnExit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure edtPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    function ShowArabicMessage(const AText, ACaption: string;
      DlgType: TMsgDlgType; Buttons: TMsgDlgButtons): Integer;
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
  // Basic Form Settings
  BiDiMode := bdRightToLeft;
  Position := poScreenCenter;
  Caption := 'نظام إدارة قطع الغيار - تسجيل الدخول';

  // Setup Arabic text
  lblTitle.Caption := 'نظام إدارة المخازن - الجيش المصري';
  lblPassword.Caption := 'كلمة المرور:';
  btnLogin.Caption := 'دخول';
  btnExit.Caption := 'خروج';

  // Focus on password field
  edtPassword.SetFocus;
end;


procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if Trim(edtPassword.Text) = '' then
  begin
    ShowArabicMessage('يرجى إدخال كلمة المرور',
      'تسجيل الدخول', mtWarning, [mbOK]);
    edtPassword.SetFocus;
    Exit;
  end;

  if DBManager.CheckPassword(edtPassword.Text) then
  begin
    ShowArabicMessage('مرحباً بك في النظام',
      'تسجيل دخول ناجح', mtInformation, [mbOK]);

    Application.CreateForm(TfrmMain, frmMain);
    frmMain.Show;
    Hide;
  end
  else
  begin
    ShowArabicMessage('كلمة المرور غير صحيحة',
      'خطأ في تسجيل الدخول', mtError, [mbOK]);
    edtPassword.Clear;
    edtPassword.SetFocus;
  end;
end;

procedure TfrmLogin.btnExitClick(Sender: TObject);
begin
  if ShowArabicMessage('هل تريد الخروج من النظام؟',
    'تأكيد الخروج', mtConfirmation, [mbYes, mbNo]) = mrYes then
    Application.Terminate;
end;

procedure TfrmLogin.edtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // Enter key
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
  IconPanel: TPanel;
  IconLabel: TLabel;
  OKButton, YesButton, NoButton, CancelButton: TButton;
  ButtonWidth, ButtonLeft: Integer;
begin
  MsgForm := TForm.Create(nil);
  try
    MsgForm.Caption := ACaption;
    MsgForm.BiDiMode := bdRightToLeft;
    MsgForm.Position := poScreenCenter;
    MsgForm.BorderStyle := bsDialog;
    MsgForm.Width := 450;
    MsgForm.Height := 220;
    MsgForm.Color := clWhite;
    MsgForm.Font.Name := 'Arial';

    // Icon panel for message type
    IconPanel := TPanel.Create(MsgForm);
    IconPanel.Parent := MsgForm;
    IconPanel.Left := 20;
    IconPanel.Top := 20;
    IconPanel.Width := 60;
    IconPanel.Height := 60;
    IconPanel.BevelOuter := bvNone;

    IconLabel := TLabel.Create(MsgForm);
    IconLabel.Parent := IconPanel;
    IconLabel.Font.Size := 24;
    IconLabel.Font.Style := [fsBold];
    IconLabel.Align := alClient;
    IconLabel.Alignment := taCenter;
    IconLabel.Layout := tlCenter;

    case DlgType of
      mtInformation:
      begin
        IconLabel.Caption := 'ℹ';
        IconLabel.Font.Color := $1F7A1F; // Green
        IconPanel.Color := $F0FFF0;
      end;
      mtWarning:
      begin
        IconLabel.Caption := '⚠';
        IconLabel.Font.Color := $FF8C00; // Orange
        IconPanel.Color := $FFF8DC;
      end;
      mtError:
      begin
        IconLabel.Caption := '✕';
        IconLabel.Font.Color := $DC143C; // Red
        IconPanel.Color := $FFE4E1;
      end;
      mtConfirmation:
      begin
        IconLabel.Caption := '?';
        IconLabel.Font.Color := $4169E1; // Blue
        IconPanel.Color := $F0F8FF;
      end;
    end;

    // Message label
    MsgLabel := TLabel.Create(MsgForm);
    MsgLabel.Parent := MsgForm;
    MsgLabel.Caption := AText;
    MsgLabel.BiDiMode := bdRightToLeft;
    MsgLabel.Font.Name := 'Arial';
    MsgLabel.Font.Size := 11;
    MsgLabel.WordWrap := True;
    MsgLabel.Left := 100;
    MsgLabel.Top := 30;
    MsgLabel.Width := 320;
    MsgLabel.Height := 80;
    MsgLabel.Alignment := taRightJustify;

    // Button panel
    ButtonPanel := TPanel.Create(MsgForm);
    ButtonPanel.Parent := MsgForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 60;
    ButtonPanel.BevelOuter := bvNone;
    ButtonPanel.Color := $F8F8F8;

    ButtonWidth := 80;
    ButtonLeft := MsgForm.Width - 100;

    // Create buttons
    if mbOK in Buttons then
    begin
      OKButton := TButton.Create(MsgForm);
      OKButton.Parent := ButtonPanel;
      OKButton.Caption := 'موافق';
      OKButton.ModalResult := mrOk;
      OKButton.Width := ButtonWidth;
      OKButton.Left := ButtonLeft;
      OKButton.Top := 15;
      OKButton.Height := 30;
      OKButton.Font.Style := [fsBold];
      OKButton.Font.Color := clWhite;
      ButtonLeft := ButtonLeft - ButtonWidth - 15;
    end;

    if mbYes in Buttons then
    begin
      YesButton := TButton.Create(MsgForm);
      YesButton.Parent := ButtonPanel;
      YesButton.Caption := 'نعم';
      YesButton.ModalResult := mrYes;
      YesButton.Width := ButtonWidth;
      YesButton.Left := ButtonLeft;
      YesButton.Top := 15;
      YesButton.Height := 30;
      YesButton.Font.Style := [fsBold];
      YesButton.Font.Color := clWhite;
      ButtonLeft := ButtonLeft - ButtonWidth - 15;
    end;

    if mbNo in Buttons then
    begin
      NoButton := TButton.Create(MsgForm);
      NoButton.Parent := ButtonPanel;
      NoButton.Caption := 'لا';
      NoButton.ModalResult := mrNo;
      NoButton.Width := ButtonWidth;
      NoButton.Left := ButtonLeft;
      NoButton.Top := 15;
      NoButton.Height := 30;
      NoButton.Font.Style := [fsBold];
      NoButton.Font.Color := clWhite;
      ButtonLeft := ButtonLeft - ButtonWidth - 15;
    end;

    if mbCancel in Buttons then
    begin
      CancelButton := TButton.Create(MsgForm);
      CancelButton.Parent := ButtonPanel;
      CancelButton.Caption := 'إلغاء';
      CancelButton.ModalResult := mrCancel;
      CancelButton.Width := ButtonWidth;
      CancelButton.Left := ButtonLeft;
      CancelButton.Top := 15;
      CancelButton.Height := 30;
      CancelButton.Font.Style := [fsBold];
      CancelButton.Font.Color := clWhite;
    end;

    Result := MsgForm.ShowModal;
  finally
    MsgForm.Free;
  end;
end;

end.

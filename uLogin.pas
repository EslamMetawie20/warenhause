unit uLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmLogin = class(TForm)
    // Components from DFM file
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
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    // Dynamically created components
    pnlHeader: TPanel;
    pnlContent: TPanel;
    pnlFooter: TPanel;
    pnlLoginBox: TPanel;
    imgArmedForces: TImage;  // شعار القوات المسلحة
    imgEgyptFlag: TImage;    // علم مصر
    lblSystemTitle: TLabel;
    lblDateTime: TLabel;
    lblCopyright: TLabel;
    procedure SetupUI;
    procedure SetupColors;
    procedure SetupFonts;
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
  // Basic Form Settings - نفس uMain
  BiDiMode := bdRightToLeft;
  Position := poScreenCenter;
  WindowState := wsNormal;  // Changed from wsMaximized to work with login form

  SetupUI;
  SetupColors;
  SetupFonts;

  // إعداد النصوص
  Caption := 'تسجيل الدخول - نظام إدارة المخازن';
  if Assigned(lblSystemTitle) then
    lblSystemTitle.Caption := 'القوات المسلحة المصرية';
  if Assigned(lblDateTime) then
    lblDateTime.Caption := FormatDateTime('dddd، dd mmmm yyyy - hh:nn:ss', Now);
  if Assigned(lblTitle) then
    lblTitle.Caption := 'تسجيل الدخول للنظام';
  if Assigned(lblPassword) then
    lblPassword.Caption := 'كلمة المرور:';
  if Assigned(btnLogin) then
    btnLogin.Caption := 'دخول';
  if Assigned(btnExit) then
    btnExit.Caption := 'إلغاء';
  if Assigned(lblCopyright) then
    lblCopyright.Caption := '© 2025 القوات المسلحة المصرية - جميع الحقوق محفوظة';
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  if Assigned(edtPassword) then
    edtPassword.SetFocus;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmLogin.SetupUI;
begin
  // Create dynamic panels for additional layout
  pnlHeader := TPanel.Create(Self);
  pnlHeader.Parent := Self;
  pnlHeader.Align := alTop;
  pnlHeader.Height := 100;  // زود الارتفاع عشان يستوعب النص والصور
  pnlHeader.BevelOuter := bvNone;

  pnlContent := TPanel.Create(Self);
  pnlContent.Parent := Self;
  pnlContent.Align := alClient;
  pnlContent.BevelOuter := bvNone;

  pnlFooter := TPanel.Create(Self);
  pnlFooter.Parent := Self;
  pnlFooter.Align := alBottom;
  pnlFooter.Height := 25;
  pnlFooter.BevelOuter := bvNone;

  // إضافة شعار القوات المسلحة المصرية
  imgArmedForces := TImage.Create(Self);
  imgArmedForces.Parent := pnlHeader;
  imgArmedForces.Left := 20;
  imgArmedForces.Top := 20;  // أعلى شوية
  imgArmedForces.Width := 60;
  imgArmedForces.Height := 60;
  imgArmedForces.Proportional := True;
  imgArmedForces.Stretch := True;
  imgArmedForces.Center := True;
  // تحميل شعار القوات المسلحة
  try
    imgArmedForces.Picture.LoadFromFile('C:\MEEEEH\berawy\Resources\ArmedForces.png');
  except
    // إذا لم توجد الصورة، لا نفعل شيء
  end;

  // إضافة علم مصر
  imgEgyptFlag := TImage.Create(Self);
  imgEgyptFlag.Parent := pnlHeader;
  imgEgyptFlag.Left := ClientWidth - 80;
  imgEgyptFlag.Top := 20;  // نفس ارتفاع الشعار
  imgEgyptFlag.Width := 60;
  imgEgyptFlag.Height := 60;
  imgEgyptFlag.Proportional := True;
  imgEgyptFlag.Stretch := True;
  imgEgyptFlag.Center := True;
  imgEgyptFlag.Anchors := [akTop, akRight];
  // تحميل علم مصر
  try
    imgEgyptFlag.Picture.LoadFromFile('C:\MEEEEH\berawy\Resources\egypt.png');
  except
    // إذا لم توجد الصورة، لا نفعل شيء
  end;

  // Header Components - النص في الوسط الفعلي، بعيد عن الصور
  lblSystemTitle := TLabel.Create(Self);
  lblSystemTitle.Parent := pnlHeader;
  lblSystemTitle.Left := 150;  // بداية بعد الشعار بمسافة أكبر
  lblSystemTitle.Top := 25;
  lblSystemTitle.Width := ClientWidth - 300;  // عرض أصغر عشان ميروحش على العلم
  lblSystemTitle.Height := 30;
  lblSystemTitle.Alignment := taCenter;

  lblDateTime := TLabel.Create(Self);
  lblDateTime.Parent := pnlHeader;
  lblDateTime.Left := 150;  // نفس مكان النص الرئيسي
  lblDateTime.Top := 60;    // تحت العنوان الرئيسي
  lblDateTime.Width := ClientWidth - 300;  // نفس العرض
  lblDateTime.Height := 20;
  lblDateTime.Alignment := taCenter;

  // Move existing pnlMain to content area
  if Assigned(pnlMain) then
  begin
    pnlMain.Parent := pnlContent;
    pnlMain.Align := alNone;
    pnlMain.Width := 400;
    pnlMain.Height := 250;
    pnlMain.Left := (pnlContent.Width - 400) div 2;
    pnlMain.Top := (pnlContent.Height - 250) div 2;
  end;

  // Footer Components
  lblCopyright := TLabel.Create(Self);
  lblCopyright.Parent := pnlFooter;
  lblCopyright.Left := 50;
  lblCopyright.Top := 5;
  lblCopyright.Width := 500;
  lblCopyright.Height := 15;
  lblCopyright.Alignment := taLeftJustify;
end;

procedure TfrmLogin.SetupColors;
begin
  // Color Scheme: Egyptian Military Theme - ألوان احترافية محسنة
  Color := $F0F0F0; // رمادي فاتح جداً للخلفية

  // Header - ألوان عسكرية فخمة
  pnlHeader.Color := $1A1A1A; // أسود داكن بدلاً من البني

  // Content - لون متناسق
  pnlContent.Color := $F0F0F0;

  // Login Box - صندوق أبيض نظيف مع حدود
  if Assigned(pnlMain) then
  begin
    pnlMain.Color := clWhite;
    pnlMain.BevelOuter := bvRaised;
    pnlMain.BevelKind := bkFlat;
    pnlMain.BorderWidth := 2;
  end;

  // Footer - لون متدرج
  pnlFooter.Color := $D0D0D0;

  // Input field - أبيض مع حدود واضحة
  if Assigned(edtPassword) then
  begin
    edtPassword.Color := clWhite;
    edtPassword.BorderStyle := bsSingle;
  end;
end;

procedure TfrmLogin.SetupFonts;
begin
  // نظام خطوط احترافي محسن

  // System Title - عنوان فخم وواضح
  lblSystemTitle.Font.Name := 'Arial';
  lblSystemTitle.Font.Size := 16;  // حجم أكبر
  lblSystemTitle.Font.Style := [fsBold];
  lblSystemTitle.Font.Color := $556B2F; // ذهبي فاخر بدلاً من الأبيض

  // DateTime - لون واضح ومقروء
  lblDateTime.Font.Name := 'Arial';
  lblDateTime.Font.Size := 10;  // حجم أكبر قليلاً
  lblDateTime.Font.Color := $C0C0C0; // فضي فاتح بدلاً من السيلفر الداكن

  // Login Title - عنوان مميز
  lblTitle.Font.Name := 'Arial';
  lblTitle.Font.Size := 14;  // حجم أكبر
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Color := $8B4513; // بني محروق أنيق

  // Labels and Buttons - خط عام محسن
  Font.Name := 'Arial';
  Font.Size := 10;

  // Password Label - واضح ومقروء
  lblPassword.Font.Name := 'Arial';
  lblPassword.Font.Size := 11;  // حجم أكبر
  lblPassword.Font.Style := [fsBold];
  lblPassword.Font.Color := $2F4F4F; // رمادي داكن بدلاً من الأسود الصارخ

  // Password Field - خط واضح
  edtPassword.Font.Name := 'Arial';
  edtPassword.Font.Size := 12;  // حجم أكبر للقراءة السهلة

  // Buttons - أزرار واضحة ومقروءة
  btnLogin.Font.Name := 'Arial';
  btnLogin.Font.Size := 11;  // حجم أكبر
  btnLogin.Font.Style := [fsBold];

  btnExit.Font.Name := 'Arial';
  btnExit.Font.Size := 11;  // حجم أكبر
  btnExit.Font.Style := [fsBold];

  // Footer - واضح ومقروء
  lblCopyright.Font.Name := 'Arial';
  lblCopyright.Font.Size := 9;
  lblCopyright.Font.Color := $696969; // رمادي متوسط مقروء

  // Button fonts are set in DFM - نفس تعليق uMain
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if not Assigned(edtPassword) then Exit;

  if Trim(edtPassword.Text) = '' then
  begin
    ShowArabicMessage('يرجى إدخال كلمة المرور',
      'نظام الأمان', mtWarning, [mbOK]);
    edtPassword.SetFocus;
    Exit;
  end;

  if DBManager.CheckPassword(edtPassword.Text) then
  begin
    ModalResult := mrOK;
  end
  else
  begin
    ShowArabicMessage('كلمة المرور غير صحيحة',
      'خطأ في التحقق', mtError, [mbOK]);
    edtPassword.Clear;
    edtPassword.SetFocus;
  end;
end;

procedure TfrmLogin.btnExitClick(Sender: TObject);
begin
  if ShowArabicMessage('هل تريد إغلاق البرنامج؟',
    'تأكيد الخروج', mtConfirmation, [mbYes, mbNo]) = mrYes then
    Application.Terminate;
end;

procedure TfrmLogin.edtPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
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
  // نفس طريقة ShowArabicMessage في uMain تماماً
  MsgForm := TForm.Create(nil);
  try
    MsgForm.Caption := ACaption;
    MsgForm.BiDiMode := bdRightToLeft;
    MsgForm.Position := poScreenCenter;
    MsgForm.BorderStyle := bsDialog;
    MsgForm.Width := 400;
    MsgForm.Height := 200;
    MsgForm.Color := clWhite;

    // Message label
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

    // Button panel
    ButtonPanel := TPanel.Create(MsgForm);
    ButtonPanel.Parent := MsgForm;
    ButtonPanel.Align := alBottom;
    ButtonPanel.Height := 50;
    ButtonPanel.BevelOuter := bvNone;
    ButtonPanel.Color := $F0F0F0;

    ButtonWidth := 75;
    ButtonLeft := MsgForm.Width - 100;

    // Create buttons based on requirements
    if mbOK in Buttons then
    begin
      OKButton := TButton.Create(MsgForm);
      OKButton.Parent := ButtonPanel;
      OKButton.Caption := 'موافق';
      OKButton.ModalResult := mrOk;
      OKButton.Width := ButtonWidth;
      OKButton.Left := ButtonLeft;
      OKButton.Top := 10;
      OKButton.Font.Style := [fsBold];
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
      YesButton.Font.Style := [fsBold];
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
      NoButton.Font.Style := [fsBold];
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
      CancelButton.Font.Style := [fsBold];
    end;

    Result := MsgForm.ShowModal;
  finally
    MsgForm.Free;
  end;
end;

end.

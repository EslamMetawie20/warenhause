program WarehouseSystem;

uses
  Vcl.Forms,
  uLogin in 'uLogin.pas' {frmLogin},
  uMain in 'uMain.pas' {frmMain},
  uAddItem in 'uAddItem.pas' {frmAddItem},
  uDatabase in 'uDatabase.pas',
  uReceipt in 'uReceipt.pas',
  uArabicTexts in 'uArabicTexts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'نظام إدارة المخازن';
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
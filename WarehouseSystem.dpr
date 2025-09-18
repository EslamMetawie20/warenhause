program WarehouseSystem;

uses
  System.UITypes,
  Vcl.Forms,
  Vcl.Dialogs,
  uLogin in 'uLogin.pas',
  uMain in 'uMain.pas',
  uAddItem in 'uAddItem.pas',
  uDatabase in 'uDatabase.pas',
  uReceipt in 'uReceipt.pas',
  uArabicTexts in 'uArabicTexts.pas',
  uCart in 'uCart.pas',
  uCartForm in 'uCartForm.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Warehouse Management System';

  Application.CreateForm(TfrmLogin, frmLogin);
  if frmLogin.ShowModal = mrOK then
  begin
    frmLogin.Free;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  end;

end.
unit uDatabase;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, uArabicTexts;

type
  TSparePartItem = record
    ItemID: string[50];
    ItemName: string[100];
    Quantity: Integer;
    Location: string[100];
    Price: Currency;
  end;

  TDatabaseManager = class
  private
    FDataFile: string;
    FItems: TList;
    FPassword: string;
    procedure LoadData;
    procedure SaveData;
  public
    constructor Create;
    destructor Destroy; override;
    function CheckPassword(const APassword: string): Boolean;
    function FindItem(const ItemID: string): TSparePartItem;
    function WithdrawItem(const ItemID: string; Quantity: Integer): Boolean;
    function AddNewItem(const ItemID, ItemName, Location: string;
      Quantity: Integer; Price: Currency): Boolean;
    function GetItemDetails(const ItemID: string; var ItemName, Location: string;
      var AvailableQty: Integer; var Price: Currency): Boolean;
    function GetAllItems: TList;
  end;

var
  DBManager: TDatabaseManager;

implementation

type
  PSparePartItem = ^TSparePartItem;

{ TDatabaseManager }

constructor TDatabaseManager.Create;
begin
  inherited;
  FDataFile := ExtractFilePath(ParamStr(0)) + 'warehouse.dat';
  FPassword := APP_PASSWORD;
  FItems := TList.Create;
  LoadData;
end;

destructor TDatabaseManager.Destroy;
var
  I: Integer;
begin
  SaveData;
  for I := 0 to FItems.Count - 1 do
    Dispose(PSparePartItem(FItems[I]));
  FItems.Free;
  inherited;
end;

procedure TDatabaseManager.LoadData;
var
  FileStream: TFileStream;
  Item: PSparePartItem;
  Count, I: Integer;
begin
  if not FileExists(FDataFile) then
  begin
    // بيانات تجريبية بالعربية
    AddNewItem('001', 'بطارية 12 فولت', 'المخزن الرئيسي أ1', 50, 250.00);
    AddNewItem('002', 'فلتر هواء', 'المخزن الرئيسي أ2', 30, 150.00);
    AddNewItem('003', 'زيت محرك', 'المخزن ب1', 100, 85.00);
    AddNewItem('004', 'إطار احتياطي', 'المخزن ج1', 20, 800.00);
    AddNewItem('005', 'مفتاح 19 مم', 'خزانة الأدوات', 15, 45.00);
    SaveData;
    Exit;
  end;

  try
    FileStream := TFileStream.Create(FDataFile, fmOpenRead);
    try
      FileStream.Read(Count, SizeOf(Integer));
      for I := 0 to Count - 1 do
      begin
        New(Item);
        FileStream.Read(Item^, SizeOf(TSparePartItem));
        FItems.Add(Item);
      end;
    finally
      FileStream.Free;
    end;
  except
    // في حالة فشل القراءة
  end;
end;

procedure TDatabaseManager.SaveData;
var
  FileStream: TFileStream;
  Count, I: Integer;
  Item: PSparePartItem;
begin
  try
    FileStream := TFileStream.Create(FDataFile, fmCreate);
    try
      Count := FItems.Count;
      FileStream.Write(Count, SizeOf(Integer));
      for I := 0 to FItems.Count - 1 do
      begin
        Item := PSparePartItem(FItems[I]);
        FileStream.Write(Item^, SizeOf(TSparePartItem));
      end;
    finally
      FileStream.Free;
    end;
  except
    // في حالة فشل الحفظ
  end;
end;

function TDatabaseManager.CheckPassword(const APassword: string): Boolean;
begin
  Result := APassword = FPassword;
end;

function TDatabaseManager.FindItem(const ItemID: string): TSparePartItem;
var
  I: Integer;
  Item: PSparePartItem;
begin
  Result.ItemID := '';
  for I := 0 to FItems.Count - 1 do
  begin
    Item := PSparePartItem(FItems[I]);
    if Item^.ItemID = ItemID then
    begin
      Result := Item^;
      Exit;
    end;
  end;
end;

function TDatabaseManager.WithdrawItem(const ItemID: string; Quantity: Integer): Boolean;
var
  I: Integer;
  Item: PSparePartItem;
begin
  Result := False;
  for I := 0 to FItems.Count - 1 do
  begin
    Item := PSparePartItem(FItems[I]);
    if Item^.ItemID = ItemID then
    begin
      if Item^.Quantity >= Quantity then
      begin
        Item^.Quantity := Item^.Quantity - Quantity;
        SaveData;
        Result := True;
      end;
      Exit;
    end;
  end;
end;

function TDatabaseManager.AddNewItem(const ItemID, ItemName, Location: string;
  Quantity: Integer; Price: Currency): Boolean;
var
  Item: PSparePartItem;
  I: Integer;
begin
  // التحقق من عدم وجود القطعة
  for I := 0 to FItems.Count - 1 do
  begin
    if PSparePartItem(FItems[I])^.ItemID = ItemID then
    begin
      Result := False;
      Exit;
    end;
  end;

  New(Item);
  Item^.ItemID := ItemID;
  Item^.ItemName := ItemName;
  Item^.Location := Location;
  Item^.Quantity := Quantity;
  Item^.Price := Price;
  FItems.Add(Item);
  SaveData;
  Result := True;
end;

function TDatabaseManager.GetItemDetails(const ItemID: string; var ItemName, Location: string;
  var AvailableQty: Integer; var Price: Currency): Boolean;
var
  Item: TSparePartItem;
begin
  Item := FindItem(ItemID);
  Result := Item.ItemID <> '';
  if Result then
  begin
    ItemName := Item.ItemName;
    Location := Item.Location;
    AvailableQty := Item.Quantity;
    Price := Item.Price;
  end;
end;

function TDatabaseManager.GetAllItems: TList;
begin
  Result := FItems;
end;

initialization
  DBManager := TDatabaseManager.Create;

finalization
  DBManager.Free;

end.


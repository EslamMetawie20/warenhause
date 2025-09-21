unit uDatabase;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, uArabicTexts;

type
  TSparePartItem = record
    ItemID: string;
    ItemName: string;
    Quantity: Integer;
    Location: string;
    Price: Currency;
  end;

  TDatabaseManager = class
  private
    FDataFile: string;
    FItems: TList;
    FPassword: string;
    FNextID: Integer;
    procedure LoadData;
    procedure SaveData;
    procedure CleanupZeroQuantityItems;
    function GenerateNextID: string;
  public
    constructor Create;
    destructor Destroy; override;
    function CheckPassword(const APassword: string): Boolean;
    function FindItem(const ItemID: string): TSparePartItem;
    function WithdrawItem(const ItemID: string; Quantity: Integer): Boolean;
    function AddNewItem(const ItemName, Location: string;
      Quantity: Integer; Price: Currency): string;
    function AddNewItemWithID(const ItemID, ItemName, Location: string;
      Quantity: Integer; Price: Currency): string;
    function ItemIDExists(const ItemID: string): Boolean;
    function UpdateItem(const ItemID, ItemName, Location: string;
      Quantity: Integer; Price: Currency): Boolean;
    function DeleteItem(const ItemID: string): Boolean;
    function GetItemDetails(const ItemID: string; var ItemName, Location: string;
      var AvailableQty: Integer; var Price: Currency): Boolean;
    function GetAllItems: TList;
    function GetNextID: string;
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
  FNextID := 1;
  LoadData;
  CleanupZeroQuantityItems;
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
  Reader: TBinaryReader;
  Item: PSparePartItem;
  Count, I, MaxID: Integer;
begin
  if not FileExists(FDataFile) then
  begin
    // Start with empty database - user can add items
    FNextID := 1;
    Exit;
  end;

  try
    FileStream := TFileStream.Create(FDataFile, fmOpenRead);
    Reader := TBinaryReader.Create(FileStream, TEncoding.UTF8);
    try
      FNextID := Reader.ReadInteger;
      Count := Reader.ReadInteger;
      MaxID := 0;

      for I := 0 to Count - 1 do
      begin
        New(Item);
        Item^.ItemID := Reader.ReadString;
        Item^.ItemName := Reader.ReadString;
        Item^.Quantity := Reader.ReadInteger;
        Item^.Location := Reader.ReadString;
        Item^.Price := Reader.ReadDouble;
        FItems.Add(Item);

        // تتبع أعلى رقم ID
        if StrToIntDef(Item^.ItemID, 0) > MaxID then
          MaxID := StrToIntDef(Item^.ItemID, 0);
      end;

      // التأكد من أن NextID أكبر من أعلى ID موجود
      if MaxID >= FNextID then
        FNextID := MaxID + 1;

    finally
      Reader.Free;
      FileStream.Free;
    end;
  except
    // في حالة فشل القراءة
    FNextID := 1;
  end;
end;

procedure TDatabaseManager.SaveData;
var
  FileStream: TFileStream;
  Writer: TBinaryWriter;
  Count, I: Integer;
  Item: PSparePartItem;
begin
  try
    FileStream := TFileStream.Create(FDataFile, fmCreate);
    Writer := TBinaryWriter.Create(FileStream, TEncoding.UTF8);
    try
      Writer.Write(FNextID);
      Count := FItems.Count;
      Writer.Write(Count);
      for I := 0 to FItems.Count - 1 do
      begin
        Item := PSparePartItem(FItems[I]);
        Writer.Write(Item^.ItemID);
        Writer.Write(Item^.ItemName);
        Writer.Write(Item^.Quantity);
        Writer.Write(Item^.Location);
        Writer.Write(Item^.Price);
      end;
    finally
      Writer.Free;
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
        // إذا وصلت الكمية إلى صفر، احذف العنصر من قاعدة البيانات
        if Item^.Quantity = 0 then
        begin
          Dispose(Item);
          FItems.Delete(I);
        end;
        SaveData;
        Result := True;
      end;
      Exit;
    end;
  end;
end;

function TDatabaseManager.GenerateNextID: string;
begin
  Result := IntToStr(FNextID);
  Inc(FNextID);
end;

function TDatabaseManager.GetNextID: string;
begin
  Result := IntToStr(FNextID);
end;

function TDatabaseManager.AddNewItem(const ItemName, Location: string;
  Quantity: Integer; Price: Currency): string;
var
  Item: PSparePartItem;
begin
  New(Item);
  Item^.ItemID := GenerateNextID;
  Item^.ItemName := ItemName;
  Item^.Location := Location;
  Item^.Quantity := Quantity;
  Item^.Price := Price;
  FItems.Add(Item);
  SaveData;
  Result := Item^.ItemID;
end;

function TDatabaseManager.AddNewItemWithID(const ItemID, ItemName, Location: string;
  Quantity: Integer; Price: Currency): string;
var
  Item: PSparePartItem;
begin
  // التحقق من وجود الرقم مسبقاً
  if ItemIDExists(ItemID) then
  begin
    Result := '';
    Exit;
  end;

  New(Item);
  Item^.ItemID := ItemID;
  Item^.ItemName := ItemName;
  Item^.Location := Location;
  Item^.Quantity := Quantity;
  Item^.Price := Price;
  FItems.Add(Item);
  SaveData;
  Result := Item^.ItemID;
end;

function TDatabaseManager.ItemIDExists(const ItemID: string): Boolean;
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
      Result := True;
      Exit;
    end;
  end;
end;

function TDatabaseManager.UpdateItem(const ItemID, ItemName, Location: string;
  Quantity: Integer; Price: Currency): Boolean;
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
      Item^.ItemName := ItemName;
      Item^.Location := Location;
      Item^.Quantity := Quantity;
      Item^.Price := Price;
      SaveData;
      Result := True;
      Exit;
    end;
  end;
end;

function TDatabaseManager.DeleteItem(const ItemID: string): Boolean;
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
      Dispose(Item);
      FItems.Delete(I);
      SaveData;
      Result := True;
      Exit;
    end;
  end;
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

procedure TDatabaseManager.CleanupZeroQuantityItems;
var
  I, MaxID: Integer;
  Item: PSparePartItem;
  NeedsSave: Boolean;
begin
  NeedsSave := False;
  I := 0;
  while I < FItems.Count do
  begin
    Item := PSparePartItem(FItems[I]);
    if Item^.Quantity <= 0 then
    begin
      Dispose(Item);
      FItems.Delete(I);
      NeedsSave := True;
    end
    else
      Inc(I);
  end;

  // إعادة حساب NextID بناء على أعلى رقم موجود
  if FItems.Count > 0 then
  begin
    MaxID := 0;
    for I := 0 to FItems.Count - 1 do
    begin
      Item := PSparePartItem(FItems[I]);
      if StrToIntDef(Item^.ItemID, 0) > MaxID then
        MaxID := StrToIntDef(Item^.ItemID, 0);
    end;
    FNextID := MaxID + 1;
  end
  else
    FNextID := 1;

  if NeedsSave then
    SaveData;
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


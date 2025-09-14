unit uCart;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uDatabase;

type
  // Warenkorb-Item Struktur
  TCartItem = record
    ItemID: string;
    ItemName: string;
    RequestedQty: Integer;
    AvailableQty: Integer;
    Location: string;
    Price: Currency;
    TotalPrice: Currency;
  end;

  // Warenkorb-Manager Klasse
  TCartManager = class
  private
    FCartItems: TList<TCartItem>;
    FOnCartChanged: TNotifyEvent;
    function FindCartItemIndex(const ItemID: string): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    // Warenkorb-Operationen
    function AddItem(const ItemID: string; Quantity: Integer): Boolean;
    function UpdateItemQuantity(const ItemID: string; NewQuantity: Integer): Boolean;
    function RemoveItem(const ItemID: string): Boolean;
    procedure ClearCart;

    // Getter-Methoden
    function GetCartItems: TList<TCartItem>;
    function GetItemCount: Integer;
    function GetTotalItems: Integer;
    function GetTotalValue: Currency;
    function IsEmpty: Boolean;
    function HasItem(const ItemID: string): Boolean;
    function GetItemQuantity(const ItemID: string): Integer;

    // Checkout-Operationen
    function ValidateCart(var ErrorMessage: string): Boolean;
    function ProcessCheckout(var Receipt: string): Boolean;

    // Events
    property OnCartChanged: TNotifyEvent read FOnCartChanged write FOnCartChanged;
  end;

var
  CartManager: TCartManager;

implementation

{ TCartManager }

constructor TCartManager.Create;
begin
  inherited Create;
  FCartItems := TList<TCartItem>.Create;
end;

destructor TCartManager.Destroy;
begin
  FCartItems.Free;
  inherited Destroy;
end;

function TCartManager.FindCartItemIndex(const ItemID: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FCartItems.Count - 1 do
  begin
    if FCartItems[I].ItemID = ItemID then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TCartManager.AddItem(const ItemID: string; Quantity: Integer): Boolean;
var
  CartItem: TCartItem;
  DBItem: TSparePartItem;
  ExistingIndex: Integer;
begin
  Result := False;

  if (Trim(ItemID) = '') or (Quantity <= 0) then
    Exit;

  // Artikel aus Datenbank holen
  DBItem := DBManager.FindItem(ItemID);
  if DBItem.ItemID = '' then
    Exit; // Artikel nicht gefunden

  // Prüfen ob genug verfügbar
  ExistingIndex := FindCartItemIndex(ItemID);
  if ExistingIndex >= 0 then
  begin
    // Artikel bereits im Warenkorb - Menge addieren
    if (FCartItems[ExistingIndex].RequestedQty + Quantity) > DBItem.Quantity then
      Exit; // Nicht genug verfügbar

    CartItem := FCartItems[ExistingIndex];
    CartItem.RequestedQty := CartItem.RequestedQty + Quantity;
    CartItem.TotalPrice := CartItem.Price * CartItem.RequestedQty;
    FCartItems[ExistingIndex] := CartItem;
  end
  else
  begin
    // Neuer Artikel
    if Quantity > DBItem.Quantity then
      Exit; // Nicht genug verfügbar

    CartItem.ItemID := DBItem.ItemID;
    CartItem.ItemName := DBItem.ItemName;
    CartItem.RequestedQty := Quantity;
    CartItem.AvailableQty := DBItem.Quantity;
    CartItem.Location := DBItem.Location;
    CartItem.Price := DBItem.Price;
    CartItem.TotalPrice := DBItem.Price * Quantity;

    FCartItems.Add(CartItem);
  end;

  Result := True;

  // Event auslösen
  if Assigned(FOnCartChanged) then
    FOnCartChanged(Self);
end;

function TCartManager.UpdateItemQuantity(const ItemID: string; NewQuantity: Integer): Boolean;
var
  Index: Integer;
  CartItem: TCartItem;
begin
  Result := False;

  if NewQuantity <= 0 then
  begin
    Result := RemoveItem(ItemID);
    Exit;
  end;

  Index := FindCartItemIndex(ItemID);
  if Index >= 0 then
  begin
    CartItem := FCartItems[Index];
    if NewQuantity <= CartItem.AvailableQty then
    begin
      CartItem.RequestedQty := NewQuantity;
      CartItem.TotalPrice := CartItem.Price * NewQuantity;
      FCartItems[Index] := CartItem;
      Result := True;

      if Assigned(FOnCartChanged) then
        FOnCartChanged(Self);
    end;
  end;
end;

function TCartManager.RemoveItem(const ItemID: string): Boolean;
var
  Index: Integer;
begin
  Result := False;
  Index := FindCartItemIndex(ItemID);
  if Index >= 0 then
  begin
    FCartItems.Delete(Index);
    Result := True;

    if Assigned(FOnCartChanged) then
      FOnCartChanged(Self);
  end;
end;

procedure TCartManager.ClearCart;
begin
  FCartItems.Clear;

  if Assigned(FOnCartChanged) then
    FOnCartChanged(Self);
end;

function TCartManager.GetCartItems: TList<TCartItem>;
begin
  Result := FCartItems;
end;

function TCartManager.GetItemCount: Integer;
begin
  Result := FCartItems.Count;
end;

function TCartManager.GetTotalItems: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FCartItems.Count - 1 do
    Result := Result + FCartItems[I].RequestedQty;
end;

function TCartManager.GetTotalValue: Currency;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FCartItems.Count - 1 do
    Result := Result + FCartItems[I].TotalPrice;
end;

function TCartManager.IsEmpty: Boolean;
begin
  Result := FCartItems.Count = 0;
end;

function TCartManager.HasItem(const ItemID: string): Boolean;
begin
  Result := FindCartItemIndex(ItemID) >= 0;
end;

function TCartManager.GetItemQuantity(const ItemID: string): Integer;
var
  Index: Integer;
begin
  Result := 0;
  Index := FindCartItemIndex(ItemID);
  if Index >= 0 then
    Result := FCartItems[Index].RequestedQty;
end;

function TCartManager.ValidateCart(var ErrorMessage: string): Boolean;
var
  I: Integer;
  CartItem: TCartItem;
  CurrentDBItem: TSparePartItem;
begin
  Result := True;
  ErrorMessage := '';

  if IsEmpty then
  begin
    ErrorMessage := 'الواrenkorb فارغ';
    Result := False;
    Exit;
  end;

  // Verfügbarkeit aller Artikel erneut prüfen
  for I := 0 to FCartItems.Count - 1 do
  begin
    CartItem := FCartItems[I];
    CurrentDBItem := DBManager.FindItem(CartItem.ItemID);

    if CurrentDBItem.ItemID = '' then
    begin
      ErrorMessage := Format('الصنف %s غير موجود في قاعدة البيانات', [CartItem.ItemID]);
      Result := False;
      Exit;
    end;

    if CartItem.RequestedQty > CurrentDBItem.Quantity then
    begin
      ErrorMessage := Format('الكمية المطلوبة للصنف %s (%d) أكبر من المتاح (%d)',
        [CartItem.ItemName, CartItem.RequestedQty, CurrentDBItem.Quantity]);
      Result := False;
      Exit;
    end;
  end;
end;

function TCartManager.ProcessCheckout(var Receipt: string): Boolean;
var
  I: Integer;
  CartItem: TCartItem;
  TotalValue: Currency;
  ItemsProcessed: Integer;
begin
  Result := False;
  Receipt := '';
  ItemsProcessed := 0;

  try
    // Alle Artikel aus dem Warenkorb entnehmen
    for I := 0 to FCartItems.Count - 1 do
    begin
      CartItem := FCartItems[I];
      if DBManager.WithdrawItem(CartItem.ItemID, CartItem.RequestedQty) then
        Inc(ItemsProcessed)
      else
      begin
        // Fehler beim Entnehmen - eventuell Rollback nötig
        Receipt := Format('خطأ في سحب الصنف: %s', [CartItem.ItemName]);
        Exit;
      end;
    end;

    // Receipt erstellen
    TotalValue := GetTotalValue;
    Receipt := Format(
      'إيصال سحب قطع الغيار'#13#10 +
      '===================='#13#10 +
      'التاريخ: %s'#13#10 +
      'الوقت: %s'#13#10#13#10 +
      'الأصناف المسحوبة:'#13#10,
      [DateToStr(Now), TimeToStr(Now)]
    );

    for I := 0 to FCartItems.Count - 1 do
    begin
      CartItem := FCartItems[I];
      Receipt := Receipt + Format(
        '- %s (رقم: %s)'#13#10 +
        '  الكمية: %d'#13#10 +
        '  السعر الإجمالي: %.2f جنيه'#13#10#13#10,
        [CartItem.ItemName, CartItem.ItemID, CartItem.RequestedQty, CartItem.TotalPrice]
      );
    end;

    Receipt := Receipt + Format(
      'إجمالي القيمة: %.2f جنيه'#13#10 +
      'عدد الأصناف: %d'#13#10 +
      'إجمالي القطع: %d'#13#10#13#10 +
      '© القوات المسلحة المصرية',
      [TotalValue, GetItemCount, GetTotalItems]
    );

    // Warenkorb leeren
    ClearCart;

    Result := True;

  except
    on E: Exception do
    begin
      Receipt := Format('خطأ في عملية السحب: %s', [E.Message]);
      Result := False;
    end;
  end;
end;

initialization
  CartManager := TCartManager.Create;

finalization
  CartManager.Free;

end.
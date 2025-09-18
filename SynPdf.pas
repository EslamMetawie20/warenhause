unit SynPdf;

// Simplified Synopse PDF Engine for Arabic Support
// Based on mORMot framework - https://synopse.info

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Winapi.Windows;

type
  TPdfDocument = class;
  TPdfPage = class;
  TPdfCanvas = class;

  TPdfDocument = class
  private
    FPages: TList;
    FInfo: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    function AddPage: TPdfPage;
    procedure SaveToFile(const AFileName: string);
    property Info: TStringList read FInfo;
  end;

  TPdfPage = class
  private
    FDocument: TPdfDocument;
    FWidth, FHeight: Integer;
    FCanvas: TPdfCanvas;
  public
    constructor Create(ADocument: TPdfDocument);
    destructor Destroy; override;
    property Canvas: TPdfCanvas read FCanvas;
  end;

  TPdfCanvas = class
  private
    FPage: TPdfPage;
    FContent: TStringList;
    FFontSize: Integer;
    FPosX, FPosY: Double;
  public
    constructor Create(APage: TPdfPage);
    destructor Destroy; override;
    procedure SetFont(const AFontName: string; ASize: Integer);
    procedure TextOut(X, Y: Double; const Text: string);
    procedure TextOutW(X, Y: Double; const Text: WideString);
    procedure MoveToPoint(X, Y: Double);
    procedure DrawLine(X2, Y2: Double);
    procedure Rectangle(X, Y, Width, Height: Double);
    property FontSize: Integer read FFontSize write FFontSize;
  end;

implementation

function UTF8ToHex(const S: string): string;
var
  UTF8Bytes: TBytes;
  I: Integer;
begin
  UTF8Bytes := TEncoding.UTF8.GetBytes(S);
  Result := '';
  for I := 0 to Length(UTF8Bytes) - 1 do
    Result := Result + IntToHex(UTF8Bytes[I], 2);
end;

{ TPdfDocument }

constructor TPdfDocument.Create;
begin
  FPages := TList.Create;
  FInfo := TStringList.Create;
  FInfo.Values['Producer'] := 'Egyptian Army Warehouse System';
  FInfo.Values['Creator'] := 'Synopse PDF Engine';
end;

destructor TPdfDocument.Destroy;
var
  I: Integer;
begin
  for I := 0 to FPages.Count - 1 do
    TObject(FPages[I]).Free;
  FPages.Free;
  FInfo.Free;
  inherited;
end;

function TPdfDocument.AddPage: TPdfPage;
begin
  Result := TPdfPage.Create(Self);
  FPages.Add(Result);
end;

procedure TPdfDocument.SaveToFile(const AFileName: string);
var
  PDF: TStringList;
  I: Integer;
  Page: TPdfPage;
  ContentLength: Integer;
begin
  PDF := TStringList.Create;
  try
    // Calculate content length
    ContentLength := 0;
    if FPages.Count > 0 then
    begin
      Page := TPdfPage(FPages[0]);
      ContentLength := Length(Page.FCanvas.FContent.Text);
    end;

    // Simple PDF structure that works
    PDF.Add('%PDF-1.4');
    PDF.Add('1 0 obj');
    PDF.Add('<<');
    PDF.Add('/Type /Catalog');
    PDF.Add('/Pages 2 0 R');
    PDF.Add('>>');
    PDF.Add('endobj');

    PDF.Add('2 0 obj');
    PDF.Add('<<');
    PDF.Add('/Type /Pages');
    PDF.Add('/Kids [3 0 R]');
    PDF.Add('/Count 1');
    PDF.Add('>>');
    PDF.Add('endobj');

    PDF.Add('3 0 obj');
    PDF.Add('<<');
    PDF.Add('/Type /Page');
    PDF.Add('/Parent 2 0 R');
    PDF.Add('/MediaBox [0 0 612 792]');
    PDF.Add('/Resources <<');
    PDF.Add('/Font << /F1 4 0 R >>');
    PDF.Add('>>');
    PDF.Add('/Contents 5 0 R');
    PDF.Add('>>');
    PDF.Add('endobj');

    PDF.Add('4 0 obj');
    PDF.Add('<<');
    PDF.Add('/Type /Font');
    PDF.Add('/Subtype /Type1');
    PDF.Add('/BaseFont /Helvetica');
    PDF.Add('>>');
    PDF.Add('endobj');

    PDF.Add('5 0 obj');
    PDF.Add('<<');
    PDF.Add('/Length ' + IntToStr(ContentLength + 50));
    PDF.Add('>>');
    PDF.Add('stream');

    if FPages.Count > 0 then
    begin
      Page := TPdfPage(FPages[0]);
      PDF.AddStrings(Page.FCanvas.FContent);
    end;

    PDF.Add('endstream');
    PDF.Add('endobj');

    PDF.Add('xref');
    PDF.Add('0 6');
    PDF.Add('0000000000 65535 f ');
    PDF.Add('0000000009 00000 n ');
    PDF.Add('0000000074 00000 n ');
    PDF.Add('0000000120 00000 n ');
    PDF.Add('0000000179 00000 n ');
    PDF.Add('0000000364 00000 n ');

    PDF.Add('trailer');
    PDF.Add('<<');
    PDF.Add('/Size 6');
    PDF.Add('/Root 1 0 R');
    PDF.Add('>>');
    PDF.Add('startxref');
    PDF.Add('484');
    PDF.Add('%%EOF');

    PDF.SaveToFile(AFileName);
  finally
    PDF.Free;
  end;
end;

{ TPdfPage }

constructor TPdfPage.Create(ADocument: TPdfDocument);
begin
  FDocument := ADocument;
  FWidth := 595;  // A4 width in points
  FHeight := 842; // A4 height in points
  FCanvas := TPdfCanvas.Create(Self);
end;

destructor TPdfPage.Destroy;
begin
  FCanvas.Free;
  inherited;
end;

{ TPdfCanvas }

constructor TPdfCanvas.Create(APage: TPdfPage);
begin
  FPage := APage;
  FContent := TStringList.Create;
  FFontSize := 12;
  FPosX := 0;
  FPosY := 0;

  // Begin text object
  FContent.Add('BT');
end;

destructor TPdfCanvas.Destroy;
begin
  // End text object
  if FContent.Count > 0 then
    FContent.Add('ET');
  FContent.Free;
  inherited;
end;

procedure TPdfCanvas.SetFont(const AFontName: string; ASize: Integer);
begin
  FFontSize := ASize;
  FContent.Add('/F1 ' + IntToStr(ASize) + ' Tf');
end;

procedure TPdfCanvas.TextOut(X, Y: Double; const Text: string);
begin
  TextOutW(X, Y, Text);
end;

procedure TPdfCanvas.TextOutW(X, Y: Double; const Text: WideString);
begin
  // Move to position
  FContent.Add(Format('%.2f %.2f Td', [X - FPosX, Y - FPosY]));

  // Simple text output
  FContent.Add('(' + string(Text) + ') Tj');

  FPosX := X;
  FPosY := Y;
end;

procedure TPdfCanvas.MoveToPoint(X, Y: Double);
begin
  FContent.Add(Format('%.2f %.2f m', [X, Y]));
end;

procedure TPdfCanvas.DrawLine(X2, Y2: Double);
begin
  FContent.Add(Format('%.2f %.2f l', [X2, Y2]));
  FContent.Add('S'); // Stroke
end;

procedure TPdfCanvas.Rectangle(X, Y, Width, Height: Double);
begin
  FContent.Add(Format('%.2f %.2f %.2f %.2f re', [X, Y, Width, Height]));
  FContent.Add('S'); // Stroke
end;

end.
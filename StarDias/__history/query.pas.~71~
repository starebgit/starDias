
unit query;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Printers,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, DBTables, Grids, ExtCtrls,
  Data.Win.ADODB, Dialogs, Clipbrd, Variants;

type
  TFquery = class(TForm)
    // (these can stay even if unused)
    Query1NALOG: TStringField;
    Query1KODA: TStringField;
    Query1POTRDITEV: TStringField;
    Query1DONOS: TFloatField;
    Query1DELMESTO: TStringField;
    Query1DATUM: TDateField;
    Query1DOBA: TSmallintField;
    Query1RAZLIKA: TSmallintField;
    Query1TIP: TStringField;
    Query1SKLAD: TStringField;
    Query1TK1: TSmallintField;
    Query1TK2: TSmallintField;
    Query1TK3: TSmallintField;
    Query1PEC: TSmallintField;

    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Query1: TQuery;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;

    ADOQuery1: TADOQuery; // IMPORTANT: delete ALL persistent fields under this component in the DFM

    Panel3: TPanel;
    Tabela: TStringGrid;
    Button4: TButton;

    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure KopirajNalogeClick(Sender: TObject);
  private
    pnas: string;
    dst: TDateTime;
  public
    procedure pokazi(dat: TDateTime; ix: Integer);
  end;

var
  Fquery: TFquery;

implementation

{$R *.DFM}

procedure BuildGridColumns(Grid: TDBGrid; DS: TDataSource);
var
  i: Integer;
  F: TField;
begin
  Grid.Columns.BeginUpdate;
  try
    Grid.Columns.Clear;
    if (DS = nil) or (DS.DataSet = nil) then Exit;

    for i := 0 to DS.DataSet.FieldCount - 1 do
    begin
      F := DS.DataSet.Fields[i];
      with Grid.Columns.Add do
      begin
        FieldName := F.FieldName;
        Title.Caption := F.DisplayName;
        Width := F.DisplayWidth * 8;
      end;
    end;
  finally
    Grid.Columns.EndUpdate;
  end;
end;

function FStr(const Q: TADOQuery; const FieldName: string): string;
var
  V: Variant;
begin
  V := Q.FieldByName(FieldName).Value;
  if VarIsNull(V) or VarIsEmpty(V) then Result := '' else Result := VarToStr(V);
end;

function FDateStr(const Q: TADOQuery; const FieldName: string): string;
var
  V: Variant;
begin
  V := Q.FieldByName(FieldName).Value;
  if VarIsNull(V) or VarIsEmpty(V) then
    Result := ''
  else
    Result := DateToStr(VarToDateTime(V));
end;

function FInt(const Q: TADOQuery; const FieldName: string): Integer;
var
  V: Variant;
begin
  V := Q.FieldByName(FieldName).Value;
  if VarIsNull(V) or VarIsEmpty(V) then
    Result := 0
  else
    Result := Round(VarAsType(V, varDouble)); // works for Smallint/Integer/Float
end;

procedure TFquery.FormCreate(Sender: TObject);
begin
  // make grid use dynamic fields
  DBGrid1.Columns.Clear;
  // IMPORTANT: in the DFM/Designer, delete ADOQuery1 persistent fields!
end;

// procedura za prikaz vsebine tabele za en dan
procedure TFquery.pokazi(dat: TDateTime; ix: Integer);
var
  dr, sx, skl: string;
  sum: Integer;
  ii: Integer;

  procedure zapis;
  begin
    tabela.Cells[0, ii] := skl;
    tabela.Cells[1, ii] := IntToStr(sum);
  end;

begin
  tabela.Cells[0, 0] := 'Skladišèe';
  tabela.Cells[1, 0] := 'Seštevek';
  dst := dat;

  dr := ExtractFilePath(Application.ExeName);
  sx := ADOQuery1.ConnectionString;
  ADOQuery1.ConnectionString := sx + dr;


  ADOQuery1.SQL.Clear;
  case ix of
    2: ADOQuery1.SQL.Add(
      'Select * From stara ' +
      'Where ((doba > 1 and datum + doba = :NOD) or (doba=1 and datum + doba + 1 = :NOP)) ' +
      'and (tip = ''X'' or tip = ''U'' ) order by sklad, tip, koda');
    1: ADOQuery1.SQL.Add(
      'Select * From stara ' +
      'Where ((doba > 1 and datum + doba = :NOD) or (doba=1 and datum + doba + 1 = :NOP)) ' +
      'and (tip = ''Y'') order by sklad, tip, koda');
    3: ADOQuery1.SQL.Add(
      'Select * From stara ' +
      'Where ((doba > 1 and datum + doba = :NOD) or (doba=1 and datum + doba + 1 = :NOP)) ' +
      'order by sklad, koda');
  end;

  case ix of
    1: pnas := '100% kontrola';
    2: pnas := 'Statistièna kontrola';
    3: pnas := 'Vse';
  end;

  ADOQuery1.Close;
  ADOQuery1.Parameters.ParamByName('NOD').Value := dat;
  ADOQuery1.Parameters.ParamByName('NOP').Value := dat;
  ADOQuery1.Open;

  // rebuild DBGrid columns AFTER opening (so field list is real)
  BuildGridColumns(DBGrid1, DataSource1);

  ADOQuery1.First;
  sum := 0;
  ii := 1;
  skl := FStr(ADOQuery1, 'SKLAD');

  while not ADOQuery1.Eof do
  begin
    if skl <> FStr(ADOQuery1, 'SKLAD') then
    begin
      zapis;
      sum := 0;
      Inc(ii);
    end;

    sum := sum + FInt(ADOQuery1, 'DONOS');
    skl := FStr(ADOQuery1, 'SKLAD');
    ADOQuery1.Next;
  end;

  zapis;
  tabela.RowCount := ii + 1;

  ADOQuery1.Last;
  ShowModal;

  ADOQuery1.Close;
  ADOQuery1.ConnectionString := sx;
end;

// izpis prikazane tabele na papir
procedure TFquery.Button1Click(Sender: TObject);
var
  MojaDat: TextFile;
  capp, cap1, cap2, uu, sk: string;
  cc, ix, c1, kk, sum: Integer;
begin
  AssignPrn(MojaDat);
  Rewrite(MojaDat);

  capp := 'K O N T R O L N I     L I S T / ' + DateToStr(dst);
  cap1 := 'E T A   Cerkno';
  cap2 := 'Datum : ' + DateToStr(Date) + '  ' + TimeToStr(Time);

  Printer.Canvas.Font.Name := 'Courier New';
  Printer.Canvas.Font.Size := 12;
  cc := Printer.PageWidth div Printer.Canvas.TextWidth('P');
  c1 := cc - Length(cap1) - Length(cap2);
  Writeln(MojaDat, cap1 + StringOfChar(' ', c1) + cap2);
  Writeln(MojaDat, 'DE Termoregulator');

  Printer.Canvas.Font.Size := 16;
  cc := Printer.PageWidth div Printer.Canvas.TextWidth('P');
  ix := (cc - Length(capp)) div 2;
  Writeln(MojaDat, StringOfChar(' ', ix) + capp);

  Printer.Canvas.Font.Size := 12;
  Writeln(MojaDat, '');
  Writeln(MojaDat, pnas);
  Writeln(MojaDat, '');

  Writeln(MojaDat, Format('%10s%18s%8s%4s%13s%12s%12s',
    ['Nalog', 'Material', 'Donos', 'Peè', 'Del. mesto', 'Datum', 'TK1/TK2/TK3']));
  Writeln(MojaDat, '');

  ADOQuery1.First;
  sk := FStr(ADOQuery1, 'SKLAD');
  uu := FStr(ADOQuery1, 'TIP');
  kk := 1;
  sum := 0;

  while not ADOQuery1.Eof do
  begin
    if sk <> FStr(ADOQuery1, 'SKLAD') then
    begin
      Writeln(MojaDat, '   --------------------------------------------------------------------------');
      Writeln(MojaDat, Format('%25s%9s', ['   Skupaj za skaldišèe ' + sk, IntToStr(sum)]));
      Writeln(MojaDat);
      Writeln(MojaDat);
      kk := kk + 2;
      sk := FStr(ADOQuery1, 'SKLAD');
      sum := 0;
    end;

    if uu <> FStr(ADOQuery1, 'TIP') then
    begin
      if sum > 0 then
      begin
        Writeln(MojaDat);
        Writeln(MojaDat);
        kk := kk + 2;
      end;
      uu := FStr(ADOQuery1, 'TIP');
    end;

    sum := sum + FInt(ADOQuery1, 'DONOS');

    if kk = 56 then Writeln(MojaDat);

    Writeln(MojaDat, Format('%10s%18s%8s%4s%13s%12s%12s', [
      FStr(ADOQuery1, 'NALOG'),
      FStr(ADOQuery1, 'KODA'),
      IntToStr(FInt(ADOQuery1, 'DONOS')),
      IntToStr(FInt(ADOQuery1, 'PEC')),
      FStr(ADOQuery1, 'DELMESTO'),
      FDateStr(ADOQuery1, 'DATUM'),
      IntToStr(FInt(ADOQuery1, 'TK1')) + '/' + IntToStr(FInt(ADOQuery1, 'TK2')) + '/' + IntToStr(FInt(ADOQuery1, 'TK3'))
    ]));

    Inc(kk);
    ADOQuery1.Next;
  end;

  Writeln(MojaDat, '   --------------------------------------------------------------------------');
  Writeln(MojaDat, Format('%25s%9s', ['   Skupaj za skaldišèe ' + sk, IntToStr(sum)]));
  System.CloseFile(MojaDat);
end;

procedure TFquery.Button3Click(Sender: TObject);
var
  Mojadat: TextFile;
  kk: Integer;
  uu: string;
begin
  AssignFile(Mojadat, 'stat.txt');
  Rewrite(Mojadat);

  ADOQuery1.First;
  uu := FStr(ADOQuery1, 'TIP');
  kk := 1;

  while not ADOQuery1.Eof do
  begin
    if uu <> FStr(ADOQuery1, 'TIP') then
    begin
      Writeln(Mojadat);
      Writeln(Mojadat);
      kk := kk + 2;
      uu := FStr(ADOQuery1, 'TIP');
    end;

    if kk = 56 then Writeln(Mojadat);

    Writeln(Mojadat, Format('%10s%18s%8s%4s%13s%12s%12s', [
      FStr(ADOQuery1, 'NALOG'),
      FStr(ADOQuery1, 'KODA'),
      IntToStr(FInt(ADOQuery1, 'DONOS')),
      IntToStr(FInt(ADOQuery1, 'PEC')),
      FStr(ADOQuery1, 'DELMESTO'),
      FDateStr(ADOQuery1, 'DATUM'),
      IntToStr(FInt(ADOQuery1, 'TK1')) + '/' + IntToStr(FInt(ADOQuery1, 'TK2')) + '/' + IntToStr(FInt(ADOQuery1, 'TK3'))
    ]));

    Inc(kk);
    ADOQuery1.Next;
  end;

  CloseFile(Mojadat);
end;

procedure TFquery.KopirajNalogeClick(Sender: TObject);
var
  ClipboardText: string;
begin
  ClipboardText := '';
  ADOQuery1.First;
  while not ADOQuery1.Eof do
  begin
    ClipboardText := ClipboardText + FStr(ADOQuery1, 'NALOG') + sLineBreak;
    ADOQuery1.Next;
  end;

  Clipboard.AsText := ClipboardText;
  ShowMessage('Stolpec Nalogov je bil kopiran v odložišèe. Prilepite ga s Ctrl + V.');
end;

end.



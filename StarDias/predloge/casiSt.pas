unit casiSt;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Dialogs,
  StdCtrls, Forms, DBCtrls, DB, DBGrids, DBTables, Grids, ExtCtrls;

type
  sest = array[1..6] of boolean ;
  TFcasiSt = class(TForm)
    Table1KODA: TStringField;
    Table1DNI: TSmallintField;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Table1: TTable;
    Database1: TDatabase;
    table2: TTable;
    Button2: TButton;
    Button1: TButton;
    Table1TK1: TSmallintField;
    Table1TK2: TSmallintField;
    Table1TK3: TSmallintField;
    Button3: TButton;
    Button4: TButton;
    Table1SKODA: TStringField;
    Button5: TButton;
    Table1TSTAT: TSmallintField;
    Table1PAKIR: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { private declarations }
  public
    procedure pokazi ;
    //function najdi(kd: string) : integer ;
    procedure najdi(kd: string; var cas,t1,t2,t3,tt : integer; var pk : string)  ;
    procedure najdi_00(kd: string; var cas,t1,t2,t3,tt : integer; var pk : string)  ;
    procedure isci(kd: string; var dd,t1,t2,t3,tt : integer; var cr : string; var kkon : sest) ;
    procedure isci1(kd: string; var dd,t1,t2,t3,tt : integer; var kk,cr : string);
    procedure Zapis(kd,kk,pk: string; db,t1,t2,t3,tt : integer);
    procedure isciTemp(kd: string; var dd,t1,t2,t3 : integer) ;
    Function stark(kd : string) : string ;
    procedure poprav(kd : string) ;
  end;

var
  FcasiSt: TFcasiSt;

implementation

{$R *.DFM}

procedure TFcasiSt.FormCreate(Sender: TObject);
   var pt : string ;
begin
  //Table1.Open;
  pt := application.exename ;
  table1.DatabaseName := ExtractFileDir(pt) ;
end;

// prikaz tabele predpisanih èasov staranja
procedure TFcasiSt.pokazi ;
begin
  Table1.indexName := 'koda' ;
  Table1.open ;
  ShowModal ;
  Table1.close ;
end ;

procedure TFcasiSt.poprav(kd : string) ;
begin
  Table1.open  ;
  if Table1.Locate('koda',kd,[]) then
  begin
    table1.edit ;
    if table1pakir.value = 'R' then table1pakir.value := 'N'
                               else  table1pakir.value := 'R' ;
    table1.post ;
  end ;
  table1.Close ;
end ;

procedure TFcasiSt.najdi_00(kd: string; var cas,t1,t2,t3,tt : integer; var pk : string)  ;
  var ii : Integer ;
      dod : string ;
begin
  for ii := 1 to 5 do
  begin
     case ii of
       1 : dod := '-00' ;
       2 : dod := '-01' ;
       3 : dod := '-02' ;
       4 : dod := '-10' ;
       5 : dod := '' ;
     end;
     kd := Kd + dod ;
     najdi(kd,cas,t1,t2,t3,tt,pk) ;
     if cas > 0 then break
  end;
end;

// iskanje po tabeli
procedure TFcasiSt.najdi(kd: string; var cas,t1,t2,t3,tt : integer; var pk : string)  ;
  procedure zeros ;
  begin
     t1 := 0 ;
     t2 := 0 ;
     t3 := 0 ;
     tt := 0 ;
     pk := '' ;
     cas := 0 ;
  end ;
begin
  Table1.open  ;
  if Table1.Locate('koda',kd,[]) then
  begin
    cas := Table1dni.value ;
    try
      t1 := Table1tk1.value ;
      t2 := Table1tk2.value ;
      t3 := Table1tk3.value ;
      tt := Table1tstat.value ;
      pk := Table1pakir.value ;
    except
      zeros
    end ;
 { end else
  begin
    if Table1.Locate('skoda',kd,[]) then
    begin
      cas := Table1dni.value ;
      try
        t1 := Table1tk1.value ;
        t2 := Table1tk2.value ;
        t3 := Table1tk3.value ;
        tt := Table1tstat.value ;
        pk := Table1pakir.value ;
      except
        zeros
      end ;
    end else 
    begin
      cas := 0 ;
      zeros
    end ;  }
  end else zeros ;
  Table1.Close ;
end ;

// Funkcija išèe bazi MPTER po kodi
procedure TFcasiSt.isci(kd: string; var dd,t1,t2,t3,tt : integer; var cr : string; var kkon : sest) ;
  var itt : integer ;
  function prs(im : string) :boolean ;
  begin
    if table2.FieldByname(im).IsNull then result := false
    else
      if trim(table2.FieldByname(im).value) = '' then result := false else result := true
  end;

  function prv : Integer ;
  begin
     if table2.FieldByname('Kontrola_vz_100').IsNull then result := 0
     else
      if trim(table2.FieldByname('Kontrola_vz_100').value) = '100%' then result := 2 else result := 1
  end;
  procedure beri ;
    var ss : string ;
  begin
    try
      dd := round(table2.fieldbyName('cas_staranja').value/24) ;
    except
      dd := 2 ;
    end;
    t1 := table2.fieldbyName('tk1').value ;
    t2 := table2.fieldbyName('tk2').value ;
    t3 := table2.fieldbyName('tk3').value ;
    tt := table2.fieldbyName('tstar').value ;

    itt := prv ;
    if itt > 0 then kkon[itt] := true  ;

    if prs('Kontrola_100_01') then kkon[2] := true ;
    if prs('Kontrola_100_11') then kkon[3] := true ;
    if prs('Kontrola_100_21') then kkon[4] := true ;
    if prs('Kontrola_vz_00') then kkon[1] := true ;
    if prs('Kontrola_vz_10') then kkon[5] := true ;
    if prs('Kontrola_vz_20')then kkon[6] := true ;
    try
       ss := Table2.Fieldbyname('pakiranje').value ;
     except
       ss := ''
     end ;
     try
       if ss = '' then ss := Table2.Fieldbyname('pakiranje_1').value ;
     except
        ss := 'NAVITI'
     end;
     if ss = 'NAVITI' then cr := 'N' else cr := 'R' ;
  end ;
begin
  dd := 0 ;
  try
    Database1.DatabaseName := 'mpter' ;
    database1.Open ;
  except
    Database1.Close  ;
    exit
  end ;
  table2.Open ;
  if Table2.Locate('koda_d',kd,[]) then    // osnovni stolpec
  begin
    beri
  end else
  begin
    if Table2.Locate('koda_d_e',kd,[]) then   // pomožni stolpec
    begin
      beri
    end else
    begin
      dd := 0 ;
      t1 := 0 ;
      t2 := 0 ;
      t3 := 0
    end
  end ;
  Table2.Close ;
  Database1.Close  ;
end ;

// Funkcija išèe v bazi MPTER po šifri
procedure TFcasiSt.isci1(kd: string; var dd,t1,t2,t3,tt : integer; var kk,cr : string) ;
  var ss : string ;
begin
  dd := 0 ;
{  try
    Database1.DatabaseName := 'mpter' ;
    database1.Open ;
  except
    Database1.Close  ;
    exit
  end ;     }
  table2.Open ;
  if Table2.Locate('sifra_d',kd,[]) then
  begin
    dd := round(table2.fieldbyName('cas_staranja').value/24) ;
    t1 := table2.fieldbyName('tk1').value ;
    t2 := table2.fieldbyName('tk2').value ;
    t3 := table2.fieldbyName('tk3').value ;
    kk := table2.fieldbyName('koda_d').value ;
    tt := table2.fieldbyName('tstar').value ;

    try
       ss := Table2.Fieldbyname('pakiranje').value ;
     except
       ss := ''
     end ;
     if ss = '' then ss := Table2.Fieldbyname('pakiranje_1').value ;
     if ss = 'NAVITI' then cr := 'N' else cr := 'R' ;
  end else
  begin
    dd := 0 ;
    t1 := 0 ;
    t2 := 0 ;
    t3 := 0 ;
    kk := '' ;
  end ;

  Table2.Close ;
 // Database1.Close  ;
end ;

// Zapis v tabelo
procedure  TFcasiSt.Zapis(kd,kk,pk: string; db,t1,t2,t3,tt : integer) ;
begin
  Table1.open ;
  if not Table1.Locate('koda',kd,[]) then
     Table1.Appendrecord([kd,db,t1,t2,t3,kk,tt,pk]) ;
  Table1.Close ;
end ;

// Brisanje zapisa
procedure TFcasiSt.Button2Click(Sender: TObject);
  var ii : integer ;
begin
  ii := MessageDlg('Ali zares želiš izbrisati',mtConfirmation,[mbYes, mbNo],0);
  if ii = 6 then  Table1.Delete
end;

procedure TFcasiSt.Button3Click(Sender: TObject);
  var t1,t2,t3,dd : integer ;
begin
  Table1.First ;
  table2.Open ;
  while not table1.eof do
  begin
    IsciTemp(table1koda.value,dd,t1,t2,t3) ;
    If dd > 0 then
    begin
      table1.edit ;
      Table1tk1.value := t1 ;
      Table1tk2.value := t2 ;
      Table1tk3.value := t3 ;
      Table1.post
    end ;
    Table1.next ;
  end ;
  table2.Close ;
end;


procedure TFcasiSt.isciTemp(kd: string; var dd,t1,t2,t3 : integer) ;
 var cc : boolean ;
    s1 : integer ;
    sif : string ;
begin
  dd := 0 ;
{  try
    Database1.DatabaseName := 'mpter' ;
    database1.Open ;
  except
    Database1.Close  ;
    exit
  end ;     }
  cc := table2.active ;
  if copy(kd,1,3) = '045' then
  begin
    sif := copy(kd,6,3) + copy(kd,10,3) ;
    s1 := 1
  end else
    s1 := 0 ;
  if not cc then table2.Open ;
  if ((s1 = 0) and (Table2.Locate('koda_d',kd,[]))) or
     ((s1 = 1) and (Table2.Locate('sifra_d',sif,[])))   then
  begin
    dd := 1 ;
    t1 := Table2.FieldbyName('tk1').value ;
    t2 := Table2.FieldbyName('tk2').value ;
    t3 := Table2.FieldbyName('tk3').value ;
  end ;
  if not cc then table2.close ;
end ;



procedure TFcasiSt.Button4Click(Sender: TObject);
  var dd,t1,t2,t3,tt,ii : integer ;
      kd,sf,kk,pk,dod,kdd : string ;
      kkon : sest ;
      prvi : boolean ;
begin
 // Table1.First ;
 // While not Table1.eof do
 // begin

    kd := table1koda.value ;
    kd := copy(kd,1,12) ;
    for ii := 1 to 6 do kkon[ii] := false ;

    Isci(kd,dd,t1,t2,t3,tt,pk,kkon) ;
    if dd <> 0 then
    begin
      prvi := true ;
      for ii := 1 to 6 do if kkon[ii] then prvi := false ;
      if prvi then kkon[1] := true ;
      prvi := true ;
      for ii := 1 to 6 do
      begin
        case ii of
          1 : dod := '-00' ;
          2 : dod := '-01' ;
          3 : dod := '-11' ;
          4 : dod := '-21' ;
          5 : dod := '-10' ;
          6 : dod := '-20' ;
        end;
        if kkon[ii] then
        begin
          kdd := kd + dod ;
          if prvi then Table1.edit else Table1.Append ;
          Table1koda.value := kdd ;
          Table1dni.value := dd ;
          Table1tk1.value := t1 ;
          Table1tk2.value := t2 ;
          Table1tk3.value := t3 ;
          prvi := false ;
          Table1.Post ;
        end;
      end;
    end else
    begin
      sf := copy(kd,6,3) + copy(kd,10,3) ;
      FcasiSt.isci1(sf,dd,t1,t2,t3,tt,kk,pk) ;
      if dd <> 0 then
      begin
        Table1.edit ;
        Table1dni.value := dd ;
        Table1tk1.value := t1 ;
        Table1tk2.value := t2 ;
        Table1tk3.value := t3 ;
        Table1.Post ;
      end ;
    end ;
 //   Table1.Next ;
 // end ;
end;

Function TFcasiSt.stark(kd : string) : string ;
begin
  Table1.open ;
  If Table1.Locate('koda',kd,[]) then result := table1skoda.value
                                 else result := '' ;
  Table1.Close ;
end ;


procedure TFcasiSt.Button5Click(Sender: TObject);
  var kd,sif,kd1 : string ;

  procedure zapis ;
    var t1 : integer ;
        cr,ss : string ;
  begin
     t1 := Table2.Fieldbyname('tstar').value ;
     try
       ss := Table2.Fieldbyname('pakiranje_nn').value ;
     except
       ss := ''
     end ;
 //    if ss = '' then ss := Table2.Fieldbyname('pakiranje_nn_1').value ;
     if ss = 'NAVITI' then cr := 'N' else cr := 'R' ;
     Table1.edit ;
     Table1tstat.value := t1 ;
     table1pakir.value := cr ;
     Table1.Post ;
  end ;
begin
  table1.First ;
  table2.Open ;
  while not table1.eof do
  begin
    kd := table1Koda.value ;
    if copy(kd,1,2) <> '00' then
    begin
      sif := copy(kd,6,3) + copy(kd,10,3) ;
      if Table2.Locate('sifra_d',sif,[]) then zapis
    end else
    begin
      if Table2.Locate('koda_d',kd,[]) then zapis ;
    end ;
    Table1.next ;
  end ;
  table2.Close ; ;
end;

end.
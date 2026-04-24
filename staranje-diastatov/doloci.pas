unit doloci;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFdoloci = class(TForm)
    Panel1: TPanel;
    ListBox1: TListBox;
    DatePicker1: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    procedure izbor(var dd : TdateTime; var pc : Integer) ;
  end;

var
  Fdoloci: TFdoloci;

implementation

{$R *.dfm}

uses peci;
procedure TfDoloci.izbor(var dd : TdateTime; var pc : Integer) ;
  var Listpec,ListKod : TstringList ;
      ii : Integer ;
      d1 : string ;
begin
  Listpec := TstringList.Create ;
  panel1.Color := $02F0F0FF ;
  FPeci.GetList(listpec) ;
  ListBox1.items := Listpec ;
  datePicker1.Date := date ;
  ShowModal ;
  if modalResult = mrOK then
  begin
    d1 := dateTostr(datePicker1.Date) ;
    dd := StrTodate(d1) ;
    ii := ListBox1.itemIndex ;
    if ii >= 0 then  pc := StrToInt(copy(Listbox1.Items[ii],1,2))
               else  pc := 0 ;
  end else pc := 0 ;
  Listpec.Free ;
end;
end.

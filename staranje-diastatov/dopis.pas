unit dopis;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, vpis,peci;

type
  TFdopis = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
     pc : integer ;
  public
    function izbor(postav : vpeci) : integer ;
  end;

var
  Fdopis: TFdopis;

implementation

{$R *.dfm}


procedure TFdopis.Button1Click(Sender: TObject);
  var ii : Integer ;

begin
   ii := ListBox1.itemIndex ;
   if ii >= 0 then  pc := StrToInt(copy(Listbox1.Items[ii],1,2)) ;
   close ;
end;

function TFdopis.izbor(postav : vpeci) : integer;
  var Listpec : TstringList ;
      ii : integer ;
begin
  pc := 0 ;
  Listpec := TstringList.Create ;
  FPeci.GetList(listpec) ;
  for ii  := 0 to listpec.count-1 do
    listpec[ii] := Listpec[ii] + '--' + IntTostr(postav[ii+1]) ;

  {Forders.GetList(listkod) ;
  ComboBox1.items := ListKod ;  }
  ListBox1.items := Listpec ;
  Panel1.Color := $02ffffc0 ;
  showModal ;
  result := pc ;
end ;

end.

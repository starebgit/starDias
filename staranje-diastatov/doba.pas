unit doba;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFdoba = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
  private
    { Private declarations }
  public
    procedure vpisi(var dat1,dat2 : Tdatetime) ;
  end;

var
  Fdoba: TFdoba;

implementation

{$R *.DFM}

procedure Tfdoba.vpisi(var dat1,dat2 : Tdatetime) ;
begin
  ShowModal ;
  dat1 := StrTodate(edit1.text) ;
  dat2 := StrTodate(edit2.text) ;
end ;

end.

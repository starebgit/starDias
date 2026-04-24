object Fdopis: TFdopis
  Left = 0
  Top = 0
  Caption = 'Prelo'#382'i v pe'#269
  ClientHeight = 590
  ClientWidth = 733
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 497
    Height = 590
    Align = alLeft
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 80
      Top = 56
      Width = 63
      Height = 17
      Caption = 'Izbor pe'#269'i'
    end
    object ListBox1: TListBox
      Left = 96
      Top = 79
      Width = 217
      Height = 353
      ItemHeight = 17
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 497
    Top = 0
    Width = 236
    Height = 590
    Align = alClient
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = 584
    ExplicitTop = 48
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Button1: TButton
      Left = 56
      Top = 79
      Width = 89
      Height = 25
      Caption = 'V redu'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 56
      Top = 152
      Width = 89
      Height = 25
      Caption = 'Prekini'
      ModalResult = 2
      TabOrder = 1
    end
  end
end

object TelaClienteCadastro: TTelaClienteCadastro
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Cliente'
  ClientHeight = 161
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  TextHeight = 15
  object PanelRodape: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 117
    Width = 375
    Height = 41
    Align = alBottom
    TabOrder = 0
    ExplicitWidth = 545
    object BotaoCancelar: TSpeedButton
      AlignWithMargins = True
      Left = 301
      Top = 4
      Width = 70
      Height = 33
      Align = alRight
      Caption = 'Cancelar'
      StyleName = 'Windows'
      OnClick = BotaoCancelarClick
      ExplicitLeft = 240
      ExplicitTop = 1
      ExplicitHeight = 39
    end
    object BotaoGravar: TSpeedButton
      AlignWithMargins = True
      Left = 225
      Top = 4
      Width = 70
      Height = 33
      Align = alRight
      Caption = 'Gravar'
      StyleName = 'Windows'
      OnClick = BotaoGravarClick
      ExplicitLeft = 240
      ExplicitTop = 1
      ExplicitHeight = 39
    end
  end
  object PanelDados: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 375
    Height = 108
    Align = alClient
    TabOrder = 1
    ExplicitLeft = -2
    ExplicitWidth = 545
    object LabelCodigo: TLabel
      Left = 8
      Top = 8
      Width = 39
      Height = 15
      Caption = 'C'#243'digo'
    end
    object LabelNome: TLabel
      Left = 103
      Top = 8
      Width = 33
      Height = 15
      Caption = 'Nome'
    end
    object LabelData: TLabel
      Left = 8
      Top = 58
      Width = 24
      Height = 15
      Caption = 'Data'
    end
    object EditCodigo: TEdit
      Left = 8
      Top = 29
      Width = 89
      Height = 23
      CharCase = ecUpperCase
      TabOrder = 0
      OnKeyPress = EditCodigoKeyPress
    end
    object EditNome: TEdit
      Left = 103
      Top = 29
      Width = 257
      Height = 23
      CharCase = ecUpperCase
      TabOrder = 1
    end
    object EditData: TDateTimePicker
      Left = 8
      Top = 79
      Width = 90
      Height = 23
      Date = 45991.000000000000000000
      Time = 0.005888506944756955
      TabOrder = 2
    end
  end
end

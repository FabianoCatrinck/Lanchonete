unit Sobre;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TTelaSobre = class(TForm)
    PanelRodape: TPanel;
    BotaoFechar: TSpeedButton;
    PanelDados: TPanel;
    Memo: TMemo;
    procedure BotaoFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.dfm}

procedure TTelaSobre.BotaoFecharClick(Sender: TObject);
begin
  Close;
end;

end.

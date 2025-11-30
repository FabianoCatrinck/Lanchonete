unit CardapioConsulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, ComObj;

type
  TTelaCardapioConsulta = class(TForm)
    PanelRodape: TPanel;
    BotaoFechar: TSpeedButton;
    PanelDados: TPanel;
    Cardapio: TFDMemTable;
    CardapioCodigo: TIntegerField;
    CardapioLanche: TStringField;
    CardapioValor: TFloatField;
    CardapioIngredientes: TStringField;
    BotaoImprimir: TSpeedButton;
    DataSourceCardapio: TDataSource;
    DBGrid: TDBGrid;
    CardapioIdLanche: TIntegerField;
    procedure BotaoFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BotaoImprimirClick(Sender: TObject);
  private
    { Private declarations }
    procedure CarregarCardapio();
    procedure ObterLanches();
    procedure ObterIngredientes();

  public
    { Public declarations }
  end;



implementation

{$R *.dfm}

uses DataModule;

procedure TTelaCardapioConsulta.BotaoFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTelaCardapioConsulta.BotaoImprimirClick(Sender: TObject);
var
  ExcelApp, Workbook, Worksheet: OleVariant;
  SaveDlg: TSaveDialog;
  Col, Linha: Integer;
  FileName, Titulo: string;
begin
  // Verifica se há dados
  if Cardapio.IsEmpty then
  begin
    ShowMessage('Nenhum item no cardápio para exportar.');
    Exit;
  end;

  // Título específico do Cardápio
  Titulo := 'Cardápio Cadastrado';

  // --- Preparar diálogo para salvar ---
  SaveDlg := TSaveDialog.Create(nil);
  try
    SaveDlg.DefaultExt := 'xlsx';
    SaveDlg.Filter := 'Excel files (*.xlsx)|*.xlsx|All files (*.*)|*.*';
    SaveDlg.FileName := 'Cardapio_' + FormatDateTime('yyyy-mm-dd_hhnnss', Now) + '.xlsx';
    if not SaveDlg.Execute then
      Exit; // usuário cancelou
    FileName := SaveDlg.FileName;
  finally
    SaveDlg.Free;
  end;

  // --- Criar Excel ---
  try
    ExcelApp := CreateOleObject('Excel.Application');
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao iniciar o Excel: ' + E.Message);
      Exit;
    end;
  end;

  try
    ExcelApp.Visible := False;
    ExcelApp.DisplayAlerts := False;

    Workbook := ExcelApp.Workbooks.Add;
    Worksheet := Workbook.Worksheets[1];

    // --- TÍTULO ---
    Worksheet.Cells[1, 1] := Titulo;
    Worksheet.Rows[1].Font.Bold := True;
    Worksheet.Rows[1].Font.Size := 14;

    // Cabeçalhos (linha 3)
    for Col := 0 to Cardapio.FieldCount - 1 do
      Worksheet.Cells[3, Col + 1] := Cardapio.Fields[Col].DisplayName;

    Worksheet.Rows[3].Font.Bold := True;

    // Dados a partir da linha 4
    Linha := 4;
    Cardapio.First;
    while not Cardapio.EOF do
    begin
      for Col := 0 to Cardapio.FieldCount - 1 do
        Worksheet.Cells[Linha, Col + 1] :=
           Cardapio.Fields[Col].AsString;
      Inc(Linha);
      Cardapio.Next;
    end;

    Worksheet.Columns.AutoFit;

    // Salvar em .xlsx
    try
      Workbook.SaveAs(FileName, 51); // 51 = xlOpenXMLWorkbook
      ShowMessage('Cardápio exportado com sucesso para:' + sLineBreak + FileName);
    except
      on E: Exception do
        ShowMessage('Erro ao salvar arquivo: ' + E.Message);
    end;

    ExcelApp.Visible := True;
    ExcelApp.DisplayAlerts := True;

    Worksheet := Unassigned;
    Workbook := Unassigned;
    ExcelApp := Unassigned;

  except
    on E: Exception do
    begin
      if not VarIsEmpty(ExcelApp) then
      begin
        ExcelApp.Quit;
        ExcelApp := Unassigned;
      end;
      ShowMessage('Erro durante exportação: ' + E.Message);
    end;
  end;
end;

procedure TTelaCardapioConsulta.CarregarCardapio;
begin
  if not Cardapio.Active then
     Cardapio.CreateDataSet;

  ObterLanches();
end;

procedure TTelaCardapioConsulta.FormShow(Sender: TObject);
begin
  CarregarCardapio;
end;

procedure TTelaCardapioConsulta.ObterIngredientes;
var
  Consulta: TFDQuery;
  Ingredientes: String;
begin
  Ingredientes := '';
  Consulta := TFDQuery.Create(nil);
  try
    Consulta.Connection := Dados.FDConnection;
    Consulta.SQL.Add('select i.nomeingrediente as Descricao, li.idlanche');
    Consulta.SQL.Add('from LancheDetalheIngrediente li');
    Consulta.SQL.Add('join ingrediente i on i.idingrediente = li.idingrediente');
    Consulta.SQL.Add('group by li.IdLanche, li.idingrediente');
    Consulta.SQL.Add('order by li.idlanche');

    Consulta.Open;

    Cardapio.First;

    while not Cardapio.Eof do
    begin
      Ingredientes := '';
      Consulta.Filtered := False;
      Consulta.Filter := 'idlanche=' + Cardapio.FieldByName('idlanche').AsString;
      Consulta.Filtered := True;

      while not Consulta.Eof do
      begin
        if Consulta.RecNo = 1 then
          Ingredientes := Consulta.FieldByName('Descricao').AsString
        else
          Ingredientes := Ingredientes+ ', ' + Consulta.FieldByName('Descricao').AsString;

        Consulta.Next;
      end;

      if Ingredientes <> '' then
      begin
        Cardapio.Edit;
        Cardapio.FieldByName('Ingredientes').AsString := Ingredientes;
        Cardapio.Post;
      end;

      Cardapio.Next;
    end;
  finally
    Consulta.Filtered := True;
    Consulta.Close;
    FreeAndNil(Consulta);
  end;
end;

procedure TTelaCardapioConsulta.ObterLanches;
var
  Consulta: TFDQuery;
begin
  Consulta := TFDQuery.Create(nil);
  try
    Consulta.Connection := Dados.FDConnection;
    Consulta.SQL.Add('select l.idlanche, l.CodigoLanche as Codigo, l.nomelanche as Lanche, l.Valor');
    Consulta.SQL.Add('from lanche l');
    Consulta.SQL.Add('order  by l.codigolanche');

    Consulta.Open;

    Cardapio.CopyDataSet(Consulta);

    ObterIngredientes();
  finally
    Consulta.Close;
    FreeAndNil(Consulta);
  end;
end;

end.

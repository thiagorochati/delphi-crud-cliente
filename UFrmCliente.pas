unit UFrmCliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  FMX.TabControl, System.Actions, FMX.ActnList, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListView, System.IOUtils;

type
  TFrmCliente = class(TForm)
    TabControl1: TTabControl;
    TabConsulta: TTabItem;
    TabCadastro: TTabItem;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    EditNome: TEdit;
    Layout3: TLayout;
    Label2: TLabel;
    EditCPF: TEdit;
    Layout4: TLayout;
    Label3: TLabel;
    EditEmail: TEdit;
    Rectangle2: TRectangle;
    Label4: TLabel;
    Image1: TImage;
    Label5: TLabel;
    ActionList1: TActionList;
    MudaAba: TChangeTabAction;
    Rectangle3: TRectangle;
    Label6: TLabel;
    Rectangle4: TRectangle;
    Label7: TLabel;
    Image2: TImage;
    FDConnection1: TFDConnection;
    QDados: TFDQuery;
    VertCliente: TVertScrollBox;
    TabLogin: TTabItem;
    TabUsuario: TTabItem;
    Rectangle5: TRectangle;
    Layout5: TLayout;
    Layout6: TLayout;
    Rectangle6: TRectangle;
    EditEmailLogin: TEdit;
    Rectangle7: TRectangle;
    EditSenhaLogin: TEdit;
    btnLogin: TRectangle;
    Label8: TLabel;
    Rectangle9: TRectangle;
    Image3: TImage;
    Label9: TLabel;
    Layout7: TLayout;
    Layout8: TLayout;
    Label10: TLabel;
    EditNomeUsuario: TEdit;
    Layout9: TLayout;
    Label11: TLabel;
    EditEmailUsuario: TEdit;
    Layout10: TLayout;
    Label12: TLabel;
    EditSenhaUsuario: TEdit;
    Rectangle10: TRectangle;
    Label13: TLabel;
    Label14: TLabel;
    Image4: TImage;
    procedure Image1Click(Sender: TObject);
    procedure Rectangle3Click(Sender: TObject);
    procedure Rectangle2Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FDConnection1AfterConnect(Sender: TObject);
    procedure Rectangle10Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }

    procedure AtualizaCliente; //Ctrl + Shift + C
  public
    { Public declarations }
    procedure DeletaCliente(vCodigo: integer);
  end;

var
  FrmCliente: TFrmCliente;

implementation

{$R *.fmx}

uses UFrameCliente;

procedure TFrmCliente.AtualizaCliente;
var
  i : integer;
  Frame : TFrameCliente;
begin
  VertCliente.BeginUpdate;

  //Limpando todos os itens do VertScrollBox
  for i := VertCliente.Content.ChildrenCount - 1 downto 0 do
    if VertCliente.Content.Children[i] is TFrame then
      TFrame(VertCliente.Content.Children[i]).DisposeOf;

  QDados.Close;
  QDados.SQL.Clear;
  QDados.SQL.Add('SELECT * FROM CLIENTE');
  QDados.Open;

  While not QDados.Eof do
  begin
    Frame := TFrameCliente.Create(nil);

    Frame.LabelNome.Text  := QDados.FieldByName('NOME').AsString;
    Frame.LabelEmail.Text := QDados.FieldByName('EMAIL').AsString;

    Frame.pIdCliente := QDados.FieldByName('ID_CLIENTE').AsInteger;

    Frame.Align := TAlignLayout.Top;

    VertCliente.AddObject(Frame);

    QDados.Next;
  end;

  VertCliente.EndUpdate;
end;

procedure TFrmCliente.btnLoginClick(Sender: TObject);
begin
  QDados.Close;
  QDados.SQL.Clear;
  QDados.SQL.Add('SELECT * FROM USUARIO WHERE EMAIL = :EMAIL AND SENHA = :SENHA');
  QDados.ParamByName('EMAIL').Value := EditEmailLogin.Text;
  QDados.ParamByName('SENHA').Value := EditSenhaLogin.Text;
  QDados.Open;

  if QDados.IsEmpty then
  begin
    ShowMessage('Usuário ou senha inválida');
  end
  else
  begin
    ShowMessage('Olá ' + QDados.FieldByName('NOME').AsString + ' seja bem vindo!');
    AtualizaCliente;
    MudaAba.Tab := TabConsulta;
    MudaAba.ExecuteTarget(Self);
  end;
end;

procedure TFrmCliente.DeletaCliente(vCodigo: integer);
begin
  QDados.Close;
  QDados.SQL.Clear;
  QDados.SQL.Add('DELETE FROM CLIENTE WHERE ID_CLIENTE =:ID_CLIENTE');
  QDados.ParamByName('ID_CLIENTE').Value := vCodigo;
  QDados.ExecSQL;

  AtualizaCliente;
end;

procedure TFrmCliente.FDConnection1AfterConnect(Sender: TObject);
var
  Aux : String;
begin
  Aux := 'CREATE TABLE IF NOT EXISTS CLIENTE (' +
         '  ID_CLIENTE INTEGER,       ' +
         '  NOME       VARCHAR(50),   ' +
         '  EMAIL      VARCHAR(80),   ' +
         '  CPF        VARCHAR(15),   ' +
         '  PRIMARY KEY (ID_CLIENTE)) ';

  FDConnection1.ExecSQL(Aux);

  Aux := 'CREATE TABLE IF NOT EXISTS USUARIO (' +
         '  ID_USUARIO INTEGER,       ' +
         '  NOME       VARCHAR(50),   ' +
         '  EMAIL      VARCHAR(80),   ' +
         '  SENHA      VARCHAR(15),   ' +
         '  PRIMARY KEY (ID_USUARIO)) ';

  FDConnection1.ExecSQL(Aux);

end;

procedure TFrmCliente.FormShow(Sender: TObject);
begin
  TabControl1.TabPosition := TTabPosition.None;
  TabControl1.ActiveTab := TabLogin;

  FDConnection1.Params.Values['Database'] :=
  System.IOUtils.TPath.GetDocumentsPath + '/BDCadastro.sql';
end;

procedure TFrmCliente.Image1Click(Sender: TObject);
begin
  MudaAba.tab := TabConsulta;
  Mudaaba.ExecuteTarget(Self);
end;

procedure TFrmCliente.Image2Click(Sender: TObject);
begin
  AtualizaCliente;
end;

procedure TFrmCliente.Label14Click(Sender: TObject);
begin
  MudaAba.Tab := TabUsuario;
  MudaAba.ExecuteTarget(Self)
end;

procedure TFrmCliente.Rectangle10Click(Sender: TObject);
var
  Aux : String;
begin
  Aux := 'INSERT INTO USUARIO (' +
         '  NOME, ' +
         '  SENHA, ' +
         '  EMAIL ) ' +
         ' VALUES ( ' +
         ' :NOME, ' +
         ' :SENHA, ' +
         ' :EMAIL)';

  QDados.Close;
  QDados.SQL.Clear;
  QDados.SQL.Add(Aux);
  QDados.ParamByName('NOME').Value  := EditNomeUsuario.Text;
  QDados.ParamByName('SENHA').Value := EditSenhaUsuario.Text;
  QDados.ParamByName('EMAIL').Value := EditEmailUsuario.Text;
  QDados.ExecSQL;

  //Depois que gravei, limpo os campos
  EditNomeUsuario.Text  := '';
  EditSenhaUsuario.Text := '';
  EditEmailUsuario.Text := '';

  MudaAba.tab := TabLogin;
  Mudaaba.ExecuteTarget(Self);
end;

procedure TFrmCliente.Rectangle2Click(Sender: TObject);
var
  Aux : String;
begin
  Aux := 'INSERT INTO CLIENTE (' +
         '  NOME, ' +
         '  CPF, ' +
         '  EMAIL ) ' +
         ' VALUES ( ' +
         ' :NOME, ' +
         ' :CPF, ' +
         ' :EMAIL)';

  QDados.Close;
  QDados.SQL.Clear;
  QDados.SQL.Add(Aux);
  QDados.ParamByName('NOME').Value  := EditNome.Text;
  QDados.ParamByName('CPF').Value   := EditCPF.Text;
  QDados.ParamByName('EMAIL').Value := EditEmail.Text;
  QDados.ExecSQL;

  //Depois que gravei, limpo os campos
  EditNome.Text  := '';
  EditCPF.Text   := '';
  EditEmail.Text := '';

  MudaAba.tab := TabConsulta;
  Mudaaba.ExecuteTarget(Self);
end;

procedure TFrmCliente.Rectangle3Click(Sender: TObject);
begin
  MudaAba.tab := TabCadastro;
  Mudaaba.ExecuteTarget(Self);
end;

end.

unit UFrameCliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects;

type
  TFrameCliente = class(TFrame)
    Rectangle1: TRectangle;
    Image1: TImage;
    LabelNome: TLabel;
    LabelEmail: TLabel;
    ImgExcluir: TImage;
    procedure ImgExcluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pIdCliente : integer;
  end;

implementation

{$R *.fmx}

uses UFrmCliente;

procedure TFrameCliente.ImgExcluirClick(Sender: TObject);
begin
  FrmCliente.DeletaCliente(pIdCliente);
end;

end.

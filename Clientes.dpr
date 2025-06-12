program Clientes;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFrmCliente in 'UFrmCliente.pas' {FrmCliente},
  UFrameCliente in 'UFrameCliente.pas' {FrameCliente: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmCliente, FrmCliente);
  Application.Run;
end.

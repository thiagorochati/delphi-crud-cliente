program Clientes;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFrmCliente in 'UFrmCliente.pas' {Form1},
  UFrameCliente in 'UFrameCliente.pas' {FrameCliente: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

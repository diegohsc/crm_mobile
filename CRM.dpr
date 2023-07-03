program CRM;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrincipal in 'UPrincipal.pas' {FrmPrincipal},
  Frame.Negocio in 'Frames\Frame.Negocio.pas' {FrameNegocio: TFrame},
  uLoading in 'Units\uLoading.pas',
  DataModule.Global in 'DataModules\DataModule.Global.pas' {DmGlobal: TDataModule},
  uSession in 'Units\uSession.pas',
  uSuperChartLight in 'Units\uSuperChartLight.pas',
  uActionSheet in 'Units\uActionSheet.pas',
  UnitNegocioCad in 'UnitNegocioCad.pas' {FrmNegocioCad},
  UnitTarefaCad in 'UnitTarefaCad.pas' {FrmTarefaCad};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TDmGlobal, DmGlobal);
  Application.CreateForm(TFrmNegocioCad, FrmNegocioCad);
  Application.CreateForm(TFrmTarefaCad, FrmTarefaCad);
  Application.Run;
end.

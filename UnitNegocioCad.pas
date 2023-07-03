unit UnitNegocioCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.ListBox, FMX.Edit, uLoading,
  uSession;

type
  TFrmNegocioCad = class(TForm)
    rectToolbar2: TRectangle;
    lblTitulo: TLabel;
    Image5: TImage;
    btnSalvar: TSpeedButton;
    Image1: TImage;
    btnVoltar: TSpeedButton;
    cmbEtapa: TComboBox;
    edtDescricao: TEdit;
    EdtValor: TEdit;
    EdtEmail: TEdit;
    edtFone: TEdit;
    EdtContato: TEdit;
    EdtEmpresa: TEdit;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    Fid_negocio: integer;
    procedure ListarNegocioId(id: integer);
    procedure NegocioTerminate(Sender: TObject);
    procedure NegocioCadTerminate(Sender: TObject);
    { Private declarations }
  public
    property id_negocio: integer read Fid_negocio write Fid_negocio;
  end;

var
  FrmNegocioCad: TFrmNegocioCad;

implementation

{$R *.fmx}

uses DataModule.Global;

procedure TFrmNegocioCad.NegocioTerminate(Sender: TObject);
begin
    TLoading.Hide;

    // Verifica se deu erro na thread...
    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
end;

procedure TFrmNegocioCad.NegocioCadTerminate(Sender: TObject);
begin
    TLoading.Hide;

    // Verifica se deu erro na thread...
    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;

    close;
end;

procedure TFrmNegocioCad.btnSalvarClick(Sender: TObject);
var
    t: TThread;
begin
    TLoading.Show(FrmNegocioCad, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(1500);

        // Enviar os dados do negocios p/ server...
        DmGlobal.CadastrarNegocio(id_negocio, TSession.ID_USUARIO, cmbEtapa.Selected.Text,
                                  edtDescricao.Text, EdtEmpresa.Text, EdtContato.Text,
                                  edtFone.Text, EdtEmail.Text, EdtValor.Text.ToDouble);
    end);

    t.OnTerminate := NegocioCadTerminate;
    t.Start;
end;

procedure TFrmNegocioCad.btnVoltarClick(Sender: TObject);
begin
    close;
end;

procedure TFrmNegocioCad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmNegocioCad := nil;
end;

procedure TFrmNegocioCad.ListarNegocioId(id: integer);
var
    t: TThread;
begin
    TLoading.Show(FrmNegocioCad, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(1500);

        // Busca os dados do negocios no server...
        DmGlobal.ListarNegocioId(id);

        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
            cmbEtapa.ItemIndex := 0;  // Ajutar...
            edtDescricao.Text := DmGlobal.TabNegocio.fieldbyname('descricao').asstring;
            edtEmpresa.Text := DmGlobal.TabNegocio.fieldbyname('empresa').asstring;
            edtContato.Text := DmGlobal.TabNegocio.fieldbyname('contato').asstring;
            edtFone.Text := DmGlobal.TabNegocio.fieldbyname('fone').asstring;
            edtEmail.Text := DmGlobal.TabNegocio.fieldbyname('email').asstring;
            edtValor.Text := FormatFloat('#,##0.00', DmGlobal.TabNegocio.fieldbyname('valor').asfloat);
        end);
    end);

    t.OnTerminate := NegocioTerminate;
    t.Start;
end;

procedure TFrmNegocioCad.FormShow(Sender: TObject);
begin
    if id_negocio = 0 then
        lblTitulo.Text := 'Novo Negócio'
    else
    begin
        lblTitulo.Text := 'Editar Negócio';
        ListarNegocioId(id_negocio);
    end;
end;

end.

unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.TabControl,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox, uLoading, DataModule.Global, uSession,
  Frame.Negocio, uSuperChartLight, System.JSON, uActionSheet,  FMX.DialogService,
  UnitTarefaCad, FMX.Ani , StrUtils , System.DateUtils;

type
  TFrmPrincipal = class(TForm)
    rectAbas: TRectangle;
    LytAba1: TLayout;
    Label1: TLabel;
    Image1: TImage;
    LayAba2: TLayout;
    Label2: TLabel;
    Image2: TImage;
    LayAba3: TLayout;
    Label3: TLabel;
    Image3: TImage;
    layAba4: TLayout;
    Label4: TLabel;
    Image4: TImage;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    rectTollBar1: TRectangle;
    Label5: TLabel;
    imgRefrashDeshboard: TImage;
    BtnRefrashDeshBoard: TSpeedButton;
    rectToolBar2: TRectangle;
    Label6: TLabel;
    Image5: TImage;
    SpeedButton1: TSpeedButton;
    rectToolBar3: TRectangle;
    Label7: TLabel;
    rectToolBar4: TRectangle;
    lblConfiguracoes: TLabel;
    rectfundoAba1: TRectangle;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Layout2: TLayout;
    Image6: TImage;
    Label8: TLabel;
    lblDash1Valor: TLabel;
    Rectangle2: TRectangle;
    Layout3: TLayout;
    Image7: TImage;
    Label10: TLabel;
    Layout4: TLayout;
    lblDash2Valor: TLabel;
    Rectangle3: TRectangle;
    Layout5: TLayout;
    Label12: TLabel;
    lbnegocios: TListBox;
    lvNegocios: TListView;
    imgContato: TImage;
    lytGrafico: TLayout;
    lvtarefas: TListView;
    Rectangle4: TRectangle;
    lblFinalizada: TLabel;
    lblPendente: TLabel;
    rectStatusTarefa: TRectangle;
    imgFinalizado: TImage;
    imgData: TImage;
    lbTarefa: TListBox;
    ListBoxItem1: TListBoxItem;
    Image8: TImage;
    Label9: TLabel;
    Line1: TLine;
    ListBoxItem2: TListBoxItem;
    Image9: TImage;
    Label11: TLabel;
    Line2: TLine;
    ListBoxItem3: TListBoxItem;
    Image10: TImage;
    Label13: TLabel;
    Line3: TLine;
    procedure LytAba1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbnegociosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lvNegociosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lblPendenteClick(Sender: TObject);
    procedure lblFinalizadaClick(Sender: TObject);
    procedure lvtarefasItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    menu_Negocio:TActionSheet;
    menu_tarefa:TActionSheet;
    procedure mudarAba(aba: Integer);
    procedure listarNegociosResumo();
    procedure NegociosResumoTerminate(Sender: TObject);
    procedure AddEtapaNegocio(etapa: string; qtd: integer; valor: double);
    procedure addNegociosListView(id_negocio:integer; descricao , empresa : string; valor:double);
    procedure    listarNegocios(Item:string);
    procedure NegociosTerminate(Sender: TObject);
    procedure montaDeshBoard();
    procedure MontarGrafico(json_array: TJsonArray);
    procedure DashboardTerminate(Sender: TObject);
    procedure ClickNegocioExcluir(Sender: TObject);
    procedure ClickTarefaExcluir(Sender: TObject);
    procedure ClickTarefaNova(Sender: TObject);
    procedure ClickNegocioEditar(Sender: TObject);
    procedure selecionaFiltroTarefa(lbl:TLabel);
    procedure ListarTarefas(status: string);
    procedure AddTarefaListview(id_tarefa: integer; tarefa, descricao,
      dt_tarefa, hora, ind_concluido: string);
    function StringUTCToDate(str: string): TDate;
    procedure TarefaTerminate(Sender: TObject);
    procedure ClickTarefaNaoFinalizada(Sender: TObject);
    procedure ClickTarefaFinalizada(Sender: TObject);
    procedure StatusTarefa(id_tarefa: integer; ind_concluido: string);
    procedure TarefaStatusTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitNegocioCad;

procedure TFrmPrincipal.addNegociosListView(id_negocio: integer; descricao,
  empresa: string; valor: double);
var
  item:TListViewItem;
begin
  item:= lvNegocios.Items.Add;
  item.Height:= 60;
  item.TagString:= id_negocio.ToString;

  TListItemText(item.Objects.FindDrawable('txtDescricao')).Text:= descricao;
  TListItemText(item.Objects.FindDrawable('txtEmpresa')).Text:= empresa;
  TListItemText(item.Objects.FindDrawable('txtValor')).text:= FormatFloat('###,##0.00',valor);
  TListItemImage(item.Objects.FindDrawable('imgEmpresa')).Bitmap:= imgContato.Bitmap;

end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  TSession.ID_USUARIO:= 1;
  montaDeshBoard;


    // Menu negocio...
    menu_negocio := TActionSheet.Create(FrmPrincipal);
    menu_negocio.TitleFontSize := 12;
    menu_negocio.TitleMenuText := 'Negócios';
    menu_negocio.TitleFontColor := $FFA3A3A3;

    menu_negocio.CancelMenuText := 'Cancelar';
    menu_negocio.CancelFontSize := 15;
    menu_negocio.CancelFontColor := $FF4162FF;

    menu_negocio.BackgroundOpacity := 0.5;
    menu_negocio.MenuColor := $FFFFFFFF;

    menu_negocio.AddItem('', 'Excluir', ClickNegocioExcluir, $FFDA4F3F, 15);
    menu_negocio.AddItem('', 'Adicionar Tarefa', ClickTarefaNova, $FF4162FF, 15);
    menu_negocio.AddItem('', 'Editar', ClickNegocioEditar, $FF4162FF, 15);


    // Menu tarefas...
    menu_tarefa := TActionSheet.Create(FrmPrincipal);
    menu_tarefa.TitleFontSize := 12;
    menu_tarefa.TitleMenuText := 'Tarefas';
    menu_tarefa.TitleFontColor := $FFA3A3A3;

    menu_tarefa.CancelMenuText := 'Cancelar';
    menu_tarefa.CancelFontSize := 15;
    menu_tarefa.CancelFontColor := $FF4162FF;

    menu_tarefa.BackgroundOpacity := 0.5;
    menu_tarefa.MenuColor := $FFFFFFFF;

    menu_tarefa.AddItem('', 'Excluir', ClickTarefaExcluir, $FFDA4F3F, 15);
    menu_tarefa.AddItem('', 'Tarefa Não Finalizada', ClickTarefaNaoFinalizada, $FF4162FF, 15);
    menu_tarefa.AddItem('', 'Tarefa Finalizada', ClickTarefaFinalizada, $FF4162FF, 15);
end;

procedure TFrmPrincipal.lblFinalizadaClick(Sender: TObject);
begin
    selecionaFiltroTarefa(TLabel(Sender));
end;

procedure TFrmPrincipal.lblPendenteClick(Sender: TObject);
begin
  selecionaFiltroTarefa(TLabel(Sender));
end;

procedure TFrmPrincipal.lbnegociosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
   listarNegocios(Item.TagString)
end;



procedure TFrmPrincipal.listarNegocios(Item: string);
var
  t:TThread;
begin
  TLoading.Show(Self,'Aguarde...');

  lvnegocios.BeginUpdate;
  lvnegocios.Items.Clear;

  t:= TThread.CreateAnonymousThread(
   procedure
   begin
     DmGlobal.ListarNegocios(Item, TSession.ID_USUARIO) ;
     TThread.Synchronize(TThread.CurrentThread, procedure
     begin
       while not DmGlobal.TabNegocios.Eof do
       begin
          addNegociosListView( DmGlobal.TabNegocios.fieldbyname('id_negocio').AsInteger,
                                DmGlobal.TabNegocios.fieldbyname('descricao').AsString,
                                DmGlobal.TabNegocios.fieldbyname('empresa').AsString,
                                DmGlobal.TabNegocios.fieldbyname('valor').AsFloat);



         DmGlobal.TabNegocios.Next;
       end;

        DmGlobal.TabNegocios.Close;
     end);
   end

  );

  t.onterminate:= NegociosTerminate;
  t.Start;


end;

procedure TFrmPrincipal.listarNegociosResumo;
var
  t:TThread;
begin
  TLoading.Show(Self,'Aguarde...');

  lbnegocios.BeginUpdate;
  lbnegocios.Items.Clear;

  t:= TThread.CreateAnonymousThread(
   procedure
   begin
     DmGlobal.ListarNegociosResumo(TSession.ID_USUARIO) ;
     TThread.Synchronize(TThread.CurrentThread, procedure
     begin
       while not DmGlobal.TabNegociosResumo.Eof do
       begin
          AddEtapaNegocio(DmGlobal.TabNegociosResumo.fieldbyname('etapa').asstring,
                                  DmGlobal.TabNegociosResumo.fieldbyname('qtd').asinteger,
                                  DmGlobal.TabNegociosResumo.fieldbyname('valor').asfloat);



         DmGlobal.TabNegociosResumo.Next;
       end;
        lbnegocios.ItemIndex:=0;
        DmGlobal.TabNegociosResumo.Close;
     end);
   end

  );

  t.onterminate:= NegociosResumoTerminate;
  t.Start;


end;


procedure TFrmPrincipal.lvNegociosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  menu_Negocio.Tag:= AItem.Index;
  menu_negocio.TagString:= AItem.TagString; //id_negocio.

  menu_Negocio.ShowMenu;
end;

procedure TFrmPrincipal.lvtarefasItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    menu_tarefa.Tag := AItem.Index;
    menu_tarefa.TagString := Aitem.TagString; // id_tarefa
    menu_tarefa.ShowMenu;
end;

procedure TFrmPrincipal.NegociosTerminate(Sender: TObject);
begin
    lvNegocios.EndUpdate;
    TLoading.Hide;

    // Verifica se deu erro na thread...
    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;


end;



procedure TFrmPrincipal.selecionaFiltroTarefa(lbl: TLabel);
begin
  rectStatusTarefa.Width:= lbl.Width;
  // rectStatusTarefa.Position.X:= lbl.Position.X;
  TAnimator.AnimateFloat(rectStatusTarefa,'position.x',lbl.Position.X,0.2,TAnimationType.InOut,TInterpolationType.Circular);

  ListarTarefas(lbl.Text);
end;

procedure TFrmPrincipal.NegociosResumoTerminate(Sender: TObject);
begin
    lbNegocios.EndUpdate;
    TLoading.Hide;

    // Verifica se deu erro na thread...
    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;

   // ListarNegocios(lbNegocios.ItemByIndex(0).tagstring);
end;

procedure TFrmPrincipal.LytAba1Click(Sender: TObject);
begin
  mudarAba(TLayout(Sender).Tag);
  montaDeshBoard;
end;

procedure TFrmPrincipal.montaDeshBoard;
var
    t: TThread;
    json_array: TJSONArray;
begin
 //   lblDash1Valor.Text := '---';
 //   lblDash1Qtd.Text := '---';
 //   lblDash2Valor.Text := '---';
  //  lblDash2Qtd.Text := '---';

    TLoading.Show(FrmPrincipal, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(1000);
        DmGlobal.DashboardResumos(TSession.ID_USUARIO);
        json_array := DmGlobal.DashboardAnual(TSession.ID_USUARIO);

        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
            lblDash1Valor.Text := FormatFloat('R$#,##0.00', DmGlobal.TabDashboard.fieldbyname('valor_mes').asfloat);
         //   lblDash1Qtd.Text := FormatFloat('(#,## negócios)', DmGlobal.TabDashboard.fieldbyname('qtd_mes').asfloat);
            lblDash2Valor.Text := FormatFloat('(R$#,##0.00)', DmGlobal.TabDashboard.fieldbyname('valor_dia').asfloat);
           // lblDash2Qtd.Text := FormatFloat('#,## atividades', DmGlobal.TabDashboard.fieldbyname('qtd_dia').asfloat);

            // Montar grafico...
            MontarGrafico(json_array);
        end);

    end);

    t.OnTerminate := DashboardTerminate;
    t.Start;
end;

procedure TfrmPrincipal.mudarAba(aba:Integer);
begin
  LytAba1.Opacity:= 0.5;
  LayAba2.Opacity:= 0.5;
  LayAba3.Opacity:= 0.5;
  layAba4.Opacity:= 0.5;

  case aba of
    0: LytAba1.Opacity:= 1;
    1: begin
       LayAba2.Opacity:= 1;
       listarNegociosResumo;
       end;
    2: LayAba3.Opacity:= 1;
    3: layAba4.Opacity:= 1;

  end;


  TabControl1.GotoVisibleTab(aba);

end;


procedure TFrmPrincipal.AddEtapaNegocio(etapa: string;
                                        qtd: integer;
                                        valor: double);
var
    f: TFrameNegocio;
    item: TListBoxItem;
begin
    item := TListBoxItem.Create(lbNegocios);
    item.Width := 150;
    item.TagString := etapa;

    f := TFrameNegocio.Create(item);
    f.lblEtapa.Text := etapa;
    f.lblQtd.Text := FormatFloat('#,## negócios', qtd);
    f.lblValor.Text := FormatFloat('R$#,##0.00', valor);

    item.AddObject(f);

    lbNegocios.AddObject(item);
end;


procedure TFrmPrincipal.MontarGrafico(json_array: TJsonArray);
var
    chart: TSuperChart;
    erro: string;
begin
    try
        chart := TSuperChart.Create(lytGrafico, Lines);

        // Valores...
        chart.ShowValues := true;
        chart.FontSizeValues := 10;
        chart.FontColorValues := $FFFFFFFF;
        chart.FormatValues := '#,##0.00';

        // Linhas...
        chart.LineColor := $FF5467FB;
        chart.FontColorValues := $FF5467FB;

        // Argumentos...
        chart.FontSizeArgument := 8;
        chart.FontColorArgument := $FF656565;

        // Render grafico...
        chart.LoadFromJSON(json_array.ToJSON, erro);

        if NOT erro.IsEmpty then
            showmessage(erro);
    finally
        chart.DisposeOf;
    end;
end;

procedure TFrmPrincipal.DashboardTerminate(Sender: TObject);
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


procedure TFrmPrincipal.ClickNegocioExcluir(Sender: TObject);
begin
    menu_negocio.HideMenu;

    TDialogService.MessageDialog('Confirma exclusão do negócio?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
                     procedure(const AResult: TModalResult)
                     begin
                        if AResult = mrYes then
                        begin
                            try
                                DmGlobal.ExcluirNegocio(menu_negocio.TagString.ToInteger);
                                lvNegocios.Items.Delete(menu_negocio.Tag);

                            except on ex:exception do
                                showmessage('Erro ao excluir negócio: ' + ex.Message);
                            end;
                        end;
                     end);
end;


procedure TFrmPrincipal.ClickTarefaNova(Sender: TObject);
begin
    menu_negocio.HideMenu;

    if NOT Assigned(FrmTarefaCad) then
        Application.CreateForm(TFrmTarefaCad, FrmTarefaCad);

    FrmTarefaCad.Show;
end;

procedure TFrmPrincipal.ClickTarefaExcluir(Sender: TObject);
begin
   // menu_tarefa.HideMenu;

    TDialogService.MessageDialog('Confirma exclusão da tarefa?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
                     procedure(const AResult: TModalResult)
                     begin
                        if AResult = mrYes then
                        begin
                            try
                            //    DmGlobal.ExcluirTarefa(menu_tarefa.TagString.ToInteger);
                              //  lvTarefas.Items.Delete(menu_tarefa.Tag);

                            except on ex:exception do
                                showmessage('Erro ao excluir tarefa: ' + ex.Message);
                            end;
                        end;
                     end);
end;


procedure TFrmPrincipal.ClickNegocioEditar(Sender: TObject);
begin
    menu_negocio.HideMenu;

    if NOT Assigned(FrmNegocioCad) then
        Application.CreateForm(TFrmNegocioCad, FrmNegocioCad);

    FrmNegocioCad.id_negocio := menu_negocio.TagString.ToInteger;
    FrmNegocioCad.Show;
end;

procedure TFrmPrincipal.ListarTarefas(status: string);
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, '');

    lvTarefas.BeginUpdate;
    lvTarefas.Items.Clear;

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(1000);

        // Lista as tarefas...
        DmGlobal.ListarTarefas(IfThen(status = 'Pendente', 'N', 'S'), TSession.ID_USUARIO);

        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
            while NOT DmGlobal.TabTarefas.eof do
            begin
                AddTarefaListview(DmGlobal.TabTarefas.fieldbyname('idtarefa').AsInteger,
                                   DmGlobal.TabTarefas.fieldbyname('tarefa').asstring,
                                   DmGlobal.TabTarefas.fieldbyname('descricao').asstring,
                                   FormatDateTime('dd/mm/yyyy', StringUTCToDate(DmGlobal.TabTarefas.fieldbyname('dttarefa').asstring)),
                                   DmGlobal.TabTarefas.fieldbyname('hora').asstring,
                                   DmGlobal.TabTarefas.fieldbyname('indconcluido').asstring);


                DmGlobal.TabTarefas.Next;
            end;
            DmGlobal.TabTarefas.Close;
        end);
    end);

    t.OnTerminate := TarefaTerminate;
    t.Start;
end;


procedure TFrmPrincipal.AddTarefaListview(id_tarefa: integer;
                                          tarefa, descricao, dt_tarefa, hora, ind_concluido: string);
var
    item: TListViewItem;
begin
    item := lvtarefas.Items.Add;
    item.Height := 80;
    item.TagString := id_tarefa.tostring;

    TListItemText(item.Objects.FindDrawable('txtTarefa')).Text := tarefa;
    TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := descricao;
    TListItemText(item.Objects.FindDrawable('txtData')).Text := dt_tarefa + ' - ' + hora + 'h';
    TListItemImage(item.Objects.FindDrawable('imgData')).Bitmap := imgData.Bitmap;

    if ind_concluido = 'S' then
        TListItemImage(item.Objects.FindDrawable('imgFinalizado')).Bitmap := imgFinalizado.Bitmap;
end;


function TFrmPrincipal.StringUTCToDate(str: string): TDate;
var
    ano, mes, dia, hora, minuto, seg: integer;
begin
    try
        ano := Copy(str, 1, 4).ToInteger;
        mes := Copy(str, 6, 2).ToInteger;
        dia := Copy(str, 9, 2).ToInteger;
        hora := Copy(str, 12, 2).ToInteger;
        minuto := Copy(str, 15, 2).ToInteger;
        seg := Copy(str, 18, 2).ToInteger;

        Result := EncodeDateTime(ano, mes, dia, hora, minuto, seg, 0);
    except
        Result := 0;
    end;
end;


procedure TFrmPrincipal.TarefaTerminate(Sender: TObject);
begin
    lvTarefas.EndUpdate;
    TLoading.Hide;

    // Verifica se deu erro na thread...
    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
end;

procedure TFrmPrincipal.ClickTarefaNaoFinalizada(Sender: TObject);
begin
    menu_tarefa.HideMenu;

    StatusTarefa(menu_tarefa.TagString.ToInteger, 'N');
end;

procedure TFrmPrincipal.ClickTarefaFinalizada(Sender: TObject);
begin
    menu_tarefa.HideMenu;

    StatusTarefa(menu_tarefa.TagString.ToInteger, 'S');
end;

procedure TFrmPrincipal.StatusTarefa(id_tarefa: integer; ind_concluido: string);
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, '');

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(1500);

        // Enviar os dados da tarefa p/ server...
        DmGlobal.StatusTarefa(id_tarefa, ind_concluido);
    end);

    t.OnTerminate := TarefaStatusTerminate;
    t.Start;
end;


procedure TFrmPrincipal.TarefaStatusTerminate(Sender: TObject);
begin
    TLoading.Hide;

    // Verifica se deu erro na thread...
    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;

    lvTarefas.Items.Delete(menu_tarefa.Tag);
end;

end.

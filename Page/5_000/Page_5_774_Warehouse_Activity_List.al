OBJECT Page 5774 Warehouse Activity List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Lageraktivitetsoversigt;
               ENU=Warehouse Activity List];
    SourceTable=Table5766;
    PageType=List;
    OnOpenPage=BEGIN
                 ErrorIfUserIsNotWhseEmployee;
               END;

    OnFindRecord=BEGIN
                   EXIT(FindFirstAllowedRec(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(FindNextAllowedRec(Steps));
                 END;

    OnAfterGetCurrRecord=BEGIN
                           CurrPage.CAPTION := FormCaption;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 18      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Warehouse;
                      Image=EditLines;
                      OnAction=BEGIN
                                 CASE Type OF
                                   Type::"Put-away":
                                     PAGE.RUN(PAGE::"Warehouse Put-away",Rec);
                                   Type::Pick:
                                     PAGE.RUN(PAGE::"Warehouse Pick",Rec);
                                   Type::Movement:
                                     PAGE.RUN(PAGE::"Warehouse Movement",Rec);
                                   Type::"Invt. Put-away":
                                     PAGE.RUN(PAGE::"Inventory Put-away",Rec);
                                   Type::"Invt. Pick":
                                     PAGE.RUN(PAGE::"Inventory Pick",Rec);
                                   Type::"Invt. Movement":
                                     PAGE.RUN(PAGE::"Inventory Movement",Rec);
                                 END;
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903358206;1 ;Action    ;
                      CaptionML=[DAN=L‘g-p†-lager-oversigt;
                                 ENU=Put-away List];
                      ToolTipML=[DAN=F† vist eller udskriv en detaljeret liste over varer, som skal l‘gges p† lager.;
                                 ENU=View or print a detailed list of items that must be put away.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 5751;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905733806;1 ;Action    ;
                      CaptionML=[DAN=Plukliste;
                                 ENU=Picking List];
                      ToolTipML=[DAN=F† vist eller udskriv en detaljeret liste over varer, som skal plukkes.;
                                 ENU=View or print a detailed list of items that must be picked.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 5752;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906867906;1 ;Action    ;
                      CaptionML=[DAN=Bev‘gelsesoversigt (logistik);
                                 ENU=Warehouse Movement List];
                      ToolTipML=[DAN=F† vist eller udskriv en detaljeret liste over varer, som skal flyttes inden for lageret.;
                                 ENU=View or print a detailed list of items that must be moved within the warehouse.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 7301;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type aktivitet, eksempelvis l‘g-p†-lager, som lagerstedet udf›rer for de linjer, der er knyttet til hovedet.;
                           ENU=Specifies the type of activity, such as Put-away, that the warehouse performs on the lines that are attached to the header.];
                ApplicationArea=#Warehouse;
                SourceExpr=Type;
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor lageraktiviteten finder sted.;
                           ENU=Specifies the code for the location where the warehouse activity takes place.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om den destinationstype, f.eks. debitor eller kreditor, som er knyttet til lageraktiviteten.;
                           ENU=Specifies information about the type of destination, such as customer or vendor, associated with the warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer eller den kode for debitoren eller kreditoren, som linjen er tilknyttet.;
                           ENU=Specifies the number or the code of the customer or vendor that the line is linked to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No." }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No." }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af linjer i lageraktivitetsdokumentet.;
                           ENU=Specifies the number of lines in the warehouse activity document.];
                ApplicationArea=#Warehouse;
                SourceExpr="No. of Lines" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan linjerne sorteres i lagerhovedet, f.eks. efter Vare eller Bilag.;
                           ENU=Specifies the method by which the lines are sorted on the warehouse header, such as Item or Document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text000@1002 : TextConst 'DAN=L‘g-p†-lager-oversigt (logistik);ENU=Warehouse Put-away List';
      Text001@1003 : TextConst 'DAN=Plukliste (logistik);ENU=Warehouse Pick List';
      Text002@1004 : TextConst 'DAN=Bev‘gelsesoversigt (logistik);ENU=Warehouse Movement List';
      Text003@1005 : TextConst 'DAN=Lageraktivitetsoversigt;ENU=Warehouse Activity List';
      Text004@1006 : TextConst 'DAN=L‘g-p†-lager-oversigt (lager);ENU=Inventory Put-away List';
      Text005@1007 : TextConst 'DAN=Plukliste (lager);ENU=Inventory Pick List';
      Text006@1000 : TextConst 'DAN=Liste flytning (lager);ENU=Inventory Movement List';

    LOCAL PROCEDURE FormCaption@1() : Text[250];
    BEGIN
      CASE Type OF
        Type::"Put-away":
          EXIT(Text000);
        Type::Pick:
          EXIT(Text001);
        Type::Movement:
          EXIT(Text002);
        Type::"Invt. Put-away":
          EXIT(Text004);
        Type::"Invt. Pick":
          EXIT(Text005);
        Type::"Invt. Movement":
          EXIT(Text006);
        ELSE
          EXIT(Text003);
      END;
    END;

    BEGIN
    END.
  }
}


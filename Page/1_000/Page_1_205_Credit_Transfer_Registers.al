OBJECT Page 1205 Credit Transfer Registers
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditoverf›rselsjournaler;
               ENU=Credit Transfer Registers];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table1205;
    PageType=List;
    ActionList=ACTIONS
    {
      { 11      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 12      ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Poster;
                                 ENU=Entries];
                      ToolTipML=[DAN=Angiv de kreditoverf›rselsposter, der er relateret til betalingsfileksport for udvalgte kreditoverf›rsler.;
                                 ENU=Specify the credit transfer entries that are related to the payment file export for a selected credit transfer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1206;
                      RunPageLink=Credit Transfer Register No.=FIELD(No.);
                      Promoted=Yes;
                      Image=List;
                      PromotedCategory=Process }
      { 17      ;1   ;Action    ;
                      Name=ReexportHistory;
                      CaptionML=[DAN=Historik for reeksporterede betalinger;
                                 ENU=Reexported Payments History];
                      ToolTipML=[DAN=Se en liste med betalingsfiler, der allerede er blevet reeksporteret.;
                                 ENU=View a list of payment files that have already been re-exported.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 1209;
                      RunPageLink=Credit Transfer Register No.=FIELD(No.);
                      Promoted=Yes;
                      Image=History;
                      PromotedCategory=Process }
      { 18      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Reeksport‚r betalinger til fil;
                                 ENU=Reexport Payments to File];
                      ToolTipML=[DAN=Eksport betalinger for de udvalgte kreditoverf›rsler til en bankfil. Betalingerne blev oprindeligt eksporteret fra vinduet Udbetalingskladde.;
                                 ENU=Export payments for the selected credit transfers to a bank file. The payments were originally exported from the Payment Journal window.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ExportElectronicDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Reexport
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et serienummer for en vellykket kreditoverf›rsel. Mislykkede fileksporter udelukkes fra sekvensen af serienumre. Du kan finde flere oplysninger i feltet Status.;
                           ENU=Specifies a serial number for a successful credit transfer. Failed file exports are excluded from the sequence of serial numbers. For more information, see the Status field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Identifier;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Oprettet dato/klokkesl‘t;
                           ENU=Created Date-Time];
                ToolTipML=[DAN=Angiver, hvorn†r kreditoverf›rslen blev gennemf›rt.;
                           ENU=Specifies when the credit transfer was made.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=FORMAT("Created Date-Time");
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bruger, som gennemf›rte kreditoverf›rslen.;
                           ENU=Specifies which user made the credit transfer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Created by User";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for betalingsfileksporten for denne kreditoverf›rsel. Dette felt er skrivebeskyttet.;
                           ENU=Specifies the status of the payment file export for this credit transfer. The field is read-only.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange kreditoverf›rsler den eksporterede fil d‘kker.;
                           ENU=Specifies how many credit transfers the exported file covers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Transfers";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer i, hvorfra kreditoverf›rslen blev udf›rt.;
                           ENU=Specifies the number of your bank account from which the credit transfer was made.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="From Bank Account No.";
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den bankkonto, hvorfra kreditoverf›rslen blev udf›rt.;
                           ENU=Specifies the name of your bank account from which the credit transfer was made.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="From Bank Account Name";
                Editable=FALSE }

    { 8   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 9   ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

    { 10  ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {

    BEGIN
    END.
  }
}


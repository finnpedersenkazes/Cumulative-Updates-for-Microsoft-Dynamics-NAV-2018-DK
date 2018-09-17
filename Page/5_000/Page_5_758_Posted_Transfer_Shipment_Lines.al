OBJECT Page 5758 Posted Transfer Shipment Lines
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
    CaptionML=[DAN=Bogfõrte overflytn.lev.linjer;
               ENU=Posted Transfer Shipment Lines];
    SourceTable=Table5745;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       DocumentNoHideValue := FALSE;
                       DocumentNoOnFormat;
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
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Location;
                      Image=View;
                      OnAction=VAR
                                 TransShptHeader@1001 : Record 5744;
                               BEGIN
                                 TransShptHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Posted Transfer Shipment",TransShptHeader);
                               END;
                                }
      { 19      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Location;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bilagsnummer, der er knyttet til overflytningslinjen.;
                           ENU=Specifies the document number associated with this transfer line.];
                ApplicationArea=#Location;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, der skal overflyttes.;
                           ENU=Specifies the number of the item that will be transferred.];
                ApplicationArea=#Location;
                SourceExpr="Item No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Location;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varen, der er angivet pÜ linjen.;
                           ENU=Specifies the quantity of the item specified on the line.];
                ApplicationArea=#Location;
                SourceExpr=Quantity }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Location;
                SourceExpr="Unit of Measure" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Location;
                SourceExpr="Shipment Date" }

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
      TempTransShptLine@1000 : TEMPORARY Record 5745;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    LOCAL PROCEDURE IsFirstLine@2(DocNo@1000 : Code[20];LineNo@1001 : Integer) : Boolean;
    VAR
      TransShptLine@1002 : Record 5745;
    BEGIN
      TempTransShptLine.RESET;
      TempTransShptLine.COPYFILTERS(Rec);
      TempTransShptLine.SETRANGE("Document No.",DocNo);
      IF NOT TempTransShptLine.FINDFIRST THEN BEGIN
        TransShptLine.COPYFILTERS(Rec);
        TransShptLine.SETRANGE("Document No.",DocNo);
        TransShptLine.FINDFIRST;
        TempTransShptLine := TransShptLine;
        TempTransShptLine.INSERT;
      END;
      IF TempTransShptLine."Line No." = LineNo THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE DocumentNoOnFormat@19001080();
    BEGIN
      IF NOT IsFirstLine("Document No.","Line No.") THEN
        DocumentNoHideValue := TRUE;
    END;

    BEGIN
    END.
  }
}


OBJECT Page 5759 Posted Transfer Receipt Lines
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
    CaptionML=[DAN=Bogfõrte overflytn.kvit.linjer;
               ENU=Posted Transfer Receipt Lines];
    SourceTable=Table5747;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       DocumentNoHideValue := FALSE;
                       DocumentNoOnFormat;
                     END;

    OnQueryClosePage=BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                         LookupOKOnPush;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 19      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Location;
                      Image=View;
                      OnAction=VAR
                                 TransRcptHeader@1001 : Record 5746;
                               BEGIN
                                 TransRcptHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Posted Transfer Receipt",TransRcptHeader);
                               END;
                                }
      { 20      ;2   ;Action    ;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, du vil overflytte.;
                           ENU=Specifies the number of the item that you want to transfer.];
                ApplicationArea=#Location;
                SourceExpr="Item No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den vare, der overflyttes.;
                           ENU=Specifies the description of the item being transferred.];
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
                ToolTipML=[DAN=Angiver modtagelsesdatoen for overflytningsmodtagelseslinjen.;
                           ENU=Specifies the receipt date of the transfer receipt line.];
                ApplicationArea=#Location;
                SourceExpr="Receipt Date" }

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
      FromTransRcptLine@1000 : Record 5747;
      TempTransRcptLine@1001 : TEMPORARY Record 5747;
      ItemChargeAssgntPurch@1002 : Record 5805;
      AssignItemChargePurch@1003 : Codeunit 5805;
      UnitCost@1004 : Decimal;
      CreateCostDistrib@1005 : Boolean;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    [External]
    PROCEDURE Initialize@1(NewItemChargeAssgntPurch@1000 : Record 5805;NewUnitCost@1001 : Decimal);
    BEGIN
      ItemChargeAssgntPurch := NewItemChargeAssgntPurch;
      UnitCost := NewUnitCost;
      CreateCostDistrib := TRUE;
    END;

    LOCAL PROCEDURE IsFirstLine@2(DocNo@1000 : Code[20];LineNo@1001 : Integer) : Boolean;
    VAR
      TransRcptLine@1002 : Record 5747;
    BEGIN
      TempTransRcptLine.RESET;
      TempTransRcptLine.COPYFILTERS(Rec);
      TempTransRcptLine.SETRANGE("Document No.",DocNo);
      IF NOT TempTransRcptLine.FINDFIRST THEN BEGIN
        TransRcptLine.COPYFILTERS(Rec);
        TransRcptLine.SETRANGE("Document No.",DocNo);
        TransRcptLine.FINDFIRST;
        TempTransRcptLine := TransRcptLine;
        TempTransRcptLine.INSERT;
      END;
      IF TempTransRcptLine."Line No." = LineNo THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE LookupOKOnPush@19031339();
    BEGIN
      IF CreateCostDistrib THEN BEGIN
        FromTransRcptLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(FromTransRcptLine);
        IF FromTransRcptLine.FINDFIRST THEN BEGIN
          ItemChargeAssgntPurch."Unit Cost" := UnitCost;
          AssignItemChargePurch.CreateTransferRcptChargeAssgnt(FromTransRcptLine,ItemChargeAssgntPurch);
        END;
      END;
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


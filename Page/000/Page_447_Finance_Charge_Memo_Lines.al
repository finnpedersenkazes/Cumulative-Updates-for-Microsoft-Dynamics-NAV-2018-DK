OBJECT Page 447 Finance Charge Memo Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table303;
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnAfterGetCurrRecord=BEGIN
                           SetShowMandatoryConditions;
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1900206104;2 ;Action    ;
                      AccessByPermission=TableData 279=R;
                      CaptionML=[DAN=&Inds‘t udv. tekster;
                                 ENU=Insert &Ext. Texts];
                      ToolTipML=[DAN=Inds‘t den forl‘ngede varebeskrivelse, som h›rer til varen, der behandles p† linjen.;
                                 ENU=Insert the extended item description that is set up for the item that is being processed on the line.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Text;
                      OnAction=BEGIN
                                 InsertExtendedText(TRUE);
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

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type;
                OnValidate=BEGIN
                             TypeOnAfterValidate;
                             NoOnAfterValidate;
                             SetShowMandatoryConditions
                           END;

                ShowMandatory=TRUE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                OnValidate=BEGIN
                             NoOnAfterValidate;
                           END;

                ShowMandatory=TypeIsGLAccount }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for den debitorpost, som denne rentenotalinje vedr›rer.;
                           ENU=Specifies the posting date of the customer ledger entry that this finance charge memo line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dokumenttypen for den debitorpost, som denne rentenotalinje vedr›rer.;
                           ENU=Specifies the document type of the customer ledger entry this finance charge memo line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                OnValidate=BEGIN
                             DocumentTypeOnAfterValidate;
                           END;

                ShowMandatory=TypeIsCustomerLedgerEntry }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for den debitorpost, som denne rentenotalinje vedr›rer.;
                           ENU=Specifies the document number of the customer ledger entry this finance charge memo line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                OnValidate=BEGIN
                             DocumentNoOnAfterValidate;
                           END;

                ShowMandatory=TypeIsCustomerLedgerEntry }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for den debitorpost, som denne rentenotalinje vedr›rer.;
                           ENU=Specifies the due date of the customer ledger entry this finance charge memo line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en postbeskrivelse, som er baseret p† indholdet af feltet Type.;
                           ENU=Specifies an entry description, based on the contents of the Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det oprindelige bel›b for den debitorpost, som denne rentenotalinje vedr›rer.;
                           ENU=Specifies the original amount of the customer ledger entry that this finance charge memo line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Original Amount";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver restbel›bet for den debitorpost, som denne rentenotalinje vedr›rer.;
                           ENU=Specifies the remaining amount of the customer ledger entry this finance charge memo line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet i den valuta, som er repr‘senteret ved valutakoden p† rentenotahovedet.;
                           ENU=Specifies the amount in the currency that is represented by the currency code on the finance charge memo header.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN="Angiver kontokoden for debitoren. ";
                           ENU="Specifies the account code of the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      TransferExtendedText@1000 : Codeunit 378;
      TypeIsGLAccount@1001 : Boolean;
      TypeIsCustomerLedgerEntry@1002 : Boolean;

    LOCAL PROCEDURE InsertExtendedText@5(Unconditionally@1000 : Boolean);
    BEGIN
      IF TransferExtendedText.FinChrgMemoCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
        CurrPage.SAVERECORD;
        TransferExtendedText.InsertFinChrgMemoExtText(Rec);
      END;
      IF TransferExtendedText.MakeUpdate THEN
        CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE FormUpdateAttachedLines@3();
    BEGIN
      IF CheckAttachedLines THEN BEGIN
        CurrPage.SAVERECORD;
        UpdateAttachedLines;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    PROCEDURE UpdateForm@1101100000(SetSaveRecord@1000 : Boolean);
    BEGIN
      CurrPage.UPDATE(SetSaveRecord);
    END;

    LOCAL PROCEDURE TypeOnAfterValidate@19069045();
    BEGIN
      InsertExtendedText(FALSE);
      FormUpdateAttachedLines;
    END;

    LOCAL PROCEDURE NoOnAfterValidate@19066594();
    BEGIN
      InsertExtendedText(FALSE);
    END;

    LOCAL PROCEDURE DocumentTypeOnAfterValidate@19030163();
    BEGIN
      FormUpdateAttachedLines;
    END;

    LOCAL PROCEDURE DocumentNoOnAfterValidate@19031352();
    BEGIN
      FormUpdateAttachedLines;
    END;

    LOCAL PROCEDURE SetShowMandatoryConditions@1();
    BEGIN
      TypeIsGLAccount := Type = Type::"G/L Account";
      TypeIsCustomerLedgerEntry := Type = Type::"Customer Ledger Entry"
    END;

    BEGIN
    END.
  }
}


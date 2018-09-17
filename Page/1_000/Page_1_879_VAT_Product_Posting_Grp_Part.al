OBJECT Page 1879 VAT Product Posting Grp Part
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Del til momsproduktbogf›ringsgruppe;
               ENU=VAT Product Posting Grp Part];
    SourceTable=Table1877;
    PageType=ListPart;
    OnOpenPage=BEGIN
                 VATNotification.ID := FORMAT(CREATEGUID);
                 PopulateVATProdGroups;
                 ShowVATRates;
               END;

    OnNewRecord=BEGIN
                  VALIDATE(Selected,TRUE);
                  VALIDATE("Application Type","Application Type"::Items);
                END;

    OnInsertRecord=BEGIN
                     IF VATAccountsGroup OR VATClausesGroup THEN
                       ERROR(VATAddIsNotallowedErr);
                   END;

    OnDeleteRecord=BEGIN
                     IF CheckExistingItemAndServiceWithVAT("VAT Prod. Posting Group","Application Type" = "Application Type"::Services ) THEN BEGIN
                       TrigerNotification(VATDeleteIsNotallowedErr);
                       EXIT(FALSE);
                     END;
                     IF VATAccountsGroup OR VATClausesGroup THEN BEGIN
                       SETRANGE(Selected,TRUE);
                       IF COUNT = 1 THEN BEGIN
                         TrigerNotification(VATEmptyErrorMsg);
                         EXIT(FALSE);
                       END;
                     END;
                   END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil medtage momsproduktbogf›ringsgruppen p† linjen.;
                           ENU=Specifies whether to include the VAT product posting group on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Selected;
                Visible=VATRatesGroup;
                OnValidate=BEGIN
                             IF Selected THEN
                               EXIT;

                             IF CheckExistingItemAndServiceWithVAT(xRec."VAT Prod. Posting Group",xRec."Application Type" = "Application Type"::Services) THEN BEGIN
                               TrigerNotification(VATDeleteIsNotallowedErr);
                               ERROR('');
                             END;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                OnValidate=BEGIN
                             IF CheckExistingItemAndServiceWithVAT(xRec."VAT Prod. Posting Group",xRec."Application Type" = "Application Type"::Services) THEN BEGIN
                               TrigerNotification(VATDeleteIsNotallowedErr);
                               ERROR('');
                             END;
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan en omkostningsmodtager er tilknyttet til omkostningskilden for at udf›re omkostningsvideresendelse i henhold til kostmetoden.;
                           ENU=Specifies how a cost recipient is linked to its cost source to provide cost forwarding according to the costing method.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Application Type";
                Visible=VATRatesGroup;
                OnValidate=BEGIN
                             IF CheckExistingItemAndServiceWithVAT(xRec."VAT Prod. Posting Group",xRec."Application Type" = "Application Type"::Services) THEN BEGIN
                               TrigerNotification(VATDeleteIsNotallowedErr);
                               ERROR('');
                             END;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af momsproduktbogf›ringsgruppen.;
                           ENU=Specifies a description of the VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Grp Desc.";
                Visible=VATRatesGroup }

    { 5   ;2   ;Field     ;
                Width=3;
                ToolTipML=[DAN=Angiver den anvendte momsprocent.;
                           ENU=Specifies the VAT percentage used.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT %";
                Visible=VATRatesGroup }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, hvortil der skal bogf›res salgsmoms p† for den specielle kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account number to which to post sales VAT, for the particular combination of VAT business posting group and VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales VAT Account";
                Visible=VATAccountsGroup }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, hvortil urealiseret k›bsmoms skal bogf›res.;
                           ENU=Specifies the general ledger account number to which to post purchase VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Purchase VAT Account";
                Visible=VATAccountsGroup }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen til bogf›ring af modtagermoms (k›bsmoms) for denne kombination af momsvirksomheds- og momsproduktbogf›ringsgruppen, hvis du har valgt indstillingen Modtagermoms i feltet Momsberegningstype.;
                           ENU=Specifies the general ledger account number to which you want to post reverse charge VAT (purchase VAT) for this combination of VAT business posting group and VAT product posting group, if you have selected the Reverse Charge VAT option in the VAT Calculation Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reverse Chrg. VAT Acc.";
                Visible=VATAccountsGroup }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af momsklausulen.;
                           ENU=Specifies a description of the VAT clause.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Clause Desc";
                Visible=VATClausesGroup }

  }
  CODE
  {
    VAR
      VATNotification@1007 : Notification;
      VATRatesGroup@1000 : Boolean;
      VATAccountsGroup@1001 : Boolean;
      VATClausesGroup@1002 : Boolean;
      VATAddIsNotallowedErr@1003 : TextConst 'DAN=Du kan ikke tilf›je konti nu, fordi de ikke vil indeholde indstillinger s†som momssatser. G† tilbage til siden Momssatser for varer og tjenester, tilf›j en linje, og forts‘t.;ENU=You can''t add accounts now because they won''t have settings like VAT rates. Go back to the VAT Rates for Items and Services page, add a line, and continue.';
      VATDeleteIsNotallowedErr@1004 : TextConst 'DAN=Du kan ikke slette eller ‘ndre denne momsrecord, fordi den er knyttet til en eksisterende vare.;ENU=You can''t delete or modify this VAT record because it is connected to existing item.';
      VATEmptyErrorMsg@1009 : TextConst 'DAN=Du kan ikke slette recorden, fordi momsops‘tningen ville v‘re tom.;ENU=You can''t delete the record because the VAT setup would be empty.';

    PROCEDURE ShowVATRates@1();
    BEGIN
      ResetView;
      VATRatesGroup := TRUE;
      RESET;
      CurrPage.UPDATE;
    END;

    PROCEDURE ShowVATAccounts@2();
    BEGIN
      ResetView;
      VATAccountsGroup := TRUE;
      ShowOnlySelectedSrvItem;
    END;

    PROCEDURE ShowVATClauses@3();
    BEGIN
      ResetView;
      VATClausesGroup := TRUE;
      ShowOnlySelectedSrvItem;
    END;

    LOCAL PROCEDURE ResetView@4();
    BEGIN
      VATNotification.RECALL;
      VATRatesGroup := FALSE;
      VATAccountsGroup := FALSE;
      VATClausesGroup := FALSE;
    END;

    LOCAL PROCEDURE ShowOnlySelectedSrvItem@13();
    BEGIN
      SETRANGE(Selected,TRUE);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE TrigerNotification@15(NotificationMsg@1000 : Text);
    BEGIN
      VATNotification.RECALL;
      VATNotification.MESSAGE(NotificationMsg);
      VATNotification.SEND;
    END;

    PROCEDURE HideNotification@5();
    VAR
      DummyGuid@1000 : GUID;
    BEGIN
      IF VATNotification.ID = DummyGuid THEN
        EXIT;
      VATNotification.MESSAGE := '';
      VATNotification.RECALL;
    END;

    BEGIN
    END.
  }
}


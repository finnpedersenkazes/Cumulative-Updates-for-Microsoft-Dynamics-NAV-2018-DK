OBJECT Page 473 VAT Posting Setup Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Momsbogf.ops‘tningskort;
               ENU=VAT Posting Setup Card];
    SourceTable=Table325;
    DataCaptionFields=VAT Bus. Posting Group,VAT Prod. Posting Group;
    PageType=Card;
    OnOpenPage=BEGIN
                 SetAccountsVisibility(UnrealizedVATVisible,AdjustForPmtDiscVisible);
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;Action    ;
                      Name=SuggestAccounts;
                      CaptionML=[DAN=Foresl† konti;
                                 ENU=Suggest Accounts];
                      ToolTipML=[DAN=Foresl† finanskonti for den valgte ops‘tning.;
                                 ENU=Suggest G/L Accounts for selected setup.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Default;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 SuggestSetupAccounts;
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Name=Copy;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Ko&pier;
                                 ENU=&Copy];
                      ToolTipML=[DAN=Kopier en record med udvalgte felter eller alle felter fra Skattebogf.ops‘tning til en ny record. Du skal oprette den nye record, f›r du begynder at kopiere.;
                                 ENU=Copy a record with selected fields or all fields from the Tax posting setup to a new record. Before you start to copy you have to create the new record.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Copy;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SAVERECORD;
                                 CopyVATPostingSetup.SetVATSetup(Rec);
                                 CopyVATPostingSetup.RUNMODAL;
                                 CLEAR(CopyVATPostingSetup);
                                 CurrPage.UPDATE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan moms skal beregnes ved k›b eller salg af varer med den aktuelle kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe.;
                           ENU=Specifies how VAT will be calculated for purchases or sales of items with this particular combination of VAT business posting group and VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Calculation Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den p†g‘ldende kombination af bogf›ringsf›ringsgrupper for momsvirksomheder og momsprodukter.;
                           ENU=Specifies description for this particular combination of VAT business posting group and VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den momssats, der g‘lder for den aktuelle kombination af momsvirksomhedsbogf›ringsgruppe og momsproduktbogf›ringsgruppe. Brug ikke procenttegn, n†r du indtaster momsprocenten, kun tal. Hvis momssatsen f.eks. er 25 %, skal du indtaste 25 i feltet.;
                           ENU=Specifies the relevant VAT rate for the particular combination of VAT business posting group and VAT product posting group. Do not enter the percent sign, only the number. For example, if the VAT rate is 25 %, enter 25 in this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT %" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan urealiseret moms skal administreres, dvs. moms, der er beregnet men ikke forfalden, f›r fakturaen betales.;
                           ENU=Specifies how to handle unrealized VAT, which is VAT that is calculated but not due until the invoice is paid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unrealized VAT Type";
                Visible=UnrealizedVATVisible }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for at gruppere forskellige momsbogf›ringsops‘tninger med ensartede attributter, f.eks. momsprocent.;
                           ENU=Specifies a code to group various VAT posting setups with similar attributes, for example VAT percentage.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Identifier" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den momsklausulkode, der er tilknyttet Ops‘tning af momsbogf.;
                           ENU=Specifies the VAT Clause Code that is associated with the VAT Posting Setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Clause Code" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvis denne specielle kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe skal rapporteres som tjenester i de periodiske momsrapporter.;
                           ENU=Specifies if this combination of VAT business posting group and VAT product posting group are to be reported as services in the periodic VAT reports.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EU Service" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil genberegne momsbel›b, n†r du bogf›rer betalinger, der udl›ser kontantrabatter.;
                           ENU=Specifies whether to recalculate VAT amounts when you post payments that trigger payment discounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Adjust for Payment Discount";
                Visible=AdjustForPmtDiscVisible }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bilag, der bruger denne kombinationen af momsvirksomhedsbogf›ringsgruppe og momsproduktbogf›ringsgruppe, kr‘ver et leveringscertifikat.;
                           ENU=Specifies if documents that use this combination of VAT business posting group and VAT product posting group require a certificate of supply.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Certificate of Supply Required" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momskategorien i forbindelse med afsendelse af elektroniske dokumenter. N†r du f.eks. sender salgsdokumenter via PEPPOL-tjenesten, bruges v‘rdien i dette felt til at udfylde elementet TaxApplied i leverand›rgruppen. Nummeret er baseret p† UNCL5305-standarden.;
                           ENU=Specifies the VAT category in connection with electronic document sending. For example, when you send sales documents through the PEPPOL service, the value in this field is used to populate the TaxApplied element in the Supplier group. The number is based on the UNCL5305 standard.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Tax Category" }

    { 1904305601;1;Group  ;
                CaptionML=[DAN=Salg;
                           ENU=Sales] }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, hvortil der skal bogf›res salgsmoms p† for den specielle kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account number to which to post sales VAT for the particular combination of VAT business posting group and VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales VAT Account" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, hvor ikke-realiseret salgsmoms skal bogf›res (beregnes ved bogf›ring af salgsfakturaer) med den aktuelle kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account number to which to post unrealized sales VAT (as calculated when you post sales invoices) using this particular combination of VAT business posting group and VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales VAT Unreal. Account";
                Visible=UnrealizedVATVisible }

    { 1907458401;1;Group  ;
                CaptionML=[DAN=K›b;
                           ENU=Purchases] }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, der skal bogf›res k›bsmomsen for den aktuelle kombination af virksomheds- og produktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account number to which to post purchase VAT for the particular combination of business group and product group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Purchase VAT Account" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den finanskonto, hvor urealiseret k›bsmoms skal bogf›res (beregnes ved bogf›ring af k›bsfakturaer) med den aktuelle kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe.;
                           ENU=Specifies the general ledger account number to which to post unrealized purchase VAT (as calculated when you post purchase invoices) using this particular combination of VAT business posting group and VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Purch. VAT Unreal. Account";
                Visible=UnrealizedVATVisible }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen til bogf›ring af modtagermoms (k›bsmoms) for denne kombination af momsvirksomheds- og momsproduktbogf›ringsgruppen, hvis du har valgt indstillingen Modtagermoms i feltet Momsberegningstype.;
                           ENU=Specifies the general ledger account number to which you want to post reverse charge VAT (purchase VAT) for this combination of VAT business posting group and VAT product posting group, if you have selected the Reverse Charge VAT option in the VAT Calculation Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reverse Chrg. VAT Acc." }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen til bogf›ring af bel›b til urealiseret modtagermoms (k›bsmoms) for denne kombination af momsvirksomheds- og momsproduktbogf›ringsgruppen, hvis du har valgt indstillingen Modtagermoms i feltet Momsberegningstype.;
                           ENU=Specifies the general ledger account number to which you want to post amounts for unrealized reverse charge VAT (purchase VAT) for this combination of VAT business posting group and VAT product posting group, if you have selected the Reverse Charge VAT option in the VAT Calculation Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reverse Chrg. VAT Unreal. Acc.";
                Visible=UnrealizedVATVisible }

    { 10  ;1   ;Group     ;
                CaptionML=[DAN=Forbrug;
                           ENU=Usage];
                GroupType=Group }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af momsbogf›ringsposter i denne bogf›ringsgruppe.;
                           ENU=Specifies number of VAT posting ledger entries with this posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Used in Ledger Entries" }

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
      CopyVATPostingSetup@1000 : Report 85;
      UnrealizedVATVisible@1003 : Boolean;
      AdjustForPmtDiscVisible@1002 : Boolean;

    BEGIN
    END.
  }
}


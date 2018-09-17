OBJECT Page 741 VAT Report Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=Yes;
    SourceTable=Table741;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for bilaget, der resulterede i momsposten.;
                           ENU=Specifies the posting date of the document that resulted in the VAT entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret, der resulterede i momsposten.;
                           ENU=Specifies the document number that resulted in the VAT entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bilag, der resulterede i momsposten.;
                           ENU=Specifies the type of the document that resulted in the VAT entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momspostens type.;
                           ENU=Specifies the type of the VAT entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som momsbel›bet i Bel›b er beregnet ud fra.;
                           ENU=Specifies the amount that the VAT amount in the Amount is calculated from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Base }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsbel›bet for rapportlinjen. Det beregnes p† baggrund af v‘rdien i feltet Basis.;
                           ENU=Specifies the VAT amount for the report line. This is calculated based on the value of the Base field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                OnAssistEdit=VAR
                               VATReportLineRelation@1001 : Record 744;
                               VATEntry@1002 : Record 254;
                               FilterText@1003 : Text[1024];
                               TableNo@1004 : Integer;
                             BEGIN
                               FilterText := VATReportLineRelation.CreateFilterForAmountMapping("VAT Report No.","Line No.",TableNo);
                               CASE TableNo OF
                                 DATABASE::"VAT Entry":
                                   BEGIN
                                     VATEntry.SETFILTER("Entry No.",FilterText);
                                     PAGE.RUNMODAL(0,VATEntry);
                                   END;
                               END;
                             END;
                              }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan moms skal beregnes ved k›b eller salg af varer med den aktuelle kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe.;
                           ENU=Specifies how VAT will be calculated for purchases or sales of items with this particular combination of VAT business posting group and VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Calculation Type" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den faktureringsdebitor eller -kreditor, som posten er tilknyttet.;
                           ENU=Specifies the number of the bill-to customer or pay-to vendor that the entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to/Pay-to No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="EU 3-Party Trade" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reason Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momspostens interne referencenummer.;
                           ENU=Specifies the internal reference number of the VAT entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Internal Ref. No." }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det urealiserede momsbel›b for denne linje, hvis du benytter urealiseret moms.;
                           ENU=Specifies the unrealized VAT amount for this line if you use unrealized VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unrealized Amount" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det urealiserede grundlagsbel›b, hvis du benytter urealiseret moms.;
                           ENU=Specifies the unrealized base amount if you use unrealized VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unrealized Base" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No." }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver CVR-nummeret p† den debitor eller kreditor, som momsposten er tilknyttet.;
                           ENU=Specifies the VAT registration number of the customer or vendor that the VAT entry is linked to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Registration No." }

  }
  CODE
  {

    BEGIN
    END.
  }
}


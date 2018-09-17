OBJECT Page 5161 Sales List Archive
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
    CaptionML=[DAN=Salgsoversigtsarkiv;
               ENU=Sales List Archive];
    SourceTable=Table5107;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 55      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 56      ;2   ;Action    ;
                      Name=Card;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Advanced;
                      Image=EditLines;
                      OnAction=VAR
                                 PageManagement@1000 : Codeunit 700;
                               BEGIN
                                 PageManagement.PageRun(Rec);
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

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionsnummeret p† det arkiverede salgsbilag.;
                           ENU=Specifies the version number of the archived document.];
                ApplicationArea=#Advanced;
                SourceExpr="Version No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor dokumentet blev arkiveret.;
                           ENU=Specifies the date when the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Date Archived" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tidspunkt, hvor bilaget blev arkiveret.;
                           ENU=Specifies what time the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Time Archived" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bruger-id'et for den person, der arkiverede dokumentet.;
                           ENU=Specifies the user ID of the person who archived this document.];
                ApplicationArea=#Advanced;
                SourceExpr="Archived By" }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at det arkiverede dokument er knyttet til en interaktionslogpost.;
                           ENU=Specifies that the archived document is linked to an interaction log entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Interaction Exist" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer Name" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Advanced;
                SourceExpr="External Document No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens prim‘re adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens prim‘re adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omr†dekoden for debitorens prim‘re adresse.;
                           ENU=Specifies the country/region code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Country/Region Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Post Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omr†dekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Country/Region Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr†dekoden p† den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren p† salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken s‘lger der er tilknyttet salgsoversigten.;
                           ENU=Specifies which salesperson is associated with the sales list.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

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

    BEGIN
    END.
  }
}


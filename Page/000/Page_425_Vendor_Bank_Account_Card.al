OBJECT Page 425 Vendor Bank Account Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditors bankkontokort;
               ENU=Vendor Bank Account Card];
    SourceTable=Table288;
    PageType=Card;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode til identifikation af kreditorbankkonto.;
                           ENU=Specifies a code to identify this vendor bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den bank, hvor kreditoren har bankkontoen.;
                           ENU=Specifies the name of the bank where the vendor has this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den bank, hvor kreditoren har bankkontoen.;
                           ENU=Specifies the address of the bank where the vendor has the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen p† den bank, hvor kreditoren har bankkontoen.;
                           ENU=Specifies the city of the bank where the vendor has the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telefonnummeret p† den bank, hvor kreditoren har bankkontoen.;
                           ENU=Specifies the telephone number of the bank where the vendor has the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den person i banken, der som regel kontaktes i forbindelse med denne konto.;
                           ENU=Specifies the name of the bank employee regularly contacted in connection with this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante valutakode til bankkontoen.;
                           ENU=Specifies the relevant currency code for the bank account.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† bankfilialen.;
                           ENU=Specifies the number of the bank branch.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Branch No." }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den bankkonto, der benyttes af banken.;
                           ENU=Specifies the number used by the bank for the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No." }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dit eget bank-id-nummer.;
                           ENU=Specifies a bank identification number of your own choice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Transit No." }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Kommunikation;
                           ENU=Communication] }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver faxnummeret p† den bank, hvor kreditoren har bankkontoen.;
                           ENU=Specifies the fax number of the bank where the vendor has the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No." }

    { 26  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver bankkontoens mailadresse.;
                           ENU=Specifies the email address associated with the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankens websted.;
                           ENU=Specifies the bank web site.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page" }

    { 1905090301;1;Group  ;
                CaptionML=[DAN=Overf›rsel;
                           ENU=Transfer] }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver SWIFT-koden (internationalt bank-id) p† den bank, hvor kreditoren har bankkontoen.;
                           ENU=Specifies the SWIFT code (international bank identifier code) of the bank where the vendor has the account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="SWIFT Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontoens internationale bankkontonummer.;
                           ENU=Specifies the bank account's international bank account number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IBAN }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den formatstandard, der skal bruges til bankoverf›rsler, hvis du bruger feltet Kode for bankclearing for at angive dig som afsender.;
                           ENU=Specifies the format standard to be used in bank transfers if you use the Bank Clearing Code field to identify you as the sender.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Clearing Standard" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for bankclearing, der er p†kr‘vet i henhold til den formatstandard, som du valgte i feltet Bankclearingsstandard.;
                           ENU=Specifies the code for bank clearing that is required according to the format standard you selected in the Bank Clearing Standard field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Clearing Code" }

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


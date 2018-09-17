OBJECT Page 2148 O365 Address
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Adresse;
               ENU=Address];
    DeleteAllowed=No;
    SourceTable=Table730;
    PageType=Card;
    SourceTableTemporary=Yes;
    OnQueryClosePage=BEGIN
                       IF CloseAction = ACTION::LookupOK THEN BEGIN
                         PostCode.UpdateFromStandardAddress(Rec,"Post Code" <> xRec."Post Code");
                         SaveToRecord;
                       END;
                     END;

    OnAfterGetCurrRecord=VAR
                           RecID@1000 : RecordID;
                         BEGIN
                           RecID := "Related RecordID";
                           IsPageEditable := RecID.TABLENO <> DATABASE::"Sales Invoice Header";
                           IF IsPageEditable THEN
                             CurrPage.CAPTION := EnterAddressPageCaptionLbl
                           ELSE
                             CurrPage.CAPTION := AddressPageCaptionLbl;
                         END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 8   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver mailadressen.;
                           ENU=Specifies the address.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Address;
                Editable=IsPageEditable }

    { 7   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Address 2";
                Editable=IsPageEditable }

    { 6   ;1   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Post Code";
                Editable=IsPageEditable }

    { 5   ;1   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the address city.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=City;
                Editable=IsPageEditable }

    { 4   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver amtet i adressen.;
                           ENU=Specifies the address county.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=County;
                Editable=IsPageEditable }

    { 3   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Country/Region Code";
                TableRelation=Country/Region.Code;
                Editable=IsPageEditable;
                OnLookup=VAR
                           O365SalesManagement@1002 : Codeunit 2107;
                         BEGIN
                           "Country/Region Code" := O365SalesManagement.LookupCountryCodePhone;
                         END;

                QuickEntry=FALSE }

  }
  CODE
  {
    VAR
      PostCode@1000 : Record 225;
      IsPageEditable@1001 : Boolean;
      EnterAddressPageCaptionLbl@1003 : TextConst 'DAN=Indtast adresse;ENU=Enter address';
      AddressPageCaptionLbl@1004 : TextConst 'DAN=Adresse;ENU=Address';

    BEGIN
    END.
  }
}


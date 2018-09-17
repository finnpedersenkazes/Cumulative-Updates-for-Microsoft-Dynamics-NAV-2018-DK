OBJECT Page 249 VAT Registration Log
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Log over SE/CVR-nr.;
               ENU=VAT Registration Log];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table249;
    SourceTableView=SORTING(Entry No.)
                    ORDER(Descending);
    DataCaptionFields=Account Type,Account No.;
    PageType=List;
    OnOpenPage=BEGIN
                 IF FINDFIRST THEN;
               END;

    ActionList=ACTIONS
    {
      { 12      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=Bekr‘ft SE/CVR-nr.;
                                 ENU=Verify VAT Registration No.];
                      ToolTipML=[DAN=Verificer et CVR-nummer. Hvis nummeret er verificeret, indeholder feltet Status v‘rdien Gyldig.;
                                 ENU=Verify a Tax registration number. If the number is verified the status field contains the value Valid.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 248;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Start;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code";
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det momsregistreringsnummer, du har indtastet i feltet SE/CVR-nr. p† et debitor-, kreditor- eller kontaktkort.;
                           ENU=Specifies the VAT registration number that you entered in the VAT Registration No. field on a customer, vendor, or contact card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Registration No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontotypen p† den debitor eller kreditor, hvis momsregistreringsnummer er bekr‘ftet.;
                           ENU=Specifies the account type of the customer or vendor whose VAT registration number is verified.];
                ApplicationArea=#Advanced;
                SourceExpr="Account Type";
                Visible=FALSE;
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontonummeret for den debitor eller kreditor, hvis momsregistreringsnummer er bekr‘ftet.;
                           ENU=Specifies the account number of the customer or vendor whose VAT registration number is verified.];
                ApplicationArea=#Advanced;
                SourceExpr="Account No.";
                Visible=FALSE;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status p† verificeringshandlingen.;
                           ENU=Specifies the status of the verification action.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r momsregistreringsnummeret blev bekr‘ftet.;
                           ENU=Specifies when the VAT registration number was verified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Verified Date";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, kreditor eller kontakt, hvis momsregistreringsnummer er blevet verificeret.;
                           ENU=Specifies the name of the customer, vendor, or contact whose VAT registration number was verified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Verified Name";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den debitor, kreditor eller kontakt, hvis momsregistreringsnummer er blevet verificeret.;
                           ENU=Specifies the address of the customer, vendor, or contact whose VAT registration number was verified.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Verified Address";
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver vejnavnet p† den debitor, kreditor eller kontakt, hvis momsregistreringsnummer er blevet verificeret. ";
                           ENU="Specifies the street of the customer, vendor, or contact whose VAT registration number was verified. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Verified Street" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver postnummeret p† den debitor, kreditor eller kontakt, hvis momsregistreringsnummer er blevet verificeret. ";
                           ENU="Specifies the postcode of the customer, vendor, or contact whose VAT registration number was verified. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Verified Postcode" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver byen p† den debitor, kreditor eller kontakt, hvis momsregistreringsnummer er blevet verificeret. ";
                           ENU="Specifies the city of the customer, vendor, or contact whose VAT registration number was verified. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Verified City" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver anmodnings-id'et for CVR-nummerets valideringsservice.;
                           ENU=Specifies the request identifier of the VAT registration number validation service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Request Identifier" }

  }
  CODE
  {

    BEGIN
    END.
  }
}


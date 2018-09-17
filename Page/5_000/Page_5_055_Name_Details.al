OBJECT Page 5055 Name Details
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Navneoplysninger;
               ENU=Name Details];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5050;
    PageType=Card;
    OnAfterGetCurrRecord=BEGIN
                           CurrPage.EDITABLE(Type = Type::Person);
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=&Starthilsener;
                                 ENU=&Salutations];
                      ToolTipML=[DAN=Rediger specifikke oplysninger vedr›rende kontaktpersonens navn, f.eks. kontaktens fornavn, mellemnavn, efternavn, titel osv.;
                                 ENU=Edit specific details regarding the contact person's name, for example the contact's first name, middle name, surname, title, and so on.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5151;
                      RunPageLink=Contact No. Filter=FIELD(No.),
                                  Salutation Code=FIELD(Salutation Code);
                      Promoted=Yes;
                      Image=Salutation;
                      PromotedCategory=Process }
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
                ToolTipML=[DAN=Angiver den starthilsenkode, som skal bruges, n†r du kommunikerer med kontakten. Starthilsenkoden bruges kun i Word-dokumenter. Klik p† feltet, hvis du vil se en oversigt over de starthilsenkoder, der er oprettet.;
                           ENU=Specifies the salutation code that will be used when you interact with the contact. The salutation code is only used in Word documents. To see a list of the salutation codes already defined, click the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Salutation Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktpersonens stillingsbetegnelse og g‘lder kun for kontaktpersonen.;
                           ENU=Specifies the contact's job title, and is valid for contact persons only.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Job Title" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktpersonens initialer, n†r kontakten er en person.;
                           ENU=Specifies the contact's initials, when the contact is a person.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Initials }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktpersonens fornavn og g‘lder kun for kontaktpersonen.;
                           ENU=Specifies the contact's first name and is valid for contact persons only.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="First Name" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktpersonens mellemnavn og g‘lder kun for kontaktpersonen.;
                           ENU=Specifies the contact's middle name and is valid for contact persons only.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Middle Name" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktpersonens efternavn og g‘lder kun for kontaktpersonen.;
                           ENU=Specifies the contact's surname and is valid for contact persons only.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Surname }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code" }

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


OBJECT Page 5057 Contact Alt. Address List
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
    CaptionML=[DAN=Alt. adresser p† kontakter;
               ENU=Contact Alt. Address List];
    SourceTable=Table5051;
    DataCaptionFields=Contact No.,Code;
    PageType=List;
    CardPageID=Contact Alt. Address Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Alt. adr. p† kontakt;
                                 ENU=&Alt. Contact Address] }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Datointervaller;
                                 ENU=Date Ranges];
                      ToolTipML=[DAN=Angiver datointervallet, der g‘lder for kontaktens alternative adresse.;
                                 ENU=Specify date ranges that apply to the contact's alternate address.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5058;
                      RunPageLink=Contact No.=FIELD(Contact No.),
                                  Contact Alt. Address Code=FIELD(Code);
                      Image=DateRange }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den alternative adresse.;
                           ENU=Specifies the code for the alternate address.];
                ApplicationArea=#All;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver virksomhedsnavnet for den alternative adresse.;
                           ENU=Specifies the name of the company for the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Company Name" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ekstra del af virksomhedsnavnet for den alternative adresse.;
                           ENU=Specifies the additional part of the company name for the alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr="Company Name 2";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den alternative adresse for kontakten.;
                           ENU=Specifies the alternate address of the contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Advanced;
                SourceExpr="Address 2";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen p† kontaktens alternative adresse.;
                           ENU=Specifies the city of the contact's alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr=City;
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver amtet for kontaktens alternative adresse.;
                           ENU=Specifies the county for the contact's alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr=County;
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telefonnummeret for den alternative adresse.;
                           ENU=Specifies the telephone number for the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver faxnummeret for den alternative adresse.;
                           ENU=Specifies the fax number for the alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No.";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver kontaktens mailadresse p† den alternative adresse.;
                           ENU=Specifies the e-mail address for the contact at the alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr="E-Mail";
                Visible=FALSE }

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


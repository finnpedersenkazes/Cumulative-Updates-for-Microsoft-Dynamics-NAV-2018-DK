OBJECT Page 5056 Contact Alt. Address Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontakt - alt. adr.kort;
               ENU=Contact Alt. Address Card];
    SourceTable=Table5051;
    DataCaptionExpr=Caption;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 34      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Alt. adr. p† kontakt;
                                 ENU=&Alt. Contact Address] }
      { 37      ;2   ;Action    ;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

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
                ToolTipML=[DAN=Angiver den alternative adresse for kontakten.;
                           ENU=Specifies the alternate address of the contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Address }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Address 2" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen p† kontaktens alternative adresse.;
                           ENU=Specifies the city of the contact's alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telefonnummeret for den alternative adresse.;
                           ENU=Specifies the telephone number for the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Kommunikation;
                           ENU=Communication] }

    { 31  ;2   ;Field     ;
                Name=Phone No.2;
                ToolTipML=[DAN=Angiver telefonnummeret for den alternative adresse.;
                           ENU=Specifies the telephone number for the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver mobiltelefonnummeret for den alternative adresse.;
                           ENU=Specifies the mobile phone number for the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Mobile Phone No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver faxnummeret for den alternative adresse.;
                           ENU=Specifies the fax number for the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telexnummeret for den alternative adresse.;
                           ENU=Specifies the telex number for the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Telex No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens persons›gernummer p† den alternative adresse.;
                           ENU=Specifies the pager number for the contact at the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Pager }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telexnummeret til tilbagesvar for den alternative adresse.;
                           ENU=Specifies the telex answer back number for the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Telex Answer Back" }

    { 26  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver kontaktens mailadresse p† den alternative adresse.;
                           ENU=Specifies the e-mail address for the contact at the alternate address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktens websted.;
                           ENU=Specifies the contact's web site.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Home Page" }

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
      Text000@1000 : TextConst 'DAN=ikke navngivet;ENU=untitled';

    LOCAL PROCEDURE Caption@1() : Text[130];
    VAR
      Cont@1000 : Record 5050;
    BEGIN
      IF Cont.GET("Contact No.") THEN
        EXIT("Contact No." + ' ' + Cont.Name + ' ' + Code + ' ' + "Company Name");

      EXIT(Text000);
    END;

    BEGIN
    END.
  }
}


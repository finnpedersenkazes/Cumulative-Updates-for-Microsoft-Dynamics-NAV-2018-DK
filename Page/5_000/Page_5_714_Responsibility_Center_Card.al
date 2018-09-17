OBJECT Page 5714 Responsibility Center Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ansvarscenterkort;
               ENU=Responsibility Center Card];
    SourceTable=Table5714;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 34      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ansv.ctr.;
                                 ENU=&Resp. Ctr.];
                      Image=Dimensions }
      { 30      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5714),
                                  No.=FIELD(Code);
                      Image=Dimensions }
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
                ToolTipML=[DAN=Angiver ansvarscenterkoden.;
                           ENU=Specifies the responsibility center code.];
                ApplicationArea=#Advanced;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet.;
                           ENU=Specifies the name.];
                ApplicationArea=#Advanced;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, der er knyttet til ansvarscenteret.;
                           ENU=Specifies the address associated with the responsibility center.];
                ApplicationArea=#Advanced;
                SourceExpr=Address }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Advanced;
                SourceExpr="Address 2" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Post Code" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den by, hvor ansvarscenteret ligger.;
                           ENU=Specifies the city where the responsibility center is located.];
                ApplicationArea=#Advanced;
                SourceExpr=City }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver navnet p† den person, du kontakter regelm‘ssigt. ";
                           ENU="Specifies the name of the person you regularly contact. "];
                ApplicationArea=#Advanced;
                SourceExpr=Contact }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationen for ansvarscenteret.;
                           ENU=Specifies the location of the responsibility center.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code" }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Kommunikation;
                           ENU=Communication] }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telefonnummeret for ansvarscenteret.;
                           ENU=Specifies the responsibility center's phone number.];
                ApplicationArea=#Advanced;
                SourceExpr="Phone No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver faxnummeret for ansvarscenteret.;
                           ENU=Specifies the fax number of the responsibility center.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No." }

    { 28  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver mailadressen for ansvarscenteret.;
                           ENU=Specifies the email address of the responsibility center.];
                ApplicationArea=#Advanced;
                SourceExpr="E-Mail" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ansvarscenterets websted.;
                           ENU=Specifies the responsibility center's web site.];
                ApplicationArea=#Advanced;
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

    BEGIN
    END.
  }
}


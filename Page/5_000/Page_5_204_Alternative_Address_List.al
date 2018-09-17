OBJECT Page 5204 Alternative Address List
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
    CaptionML=[DAN=Alternativ adresseliste;
               ENU=Alternate Address List];
    SourceTable=Table5201;
    DataCaptionFields=Employee No.;
    PageType=List;
    CardPageID=Alternative Address Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 28      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Adresse;
                                 ENU=&Address];
                      Image=Addresses }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5222;
                      RunPageLink=Table Name=CONST(Alternative Address),
                                  No.=FIELD(Employee No.),
                                  Alternative Address Code=FIELD(Code);
                      Image=ViewComments }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for medarbejderens alternative adresse.;
                           ENU=Specifies a code for the employee's alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens efternavn.;
                           ENU=Specifies the employee's last name.];
                ApplicationArea=#Advanced;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens fornavn eller alternative navn.;
                           ENU=Specifies the employee's first name, or an alternate name.];
                ApplicationArea=#Advanced;
                SourceExpr="Name 2";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en alternativ adresse for medarbejderen.;
                           ENU=Specifies an alternate address for the employee.];
                ApplicationArea=#Advanced;
                SourceExpr=Address }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Advanced;
                SourceExpr="Address 2";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den alternative adresse.;
                           ENU=Specifies the city of the alternate address.];
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
                ToolTipML=[DAN=Angiver amtet for medarbejderens alternative adresse.;
                           ENU=Specifies the county of the employee's alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr=County;
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens telefonnummer p† den alternative adresse.;
                           ENU=Specifies the employee's telephone number at the alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr="Phone No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens faxnummer p† den alternative adresse.;
                           ENU=Specifies the employee's fax number at the alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver medarbejderens alternative mailadresse.;
                           ENU=Specifies the employee's alternate email address.];
                ApplicationArea=#Advanced;
                SourceExpr="E-Mail";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der blev indtastet en bem‘rkning til posten.;
                           ENU=Specifies if a comment was entered for this entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}


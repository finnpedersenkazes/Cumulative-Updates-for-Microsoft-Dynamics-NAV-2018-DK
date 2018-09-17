OBJECT Page 5203 Alternative Address Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Alternativt adressekort;
               ENU=Alternative Address Card];
    SourceTable=Table5201;
    DataCaptionExpr=Caption;
    PopulateAllFields=Yes;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Adresse;
                                 ENU=&Address];
                      Image=Addresses }
      { 22      ;2   ;Action    ;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

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
                ToolTipML=[DAN=Angiver en alternativ adresse for medarbejderen.;
                           ENU=Specifies an alternate address for the employee.];
                ApplicationArea=#Advanced;
                SourceExpr=Address }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Advanced;
                SourceExpr="Address 2" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Post Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den alternative adresse.;
                           ENU=Specifies the city of the alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr=City }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens telefonnummer p† den alternative adresse.;
                           ENU=Specifies the employee's telephone number at the alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr="Phone No." }

    { 1902768601;1;Group  ;
                CaptionML=[DAN=Kommunikation;
                           ENU=Communication] }

    { 23  ;2   ;Field     ;
                Name=Phone No.2;
                ToolTipML=[DAN=Angiver medarbejderens telefonnummer p† den alternative adresse.;
                           ENU=Specifies the employee's telephone number at the alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr="Phone No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver medarbejderens faxnummer p† den alternative adresse.;
                           ENU=Specifies the employee's fax number at the alternate address.];
                ApplicationArea=#Advanced;
                SourceExpr="Fax No." }

    { 27  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver medarbejderens alternative mailadresse.;
                           ENU=Specifies the employee's alternate email address.];
                ApplicationArea=#Advanced;
                SourceExpr="E-Mail" }

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
    VAR
      Text000@1000 : TextConst 'DAN=ikke navngivet;ENU=untitled';
      Employee@1001 : Record 5200;

    LOCAL PROCEDURE Caption@1() : Text[110];
    BEGIN
      IF Employee.GET("Employee No.") THEN
        EXIT("Employee No." + ' ' + Employee.FullName + ' ' + Code);

      EXIT(Text000);
    END;

    BEGIN
    END.
  }
}


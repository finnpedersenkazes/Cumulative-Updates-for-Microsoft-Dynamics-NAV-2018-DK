OBJECT Page 1870 Credit Limit Notification
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Notifikation om kreditmaksimum;
               ENU=Credit Limit Notification];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table18;
    DelayedInsert=No;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Administrer,Opret;
                                ENU=New,Process,Report,Manage,Create];
    ActionList=ACTIONS
    {
      { 2       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Administrer;
                                 ENU=&Manage] }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om debitoren.;
                                 ENU=View or edit detailed information about the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Customer;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      RunPageMode=View }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Opret;
                                 ENU=Create] }
      { 11      ;2   ;Action    ;
                      Name=NewFinanceChargeMemo;
                      AccessByPermission=TableData 302=RIM;
                      CaptionML=[DAN=Rentenota;
                                 ENU=Finance Charge Memo];
                      ToolTipML=[DAN=Opret en ny rentenota.;
                                 ENU=Create a new finance charge memo.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 446;
                      RunPageLink=Customer No.=FIELD(No.);
                      Promoted=Yes;
                      Image=FinChargeMemo;
                      PromotedCategory=New;
                      PromotedOnly=Yes;
                      RunPageMode=Create }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=Rapport;
                                 ENU=Report] }
      { 6       ;2   ;Action    ;
                      Name=Report Customer - Balance to Date;
                      CaptionML=[DAN=Debitor - saldo til dato;
                                 ENU=Customer - Balance to Date];
                      ToolTipML=[DAN=Vis en liste over debitorers betalingshistorik op til en bestemt dato. Du kan bruge rapporten til at udtr‘kke oplysninger om din samlede salgsindkomst ved slutningen af en regnskabsperiode eller et regnskabs†r.;
                                 ENU=View a list with customers' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CustomerCard@1000 : Page 21;
                               BEGIN
                                 CustomerCard.RunReport(REPORT::"Customer - Balance to Date","No.");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 4   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver hovedmeddelelsen i notifikationen.;
                           ENU=Specifies the main message of the notification.];
                ApplicationArea=#Basic,#Suite;
                CaptionClass=Heading;
                MultiLine=Yes }

    { 3   ;1   ;Part      ;
                Name=CreditLimitDetails;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page1871;
                PartType=Page }

  }
  CODE
  {
    VAR
      Heading@1000 : Text[250];

    [External]
    PROCEDURE SetHeading@6(Value@1000 : Text[250]);
    BEGIN
      Heading := Value;
    END;

    [Internal]
    PROCEDURE InitializeFromNotificationVar@7(CreditLimitNotification@1000 : Notification);
    VAR
      Customer@1001 : Record 18;
    BEGIN
      GET(CreditLimitNotification.GETDATA(Customer.FIELDNAME("No.")));
      SETRANGE("No.","No.");

      IF GETFILTER("Date Filter") = '' THEN
        SETFILTER("Date Filter",'..%1',WORKDATE);

      CurrPage.CreditLimitDetails.PAGE.InitializeFromNotificationVar(CreditLimitNotification);
    END;

    BEGIN
    END.
  }
}


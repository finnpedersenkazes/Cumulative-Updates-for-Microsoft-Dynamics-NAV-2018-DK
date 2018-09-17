OBJECT Page 1600 Outlook Mail Engine
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Outlook-mailprogram;
               ENU=Outlook Mail Engine];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1600;
    DelayedInsert=No;
    PageType=Card;
    SourceTableTemporary=Yes;
    OnOpenPage=VAR
                 OfficeHost@1000 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Hosts.OfficeHost" RUNONCLIENT;
               BEGIN
                 IF OfficeHost.IsAvailable THEN BEGIN
                   OfficeHost := OfficeHost.Create;
                   OfficeMgt.InitializeHost(OfficeHost,OfficeHost.HostType);
                 END;

                 GetDetailsFromFilters;
                 IF Email = 'donotreply@contoso.com' THEN
                   PAGE.RUN(PAGE::"Office Welcome Dlg")
                 ELSE
                   OfficeMgt.InitializeContext(Rec);

                 CurrPage.CLOSE;
                 OfficeMgt.CloseEnginePage;
               END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=Content;
                ContainerType=ContentArea }

    { 7   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver Outlook-kontaktens mailadresse.;
                           ENU=Specifies the email address of the Outlook contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Email }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Outlook-kontaktens viste navn.;
                           ENU=Specifies the display name of the Outlook contact.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type, som det relevante bilag tilh›rer.;
                           ENU=Specifies the type that the involved document belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det relevante bilag.;
                           ENU=Specifies the number of the involved document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

  }
  CODE
  {
    VAR
      OfficeMgt@1004 : Codeunit 1630;

    LOCAL PROCEDURE GetDetailsFromFilters@1001();
    VAR
      Field@1002 : Record 2000000041;
      TypeHelper@1003 : Codeunit 10;
      RecRef@1001 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      IF TypeHelper.FindFields(RecRef.NUMBER,Field) THEN
        REPEAT
          ParseFilter(RecRef.FIELD(Field."No."));
        UNTIL Field.NEXT = 0;
      RecRef.SETTABLE(Rec);
    END;

    LOCAL PROCEDURE ParseFilter@1014(FieldRef@1003 : FieldRef);
    VAR
      FilterPrefixRegEx@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
      SingleQuoteRegEx@1001 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
      Filter@1000 : Text;
      OptionValue@1004 : Integer;
    BEGIN
      FilterPrefixRegEx := FilterPrefixRegEx.Regex('^@\*([^\\]+)\*$');
      SingleQuoteRegEx := SingleQuoteRegEx.Regex('^''([^\\]+)''$');

      Filter := FieldRef.GETFILTER;
      Filter := FilterPrefixRegEx.Replace(Filter,'$1');
      Filter := SingleQuoteRegEx.Replace(Filter,'$1');
      IF Filter <> '' THEN BEGIN
        IF FORMAT(FieldRef.TYPE) = 'Option' THEN
          WHILE TRUE DO BEGIN
            OptionValue += 1;
            IF UPPERCASE(Filter) = UPPERCASE(SELECTSTR(OptionValue,FieldRef.OPTIONCAPTION)) THEN BEGIN
              FieldRef.VALUE := OptionValue - 1;
              EXIT;
            END;
          END
        ELSE
          FieldRef.VALUE(Filter);
      END;
    END;

    BEGIN
    END.
  }
}


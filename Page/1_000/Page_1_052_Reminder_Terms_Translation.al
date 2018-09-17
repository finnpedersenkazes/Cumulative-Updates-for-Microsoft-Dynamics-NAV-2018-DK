OBJECT Page 1052 Reminder Terms Translation
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Overs‘ttelse af rykkerbetingelser;
               ENU=Reminder Terms Translation];
    SourceTable=Table1052;
    DataCaptionExpr=PageCaption;
    OnOpenPage=BEGIN
                 PageCaption := "Reminder Terms Code";
               END;

  }
  CONTROLS
  {
    { 1000;    ;Container ;
                Name=Reminder Terms Translation;
                ContainerType=ContentArea }

    { 1004;1   ;Group     ;
                GroupType=Repeater }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver overs‘ttelsen af rykkerbetingelser, s† debitorer modtager en rykkermeddelelse p† deres eget sprog.;
                           ENU=Specifies translation of reminder terms so that customers are reminded in their own language.];
                ApplicationArea=#Advanced;
                SourceExpr="Reminder Terms Code";
                Visible=false }

    { 1002;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Advanced;
                SourceExpr="Language Code" }

    { 1003;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at alle noter om linjegebyrer f›jes til rykkeren.;
                           ENU=Specifies that any notes about line fees will be added to the reminder.];
                ApplicationArea=#Advanced;
                SourceExpr="Note About Line Fee on Report" }

  }
  CODE
  {
    VAR
      PageCaption@1000 : Text;

    BEGIN
    END.
  }
}


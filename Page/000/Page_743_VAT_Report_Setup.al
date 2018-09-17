OBJECT Page 743 VAT Report Setup
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Momsrapportkonfiguration;
               ENU=VAT Report Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table743;
    PageType=Card;
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om brugerne kan modificere momsrapporter, der er blevet indsendt til SKAT. Hvis feltet er tomt, skal brugerne i stedet for oprette en korrigerende eller supplerende momsrapport.;
                           ENU=Specifies if users can modify VAT reports that have been submitted to the tax authorities. If the field is left blank, users must create a corrective or supplementary VAT report instead.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Modify Submitted Reports" }

    { 1904569201;1;Group  ;
                CaptionML=[DAN=Nummerering;
                           ENU=Numbering] }

    { 7   ;2   ;Field     ;
                Name=EC Sales List No. Series;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Series" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, der bruges til momsangivelsesrecords.;
                           ENU=Specifies the number series that is used for VAT return records.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Return No. Series" }

  }
  CODE
  {

    BEGIN
    END.
  }
}


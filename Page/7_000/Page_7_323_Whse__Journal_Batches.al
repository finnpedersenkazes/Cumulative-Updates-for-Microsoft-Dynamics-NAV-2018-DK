OBJECT Page 7323 Whse. Journal Batches
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerkladdenavne;
               ENU=Whse. Journal Batches];
    SourceTable=Table7310;
    DataCaptionExpr=DataCaption;
    DelayedInsert=Yes;
    PageType=List;
    OnNewRecord=BEGIN
                  SetupNewBatch;
                END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† lagerkladdek›rslen.;
                           ENU=Specifies the name of the warehouse journal batch.];
                ApplicationArea=#Warehouse;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af lagerkladdek›rslen.;
                           ENU=Specifies a description of the warehouse journal batch.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor kladdek›rslen g‘lder.;
                           ENU=Specifies the code of the location where the journal batch applies.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Warehouse;
                SourceExpr="Reason Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Warehouse;
                SourceExpr="No. Series" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele bilagsnumre til de lagerposter, der er registreret fra kladdek›rslen.;
                           ENU=Specifies the number series code used to assign document numbers to the warehouse entries that are registered from this journal batch.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registering No. Series" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID";
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

    LOCAL PROCEDURE DataCaption@1() : Text[250];
    VAR
      WhseJnlTemplate@1000 : Record 7309;
    BEGIN
      IF NOT CurrPage.LOOKUPMODE THEN
        IF GETFILTER("Journal Template Name") <> '' THEN
          IF GETRANGEMIN("Journal Template Name") = GETRANGEMAX("Journal Template Name") THEN
            IF WhseJnlTemplate.GET(GETRANGEMIN("Journal Template Name")) THEN
              EXIT(WhseJnlTemplate.Name + ' ' + WhseJnlTemplate.Description);
    END;

    BEGIN
    END.
  }
}


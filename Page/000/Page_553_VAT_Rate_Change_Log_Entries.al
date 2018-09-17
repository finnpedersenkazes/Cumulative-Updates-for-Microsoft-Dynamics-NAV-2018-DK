OBJECT Page 553 VAT Rate Change Log Entries
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
    CaptionML=[DAN=’ndringslogposter for momssats;
               ENU=VAT Rate Change Log Entries];
    SourceTable=Table552;
    SourceTableView=SORTING(Entry No.);
    PageType=List;
    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Table Caption")
                     END;

    ActionList=ACTIONS
    {
      { 18      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 14      ;2   ;Action    ;
                      Name=Show;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Vi&s;
                                 ENU=&Show];
                      ToolTipML=[DAN=Vis logoplysningerne.;
                                 ENU=View the log details.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=View;
                      OnAction=VAR
                                 SalesHeader@1002 : Record 36;
                                 SalesLine@1008 : Record 37;
                                 PurchaseHeader@1010 : Record 38;
                                 PurchaseLine@1009 : Record 39;
                                 ServiceHeader@1012 : Record 5900;
                                 ServiceLine@1011 : Record 5902;
                                 PageManagement@1000 : Codeunit 700;
                                 RecRef@1001 : RecordRef;
                               BEGIN
                                 IF FORMAT("Record ID") = '' THEN
                                   EXIT;
                                 IF NOT RecRef.GET("Record ID") THEN
                                   ERROR(Text0002);
                                 CASE "Table ID" OF
                                   DATABASE::"Sales Header",
                                   DATABASE::"Purchase Header",
                                   DATABASE::"Gen. Journal Line",
                                   DATABASE::Item,
                                   DATABASE::"G/L Account",
                                   DATABASE::"Item Category",
                                   DATABASE::"Item Charge",
                                   DATABASE::Resource:
                                     PageManagement.PageRunModal(RecRef);
                                   DATABASE::"Sales Line":
                                     BEGIN
                                       RecRef.SETTABLE(SalesLine);
                                       SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.");
                                       PageManagement.PageRunModal(SalesHeader);
                                     END;
                                   DATABASE::"Purchase Line":
                                     BEGIN
                                       RecRef.SETTABLE(PurchaseLine);
                                       PurchaseHeader.GET(PurchaseLine."Document Type",PurchaseLine."Document No.");
                                       PageManagement.PageRunModal(PurchaseHeader);
                                     END;
                                   DATABASE::"Service Line":
                                     BEGIN
                                       RecRef.SETTABLE(ServiceLine);
                                       ServiceHeader.GET(ServiceLine."Document Type",ServiceLine."Document No.");
                                       PageManagement.PageRunModal(ServiceHeader);
                                     END;
                                   ELSE
                                     MESSAGE(Text0001);
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Specificerer tabellen. Feltet er kun beregnet til internt brug.;
                           ENU=Specifies the table. This field is intended only for internal use.];
                ApplicationArea=#Advanced;
                SourceExpr="Table ID";
                Visible=False }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Specificerer tabellen. Feltet er kun beregnet til internt brug.;
                           ENU=Specifies the table. This field is intended only for internal use.];
                ApplicationArea=#Advanced;
                SourceExpr="Table Caption";
                Visible=False }

    { 6   ;2   ;Field     ;
                Name=Record Identifier;
                CaptionML=[DAN=Record-id;
                           ENU=Record Identifier];
                ToolTipML=[DAN=Angiver lokationskoden for denne linje i den udskrevne eller eksporterede momsrapport.;
                           ENU=Specifies the location of this line in the printed or exported VAT report.];
                ApplicationArea=#Advanced;
                SourceExpr=FORMAT("Record ID") }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver produktbogf›ringsgruppen f›r konvertering af momssats‘ndring.;
                           ENU=Specifies the general product posting group before the VAT rate change conversion.];
                ApplicationArea=#Advanced;
                SourceExpr="Old Gen. Prod. Posting Group" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nye produktbogf›ringsgruppe efter konvertering af momssats‘ndring.;
                           ENU=Specifies the new general product posting group after the VAT rate change conversion.];
                ApplicationArea=#Advanced;
                SourceExpr="New Gen. Prod. Posting Group" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsproduktbogf›ringsgruppen f›r konvertering af momssats‘ndring.;
                           ENU=Specifies the VAT product posting group before the VAT rate change conversion.];
                ApplicationArea=#Advanced;
                SourceExpr="Old VAT Prod. Posting Group" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nye momsproduktbogf›ringsgruppe efter konvertering af momssats‘ndring.;
                           ENU=Specifies the new VAT product posting group after the VAT rate change conversion.];
                ApplicationArea=#Advanced;
                SourceExpr="New VAT Prod. Posting Group" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelse for konvertering af momssats‘ndring.;
                           ENU=Specifies the description for the VAT rate change conversion.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for konvertering af momssats‘ndring.;
                           ENU=Specifies the status of the VAT rate change conversion.];
                ApplicationArea=#Advanced;
                SourceExpr=Converted }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor momssats‘ndringslogposten blev oprettet.;
                           ENU=Specifies the date when the VAT rate change log entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Converted Date" }

  }
  CODE
  {
    VAR
      Text0001@1000 : TextConst 'DAN=S›g efter siderne for at se denne post.;ENU=Search for the pages to see this entry.';
      Text0002@1001 : TextConst 'DAN=Den tilknyttede post er bogf›rt eller slettet.;ENU=The related entry has been posted or deleted.';

    BEGIN
    END.
  }
}


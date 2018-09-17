OBJECT Page 115 G/L Posting Preview
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
    CaptionML=[DAN=Vis bogf›ring;
               ENU=Posting Preview];
    SourceTable=Table265;
    PageType=List;
    SourceTableTemporary=Yes;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;ActionGroup;
                      Name=Process;
                      CaptionML=[DAN=Proces;
                                 ENU=Process] }
      { 21      ;2   ;Action    ;
                      Name=Show;
                      CaptionML=[DAN=&Vis relaterede poster;
                                 ENU=&Show Related Entries];
                      ToolTipML=[DAN=Vis detaljer om andre poster, der er relateret til finansposteringen.;
                                 ENU=View details about other entries that are related to the general ledger posting.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewDocumentLine;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PostingPreviewEventHandler.ShowEntries("Table ID");
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 16  ;1   ;Group     ;
                GroupType=Repeater }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Specificerer id'et. Feltet er kun beregnet til internt brug.;
                           ENU=Specifies the ID. This field is intended only for internal use.];
                ApplicationArea=#Advanced;
                SourceExpr="Table ID";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Relaterede poster;
                           ENU=Related Entries];
                ToolTipML=[DAN=Angiver navnet p† den tabel, hvor funktionen Naviger har fundet poster med det valgte bilagsnummer og/eller den valgte bogf›ringsdato.;
                           ENU=Specifies the name of the table where the Navigate facility has found entries with the selected document number and/or posting date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Table Name" }

    { 19  ;2   ;Field     ;
                DrillDown=Yes;
                CaptionML=[DAN=Antal poster;
                           ENU=No. of Entries];
                ToolTipML=[DAN=Angiver det antal bilag, som funktionen Naviger har fundet i tabellen med de valgte poster.;
                           ENU=Specifies the number of documents that the Navigate facility has found in the table with the selected entries.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Records";
                OnDrillDown=BEGIN
                              PostingPreviewEventHandler.ShowEntries("Table ID");
                            END;
                             }

  }
  CODE
  {
    VAR
      PostingPreviewEventHandler@1000 : Codeunit 20;

    [External]
    PROCEDURE Set@1(VAR TempDocumentEntry@1000 : TEMPORARY Record 265;NewPostingPreviewEventHandler@1001 : Codeunit 20);
    BEGIN
      PostingPreviewEventHandler := NewPostingPreviewEventHandler;
      IF TempDocumentEntry.FINDSET THEN
        REPEAT
          Rec := TempDocumentEntry;
          INSERT;
        UNTIL TempDocumentEntry.NEXT = 0;
    END;

    BEGIN
    END.
  }
}


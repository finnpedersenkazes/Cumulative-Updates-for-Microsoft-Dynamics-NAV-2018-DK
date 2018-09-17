OBJECT Page 9189 Generic Chart Memo Editor
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Memoeditor for generisk diagram;
               ENU=Generic Chart Memo Editor];
    SourceTable=Table9186;
    PageType=List;
    SourceTableTemporary=Yes;
    ShowFilter=No;
    OnAfterGetCurrRecord=BEGIN
                           MemoText := GetMemoText
                         END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Sprog;
                           ENU=Languages];
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Specificerer en kode. Feltet er kun beregnet til intern brug.;
                           ENU=Specifies a code. This field is intended only for internal use.];
                ApplicationArea=#Advanced;
                SourceExpr=Code;
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Advanced;
                SourceExpr="Language Code";
                Importance=Promoted }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† diagramnotaens sprog.;
                           ENU=Specifies the language name of the chart memo.];
                ApplicationArea=#Advanced;
                SourceExpr="Language Name";
                Importance=Promoted;
                Editable=FALSE }

    { 7   ;1   ;Group     ;
                Name=Memo;
                CaptionML=[DAN=Nota;
                           ENU=Memo];
                GroupType=Group }

    { 6   ;2   ;Field     ;
                Name=MemoText;
                ToolTipML=[DAN=Angiver teksten i diagramnotaen.;
                           ENU=Specifies the text of the chart memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MemoText;
                MultiLine=Yes;
                ColumnSpan=2;
                OnValidate=BEGIN
                             SetMemoText(MemoText)
                           END;

                ShowCaption=No }

  }
  CODE
  {
    VAR
      MemoText@1000 : Text;

    [External]
    PROCEDURE AssistEdit@1(VAR TempGenericChartMemoBuf@1000 : TEMPORARY Record 9186;MemoCode@1001 : Code[10]) : Text;
    VAR
      Language@1002 : Record 8;
    BEGIN
      COPY(TempGenericChartMemoBuf,TRUE);
      SETRANGE(Code,MemoCode);
      IF GET(MemoCode,Language.GetUserLanguage) THEN;
      CurrPage.RUNMODAL;
      EXIT(GetMemo(MemoCode,Language.GetUserLanguage))
    END;

    BEGIN
    END.
  }
}


OBJECT Page 9185 Generic Chart Text Editor
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Teksteditor for generisk diagram;
               ENU=Generic Chart Text Editor];
    SourceTable=Table9185;
    PageType=List;
    SourceTableTemporary=Yes;
    ShowFilter=No;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
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
                SourceExpr="Language Code" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sproget for den m†ls‘tningstitel, der vises ud for y-aksen i det generiske diagram.;
                           ENU=Specifies the language of the measure caption that is shown next to the y-axis of the generic chart.];
                ApplicationArea=#Advanced;
                SourceExpr="Language Name";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                Name=Text;
                ToolTipML=[DAN=Angiver den titel, der vises ud for y-aksen til at beskrive den valgte enhed.;
                           ENU=Specifies the caption that is shown next to the y-axis to describe the selected measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Caption }

  }
  CODE
  {

    [External]
    PROCEDURE AssistEdit@1(VAR TempGenericChartCaptionsBuf@1000 : TEMPORARY Record 9185;CaptionCode@1001 : Code[10]) : Text;
    VAR
      Language@1002 : Record 8;
    BEGIN
      COPY(TempGenericChartCaptionsBuf,TRUE);
      SETRANGE(Code,CaptionCode);
      IF GET(CaptionCode,Language.GetUserLanguage) THEN;
      CurrPage.RUNMODAL;
      EXIT(GetCaption(CaptionCode,Language.GetUserLanguage))
    END;

    BEGIN
    END.
  }
}


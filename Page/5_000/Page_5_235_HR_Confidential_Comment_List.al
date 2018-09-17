OBJECT Page 5235 HR Confidential Comment List
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
    CaptionML=[DAN=Bem‘rkningslinjer;
               ENU=Comment List];
    LinksAllowed=No;
    SourceTable=Table5219;
    DataCaptionExpr=Caption(Rec);
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som kommentaren blev oprettet p†.;
                           ENU=Specifies the date when the comment was created.];
                ApplicationArea=#Advanced;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver selve bem‘rkningen.;
                           ENU=Specifies the comment itself.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for kommentaren.;
                           ENU=Specifies a code for the comment.];
                ApplicationArea=#Advanced;
                SourceExpr=Code;
                Visible=FALSE }

  }
  CODE
  {
    VAR
      Employee@1002 : Record 5200;
      ConfidentialInfo@1001 : Record 5216;
      Text000@1000 : TextConst '@@@=it is a caption for empty page;DAN=ikke navngivet;ENU=untitled';

    LOCAL PROCEDURE Caption@1(HRCommentLine@1000 : Record 5219) : Text[110];
    BEGIN
      IF ConfidentialInfo.GET(HRCommentLine."No.",HRCommentLine.Code,HRCommentLine."Table Line No.") AND
         Employee.GET(HRCommentLine."No.")
      THEN
        EXIT(HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
          ConfidentialInfo."Confidential Code");
      EXIT(Text000);
    END;

    BEGIN
    END.
  }
}


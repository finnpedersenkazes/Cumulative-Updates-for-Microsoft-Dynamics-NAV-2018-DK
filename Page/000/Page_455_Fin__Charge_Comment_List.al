OBJECT Page 455 Fin. Charge Comment List
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
    SourceTable=Table306;
    DataCaptionExpr=Caption(Rec);
    DelayedInsert=Yes;
    PageType=List;
    AutoSplitKey=Yes;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dokumenttype, som bem‘rkningen er knyttet til: Rentenota eller Udstedt rentenota.;
                           ENU=Specifies the type of document the comment is attached to: either Finance Charge Memo or Issued Finance Charge Memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som kommentaren blev oprettet p†.;
                           ENU=Specifies the date the comment was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver selve bem‘rkningen.;
                           ENU=Specifies the comment itself.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Comment }

  }
  CODE
  {
    VAR
      Text000@1001 : TextConst '@@@=it is a caption for empty page;DAN=ikke navngivet;ENU=untitled';
      Text001@1000 : TextConst 'DAN=Rentenota;ENU=Fin. Charge Memo';

    LOCAL PROCEDURE Caption@1(FinChrgCommentLine@1000 : Record 306) : Text[110];
    BEGIN
      IF FinChrgCommentLine."No." = '' THEN
        EXIT(Text000);
      EXIT(Text001 + ' ' + FinChrgCommentLine."No." + ' ');
    END;

    BEGIN
    END.
  }
}


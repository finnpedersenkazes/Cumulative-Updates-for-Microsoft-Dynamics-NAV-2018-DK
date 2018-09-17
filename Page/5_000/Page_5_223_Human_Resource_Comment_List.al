OBJECT Page 5223 Human Resource Comment List
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
    CaptionML=[DAN=Bem�rkningslinjer;
               ENU=Comment List];
    LinksAllowed=No;
    SourceTable=Table5208;
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som kommentaren blev oprettet p�.;
                           ENU=Specifies the date the comment was created.];
                ApplicationArea=#Advanced;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver selve bem�rkningen.;
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
      Employee@1006 : Record 5200;
      EmployeeAbsence@1005 : Record 5207;
      EmployeeQualification@1004 : Record 5203;
      EmployeeRelative@1003 : Record 5205;
      MiscArticleInfo@1002 : Record 5214;
      ConfidentialInfo@1001 : Record 5216;
      Text000@1007 : TextConst '@@@=it is a caption for empty page;DAN=ikke navngivet;ENU=untitled';

    LOCAL PROCEDURE Caption@1(HRCommentLine@1000 : Record 5208) : Text[110];
    BEGIN
      CASE HRCommentLine."Table Name" OF
        HRCommentLine."Table Name"::"Employee Absence":
          IF EmployeeAbsence.GET(HRCommentLine."Table Line No.") THEN BEGIN
            Employee.GET(EmployeeAbsence."Employee No.");
            EXIT(
              Employee."No." + ' ' + Employee.FullName + ' ' +
              EmployeeAbsence."Cause of Absence Code" + ' ' +
              FORMAT(EmployeeAbsence."From Date"));
          END;
        HRCommentLine."Table Name"::Employee:
          IF Employee.GET(HRCommentLine."No.") THEN
            EXIT(HRCommentLine."No." + ' ' + Employee.FullName);
        HRCommentLine."Table Name"::"Alternative Address":
          IF Employee.GET(HRCommentLine."No.") THEN
            EXIT(
              HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
              HRCommentLine."Alternative Address Code");
        HRCommentLine."Table Name"::"Employee Qualification":
          IF EmployeeQualification.GET(HRCommentLine."No.",HRCommentLine."Table Line No.") AND
             Employee.GET(HRCommentLine."No.")
          THEN
            EXIT(
              HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
              EmployeeQualification."Qualification Code");
        HRCommentLine."Table Name"::"Employee Relative":
          IF EmployeeRelative.GET(HRCommentLine."No.",HRCommentLine."Table Line No.") AND
             Employee.GET(HRCommentLine."No.")
          THEN
            EXIT(
              HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
              EmployeeRelative."Relative Code");
        HRCommentLine."Table Name"::"Misc. Article Information":
          IF MiscArticleInfo.GET(
               HRCommentLine."No.",HRCommentLine."Alternative Address Code",HRCommentLine."Table Line No.") AND
             Employee.GET(HRCommentLine."No.")
          THEN
            EXIT(
              HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
              MiscArticleInfo."Misc. Article Code");
        HRCommentLine."Table Name"::"Confidential Information":
          IF ConfidentialInfo.GET(HRCommentLine."No.",HRCommentLine."Table Line No.") AND
             Employee.GET(HRCommentLine."No.")
          THEN
            EXIT(
              HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
              ConfidentialInfo."Confidential Code");
      END;
      EXIT(Text000);
    END;

    BEGIN
    END.
  }
}


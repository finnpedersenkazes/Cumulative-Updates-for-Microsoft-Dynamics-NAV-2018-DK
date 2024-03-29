OBJECT Page 1181 Data Privacy ListPage
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Listeside for databeskyttelse;
               ENU=Data Privacy ListPage];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1181;
    PageType=ListPart;
    SourceTableTemporary=Yes;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                Editable=FALSE;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                DrillDown=No;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Table Name";
                Enabled=FALSE;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                DrillDown=No;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Field Name";
                Enabled=FALSE;
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                DrillDown=No;
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Field Value";
                Enabled=FALSE;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      ConfigProgressBar@1001 : Codeunit 8615;
      CreatingPreviewDataTxt@1002 : TextConst 'DAN=Opretter eksempeldata...;ENU=Creating preview data...';

    PROCEDURE GeneratePreviewData@2(PackageCode@1001 : Code[20]);
    VAR
      ConfigPackage@1003 : Record 8623;
      ConfigPackageTable@1006 : Record 8613;
      ConfigPackageField@1000 : Record 8616;
      ConfigXMLExchange@1004 : Codeunit 8614;
      RecRef@1002 : RecordRef;
      FieldRef@1005 : FieldRef;
      Counter@1009 : Integer;
    BEGIN
      Counter := 1;
      CLEAR(Rec);
      RESET;
      DELETEALL;
      CurrPage.UPDATE;

      IF ConfigPackage.GET(PackageCode) THEN BEGIN
        ConfigPackageTable.SETRANGE("Package Code",ConfigPackage.Code);
        ConfigProgressBar.Init(ConfigPackageTable.COUNT,1,CreatingPreviewDataTxt);
        ConfigPackageTable.SETAUTOCALCFIELDS("Table Name");
        IF ConfigPackageTable.FINDSET THEN
          REPEAT
            ConfigProgressBar.Update(ConfigPackageTable."Table Name");
            RecRef.OPEN(ConfigPackageTable."Table ID");
            ConfigXMLExchange.ApplyPackageFilter(ConfigPackageTable,RecRef);
            IF RecRef.FINDSET THEN
              REPEAT
                ConfigPackageField.SETRANGE("Package Code",ConfigPackageTable."Package Code");
                ConfigPackageField.SETRANGE("Table ID",ConfigPackageTable."Table ID");
                IF ConfigPackageField.FINDSET THEN
                  REPEAT
                    FieldRef := RecRef.FIELD(ConfigPackageField."Field ID");
                    INIT;
                    ID := Counter;
                    "Table No." := ConfigPackageTable."Table ID";
                    "Field No." := ConfigPackageField."Field ID";
                    "Field Value" := FORMAT(FieldRef.VALUE);
                    "Field DataType" := FORMAT(FieldRef.TYPE);
                    IF NOT INSERT THEN
                      REPEAT
                        Counter := Counter + 1;
                        ID := Counter;
                      UNTIL INSERT;
                  UNTIL ConfigPackageField.NEXT = 0;
              UNTIL RecRef.NEXT = 0;
            RecRef.CLOSE;
          UNTIL ConfigPackageTable.NEXT = 0;
        ConfigProgressBar.Close;
      END;
      // CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}


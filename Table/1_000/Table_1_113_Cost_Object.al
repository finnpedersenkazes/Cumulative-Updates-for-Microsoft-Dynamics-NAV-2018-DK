OBJECT Table 1113 Cost Object
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               TESTFIELD(Code);
             END;

    OnDelete=BEGIN
               SETRECFILTER;
               ConfirmDeleteIfEntriesExist(Rec,TRUE);
               SETRANGE(Code);
             END;

    CaptionML=[DAN=Omkostningsemne;
               ENU=Cost Object];
    LookupPageID=Page1123;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;OnLookup=VAR
                                                              CostAccMgt@1000 : Codeunit 1100;
                                                            BEGIN
                                                              CostAccMgt.LookupCostObjectFromDimValue(Code);
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Cost Type Filter    ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Cost Type";
                                                   CaptionML=[DAN=Omkostningstypefilter;
                                                              ENU=Cost Type Filter] }
    { 4   ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 5   ;   ;Net Change          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry".Amount WHERE (Cost Object Code=FIELD(Code),
                                                                                              Cost Object Code=FIELD(FILTER(Totaling)),
                                                                                              Cost Type No.=FIELD(Cost Type Filter),
                                                                                              Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Bev�gelse;
                                                              ENU=Net Change];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 6   ;   ;Balance at Date     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry".Amount WHERE (Cost Object Code=FIELD(Code),
                                                                                              Cost Object Code=FIELD(FILTER(Totaling)),
                                                                                              Cost Type No.=FIELD(Cost Type Filter),
                                                                                              Posting Date=FIELD(UPPERLIMIT(Date Filter))));
                                                   CaptionML=[DAN=Saldo til dato;
                                                              ENU=Balance at Date];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 7   ;   ;Sorting Order       ;Code10        ;CaptionML=[DAN=Sorteringsr�kkef�lge;
                                                              ENU=Sorting Order] }
    { 8   ;   ;Comment             ;Text50        ;CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment] }
    { 9   ;   ;Line Type           ;Option        ;OnValidate=BEGIN
                                                                // Change to other type. Entries exist?
                                                                IF (("Line Type" <> "Line Type"::"Cost Object") AND
                                                                    (xRec."Line Type" = xRec."Line Type"::"Cost Object")) OR
                                                                   (("Line Type" <> "Line Type"::"Begin-Total") AND
                                                                    (xRec."Line Type" = xRec."Line Type"::"Begin-Total"))
                                                                THEN
                                                                  ConfirmModifyIfEntriesExist(Rec);

                                                                IF "Line Type" <> "Line Type"::"Cost Object" THEN BEGIN
                                                                  Blocked := TRUE;
                                                                END ELSE
                                                                  Totaling := '';
                                                              END;

                                                   CaptionML=[DAN=Linjetype;
                                                              ENU=Line Type];
                                                   OptionCaptionML=[DAN=Omkostningsemne,Overskrift,Total,Fra-sum,Til-sum;
                                                                    ENU=Cost Object,Heading,Total,Begin-Total,End-Total];
                                                   OptionString=Cost Object,Heading,Total,Begin-Total,End-Total }
    { 10  ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp�rret;
                                                              ENU=Blocked] }
    { 11  ;   ;New Page            ;Boolean       ;CaptionML=[DAN=Sideskift;
                                                              ENU=New Page] }
    { 12  ;   ;Blank Line          ;Boolean       ;CaptionML=[DAN=Tom linje;
                                                              ENU=Blank Line];
                                                   MinValue=No }
    { 13  ;   ;Indentation         ;Integer       ;CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation];
                                                   MinValue=0;
                                                   Editable=No }
    { 14  ;   ;Totaling            ;Text250       ;OnValidate=BEGIN
                                                                IF NOT ("Line Type" IN ["Line Type"::Total,"Line Type"::"End-Total"]) THEN
                                                                  FIELDERROR("Line Type");

                                                                CALCFIELDS("Net Change");
                                                              END;

                                                   OnLookup=VAR
                                                              SelectionFilter@1000 : Text[1024];
                                                            BEGIN
                                                              IF LookupCostObjectFilter(SelectionFilter) THEN
                                                                VALIDATE(Totaling,COPYSTR(SelectionFilter,1,MAXSTRLEN(Totaling)));
                                                            END;

                                                   CaptionML=[DAN=Samment�lling;
                                                              ENU=Totaling] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
    {    ;Sorting Order                            }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Code,Name                                }
  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Der er finansposter, omkostningsposter og/eller omkostningsbudgetposter, der er bogf�rt i det valgte omkostningsobjekt. Er du sikker p�, du vil slette omkostningsobjektet?;ENU=There are general ledger entries, cost entries, or cost budget entries that are posted to the selected cost object. Are you sure that you want to delete the cost object?';
      Text002@1002 : TextConst 'DAN=Der er finansposter, omkostningsposter og/eller omkostningsbudgetposter, der er bogf�rt i det valgte omkostningsobjekt. Er du sikker p�, du vil �ndre omkostningsobjektet?;ENU=There are general ledger entries, cost entries, or cost budget entries that are posted to the selected cost object. Are you sure that you want to modify the cost object?';

    LOCAL PROCEDURE EntriesExist@2(VAR CostObject@1007 : Record 1113) EntriesFound : Boolean;
    VAR
      CostAccSetup@1000 : Record 1108;
      GLEntry@1001 : Record 17;
      CostEntry@1002 : Record 1104;
      CostBudgetEntry@1003 : Record 1109;
      DimensionMgt@1004 : Codeunit 408;
      DimFilter@1005 : Text;
    BEGIN
      CostAccSetup.GET;
      IF CostObject.FINDSET THEN
        REPEAT
          DimensionMgt.GetDimSetIDsForFilter(CostAccSetup."Cost Center Dimension",CostObject.Code);
          DimFilter := DimensionMgt.GetDimSetFilter;
          IF DimFilter <> '' THEN BEGIN
            GLEntry.SETFILTER("Dimension Set ID",DimFilter);
            IF GLEntry.FINDFIRST THEN
              EntriesFound := TRUE;
          END;

          IF NOT EntriesFound THEN BEGIN
            CostBudgetEntry.SETCURRENTKEY("Budget Name","Cost Object Code");
            CostBudgetEntry.SETRANGE("Cost Center Code",CostObject.Code);
            EntriesFound := NOT CostBudgetEntry.ISEMPTY;
          END;

          IF NOT EntriesFound THEN BEGIN
            CostEntry.SETCURRENTKEY("Cost Object Code");
            CostEntry.SETRANGE("Cost Object Code",CostObject.Code);
            EntriesFound := NOT CostEntry.ISEMPTY;
          END;
        UNTIL (CostObject.NEXT = 0) OR EntriesFound;
    END;

    [External]
    PROCEDURE ConfirmDeleteIfEntriesExist@3(VAR CostObject@1000 : Record 1113;CalledFromOnInsert@1001 : Boolean);
    BEGIN
      IF EntriesExist(CostObject) THEN
        IF NOT CONFIRM(Text001,TRUE) THEN
          ERROR('');
      IF NOT CalledFromOnInsert THEN
        CostObject.DELETEALL;
    END;

    LOCAL PROCEDURE ConfirmModifyIfEntriesExist@4(VAR CostObject@1000 : Record 1113);
    VAR
      CostObject2@1001 : Record 1113;
    BEGIN
      CostObject2 := CostObject;
      CostObject2.SETRECFILTER;
      IF EntriesExist(CostObject2) THEN
        IF NOT CONFIRM(Text002,TRUE) THEN
          ERROR('');
    END;

    [External]
    PROCEDURE LookupCostObjectFilter@9(VAR Text@1000 : Text) : Boolean;
    VAR
      ChartOfCostObjects@1002 : Page 1123;
    BEGIN
      ChartOfCostObjects.LOOKUPMODE(TRUE);
      IF ChartOfCostObjects.RUNMODAL = ACTION::LookupOK THEN BEGIN
        Text := ChartOfCostObjects.GetSelectionFilter;
        EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    BEGIN
    END.
  }
}


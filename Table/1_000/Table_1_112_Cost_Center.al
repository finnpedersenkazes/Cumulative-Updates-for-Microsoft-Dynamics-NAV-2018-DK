OBJECT Table 1112 Cost Center
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
               SETCURRENTKEY("Sorting Order");
             END;

    CaptionML=[DAN=Omkostningssted;
               ENU=Cost Center];
    LookupPageID=Page1122;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;OnLookup=VAR
                                                              CostAccMgt@1000 : Codeunit 1100;
                                                            BEGIN
                                                              CostAccMgt.LookupCostCenterFromDimValue(Code);
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Cost Subtype        ;Option        ;CaptionML=[DAN=Prisundertype;
                                                              ENU=Cost Subtype];
                                                   OptionCaptionML=[DAN=" ,Serviceomkostningssted,Hj�lpeomkostningssted,Hovedomkostningssted";
                                                                    ENU=" ,Service Cost Center,Aux. Cost Center,Main Cost Center"];
                                                   OptionString=[ ,Service Cost Center,Aux. Cost Center,Main Cost Center] }
    { 4   ;   ;Cost Type Filter    ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Cost Type";
                                                   CaptionML=[DAN=Omkostningstypefilter;
                                                              ENU=Cost Type Filter] }
    { 5   ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 6   ;   ;Net Change          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry".Amount WHERE (Cost Center Code=FIELD(Code),
                                                                                              Cost Center Code=FIELD(FILTER(Totaling)),
                                                                                              Cost Type No.=FIELD(Cost Type Filter),
                                                                                              Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Bev�gelse;
                                                              ENU=Net Change];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 7   ;   ;Balance at Date     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry".Amount WHERE (Cost Center Code=FIELD(Code),
                                                                                              Cost Center Code=FIELD(FILTER(Totaling)),
                                                                                              Cost Type No.=FIELD(Cost Type Filter),
                                                                                              Posting Date=FIELD(UPPERLIMIT(Date Filter))));
                                                   CaptionML=[DAN=Saldo til dato;
                                                              ENU=Balance at Date];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 8   ;   ;Balance to Allocate ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry".Amount WHERE (Cost Center Code=FIELD(Code),
                                                                                              Cost Center Code=FIELD(FILTER(Totaling)),
                                                                                              Cost Type No.=FIELD(Cost Type Filter),
                                                                                              Posting Date=FIELD(Date Filter),
                                                                                              Allocated=CONST(No)));
                                                   CaptionML=[DAN=Saldo til fordeling;
                                                              ENU=Balance to Allocate];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 9   ;   ;Responsible Person  ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                                UserMgt.ValidateUserID("Responsible Person");
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Responsible Person");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Ansvarlig person;
                                                              ENU=Responsible Person] }
    { 10  ;   ;Sorting Order       ;Code10        ;CaptionML=[DAN=Sorteringsr�kkef�lge;
                                                              ENU=Sorting Order] }
    { 11  ;   ;Comment             ;Text50        ;CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment] }
    { 12  ;   ;Line Type           ;Option        ;OnValidate=BEGIN
                                                                // Change to other type than cost type. Entries exist?
                                                                IF (("Line Type" <> "Line Type"::"Cost Center") AND
                                                                    (xRec."Line Type" = xRec."Line Type"::"Cost Center")) OR
                                                                   (("Line Type" <> "Line Type"::"Begin-Total") AND
                                                                    (xRec."Line Type" = xRec."Line Type"::"Begin-Total"))
                                                                THEN
                                                                  ConfirmModifyIfEntriesExist(Rec);

                                                                IF "Line Type" <> "Line Type"::"Cost Center" THEN BEGIN
                                                                  Blocked := TRUE;
                                                                  "Cost Subtype" := 0;
                                                                END ELSE
                                                                  Totaling := '';
                                                              END;

                                                   CaptionML=[DAN=Linjetype;
                                                              ENU=Line Type];
                                                   OptionCaptionML=[DAN=Omkostningssted,Overskrift,Total,Fra-sum,Til-sum;
                                                                    ENU=Cost Center,Heading,Total,Begin-Total,End-Total];
                                                   OptionString=Cost Center,Heading,Total,Begin-Total,End-Total }
    { 13  ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp�rret;
                                                              ENU=Blocked] }
    { 14  ;   ;New Page            ;Boolean       ;CaptionML=[DAN=Sideskift;
                                                              ENU=New Page] }
    { 15  ;   ;Blank Line          ;Boolean       ;CaptionML=[DAN=Tom linje;
                                                              ENU=Blank Line];
                                                   MinValue=No }
    { 16  ;   ;Indentation         ;Integer       ;CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation];
                                                   MinValue=0;
                                                   Editable=No }
    { 17  ;   ;Totaling            ;Text250       ;OnValidate=BEGIN
                                                                IF NOT ("Line Type" IN ["Line Type"::Total,"Line Type"::"End-Total"]) THEN
                                                                  FIELDERROR("Line Type");

                                                                CALCFIELDS("Net Change");
                                                              END;

                                                   OnLookup=VAR
                                                              SelectionFilter@1000 : Text[1024];
                                                            BEGIN
                                                              IF LookupCostCenterFilter(SelectionFilter) THEN
                                                                VALIDATE(Totaling,COPYSTR(SelectionFilter,1,MAXSTRLEN(Totaling)));
                                                            END;

                                                   CaptionML=[DAN=Samment�lling;
                                                              ENU=Totaling] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
    {    ;Cost Subtype                             }
    {    ;Sorting Order                            }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Code,Name                                }
  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Der er finansposter, omkostningsposter eller omkostningsbudgetposter, der er bogf�rt i det valgte omkostningssted. Er du sikker p�, at du vil slette omkostningsstedet?;ENU=There are general ledger entries, cost entries, or cost budget entries that are posted to the selected cost center. Are you sure that you want to delete the cost center?';
      Text002@1002 : TextConst 'DAN=Der er finansposter, omkostningsposter eller omkostningsbudgetposter, der er bogf�rt i det valgte omkostningssted. Er du sikker p�, at du vil �ndre omkostningsstedet?;ENU=There are general ledger entries, cost entries, or cost budget entries that are posted to the selected cost center. Are you sure that you want to modify the cost center?';

    LOCAL PROCEDURE EntriesExist@1(VAR CostCenter@1007 : Record 1112) EntriesFound : Boolean;
    VAR
      CostAccSetup@1000 : Record 1108;
      GLEntry@1001 : Record 17;
      CostEntry@1002 : Record 1104;
      CostBudgetEntry@1003 : Record 1109;
      DimensionMgt@1004 : Codeunit 408;
      DimFilter@1005 : Text;
    BEGIN
      CostAccSetup.GET;
      IF CostCenter.FINDSET THEN
        REPEAT
          DimensionMgt.GetDimSetIDsForFilter(CostAccSetup."Cost Center Dimension",CostCenter.Code);
          DimFilter := DimensionMgt.GetDimSetFilter;
          IF DimFilter <> '' THEN BEGIN
            GLEntry.SETFILTER("Dimension Set ID",DimFilter);
            IF GLEntry.FINDFIRST THEN
              EntriesFound := TRUE;
          END;

          IF NOT EntriesFound THEN BEGIN
            CostBudgetEntry.SETCURRENTKEY("Budget Name","Cost Center Code");
            CostBudgetEntry.SETRANGE("Cost Center Code",CostCenter.Code);
            EntriesFound := NOT CostBudgetEntry.ISEMPTY;
          END;

          IF NOT EntriesFound THEN BEGIN
            CostEntry.SETCURRENTKEY("Cost Center Code");
            CostEntry.SETRANGE("Cost Center Code",CostCenter.Code);
            EntriesFound := NOT CostEntry.ISEMPTY;
          END;
        UNTIL (CostCenter.NEXT = 0) OR EntriesFound;
    END;

    [External]
    PROCEDURE ConfirmDeleteIfEntriesExist@3(VAR CostCenter@1000 : Record 1112;CalledFromOnInsert@1001 : Boolean);
    BEGIN
      IF EntriesExist(CostCenter) THEN
        IF NOT CONFIRM(Text001,TRUE) THEN
          ERROR('');
      IF NOT CalledFromOnInsert THEN
        CostCenter.DELETEALL;
    END;

    LOCAL PROCEDURE ConfirmModifyIfEntriesExist@4(VAR CostCenter@1000 : Record 1112);
    VAR
      CostCenter2@1001 : Record 1112;
    BEGIN
      CostCenter2 := CostCenter;
      CostCenter2.SETRECFILTER;
      IF EntriesExist(CostCenter2) THEN
        IF NOT CONFIRM(Text002,TRUE) THEN
          ERROR('');
    END;

    [External]
    PROCEDURE LookupCostCenterFilter@2(VAR Text@1000 : Text) : Boolean;
    VAR
      ChartOfCostCenters@1002 : Page 1122;
    BEGIN
      ChartOfCostCenters.LOOKUPMODE(TRUE);
      IF ChartOfCostCenters.RUNMODAL = ACTION::LookupOK THEN BEGIN
        Text := ChartOfCostCenters.GetSelectionFilter;
        EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    BEGIN
    END.
  }
}


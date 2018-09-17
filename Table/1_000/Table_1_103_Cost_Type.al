OBJECT Table 1103 Cost Type
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=;
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN
               TESTFIELD("No.");
               Modified;
             END;

    OnModify=BEGIN
               Modified;
             END;

    OnDelete=VAR
               GLAccount@1000 : Record 15;
               CostEntry@1001 : Record 1104;
               CostBudgetEntry@1002 : Record 1109;
             BEGIN
               // Message if balance  <> 0
               IF Type = Type::"Cost Type" THEN BEGIN
                 CALCFIELDS(Balance);
                 TESTFIELD(Balance,0);
               END;

               // Error if movement in not closed fiscal year
               CostEntry.SETRANGE("Cost Type No.","No.");
               AccPeriod.SETRANGE(Closed,FALSE);
               IF AccPeriod.FINDFIRST THEN
                 CostEntry.SETFILTER("Posting Date",'>=%1',AccPeriod."Starting Date");
               IF NOT CostEntry.ISEMPTY THEN
                 ERROR(Text000);

               // Renumber to entries to no. 0
               CostEntry.RESET;
               CostEntry.SETCURRENTKEY("Cost Type No.");
               CostEntry.SETRANGE("Cost Type No.","No.");
               CostEntry.MODIFYALL("Cost Type No.",'');

               CostBudgetEntry.SETCURRENTKEY("Budget Name","Cost Type No.");
               CostBudgetEntry.SETRANGE("Cost Type No.","No.");
               CostBudgetEntry.DELETEALL;

               GLAccount.SETRANGE("Cost Type No.","No.");
               GLAccount.MODIFYALL("Cost Type No.",'');
             END;

    OnRename=BEGIN
               "Modified Date" := TODAY;
             END;

    CaptionML=[DAN=Omkostningstype;
               ENU=Cost Type];
    LookupPageID=Page1100;
    DrillDownPageID=Page1100;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;AltSearchField=Search Name;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Text50        ;OnValidate=BEGIN
                                                                "Search Name" := Name;
                                                              END;

                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Search Name         ;Code50        ;CaptionML=[DAN=S›genavn;
                                                              ENU=Search Name] }
    { 4   ;   ;Type                ;Option        ;OnValidate=VAR
                                                                CostEntry@1000 : Record 1104;
                                                                CostBudgetEntry@1001 : Record 1109;
                                                              BEGIN
                                                                // Blocked if <> account
                                                                IF Type <> xRec.Type THEN
                                                                  Blocked := Type <> Type::"Cost Type";

                                                                // CHange only if no entries or budget
                                                                IF Blocked AND NOT xRec.Blocked THEN BEGIN
                                                                  CostEntry.SETRANGE("Cost Type No.","No.");
                                                                  IF NOT CostEntry.ISEMPTY THEN
                                                                    ERROR(Text001,"No.",CostEntry.TABLECAPTION);
                                                                  CostBudgetEntry.SETRANGE("Cost Type No.","No.");
                                                                  IF NOT CostBudgetEntry.ISEMPTY THEN
                                                                    ERROR(Text001,"No.",CostBudgetEntry.TABLECAPTION);
                                                                END;

                                                                Totaling := '';
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Omkostningstype,Overskrift,Total,Fra-sum,Til-sum;
                                                                    ENU=Cost Type,Heading,Total,Begin-Total,End-Total];
                                                   OptionString=Cost Type,Heading,Total,Begin-Total,End-Total }
    { 6   ;   ;Cost Center Code    ;Code20        ;TableRelation="Cost Center";
                                                   CaptionML=[DAN=Omkostningsstedskode;
                                                              ENU=Cost Center Code] }
    { 7   ;   ;Cost Object Code    ;Code20        ;TableRelation="Cost Object";
                                                   CaptionML=[DAN=Omkostningsemnekode;
                                                              ENU=Cost Object Code] }
    { 10  ;   ;Combine Entries     ;Option        ;CaptionML=[DAN=Saml poster;
                                                              ENU=Combine Entries];
                                                   OptionCaptionML=[DAN=Ingen,Dag,M†ned;
                                                                    ENU=None,Day,Month];
                                                   OptionString=None,Day,Month }
    { 13  ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp‘rret;
                                                              ENU=Blocked] }
    { 17  ;   ;New Page            ;Boolean       ;CaptionML=[DAN=Sideskift;
                                                              ENU=New Page] }
    { 18  ;   ;Blank Line          ;Boolean       ;CaptionML=[DAN=Tom linje;
                                                              ENU=Blank Line];
                                                   MinValue=No;
                                                   BlankZero=Yes }
    { 19  ;   ;Indentation         ;Integer       ;CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation];
                                                   MinValue=0 }
    { 20  ;   ;Comment             ;Text50        ;CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment] }
    { 22  ;   ;Cost Classification ;Option        ;CaptionML=[DAN=Klassificering af omkostninger;
                                                              ENU=Cost Classification];
                                                   OptionCaptionML=[DAN=" ,Faste,Variable,Variable trin";
                                                                    ENU=" ,Fixed,Variable,Step Variable"];
                                                   OptionString=[ ,Fixed,Variable,Step Variable] }
    { 23  ;   ;Fixed Share         ;Text30        ;CaptionML=[DAN=Fast fordeling;
                                                              ENU=Fixed Share] }
    { 26  ;   ;Modified Date       ;Date          ;CaptionML=[DAN=Rettelsesdato;
                                                              ENU=Modified Date];
                                                   Editable=No }
    { 27  ;   ;Modified By         ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                              ModifiedBy@1001 : Code[50];
                                                            BEGIN
                                                              ModifiedBy := "Modified By";
                                                              UserMgt.LookupUserID(ModifiedBy);
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Rettet af;
                                                              ENU=Modified By];
                                                   Editable=No }
    { 28  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 29  ;   ;Cost Center Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Cost Center";
                                                   CaptionML=[DAN=Omkostningsstedsfilter;
                                                              ENU=Cost Center Filter] }
    { 30  ;   ;Cost Object Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Cost Object";
                                                   CaptionML=[DAN=Omkostningsemnefilter;
                                                              ENU=Cost Object Filter] }
    { 31  ;   ;Balance at Date     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry".Amount WHERE (Cost Type No.=FIELD(No.),
                                                                                              Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                              Cost Center Code=FIELD(Cost Center Filter),
                                                                                              Cost Object Code=FIELD(Cost Object Filter),
                                                                                              Posting Date=FIELD(UPPERLIMIT(Date Filter))));
                                                   CaptionML=[DAN=Saldo til dato;
                                                              ENU=Balance at Date];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 32  ;   ;Net Change          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry".Amount WHERE (Cost Type No.=FIELD(No.),
                                                                                              Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                              Cost Center Code=FIELD(Cost Center Filter),
                                                                                              Cost Object Code=FIELD(Cost Object Filter),
                                                                                              Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Bev‘gelse;
                                                              ENU=Net Change];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 33  ;   ;Budget Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Budget Entry".Amount WHERE (Cost Type No.=FIELD(No.),
                                                                                                     Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                                     Cost Center Code=FIELD(Cost Center Filter),
                                                                                                     Cost Object Code=FIELD(Cost Object Filter),
                                                                                                     Date=FIELD(Date Filter),
                                                                                                     Budget Name=FIELD(Budget Filter)));
                                                   CaptionML=[DAN=Budgetbel›b;
                                                              ENU=Budget Amount];
                                                   BlankZero=Yes }
    { 34  ;   ;Totaling            ;Text250       ;TableRelation="Cost Type";
                                                   OnValidate=BEGIN
                                                                IF NOT (Type IN [Type::Total,Type::"End-Total"]) THEN
                                                                  FIELDERROR(Type);

                                                                CALCFIELDS("Net Change");
                                                              END;

                                                   OnLookup=VAR
                                                              SelectionFilter@1000 : Text[1024];
                                                            BEGIN
                                                              IF LookupCostTypeFilter(SelectionFilter) THEN
                                                                VALIDATE(Totaling,COPYSTR(SelectionFilter,1,MAXSTRLEN(Totaling)));
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Samment‘lling;
                                                              ENU=Totaling] }
    { 35  ;   ;Budget Filter       ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Cost Budget Name";
                                                   CaptionML=[DAN=Budgetfilter;
                                                              ENU=Budget Filter] }
    { 36  ;   ;Balance             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry".Amount WHERE (Cost Type No.=FIELD(No.),
                                                                                              Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                              Cost Center Code=FIELD(Cost Center Filter),
                                                                                              Cost Object Code=FIELD(Cost Object Filter)));
                                                   CaptionML=[DAN=Saldo;
                                                              ENU=Balance];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 37  ;   ;Budget at Date      ;Decimal       ;CaptionML=[DAN=Budg. bel›b til dato;
                                                              ENU=Budget at Date];
                                                   Editable=No }
    { 40  ;   ;G/L Account Range   ;Text50        ;TableRelation="G/L Account";
                                                   OnLookup=VAR
                                                              SelectionFilter@1000 : Text[1024];
                                                            BEGIN
                                                              IF LookupGLAccFilter(SelectionFilter) THEN
                                                                VALIDATE("G/L Account Range",COPYSTR(SelectionFilter,1,MAXSTRLEN("G/L Account Range")));
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Finanskontointerval;
                                                              ENU=G/L Account Range] }
    { 47  ;   ;Debit Amount        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry"."Debit Amount" WHERE (Cost Type No.=FIELD(No.),
                                                                                                      Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                                      Cost Center Code=FIELD(Cost Center Filter),
                                                                                                      Cost Object Code=FIELD(Cost Object Filter),
                                                                                                      Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Debetbel›b;
                                                              ENU=Debit Amount] }
    { 48  ;   ;Credit Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry"."Credit Amount" WHERE (Cost Type No.=FIELD(No.),
                                                                                                       Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                                       Cost Center Code=FIELD(Cost Center Filter),
                                                                                                       Cost Object Code=FIELD(Cost Object Filter),
                                                                                                       Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kreditbel›b;
                                                              ENU=Credit Amount] }
    { 51  ;   ;Balance to Allocate ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry".Amount WHERE (Cost Type No.=FIELD(No.),
                                                                                              Cost Center Code=FIELD(Cost Center Filter),
                                                                                              Cost Object Code=FIELD(Cost Object Filter),
                                                                                              Allocated=CONST(No),
                                                                                              Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Saldo til fordeling;
                                                              ENU=Balance to Allocate];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 60  ;   ;Budget Debit Amount ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Budget Entry".Amount WHERE (Cost Type No.=FIELD(No.),
                                                                                                     Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                                     Cost Center Code=FIELD(Cost Center Filter),
                                                                                                     Cost Object Code=FIELD(Cost Object Filter),
                                                                                                     Date=FIELD(Date Filter),
                                                                                                     Budget Name=FIELD(Budget Filter)));
                                                   CaptionML=[DAN=Budgetdebetbel›b;
                                                              ENU=Budget Debit Amount];
                                                   BlankNumbers=BlankNegAndZero }
    { 72  ;   ;Budget Credit Amount;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Cost Budget Entry".Amount WHERE (Cost Type No.=FIELD(No.),
                                                                                                      Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                                      Cost Center Code=FIELD(Cost Center Filter),
                                                                                                      Cost Object Code=FIELD(Cost Object Filter),
                                                                                                      Date=FIELD(Date Filter),
                                                                                                      Budget Name=FIELD(Budget Filter)));
                                                   CaptionML=[DAN=Budgetkreditbel›b;
                                                              ENU=Budget Credit Amount];
                                                   BlankNumbers=BlankNegAndZero }
    { 73  ;   ;Add. Currency Net Change;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry"."Additional-Currency Amount" WHERE (Cost Type No.=FIELD(No.),
                                                                                                                    Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                                                    Cost Center Code=FIELD(Cost Center Filter),
                                                                                                                    Cost Object Code=FIELD(Cost Object Filter),
                                                                                                                    Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Bev‘gelse af ekstra valuta;
                                                              ENU=Add. Currency Net Change];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 74  ;   ;Add. Currency Balance at Date;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Entry"."Additional-Currency Amount" WHERE (Cost Type No.=FIELD(No.),
                                                                                                                    Cost Type No.=FIELD(FILTER(Totaling)),
                                                                                                                    Cost Center Code=FIELD(Cost Center Filter),
                                                                                                                    Cost Object Code=FIELD(Cost Object Filter),
                                                                                                                    Posting Date=FIELD(UPPERLIMIT(Date Filter))));
                                                   CaptionML=[DAN=Saldo for ekstra valuta til dato;
                                                              ENU=Add. Currency Balance at Date] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Type                                     }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Name,Type                            }
  }
  CODE
  {
    VAR
      AccPeriod@1002 : Record 50;
      Text000@1003 : TextConst 'DAN=Du kan ikke slette en omkostningstype med poster i et †bent regnskabs†r.;ENU=You cannot delete a cost type with entries in an open fiscal year.';
      Text001@1004 : TextConst 'DAN=Du kan ikke ‘ndre omkostningstype %1. Der er knyttet %2 til den.;ENU=You cannot change cost type %1. There are %2 associated with it.';

    LOCAL PROCEDURE Modified@1();
    BEGIN
      "Modified Date" := TODAY;
      "Modified By" := USERID;
    END;

    [Internal]
    PROCEDURE LookupGLAccFilter@2(VAR Text@1000 : Text) : Boolean;
    VAR
      GLAccList@1001 : Page 18;
    BEGIN
      GLAccList.LOOKUPMODE(TRUE);
      IF GLAccList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        Text := GLAccList.GetSelectionFilter;
        EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    [Internal]
    PROCEDURE LookupCostTypeFilter@3(VAR Text@1000 : Text) : Boolean;
    VAR
      CostTypeList@1001 : Page 1124;
    BEGIN
      CostTypeList.LOOKUPMODE(TRUE);
      IF CostTypeList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        Text := CostTypeList.GetSelectionFilter;
        EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    BEGIN
    END.
  }
}


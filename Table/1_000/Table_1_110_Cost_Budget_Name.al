OBJECT Table 1110 Cost Budget Name
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
               TESTFIELD(Name);
             END;

    OnDelete=VAR
               CostBudgetEntry@1000 : Record 1109;
               CostBudgetRegister@1001 : Record 1111;
             BEGIN
               CostBudgetEntry.SETCURRENTKEY("Budget Name");
               CostBudgetEntry.SETRANGE("Budget Name",Name);
               CostBudgetEntry.DELETEALL;

               CostBudgetRegister.SETCURRENTKEY("Cost Budget Name");
               CostBudgetRegister.SETRANGE("Cost Budget Name",Name);
               CostBudgetRegister.DELETEALL;
             END;

    CaptionML=[DAN=Omkostningsbudgetnavn;
               ENU=Cost Budget Name];
    LookupPageID=Page1116;
  }
  FIELDS
  {
    { 1   ;   ;Name                ;Code10        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text80        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
  }
  KEYS
  {
    {    ;Name                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Name,Description                         }
  }
  CODE
  {

    BEGIN
    END.
  }
}


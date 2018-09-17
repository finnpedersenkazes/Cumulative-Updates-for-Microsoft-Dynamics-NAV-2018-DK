OBJECT Table 5207 Employee Absence
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    DataCaptionFields=Employee No.;
    OnInsert=BEGIN
               EmployeeAbsence.SETCURRENTKEY("Entry No.");
               IF EmployeeAbsence.FINDLAST THEN
                 "Entry No." := EmployeeAbsence."Entry No." + 1
               ELSE
                 "Entry No." := 1;
             END;

    CaptionML=[DAN=Medarbejders frav‘r;
               ENU=Employee Absence];
    LookupPageID=Page5211;
    DrillDownPageID=Page5211;
  }
  FIELDS
  {
    { 1   ;   ;Employee No.        ;Code20        ;TableRelation=Employee;
                                                   OnValidate=BEGIN
                                                                Employee.GET("Employee No.");
                                                                IF Employee."Privacy Blocked" THEN
                                                                  ERROR(BlockedErr);
                                                              END;

                                                   CaptionML=[DAN=Medarbejdernr.;
                                                              ENU=Employee No.];
                                                   NotBlank=Yes }
    { 2   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;From Date           ;Date          ;CaptionML=[DAN=Fra dato;
                                                              ENU=From Date] }
    { 4   ;   ;To Date             ;Date          ;CaptionML=[DAN=Til dato;
                                                              ENU=To Date] }
    { 5   ;   ;Cause of Absence Code;Code10       ;TableRelation="Cause of Absence";
                                                   OnValidate=BEGIN
                                                                CauseOfAbsence.GET("Cause of Absence Code");
                                                                Description := CauseOfAbsence.Description;
                                                                VALIDATE("Unit of Measure Code",CauseOfAbsence."Unit of Measure Code");
                                                              END;

                                                   CaptionML=[DAN=Frav‘rs†rsagskode;
                                                              ENU=Cause of Absence Code] }
    { 6   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 7   ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                "Quantity (Base)" := CalcBaseQty(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 8   ;   ;Unit of Measure Code;Code10        ;TableRelation="Human Resource Unit of Measure";
                                                   OnValidate=BEGIN
                                                                HumanResUnitOfMeasure.GET("Unit of Measure Code");
                                                                "Qty. per Unit of Measure" := HumanResUnitOfMeasure."Qty. per Unit of Measure";
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 11  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Human Resource Comment Line" WHERE (Table Name=CONST(Employee Absence),
                                                                                                          Table Line No.=FIELD(Entry No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 12  ;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 13  ;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Employee No.,From Date                  ;SumIndexFields=Quantity,Quantity (Base) }
    {    ;Employee No.,Cause of Absence Code,From Date;
                                                   SumIndexFields=Quantity,Quantity (Base) }
    {    ;Cause of Absence Code,From Date         ;SumIndexFields=Quantity,Quantity (Base) }
    {    ;From Date,To Date                        }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CauseOfAbsence@1000 : Record 5206;
      Employee@1001 : Record 5200;
      EmployeeAbsence@1002 : Record 5207;
      HumanResUnitOfMeasure@1003 : Record 5220;
      BlockedErr@1004 : TextConst 'DAN=Du kan ikke registrere frav‘r, fordi medarbejderen er blokeret p† grund af beskyttelse af personlige oplysninger.;ENU=You cannot register absence because the employee is blocked due to privacy.';

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    BEGIN
    END.
  }
}


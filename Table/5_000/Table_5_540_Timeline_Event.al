OBJECT Table 5540 Timeline Event
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tidslinjeh‘ndelse;
               ENU=Timeline Event];
  }
  FIELDS
  {
    { 1   ;   ;Transaction Type    ;Option        ;CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type];
                                                   OptionCaptionML=[DAN=Ingen,Oprindelig,Fast forsyning,Justerbar forsyning,Ny forsyning,Fast behov,Forventet behov;
                                                                    ENU=None,Initial,Fixed Supply,Adjustable Supply,New Supply,Fixed Demand,Expected Demand];
                                                   OptionString=None,Initial,Fixed Supply,Adjustable Supply,New Supply,Fixed Demand,Expected Demand }
    { 3   ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Original Date       ;Date          ;CaptionML=[DAN=Oprindelig dato;
                                                              ENU=Original Date] }
    { 5   ;   ;New Date            ;Date          ;CaptionML=[DAN=Ny dato;
                                                              ENU=New Date] }
    { 6   ;   ;ChangeRefNo         ;Text250       ;CaptionML=[DAN=’ndr.ref.nr.;
                                                              ENU=ChangeRefNo] }
    { 9   ;   ;Source Line ID      ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildelinje-id;
                                                              ENU=Source Line ID];
                                                   Editable=No }
    { 10  ;   ;Source Document ID  ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildebilags-id;
                                                              ENU=Source Document ID];
                                                   Editable=No }
    { 20  ;   ;Original Quantity   ;Decimal       ;CaptionML=[DAN=Oprindeligt antal;
                                                              ENU=Original Quantity];
                                                   DecimalPlaces=0:5 }
    { 21  ;   ;New Quantity        ;Decimal       ;CaptionML=[DAN=Nyt antal;
                                                              ENU=New Quantity];
                                                   DecimalPlaces=0:5 }
    { 1000;   ;ID                  ;Integer       ;AutoIncrement=No;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID];
                                                   MinValue=0;
                                                   NotBlank=Yes }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
    {    ;New Date,ID                              }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [Internal]
    PROCEDURE TransferToTransactionTable@19(VAR TimelineEvent@1003 : Record 5540;VAR transactionTable@1002 : DotNet "'Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.Timeline, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.TimelineVisualization.DataModel+TransactionDataTable");
    VAR
      transactionRow@1001 : DotNet "'Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.Timeline, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.TimelineVisualization.DataModel+TransactionRow";
    BEGIN
      transactionTable := transactionTable.TransactionDataTable;
      TimelineEvent.RESET;
      IF TimelineEvent.FIND('-') THEN
        REPEAT
          transactionRow := transactionTable.NewRow;
          transactionRow.RefNo := FORMAT(TimelineEvent.ID);
          transactionRow.ChangeRefNo := TimelineEvent.ChangeRefNo;
          transactionRow.TransactionType := TimelineEvent."Transaction Type";
          transactionRow.Description := TimelineEvent.Description;
          transactionRow.OriginalDate := CREATEDATETIME(TimelineEvent."Original Date",DefaultTime);
          transactionRow.NewDate := CREATEDATETIME(TimelineEvent."New Date",DefaultTime);
          transactionRow.OriginalQuantity := TimelineEvent."Original Quantity";
          transactionRow.NewQuantity := TimelineEvent."New Quantity";
          transactionTable.Rows.Add(transactionRow);
        UNTIL (TimelineEvent.NEXT = 0);
    END;

    [External]
    PROCEDURE DefaultTime@1() : Time;
    BEGIN
      EXIT(0T);
    END;

    BEGIN
    END.
  }
}


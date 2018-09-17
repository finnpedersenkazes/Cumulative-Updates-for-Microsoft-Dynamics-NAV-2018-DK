OBJECT Table 9055 Purchase Cue
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=K�bsk�indikator;
               ENU=Purchase Cue];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim�rn�gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;To Send or Confirm  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                                                              Status=FILTER(Open),
                                                                                              Responsibility Center=FIELD(Responsibility Center Filter)));
                                                   CaptionML=[DAN=Til afsendelse eller bekr�ftelse;
                                                              ENU=To Send or Confirm];
                                                   Editable=No }
    { 3   ;   ;Upcoming Orders     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                                                              Status=FILTER(Released),
                                                                                              Expected Receipt Date=FIELD(Date Filter),
                                                                                              Responsibility Center=FIELD(Responsibility Center Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Kommende ordrer;
                                                              ENU=Upcoming Orders];
                                                   Editable=No }
    { 4   ;   ;Outstanding Purchase Orders;Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                                                              Status=FILTER(Released),
                                                                                              Completely Received=FILTER(No),
                                                                                              Responsibility Center=FIELD(Responsibility Center Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Udest�ende k�bsordrer;
                                                              ENU=Outstanding Purchase Orders];
                                                   Editable=No }
    { 5   ;   ;Purchase Return Orders - All;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=FILTER(Return Order),
                                                                                              Responsibility Center=FIELD(Responsibility Center Filter)));
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=K�bsreturvareordrer - alle;
                                                              ENU=Purchase Return Orders - All];
                                                   Editable=No }
    { 6   ;   ;Not Invoiced        ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                                                              Completely Received=FILTER(Yes),
                                                                                              Invoice=FILTER(No),
                                                                                              Responsibility Center=FIELD(Responsibility Center Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Ikke faktureret;
                                                              ENU=Not Invoiced];
                                                   Editable=No }
    { 7   ;   ;Partially Invoiced  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                                                              Completely Received=FILTER(Yes),
                                                                                              Invoice=FILTER(Yes),
                                                                                              Responsibility Center=FIELD(Responsibility Center Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Delvist faktureret;
                                                              ENU=Partially Invoiced];
                                                   Editable=No }
    { 20  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter];
                                                   Editable=No }
    { 21  ;   ;Responsibility Center Filter;Code10;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for ansvarscenter;
                                                              ENU=Responsibility Center Filter];
                                                   Editable=No }
    { 22  ;   ;User ID Filter      ;Code50        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Bruger-id-filter;
                                                              ENU=User ID Filter] }
    { 23  ;   ;Pending Tasks       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("User Task" WHERE (Assigned To User Name=FIELD(User ID Filter),
                                                                                        Percent Complete=FILTER(<>100)));
                                                   CaptionML=[DAN=Ventende opgaver;
                                                              ENU=Pending Tasks] }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE SetRespCenterFilter@1();
    VAR
      UserSetupMgt@1000 : Codeunit 5700;
      RespCenterCode@1001 : Code[10];
    BEGIN
      RespCenterCode := UserSetupMgt.GetPurchasesFilter;
      IF RespCenterCode <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Responsibility Center Filter",RespCenterCode);
        FILTERGROUP(0);
      END;
    END;

    [External]
    PROCEDURE CountOrders@5(FieldNumber@1000 : Integer) : Integer;
    VAR
      CountPurchOrders@1001 : Query 9063;
      Result@1002 : Integer;
    BEGIN
      CASE FieldNumber OF
        FIELDNO("Outstanding Purchase Orders"):
          BEGIN
            CountPurchOrders.SETRANGE(Status,CountPurchOrders.Status::Released);
            CountPurchOrders.SETRANGE(Completely_Received,FALSE);
          END;
        FIELDNO("Not Invoiced"):
          BEGIN
            CountPurchOrders.SETRANGE(Completely_Received,TRUE);
            CountPurchOrders.SETRANGE(Partially_Invoiced,FALSE);
          END;
        FIELDNO("Partially Invoiced"):
          BEGIN
            CountPurchOrders.SETRANGE(Completely_Received,TRUE);
            CountPurchOrders.SETRANGE(Partially_Invoiced,TRUE);
          END;
      END;
      FILTERGROUP(2);
      CountPurchOrders.SETFILTER(Responsibility_Center,GETFILTER("Responsibility Center Filter"));
      FILTERGROUP(0);

      CountPurchOrders.OPEN;
      CountPurchOrders.READ;
      Result := CountPurchOrders.Count_Orders;

      EXIT(Result);
    END;

    [External]
    PROCEDURE ShowOrders@2(FieldNumber@1001 : Integer);
    VAR
      PurchHeader@1000 : Record 38;
    BEGIN
      PurchHeader.SETRANGE("Document Type",PurchHeader."Document Type"::Order);
      CASE FieldNumber OF
        FIELDNO("Outstanding Purchase Orders"):
          BEGIN
            PurchHeader.SETRANGE(Status,PurchHeader.Status::Released);
            PurchHeader.SETRANGE("Completely Received",FALSE);
            PurchHeader.SETRANGE(Invoice);
          END;
        FIELDNO("Not Invoiced"):
          BEGIN
            PurchHeader.SETRANGE(Status);
            PurchHeader.SETRANGE("Completely Received",TRUE);
            PurchHeader.SETRANGE(Invoice,FALSE);
          END;
        FIELDNO("Partially Invoiced"):
          BEGIN
            PurchHeader.SETRANGE(Status);
            PurchHeader.SETRANGE("Completely Received",TRUE);
            PurchHeader.SETRANGE(Invoice,TRUE);
          END;
      END;
      FILTERGROUP(2);
      PurchHeader.SETFILTER("Responsibility Center",GETFILTER("Responsibility Center Filter"));
      FILTERGROUP(0);

      PAGE.RUN(PAGE::"Purchase Order List",PurchHeader);
    END;

    BEGIN
    END.
  }
}


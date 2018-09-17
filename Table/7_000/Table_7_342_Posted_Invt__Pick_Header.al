OBJECT Table 7342 Posted Invt. Pick Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 TestNoSeries;
                 "No. Series" := GetNoSeriesCode;
                 NoSeriesMgt.InitSeries("No. Series",xRec."No. Series","Posting Date","No.","No. Series");
               END;
               "Registering Date" := WORKDATE;
             END;

    OnDelete=VAR
               PostedInvtPickLine@1001 : Record 7343;
               WhseCommentLine@1000 : Record 5770;
             BEGIN
               PostedInvtPickLine.SETRANGE("No.","No.");
               PostedInvtPickLine.DELETEALL;

               WhseCommentLine.SETRANGE("Table Name",WhseCommentLine."Table Name"::"Posted Invt. Pick");
               WhseCommentLine.SETRANGE(Type,WhseCommentLine.Type::" ");
               WhseCommentLine.SETRANGE("No.","No.");
               WhseCommentLine.DELETEALL;
             END;

    CaptionML=[DAN=Bogf›rt plukhoved (lager);
               ENU=Posted Invt. Pick Header];
    LookupPageID=Page7395;
  }
  FIELDS
  {
    { 2   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 3   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   NotBlank=Yes }
    { 4   ;   ;Assigned User ID    ;Code50        ;TableRelation="Warehouse Employee" WHERE (Location Code=FIELD(Location Code));
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
    { 5   ;   ;Assignment Date     ;Date          ;CaptionML=[DAN=Tildelt den;
                                                              ENU=Assignment Date] }
    { 6   ;   ;Assignment Time     ;Time          ;CaptionML=[DAN=Tildelt kl.;
                                                              ENU=Assignment Time] }
    { 8   ;   ;Registering Date    ;Date          ;CaptionML=[DAN=Registreringsdato;
                                                              ENU=Registering Date] }
    { 9   ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 10  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Warehouse Comment Line" WHERE (Table Name=CONST(Posted Invt. Pick),
                                                                                                     Type=CONST(" "),
                                                                                                     No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 11  ;   ;Invt Pick No.       ;Code20        ;CaptionML=[DAN=Pluknr. (lager);
                                                              ENU=Invt Pick No.] }
    { 12  ;   ;No. Printed         ;Integer       ;CaptionML=[DAN=Udskrevet;
                                                              ENU=No. Printed];
                                                   Editable=No }
    { 20  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 7306;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(120)) "Purch. Rcpt. Header" WHERE (No.=FIELD(Source No.))
                                                                 ELSE IF (Source Type=CONST(110)) "Sales Shipment Header" WHERE (No.=FIELD(Source No.))
                                                                 ELSE IF (Source Type=CONST(6650)) "Return Shipment Header" WHERE (No.=FIELD(Source No.))
                                                                 ELSE IF (Source Type=CONST(6660)) "Return Receipt Header" WHERE (No.=FIELD(Source No.))
                                                                 ELSE IF (Source Type=CONST(5744)) "Transfer Shipment Header" WHERE (No.=FIELD(Source No.))
                                                                 ELSE IF (Source Type=CONST(5746)) "Transfer Receipt Header" WHERE (No.=FIELD(Source No.))
                                                                 ELSE IF (Source Type=CONST(5405)) "Production Order".No. WHERE (Status=FILTER(Released|Finished),
                                                                                                                                 No.=FIELD(Source No.));
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 7307;   ;Source Document     ;Option        ;CaptionML=[DAN=Kildedokument;
                                                              ENU=Source Document];
                                                   OptionCaptionML=[DAN=" ,Salgsordre,,,Salgsreturv.ordre,K›bsordre,,,K›bsreturv.ordre,Indg. overflytning,Udg. overflytning,Prod.forbrug,Prod.afgang";
                                                                    ENU=" ,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,Prod. Output"];
                                                   OptionString=[ ,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,Prod. Output];
                                                   BlankZero=Yes }
    { 7308;   ;Source Type         ;Integer       ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type] }
    { 7309;   ;Source Subtype      ;Option        ;CaptionML=[DAN=Kildeundertype;
                                                              ENU=Source Subtype];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9,10;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9,10];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9,10;
                                                   Editable=No }
    { 7310;   ;Destination Type    ;Option        ;CaptionML=[DAN=Destinationstype;
                                                              ENU=Destination Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Lokation,Vare,Familie,Salgsordre";
                                                                    ENU=" ,Customer,Vendor,Location,Item,Family,Sales Order"];
                                                   OptionString=[ ,Customer,Vendor,Location,Item,Family,Sales Order] }
    { 7311;   ;Destination No.     ;Code20        ;TableRelation=IF (Destination Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Destination Type=CONST(Customer)) Customer
                                                                 ELSE IF (Destination Type=CONST(Location)) Location
                                                                 ELSE IF (Destination Type=CONST(Item)) Item
                                                                 ELSE IF (Destination Type=CONST(Family)) Family
                                                                 ELSE IF (Destination Type=CONST(Sales Order)) "Sales Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=[DAN=Destinationsnr.;
                                                              ENU=Destination No.] }
    { 7312;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 7314;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 7315;   ;External Document No.2;Code35      ;CaptionML=[DAN=Eksternt bilagsnr. 2;
                                                              ENU=External Document No.2] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Invt Pick No.                            }
    {    ;Location Code                            }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      InvtSetup@1003 : Record 313;
      NoSeriesMgt@1002 : Codeunit 396;

    LOCAL PROCEDURE GetNoSeriesCode@7() : Code[20];
    BEGIN
      InvtSetup.GET;
      EXIT(InvtSetup."Posted Invt. Pick Nos.");
    END;

    LOCAL PROCEDURE TestNoSeries@5();
    BEGIN
      InvtSetup.GET;
      InvtSetup.TESTFIELD("Posted Invt. Pick Nos.");
    END;

    [External]
    PROCEDURE Navigate@2();
    VAR
      NavigateForm@1000 : Page 344;
    BEGIN
      NavigateForm.SetDoc("Posting Date","Source No.");
      NavigateForm.RUN;
    END;

    BEGIN
    END.
  }
}


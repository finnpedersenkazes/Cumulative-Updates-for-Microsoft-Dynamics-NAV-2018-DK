OBJECT Table 910 Posted Assembly Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnDelete=VAR
               AssemblyCommentLine@1000 : Record 906;
               PostedAssemblyLinesDelete@1001 : Codeunit 902;
             BEGIN
               CheckIsNotAsmToOrder;

               PostedAssemblyLinesDelete.DeleteLines(Rec);

               AssemblyCommentLine.SETCURRENTKEY("Document Type","Document No.");
               AssemblyCommentLine.SETRANGE("Document Type",AssemblyCommentLine."Document Type"::"Posted Assembly");
               AssemblyCommentLine.SETRANGE("Document No.","No.");
               AssemblyCommentLine.DELETEALL;
             END;

    CaptionML=[DAN=Bogf�rt montagehoved;
               ENU=Posted Assembly Header];
    LookupPageID=Page922;
  }
  FIELDS
  {
    { 2   ;   ;No.                 ;Code20        ;AltSearchField=Search Description;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Search Description  ;Code50        ;CaptionML=[DAN=S�gebeskrivelse;
                                                              ENU=Search Description] }
    { 5   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 9   ;   ;Order No.           ;Code20        ;CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 10  ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 12  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(No.),
                                                                                            Code=FIELD(Variant Code));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 15  ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Varebogf�ringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 16  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 19  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Assembly Comment Line" WHERE (Document Type=CONST(Posted Assembly),
                                                                                                    Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 20  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 21  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 22  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 23  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 24  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 25  ;   ;Starting Date       ;Date          ;CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 27  ;   ;Ending Date         ;Date          ;CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 33  ;   ;Bin Code            ;Code20        ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 39  ;   ;Item Rcpt. Entry No.;Integer       ;CaptionML=[DAN=Varelev.postl�benr.;
                                                              ENU=Item Rcpt. Entry No.] }
    { 40  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 41  ;   ;Quantity (Base)     ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 54  ;   ;Assemble to Order   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Posted Assemble-to-Order Link" WHERE (Assembly Document Type=CONST(Assembly),
                                                                                                            Assembly Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Montage til ordre;
                                                              ENU=Assemble to Order];
                                                   Editable=No }
    { 65  ;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2 }
    { 67  ;   ;Cost Amount         ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Cost Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 75  ;   ;Indirect Cost %     ;Decimal       ;CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5 }
    { 76  ;   ;Overhead Rate       ;Decimal       ;CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   DecimalPlaces=0:5 }
    { 80  ;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 81  ;   ;Qty. per Unit of Measure;Decimal   ;CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 100 ;   ;Reversed            ;Boolean       ;CaptionML=[DAN=Tilbagef�rt;
                                                              ENU=Reversed] }
    { 107 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 108 ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogf�ringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 109 ;   ;Order No. Series    ;Code20        ;CaptionML=[DAN=Ordrenummerserie;
                                                              ENU=Order No. Series] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 9010;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 9020;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Order No.                                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      RowIdx@1000 : ',MatCost,ResCost,ResOvhd,AsmOvhd,Total';

    [External]
    PROCEDURE ShowDimensions@30();
    VAR
      DimMgt@1000 : Codeunit 408;
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
    END;

    [External]
    PROCEDURE ShowStatistics@48();
    BEGIN
      TESTFIELD("Item No.");
      PAGE.RUN(PAGE::"Posted Asm. Order Statistics",Rec);
    END;

    [External]
    PROCEDURE PrintRecords@1(ShowRequestForm@1000 : Boolean);
    VAR
      ReportSelections@1001 : Record 77;
      PostedAssemblyHeader@1002 : Record 910;
    BEGIN
      WITH PostedAssemblyHeader DO BEGIN
        COPY(Rec);

        ReportSelections.PrintWithGUIYesNo(
          ReportSelections.Usage::"P.Assembly Order",PostedAssemblyHeader,ShowRequestForm,0);
      END;
    END;

    [External]
    PROCEDURE Navigate@2();
    VAR
      Navigate@1000 : Page 344;
    BEGIN
      Navigate.SetDoc("Posting Date","No.");
      Navigate.RUN;
    END;

    [External]
    PROCEDURE ShowItemTrackingLines@3();
    VAR
      ItemTrackingDocMgt@1000 : Codeunit 6503;
    BEGIN
      ItemTrackingDocMgt.ShowItemTrackingForShptRcptLine(DATABASE::"Posted Assembly Header",0,"No.",'',0,0);
    END;

    [External]
    PROCEDURE CheckIsNotAsmToOrder@63();
    BEGIN
      CALCFIELDS("Assemble to Order");
      TESTFIELD("Assemble to Order",FALSE);
    END;

    [External]
    PROCEDURE IsAsmToOrder@4() : Boolean;
    BEGIN
      CALCFIELDS("Assemble to Order");
      EXIT("Assemble to Order");
    END;

    [External]
    PROCEDURE ShowAsmToOrder@61();
    VAR
      PostedATOLink@1000 : Record 914;
    BEGIN
      PostedATOLink.ShowSalesShpt(Rec);
    END;

    [External]
    PROCEDURE CalcActualCosts@52(VAR ActCost@1006 : ARRAY [5] OF Decimal);
    VAR
      TempSourceInvtAdjmtEntryOrder@1005 : TEMPORARY Record 5896;
      CalcInvtAdjmtOrder@1001 : Codeunit 5896;
    BEGIN
      TempSourceInvtAdjmtEntryOrder.SetPostedAsmOrder(Rec);
      CalcInvtAdjmtOrder.CalcActualUsageCosts(TempSourceInvtAdjmtEntryOrder,"Quantity (Base)",TempSourceInvtAdjmtEntryOrder);
      ActCost[RowIdx::MatCost] := TempSourceInvtAdjmtEntryOrder."Single-Level Material Cost";
      ActCost[RowIdx::ResCost] := TempSourceInvtAdjmtEntryOrder."Single-Level Capacity Cost";
      ActCost[RowIdx::ResOvhd] := TempSourceInvtAdjmtEntryOrder."Single-Level Cap. Ovhd Cost";
      ActCost[RowIdx::AsmOvhd] := TempSourceInvtAdjmtEntryOrder."Single-Level Mfg. Ovhd Cost";
    END;

    [External]
    PROCEDURE CalcTotalCost@25(VAR ExpCost@1001 : ARRAY [5] OF Decimal) : Decimal;
    VAR
      GLSetup@1006 : Record 98;
      Resource@1004 : Record 156;
      PostedAssemblyLine@1000 : Record 911;
      DirectLineCost@1005 : Decimal;
    BEGIN
      GLSetup.GET;

      PostedAssemblyLine.SETRANGE("Document No.","No.");
      IF PostedAssemblyLine.FINDSET THEN
        REPEAT
          CASE PostedAssemblyLine.Type OF
            PostedAssemblyLine.Type::Item:
              ExpCost[RowIdx::MatCost] += PostedAssemblyLine."Cost Amount";
            PostedAssemblyLine.Type::Resource:
              BEGIN
                Resource.GET(PostedAssemblyLine."No.");
                DirectLineCost :=
                  ROUND(
                    Resource."Direct Unit Cost" * PostedAssemblyLine."Quantity (Base)",
                    GLSetup."Unit-Amount Rounding Precision");
                ExpCost[RowIdx::ResCost] += DirectLineCost;
                ExpCost[RowIdx::ResOvhd] += PostedAssemblyLine."Cost Amount" - DirectLineCost;
              END;
          END
        UNTIL PostedAssemblyLine.NEXT = 0;

      EXIT(ExpCost[RowIdx::MatCost] + ExpCost[RowIdx::ResCost] + ExpCost[RowIdx::ResOvhd]);
    END;

    BEGIN
    END.
  }
}


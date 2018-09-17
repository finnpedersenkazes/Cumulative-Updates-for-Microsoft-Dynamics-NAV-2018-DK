OBJECT Table 25 Vendor Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditorpost;
               ENU=Vendor Ledger Entry];
    LookupPageID=Page29;
    DrillDownPageID=Page29;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Kred.nummer;
                                                              ENU=Vendor No.] }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 5   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 6   ;   ;Document No.        ;Code20        ;OnLookup=VAR
                                                              IncomingDocument@1000 : Record 130;
                                                            BEGIN
                                                              IncomingDocument.HyperlinkToDocument("Document No.","Posting Date");
                                                            END;

                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 7   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 11  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 13  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                               Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                               Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Remaining Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                               Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Restbelõb;
                                                              ENU=Remaining Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 15  ;   ;Original Amt. (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                                       Entry Type=FILTER(Initial Entry),
                                                                                                                       Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Opr. belõb (RV);
                                                              ENU=Original Amt. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 16  ;   ;Remaining Amt. (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                                       Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Restbelõb (RV);
                                                              ENU=Remaining Amt. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 17  ;   ;Amount (LCY)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                       Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                                       Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Belõb (RV);
                                                              ENU=Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 18  ;   ;Purchase (LCY)      ;Decimal       ;CaptionML=[DAN=Kõb (RV);
                                                              ENU=Purchase (LCY)];
                                                   AutoFormatType=1 }
    { 20  ;   ;Inv. Discount (LCY) ;Decimal       ;CaptionML=[DAN=Fakt.rabatbelõb (RV);
                                                              ENU=Inv. Discount (LCY)];
                                                   AutoFormatType=1 }
    { 21  ;   ;Buy-from Vendor No. ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Leverandõrnr.;
                                                              ENU=Buy-from Vendor No.] }
    { 22  ;   ;Vendor Posting Group;Code20        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=[DAN=Kreditorbogfõringsgruppe;
                                                              ENU=Vendor Posting Group] }
    { 23  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 24  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 25  ;   ;Purchaser Code      ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Indkõberkode;
                                                              ENU=Purchaser Code] }
    { 27  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 28  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 33  ;   ;On Hold             ;Code3         ;CaptionML=[DAN=Afvent;
                                                              ENU=On Hold] }
    { 34  ;   ;Applies-to Doc. Type;Option        ;CaptionML=[DAN=Udligningsbilagstype;
                                                              ENU=Applies-to Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 35  ;   ;Applies-to Doc. No. ;Code20        ;CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 36  ;   ;Open                ;Boolean       ;CaptionML=[DAN=èben;
                                                              ENU=Open] }
    { 37  ;   ;Due Date            ;Date          ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 38  ;   ;Pmt. Discount Date  ;Date          ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Kont.rabatdato;
                                                              ENU=Pmt. Discount Date] }
    { 39  ;   ;Original Pmt. Disc. Possible;Decimal;
                                                   CaptionML=[DAN=Oprindelig mulig kont.rabat;
                                                              ENU=Original Pmt. Disc. Possible];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 40  ;   ;Pmt. Disc. Rcd.(LCY);Decimal       ;CaptionML=[DAN=Modt.kont.rabat (RV);
                                                              ENU=Pmt. Disc. Rcd.(LCY)];
                                                   AutoFormatType=1 }
    { 43  ;   ;Positive            ;Boolean       ;CaptionML=[DAN=Positiv;
                                                              ENU=Positive] }
    { 44  ;   ;Closed by Entry No. ;Integer       ;TableRelation="Vendor Ledger Entry";
                                                   CaptionML=[DAN=Lukket af lõbenr.;
                                                              ENU=Closed by Entry No.] }
    { 45  ;   ;Closed at Date      ;Date          ;CaptionML=[DAN=Lukket den;
                                                              ENU=Closed at Date] }
    { 46  ;   ;Closed by Amount    ;Decimal       ;CaptionML=[DAN=Lukket med belõb;
                                                              ENU=Closed by Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 47  ;   ;Applies-to ID       ;Code50        ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Udlignings-id;
                                                              ENU=Applies-to ID] }
    { 49  ;   ;Journal Batch Name  ;Code10        ;TestTableRelation=No;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 50  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 51  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anlëg;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 52  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 53  ;   ;Transaction No.     ;Integer       ;CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.] }
    { 54  ;   ;Closed by Amount (LCY);Decimal     ;CaptionML=[DAN=Lukket med belõb (RV);
                                                              ENU=Closed by Amount (LCY)];
                                                   AutoFormatType=1 }
    { 58  ;   ;Debit Amount        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Debit Amount" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                       Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                                       Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Debetbelõb;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Credit Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Credit Amount" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                        Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                                        Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kreditbelõb;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Debit Amount (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                             Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                                             Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Debetbelõb (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 61  ;   ;Credit Amount (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                              Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                                              Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kreditbelõb (RV);
                                                              ENU=Credit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 62  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 63  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 64  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 65  ;   ;Closed by Currency Code;Code10     ;TableRelation=Currency;
                                                   CaptionML=[DAN=Lukket med valutakode;
                                                              ENU=Closed by Currency Code] }
    { 66  ;   ;Closed by Currency Amount;Decimal  ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Lukket med valutabelõb;
                                                              ENU=Closed by Currency Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Closed by Currency Code" }
    { 73  ;   ;Adjusted Currency Factor;Decimal   ;CaptionML=[DAN=Reguleret valutafaktor;
                                                              ENU=Adjusted Currency Factor];
                                                   DecimalPlaces=0:15 }
    { 74  ;   ;Original Currency Factor;Decimal   ;CaptionML=[DAN=Oprindelig valutafaktor;
                                                              ENU=Original Currency Factor];
                                                   DecimalPlaces=0:15 }
    { 75  ;   ;Original Amount     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor Ledger Entry No.=FIELD(Entry No.),
                                                                                                               Entry Type=FILTER(Initial Entry),
                                                                                                               Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Oprindeligt belõb;
                                                              ENU=Original Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 76  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 77  ;   ;Remaining Pmt. Disc. Possible;Decimal;
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                                CALCFIELDS(Amount,"Original Amount");

                                                                IF "Remaining Pmt. Disc. Possible" * Amount < 0 THEN
                                                                  FIELDERROR("Remaining Pmt. Disc. Possible",STRSUBSTNO(MustHaveSameSignErr,FIELDCAPTION(Amount)));

                                                                IF ABS("Remaining Pmt. Disc. Possible") > ABS("Original Amount") THEN
                                                                  FIELDERROR("Remaining Pmt. Disc. Possible",STRSUBSTNO(MustNotBeLargerErr,FIELDCAPTION("Original Amount")));
                                                              END;

                                                   CaptionML=[DAN=Mulig restkontantrabat;
                                                              ENU=Remaining Pmt. Disc. Possible];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 78  ;   ;Pmt. Disc. Tolerance Date;Date     ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Kontantrabattolerancedato;
                                                              ENU=Pmt. Disc. Tolerance Date] }
    { 79  ;   ;Max. Payment Tolerance;Decimal     ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                                CALCFIELDS(Amount,"Remaining Amount");

                                                                IF "Max. Payment Tolerance" * Amount < 0 THEN
                                                                  FIELDERROR("Max. Payment Tolerance",STRSUBSTNO(MustHaveSameSignErr,FIELDCAPTION(Amount)));

                                                                IF ABS("Max. Payment Tolerance") > ABS("Remaining Amount") THEN
                                                                  FIELDERROR("Max. Payment Tolerance",STRSUBSTNO(MustNotBeLargerErr,FIELDCAPTION("Remaining Amount")));
                                                              END;

                                                   CaptionML=[DAN=Maks. betalingstolerance;
                                                              ENU=Max. Payment Tolerance];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 81  ;   ;Accepted Payment Tolerance;Decimal ;CaptionML=[DAN=Godkendt betalingstolerance;
                                                              ENU=Accepted Payment Tolerance];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 82  ;   ;Accepted Pmt. Disc. Tolerance;Boolean;
                                                   CaptionML=[DAN=Godkendt kont.rabattolerance;
                                                              ENU=Accepted Pmt. Disc. Tolerance] }
    { 83  ;   ;Pmt. Tolerance (LCY);Decimal       ;CaptionML=[DAN=Betalingstolerance (RV);
                                                              ENU=Pmt. Tolerance (LCY)];
                                                   AutoFormatType=1 }
    { 84  ;   ;Amount to Apply     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                                CALCFIELDS("Remaining Amount");

                                                                IF "Amount to Apply" * "Remaining Amount" < 0 THEN
                                                                  FIELDERROR("Amount to Apply",STRSUBSTNO(MustHaveSameSignErr,FIELDCAPTION("Remaining Amount")));

                                                                IF ABS("Amount to Apply") > ABS("Remaining Amount") THEN
                                                                  FIELDERROR("Amount to Apply",STRSUBSTNO(MustNotBeLargerErr,FIELDCAPTION("Remaining Amount")));
                                                              END;

                                                   CaptionML=[DAN=Belõb, der skal udlignes;
                                                              ENU=Amount to Apply];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 85  ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code] }
    { 86  ;   ;Applying Entry      ;Boolean       ;CaptionML=[DAN=Udlignende post;
                                                              ENU=Applying Entry] }
    { 87  ;   ;Reversed            ;Boolean       ;CaptionML=[DAN=Tilbagefõrt;
                                                              ENU=Reversed] }
    { 88  ;   ;Reversed by Entry No.;Integer      ;TableRelation="Vendor Ledger Entry";
                                                   CaptionML=[DAN=Tilbagefõrt af lõbenr.;
                                                              ENU=Reversed by Entry No.];
                                                   BlankZero=Yes }
    { 89  ;   ;Reversed Entry No.  ;Integer       ;TableRelation="Vendor Ledger Entry";
                                                   CaptionML=[DAN=Tilbagefõrt lõbenr.;
                                                              ENU=Reversed Entry No.];
                                                   BlankZero=Yes }
    { 90  ;   ;Prepayment          ;Boolean       ;CaptionML=[DAN=Forudbetaling;
                                                              ENU=Prepayment] }
    { 170 ;   ;Creditor No.        ;Code20        ;OnValidate=BEGIN
                                                                IF ("Creditor No." <> '') AND ("Recipient Bank Account" <> '') THEN
                                                                  FIELDERROR("Recipient Bank Account",
                                                                    STRSUBSTNO(FieldIsNotEmptyErr,FIELDCAPTION("Creditor No."),FIELDCAPTION("Recipient Bank Account")));
                                                              END;

                                                   CaptionML=[DAN=Kredit.nummer;
                                                              ENU=Creditor No.];
                                                   Numeric=Yes }
    { 171 ;   ;Payment Reference   ;Code50        ;CaptionML=[DAN=Betalingsreference;
                                                              ENU=Payment Reference];
                                                   Numeric=Yes }
    { 172 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 173 ;   ;Applies-to Ext. Doc. No.;Code35    ;CaptionML=[DAN=Eksternt udlign.bilagsnr.;
                                                              ENU=Applies-to Ext. Doc. No.] }
    { 288 ;   ;Recipient Bank Account;Code20      ;TableRelation="Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Vendor No.));
                                                   OnValidate=BEGIN
                                                                IF ("Recipient Bank Account" <> '') AND ("Creditor No." <> '') THEN
                                                                  FIELDERROR("Creditor No.",
                                                                    STRSUBSTNO(FieldIsNotEmptyErr,FIELDCAPTION("Recipient Bank Account"),FIELDCAPTION("Creditor No.")));
                                                              END;

                                                   CaptionML=[DAN=Modtagers bankkonto;
                                                              ENU=Recipient Bank Account] }
    { 289 ;   ;Message to Recipient;Text140       ;OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Meddelelse til modtager;
                                                              ENU=Message to Recipient] }
    { 290 ;   ;Exported to Payment File;Boolean   ;CaptionML=[DAN=Eksporteret til betalingsfil;
                                                              ENU=Exported to Payment File];
                                                   Editable=No }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Vendor No.,Posting Date,Currency Code   ;SumIndexFields=Purchase (LCY),Inv. Discount (LCY) }
    { No ;Vendor No.,Currency Code,Posting Date    }
    {    ;Document No.                             }
    {    ;External Document No.                    }
    {    ;Vendor No.,Open,Positive,Due Date,Currency Code }
    {    ;Open,Due Date                            }
    {    ;Document Type,Vendor No.,Posting Date,Currency Code;
                                                   SumIndexFields=Purchase (LCY),Inv. Discount (LCY);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Closed by Entry No.                      }
    {    ;Transaction No.                          }
    { No ;Vendor No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date,Currency Code;
                                                   SumIndexFields=Purchase (LCY),Inv. Discount (LCY) }
    { No ;Vendor No.,Open,Global Dimension 1 Code,Global Dimension 2 Code,Positive,Due Date,Currency Code }
    { No ;Open,Global Dimension 1 Code,Global Dimension 2 Code,Due Date }
    { No ;Document Type,Vendor No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date,Currency Code;
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Vendor No.,Applies-to ID,Open,Positive,Due Date }
    {    ;Vendor Posting Group                     }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,Vendor No.,Posting Date,Document Type,Document No. }
    { 2   ;Brick               ;Document No.,Description,Remaining Amt. (LCY),Due Date }
  }
  CODE
  {
    VAR
      FieldIsNotEmptyErr@1002 : TextConst '@@@="%1=Field;%2=Field";DAN=%1 kan ikke bruges, nÜr %2 indeholder en vërdi.;ENU=%1 cannot be used while %2 has a value.';
      MustHaveSameSignErr@1000 : TextConst 'DAN=skal have samme fortegn som %1;ENU=must have the same sign as %1';
      MustNotBeLargerErr@1001 : TextConst 'DAN=mÜ ikke vëre stõrre end %1;ENU=must not be larger than %1';

    [External]
    PROCEDURE ShowDoc@7() : Boolean;
    VAR
      PurchInvHeader@1003 : Record 122;
      PurchCrMemoHdr@1002 : Record 124;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Invoice:
          IF PurchInvHeader.GET("Document No.") THEN BEGIN
            PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
            EXIT(TRUE);
          END;
        "Document Type"::"Credit Memo":
          IF PurchCrMemoHdr.GET("Document No.") THEN BEGIN
            PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
            EXIT(TRUE);
          END
      END;
    END;

    [External]
    PROCEDURE DrillDownOnEntries@1(VAR DtldVendLedgEntry@1000 : Record 380);
    VAR
      VendLedgEntry@1001 : Record 25;
    BEGIN
      VendLedgEntry.RESET;
      DtldVendLedgEntry.COPYFILTER("Vendor No.",VendLedgEntry."Vendor No.");
      DtldVendLedgEntry.COPYFILTER("Currency Code",VendLedgEntry."Currency Code");
      DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",VendLedgEntry."Global Dimension 1 Code");
      DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",VendLedgEntry."Global Dimension 2 Code");
      DtldVendLedgEntry.COPYFILTER("Initial Entry Due Date",VendLedgEntry."Due Date");
      VendLedgEntry.SETCURRENTKEY("Vendor No.","Posting Date");
      VendLedgEntry.SETRANGE(Open,TRUE);
      PAGE.RUN(0,VendLedgEntry);
    END;

    [External]
    PROCEDURE DrillDownOnOverdueEntries@4(VAR DtldVendLedgEntry@1000 : Record 380);
    VAR
      VendLedgEntry@1001 : Record 25;
    BEGIN
      VendLedgEntry.RESET;
      DtldVendLedgEntry.COPYFILTER("Vendor No.",VendLedgEntry."Vendor No.");
      DtldVendLedgEntry.COPYFILTER("Currency Code",VendLedgEntry."Currency Code");
      DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",VendLedgEntry."Global Dimension 1 Code");
      DtldVendLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",VendLedgEntry."Global Dimension 2 Code");
      VendLedgEntry.SETCURRENTKEY("Vendor No.","Posting Date");
      VendLedgEntry.SETFILTER("Date Filter",'..%1',WORKDATE);
      VendLedgEntry.SETFILTER("Due Date",'<%1',WORKDATE);
      VendLedgEntry.SETFILTER("Remaining Amount",'<>%1',0);
      PAGE.RUN(0,VendLedgEntry);
    END;

    [External]
    PROCEDURE GetOriginalCurrencyFactor@2() : Decimal;
    BEGIN
      IF "Original Currency Factor" = 0 THEN
        EXIT(1);
      EXIT("Original Currency Factor");
    END;

    [External]
    PROCEDURE ShowDimensions@3();
    VAR
      DimMgt@1000 : Codeunit 408;
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    [External]
    PROCEDURE SetStyle@5() : Text;
    BEGIN
      IF Open THEN BEGIN
        IF WORKDATE > "Due Date" THEN
          EXIT('Unfavorable')
      END ELSE
        IF "Closed at Date" > "Due Date" THEN
          EXIT('Attention');
      EXIT('');
    END;

    [External]
    PROCEDURE CopyFromGenJnlLine@6(GenJnlLine@1000 : Record 81);
    BEGIN
      "Vendor No." := GenJnlLine."Account No.";
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Date" := GenJnlLine."Document Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      "External Document No." := GenJnlLine."External Document No.";
      Description := GenJnlLine.Description;
      "Currency Code" := GenJnlLine."Currency Code";
      "Purchase (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
      "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
      "Buy-from Vendor No." := GenJnlLine."Sell-to/Buy-from No.";
      "Vendor Posting Group" := GenJnlLine."Posting Group";
      "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := GenJnlLine."Dimension Set ID";
      "Purchaser Code" := GenJnlLine."Salespers./Purch. Code";
      "Source Code" := GenJnlLine."Source Code";
      "On Hold" := GenJnlLine."On Hold";
      "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
      "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
      "Due Date" := GenJnlLine."Due Date";
      "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
      "Applies-to ID" := GenJnlLine."Applies-to ID";
      "Journal Batch Name" := GenJnlLine."Journal Batch Name";
      "Reason Code" := GenJnlLine."Reason Code";
      "User ID" := USERID;
      "Bal. Account Type" := GenJnlLine."Bal. Account Type";
      "Bal. Account No." := GenJnlLine."Bal. Account No.";
      "No. Series" := GenJnlLine."Posting No. Series";
      "IC Partner Code" := GenJnlLine."IC Partner Code";
      Prepayment := GenJnlLine.Prepayment;
      "Recipient Bank Account" := GenJnlLine."Recipient Bank Account";
      "Message to Recipient" := GenJnlLine."Message to Recipient";
      "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
      "Creditor No." := GenJnlLine."Creditor No.";
      "Payment Reference" := GenJnlLine."Payment Reference";
      "Payment Method Code" := GenJnlLine."Payment Method Code";
      "Exported to Payment File" := GenJnlLine."Exported to Payment File";

      OnAfterCopyVendLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    END;

    [External]
    PROCEDURE CopyFromCVLedgEntryBuffer@9(VAR CVLedgerEntryBuffer@1000 : Record 382);
    BEGIN
      "Entry No." := CVLedgerEntryBuffer."Entry No.";
      "Vendor No." := CVLedgerEntryBuffer."CV No.";
      "Posting Date" := CVLedgerEntryBuffer."Posting Date";
      "Document Type" := CVLedgerEntryBuffer."Document Type";
      "Document No." := CVLedgerEntryBuffer."Document No.";
      Description := CVLedgerEntryBuffer.Description;
      "Currency Code" := CVLedgerEntryBuffer."Currency Code";
      Amount := CVLedgerEntryBuffer.Amount;
      "Remaining Amount" := CVLedgerEntryBuffer."Remaining Amount";
      "Original Amount" := CVLedgerEntryBuffer."Original Amount";
      "Original Amt. (LCY)" := CVLedgerEntryBuffer."Original Amt. (LCY)";
      "Remaining Amt. (LCY)" := CVLedgerEntryBuffer."Remaining Amt. (LCY)";
      "Amount (LCY)" := CVLedgerEntryBuffer."Amount (LCY)";
      "Purchase (LCY)" := CVLedgerEntryBuffer."Sales/Purchase (LCY)";
      "Inv. Discount (LCY)" := CVLedgerEntryBuffer."Inv. Discount (LCY)";
      "Buy-from Vendor No." := CVLedgerEntryBuffer."Bill-to/Pay-to CV No.";
      "Vendor Posting Group" := CVLedgerEntryBuffer."CV Posting Group";
      "Global Dimension 1 Code" := CVLedgerEntryBuffer."Global Dimension 1 Code";
      "Global Dimension 2 Code" := CVLedgerEntryBuffer."Global Dimension 2 Code";
      "Dimension Set ID" := CVLedgerEntryBuffer."Dimension Set ID";
      "Purchaser Code" := CVLedgerEntryBuffer."Salesperson Code";
      "User ID" := CVLedgerEntryBuffer."User ID";
      "Source Code" := CVLedgerEntryBuffer."Source Code";
      "On Hold" := CVLedgerEntryBuffer."On Hold";
      "Applies-to Doc. Type" := CVLedgerEntryBuffer."Applies-to Doc. Type";
      "Applies-to Doc. No." := CVLedgerEntryBuffer."Applies-to Doc. No.";
      Open := CVLedgerEntryBuffer.Open;
      "Due Date" := CVLedgerEntryBuffer."Due Date" ;
      "Pmt. Discount Date" := CVLedgerEntryBuffer."Pmt. Discount Date";
      "Original Pmt. Disc. Possible" := CVLedgerEntryBuffer."Original Pmt. Disc. Possible";
      "Remaining Pmt. Disc. Possible" := CVLedgerEntryBuffer."Remaining Pmt. Disc. Possible";
      "Pmt. Disc. Rcd.(LCY)" := CVLedgerEntryBuffer."Pmt. Disc. Given (LCY)";
      Positive := CVLedgerEntryBuffer.Positive;
      "Closed by Entry No." := CVLedgerEntryBuffer."Closed by Entry No.";
      "Closed at Date" := CVLedgerEntryBuffer."Closed at Date";
      "Closed by Amount" := CVLedgerEntryBuffer."Closed by Amount";
      "Applies-to ID" := CVLedgerEntryBuffer."Applies-to ID";
      "Journal Batch Name" := CVLedgerEntryBuffer."Journal Batch Name";
      "Reason Code" := CVLedgerEntryBuffer."Reason Code";
      "Bal. Account Type" := CVLedgerEntryBuffer."Bal. Account Type";
      "Bal. Account No." := CVLedgerEntryBuffer."Bal. Account No.";
      "Transaction No." := CVLedgerEntryBuffer."Transaction No.";
      "Closed by Amount (LCY)" := CVLedgerEntryBuffer."Closed by Amount (LCY)";
      "Debit Amount" := CVLedgerEntryBuffer."Debit Amount";
      "Credit Amount" := CVLedgerEntryBuffer."Credit Amount";
      "Debit Amount (LCY)" := CVLedgerEntryBuffer."Debit Amount (LCY)";
      "Credit Amount (LCY)" := CVLedgerEntryBuffer."Credit Amount (LCY)";
      "Document Date" := CVLedgerEntryBuffer."Document Date";
      "External Document No." := CVLedgerEntryBuffer."External Document No.";
      "No. Series" := CVLedgerEntryBuffer."No. Series";
      "Closed by Currency Code" := CVLedgerEntryBuffer."Closed by Currency Code";
      "Closed by Currency Amount" := CVLedgerEntryBuffer."Closed by Currency Amount";
      "Adjusted Currency Factor" := CVLedgerEntryBuffer."Adjusted Currency Factor";
      "Original Currency Factor" := CVLedgerEntryBuffer."Original Currency Factor";
      "Pmt. Disc. Tolerance Date" := CVLedgerEntryBuffer."Pmt. Disc. Tolerance Date";
      "Max. Payment Tolerance" := CVLedgerEntryBuffer."Max. Payment Tolerance";
      "Accepted Payment Tolerance" := CVLedgerEntryBuffer."Accepted Payment Tolerance";
      "Accepted Pmt. Disc. Tolerance" := CVLedgerEntryBuffer."Accepted Pmt. Disc. Tolerance";
      "Pmt. Tolerance (LCY)" := CVLedgerEntryBuffer."Pmt. Tolerance (LCY)";
      "Amount to Apply" := CVLedgerEntryBuffer."Amount to Apply";
      Prepayment := CVLedgerEntryBuffer.Prepayment;

      OnAfterCopyVendLedgerEntryFromCVLedgEntryBuffer(Rec,CVLedgerEntryBuffer);
    END;

    [Internal]
    PROCEDURE RecalculateAmounts@36(FromCurrencyCode@1001 : Code[10];ToCurrencyCode@1002 : Code[10];PostingDate@1003 : Date);
    VAR
      CurrExchRate@1004 : Record 330;
    BEGIN
      IF ToCurrencyCode = FromCurrencyCode THEN
        EXIT;

      "Remaining Amount" :=
        CurrExchRate.ExchangeAmount("Remaining Amount",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Remaining Pmt. Disc. Possible" :=
        CurrExchRate.ExchangeAmount("Remaining Pmt. Disc. Possible",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Accepted Payment Tolerance" :=
        CurrExchRate.ExchangeAmount("Accepted Payment Tolerance",FromCurrencyCode,ToCurrencyCode,PostingDate);
      "Amount to Apply" :=
        CurrExchRate.ExchangeAmount("Amount to Apply",FromCurrencyCode,ToCurrencyCode,PostingDate);
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCopyVendLedgerEntryFromGenJnlLine@8(VAR VendorLedgerEntry@1000 : Record 25;GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCopyVendLedgerEntryFromCVLedgEntryBuffer@18(VAR VendorLedgerEntry@1000 : Record 25;CVLedgerEntryBuffer@1001 : Record 382);
    BEGIN
    END;

    BEGIN
    END.
  }
}


OBJECT Table 21 Cust. Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitorpost;
               ENU=Cust. Ledger Entry];
    LookupPageID=Page25;
    DrillDownPageID=Page25;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.] }
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
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                              Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                                              Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Remaining Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                                              Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Restbelõb;
                                                              ENU=Remaining Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 15  ;   ;Original Amt. (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                                                      Entry Type=FILTER(Initial Entry),
                                                                                                                      Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Opr. belõb (RV);
                                                              ENU=Original Amt. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 16  ;   ;Remaining Amt. (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                                                      Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Restbelõb (RV);
                                                              ENU=Remaining Amt. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 17  ;   ;Amount (LCY)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                      Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                                                      Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Belõb (RV);
                                                              ENU=Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 18  ;   ;Sales (LCY)         ;Decimal       ;CaptionML=[DAN=Salg (RV);
                                                              ENU=Sales (LCY)];
                                                   AutoFormatType=1 }
    { 19  ;   ;Profit (LCY)        ;Decimal       ;CaptionML=[DAN=Avancebelõb (RV);
                                                              ENU=Profit (LCY)];
                                                   AutoFormatType=1 }
    { 20  ;   ;Inv. Discount (LCY) ;Decimal       ;CaptionML=[DAN=Fakt.rabatbelõb (RV);
                                                              ENU=Inv. Discount (LCY)];
                                                   AutoFormatType=1 }
    { 21  ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.] }
    { 22  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   CaptionML=[DAN=Debitorbogfõringsgruppe;
                                                              ENU=Customer Posting Group] }
    { 23  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 24  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 25  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Sëlgerkode;
                                                              ENU=Salesperson Code] }
    { 27  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   ValidateTableRelation=No;
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
    { 37  ;   ;Due Date            ;Date          ;OnValidate=VAR
                                                                ReminderEntry@1000 : Record 300;
                                                                ReminderIssue@1565 : Codeunit 393;
                                                              BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                                IF "Due Date" <> xRec."Due Date" THEN BEGIN
                                                                  ReminderEntry.SETCURRENTKEY("Customer Entry No.",Type);
                                                                  ReminderEntry.SETRANGE("Customer Entry No.","Entry No.");
                                                                  ReminderEntry.SETRANGE(Type,ReminderEntry.Type::Reminder);
                                                                  ReminderEntry.SETRANGE("Reminder Level","Last Issued Reminder Level");
                                                                  IF ReminderEntry.FINDLAST THEN
                                                                    ReminderIssue.ChangeDueDate(ReminderEntry,"Due Date",xRec."Due Date");
                                                                END;
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
    { 40  ;   ;Pmt. Disc. Given (LCY);Decimal     ;CaptionML=[DAN=Ydet kont.rabat (RV);
                                                              ENU=Pmt. Disc. Given (LCY)];
                                                   AutoFormatType=1 }
    { 43  ;   ;Positive            ;Boolean       ;CaptionML=[DAN=Positiv;
                                                              ENU=Positive] }
    { 44  ;   ;Closed by Entry No. ;Integer       ;TableRelation="Cust. Ledger Entry";
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
    { 49  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
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
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Debit Amount" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                      Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                                                      Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Debetbelõb;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Credit Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Credit Amount" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                       Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                                                       Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kreditbelõb;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Debit Amount (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                            Cust. Ledger Entry No.=FIELD(Entry No.),
                                                                                                                            Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Debetbelõb (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 61  ;   ;Credit Amount (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" WHERE (Ledger Entry Amount=CONST(Yes),
                                                                                                                             Cust. Ledger Entry No.=FIELD(Entry No.),
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
    { 64  ;   ;Calculate Interest  ;Boolean       ;CaptionML=[DAN=Beregn rente;
                                                              ENU=Calculate Interest] }
    { 65  ;   ;Closing Interest Calculated;Boolean;CaptionML=[DAN=Beregnet Lukkerente;
                                                              ENU=Closing Interest Calculated] }
    { 66  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 67  ;   ;Closed by Currency Code;Code10     ;TableRelation=Currency;
                                                   CaptionML=[DAN=Lukket med valutakode;
                                                              ENU=Closed by Currency Code] }
    { 68  ;   ;Closed by Currency Amount;Decimal  ;AccessByPermission=TableData 4=R;
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
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Cust. Ledger Entry No.=FIELD(Entry No.),
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
                                                                  FIELDERROR("Remaining Pmt. Disc. Possible",STRSUBSTNO(Text000,FIELDCAPTION(Amount)));

                                                                IF ABS("Remaining Pmt. Disc. Possible") > ABS("Original Amount") THEN
                                                                  FIELDERROR("Remaining Pmt. Disc. Possible",STRSUBSTNO(Text001,FIELDCAPTION("Original Amount")));
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
                                                                  FIELDERROR("Max. Payment Tolerance",STRSUBSTNO(Text000,FIELDCAPTION(Amount)));

                                                                IF ABS("Max. Payment Tolerance") > ABS("Remaining Amount") THEN
                                                                  FIELDERROR("Max. Payment Tolerance",STRSUBSTNO(Text001,FIELDCAPTION("Remaining Amount")));
                                                              END;

                                                   CaptionML=[DAN=Maks. betalingstolerance;
                                                              ENU=Max. Payment Tolerance];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 80  ;   ;Last Issued Reminder Level;Integer ;CaptionML=[DAN=Niv. for sidst udstedte rykker;
                                                              ENU=Last Issued Reminder Level] }
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
                                                                  FIELDERROR("Amount to Apply",STRSUBSTNO(Text000,FIELDCAPTION("Remaining Amount")));

                                                                IF ABS("Amount to Apply") > ABS("Remaining Amount") THEN
                                                                  FIELDERROR("Amount to Apply",STRSUBSTNO(Text001,FIELDCAPTION("Remaining Amount")));
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
                                                              ENU=Reversed];
                                                   BlankZero=Yes }
    { 88  ;   ;Reversed by Entry No.;Integer      ;TableRelation="Cust. Ledger Entry";
                                                   CaptionML=[DAN=Tilbagefõrt af lõbenr.;
                                                              ENU=Reversed by Entry No.];
                                                   BlankZero=Yes }
    { 89  ;   ;Reversed Entry No.  ;Integer       ;TableRelation="Cust. Ledger Entry";
                                                   CaptionML=[DAN=Tilbagefõrt lõbenr.;
                                                              ENU=Reversed Entry No.];
                                                   BlankZero=Yes }
    { 90  ;   ;Prepayment          ;Boolean       ;CaptionML=[DAN=Forudbetaling;
                                                              ENU=Prepayment] }
    { 172 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Open,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 173 ;   ;Applies-to Ext. Doc. No.;Code35    ;CaptionML=[DAN=Eksternt udlign.bilagsnr.;
                                                              ENU=Applies-to Ext. Doc. No.] }
    { 288 ;   ;Recipient Bank Account;Code20      ;TableRelation="Customer Bank Account".Code WHERE (Customer No.=FIELD(Customer No.));
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
    { 1200;   ;Direct Debit Mandate ID;Code35     ;TableRelation="SEPA Direct Debit Mandate" WHERE (Customer No.=FIELD(Customer No.));
                                                   CaptionML=[DAN=Id for Direct Debit-betalingsaftale;
                                                              ENU=Direct Debit Mandate ID] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Customer No.,Posting Date,Currency Code ;SumIndexFields=Sales (LCY),Profit (LCY),Inv. Discount (LCY) }
    { No ;Customer No.,Currency Code,Posting Date  }
    {    ;Document No.                             }
    {    ;External Document No.                    }
    {    ;Customer No.,Open,Positive,Due Date,Currency Code }
    {    ;Open,Due Date                            }
    {    ;Document Type,Customer No.,Posting Date,Currency Code;
                                                   SumIndexFields=Sales (LCY),Profit (LCY),Inv. Discount (LCY);
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Salesperson Code,Posting Date            }
    {    ;Closed by Entry No.                      }
    {    ;Transaction No.                          }
    { No ;Customer No.,Open,Positive,Calculate Interest,Due Date }
    { No ;Customer No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date,Currency Code;
                                                   SumIndexFields=Sales (LCY),Profit (LCY),Inv. Discount (LCY) }
    { No ;Customer No.,Open,Global Dimension 1 Code,Global Dimension 2 Code,Positive,Due Date,Currency Code }
    { No ;Open,Global Dimension 1 Code,Global Dimension 2 Code,Due Date }
    { No ;Document Type,Customer No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date,Currency Code }
    {    ;Customer No.,Applies-to ID,Open,Positive,Due Date }
    {    ;Document Type,Posting Date              ;SumIndexFields=Sales (LCY) }
    {    ;Document Type,Customer No.,Open          }
    {    ;Customer Posting Group                   }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,Customer No.,Posting Date,Document Type,Document No. }
    { 2   ;Brick               ;Document No.,Description,Remaining Amt. (LCY),Due Date }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=skal have samme fortegn som %1;ENU=must have the same sign as %1';
      Text001@1001 : TextConst 'DAN=mÜ ikke vëre stõrre end %1;ENU=must not be larger than %1';

    [External]
    PROCEDURE ShowDoc@7() : Boolean;
    VAR
      SalesInvoiceHdr@1003 : Record 112;
      SalesCrMemoHdr@1002 : Record 114;
      ServiceInvoiceHeader@1000 : Record 5992;
      ServiceCrMemoHeader@1001 : Record 5994;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Invoice:
          BEGIN
            IF SalesInvoiceHdr.GET("Document No.") THEN BEGIN
              PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvoiceHdr);
              EXIT(TRUE);
            END;
            IF ServiceInvoiceHeader.GET("Document No.") THEN BEGIN
              PAGE.RUN(PAGE::"Posted Service Invoice",ServiceInvoiceHeader);
              EXIT(TRUE);
            END;
          END;
        "Document Type"::"Credit Memo":
          BEGIN
            IF SalesCrMemoHdr.GET("Document No.") THEN BEGIN
              PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHdr);
              EXIT(TRUE);
            END;
            IF ServiceCrMemoHeader.GET("Document No.") THEN BEGIN
              PAGE.RUN(PAGE::"Posted Service Credit Memo",ServiceCrMemoHeader);
              EXIT(TRUE);
            END;
          END;
      END;
    END;

    [External]
    PROCEDURE DrillDownOnEntries@1(VAR DtldCustLedgEntry@1000 : Record 379);
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      CustLedgEntry.RESET;
      DtldCustLedgEntry.COPYFILTER("Customer No.",CustLedgEntry."Customer No.");
      DtldCustLedgEntry.COPYFILTER("Currency Code",CustLedgEntry."Currency Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",CustLedgEntry."Global Dimension 1 Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Due Date",CustLedgEntry."Due Date");
      CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
      CustLedgEntry.SETRANGE(Open,TRUE);
      PAGE.RUN(0,CustLedgEntry);
    END;

    [External]
    PROCEDURE DrillDownOnOverdueEntries@4(VAR DtldCustLedgEntry@1000 : Record 379);
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      CustLedgEntry.RESET;
      DtldCustLedgEntry.COPYFILTER("Customer No.",CustLedgEntry."Customer No.");
      DtldCustLedgEntry.COPYFILTER("Currency Code",CustLedgEntry."Currency Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 1",CustLedgEntry."Global Dimension 1 Code");
      DtldCustLedgEntry.COPYFILTER("Initial Entry Global Dim. 2",CustLedgEntry."Global Dimension 2 Code");
      CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
      CustLedgEntry.SETFILTER("Date Filter",'..%1',WORKDATE);
      CustLedgEntry.SETFILTER("Due Date",'<%1',WORKDATE);
      CustLedgEntry.SETFILTER("Remaining Amount",'<>%1',0);
      PAGE.RUN(0,CustLedgEntry);
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
    PROCEDURE SetApplyToFilters@9(CustomerNo@1000 : Code[20];ApplyDocType@1001 : Option;ApplyDocNo@1002 : Code[20];ApplyAmount@1003 : Decimal);
    BEGIN
      SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
      SETRANGE("Customer No.",CustomerNo);
      SETRANGE(Open,TRUE);
      IF ApplyDocNo <> '' THEN BEGIN
        SETRANGE("Document Type",ApplyDocType);
        SETRANGE("Document No.",ApplyDocNo);
        IF FINDFIRST THEN;
        SETRANGE("Document Type");
        SETRANGE("Document No.");
      END ELSE
        IF ApplyDocType <> 0 THEN BEGIN
          SETRANGE("Document Type",ApplyDocType);
          IF FINDFIRST THEN;
          SETRANGE("Document Type");
        END ELSE
          IF ApplyAmount <> 0 THEN BEGIN
            SETRANGE(Positive,ApplyAmount < 0);
            IF FINDFIRST THEN;
            SETRANGE(Positive);
          END;
    END;

    [External]
    PROCEDURE SetAmountToApply@35(AppliesToDocNo@1000 : Code[20];CustomerNo@1001 : Code[20]);
    BEGIN
      SETCURRENTKEY("Document No.");
      SETRANGE("Document No.",AppliesToDocNo);
      SETRANGE("Customer No.",CustomerNo);
      SETRANGE(Open,TRUE);
      IF FINDFIRST THEN BEGIN
        IF "Amount to Apply" = 0 THEN BEGIN
          CALCFIELDS("Remaining Amount");
          "Amount to Apply" := "Remaining Amount";
        END ELSE
          "Amount to Apply" := 0;
        "Accepted Payment Tolerance" := 0;
        "Accepted Pmt. Disc. Tolerance" := FALSE;
        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",Rec);
      END;
    END;

    [External]
    PROCEDURE CopyFromGenJnlLine@6(GenJnlLine@1000 : Record 81);
    BEGIN
      "Customer No." := GenJnlLine."Account No.";
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Date" := GenJnlLine."Document Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      "External Document No." := GenJnlLine."External Document No.";
      Description := GenJnlLine.Description;
      "Currency Code" := GenJnlLine."Currency Code";
      "Sales (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
      "Profit (LCY)" := GenJnlLine."Profit (LCY)";
      "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
      "Sell-to Customer No." := GenJnlLine."Sell-to/Buy-from No.";
      "Customer Posting Group" := GenJnlLine."Posting Group";
      "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := GenJnlLine."Dimension Set ID";
      "Salesperson Code" := GenJnlLine."Salespers./Purch. Code";
      "Source Code" := GenJnlLine."Source Code";
      "On Hold" := GenJnlLine."On Hold";
      "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
      "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
      "Due Date" := GenJnlLine."Due Date";
      "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
      "Applies-to ID" := GenJnlLine."Applies-to ID";
      "Journal Batch Name" := GenJnlLine."Journal Batch Name";
      "Reason Code" := GenJnlLine."Reason Code";
      "Direct Debit Mandate ID" := GenJnlLine."Direct Debit Mandate ID";
      "User ID" := USERID;
      "Bal. Account Type" := GenJnlLine."Bal. Account Type";
      "Bal. Account No." := GenJnlLine."Bal. Account No.";
      "No. Series" := GenJnlLine."Posting No. Series";
      "IC Partner Code" := GenJnlLine."IC Partner Code";
      Prepayment := GenJnlLine.Prepayment;
      "Recipient Bank Account" := GenJnlLine."Recipient Bank Account";
      "Message to Recipient" := GenJnlLine."Message to Recipient";
      "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
      "Payment Method Code" := GenJnlLine."Payment Method Code";
      "Exported to Payment File" := GenJnlLine."Exported to Payment File";

      OnAfterCopyCustLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
    END;

    [External]
    PROCEDURE CopyFromCVLedgEntryBuffer@10(VAR CVLedgerEntryBuffer@1000 : Record 382);
    BEGIN
      TRANSFERFIELDS(CVLedgerEntryBuffer);
      Amount := CVLedgerEntryBuffer.Amount;
      "Amount (LCY)" := CVLedgerEntryBuffer."Amount (LCY)";
      "Remaining Amount" := CVLedgerEntryBuffer."Remaining Amount";
      "Remaining Amt. (LCY)" := CVLedgerEntryBuffer."Remaining Amt. (LCY)";
      "Original Amount" := CVLedgerEntryBuffer."Original Amount";
      "Original Amt. (LCY)" := CVLedgerEntryBuffer."Original Amt. (LCY)";

      OnAfterCopyCustLedgerEntryFromCVLedgEntryBuffer(Rec,CVLedgerEntryBuffer);
    END;

    PROCEDURE RecalculateAmounts@26(FromCurrencyCode@1001 : Code[10];ToCurrencyCode@1002 : Code[10];PostingDate@1003 : Date);
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
    LOCAL PROCEDURE OnAfterCopyCustLedgerEntryFromGenJnlLine@8(VAR CustLedgerEntry@1000 : Record 21;GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyCustLedgerEntryFromCVLedgEntryBuffer@11(VAR CustLedgerEntry@1001 : Record 21;CVLedgerEntryBuffer@1000 : Record 382);
    BEGIN
    END;

    BEGIN
    END.
  }
}


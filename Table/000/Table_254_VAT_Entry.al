OBJECT Table 254 VAT Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Momspost;
               ENU=VAT Entry];
    LookupPageID=Page315;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.];
                                                   Editable=No }
    { 2   ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group];
                                                   Editable=No }
    { 3   ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogfõringsgruppe;
                                                              ENU=Gen. Prod. Posting Group];
                                                   Editable=No }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date];
                                                   Editable=No }
    { 5   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.];
                                                   Editable=No }
    { 6   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund];
                                                   Editable=No }
    { 7   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                IF Type = Type::Settlement THEN
                                                                  ERROR(Text000,FIELDCAPTION(Type),Type);
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Kõb,Salg,Afregning";
                                                                    ENU=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement];
                                                   Editable=No }
    { 8   ;   ;Base                ;Decimal       ;CaptionML=[DAN=Grundlag;
                                                              ENU=Base];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 9   ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 10  ;   ;VAT Calculation Type;Option        ;CaptionML=[DAN=Momsberegningstype;
                                                              ENU=VAT Calculation Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 12  ;   ;Bill-to/Pay-to No.  ;Code20        ;TableRelation=IF (Type=CONST(Purchase)) Vendor
                                                                 ELSE IF (Type=CONST(Sale)) Customer;
                                                   OnValidate=BEGIN
                                                                VALIDATE(Type);
                                                                IF "Bill-to/Pay-to No." = '' THEN BEGIN
                                                                  "Country/Region Code" := '';
                                                                  "VAT Registration No." := '';
                                                                END ELSE
                                                                  CASE Type OF
                                                                    Type::Purchase:
                                                                      BEGIN
                                                                        Vend.GET("Bill-to/Pay-to No.");
                                                                        "Country/Region Code" := Vend."Country/Region Code";
                                                                        "VAT Registration No." := Vend."VAT Registration No.";
                                                                      END;
                                                                    Type::Sale:
                                                                      BEGIN
                                                                        Cust.GET("Bill-to/Pay-to No.");
                                                                        "Country/Region Code" := Cust."Country/Region Code";
                                                                        "VAT Registration No." := Cust."VAT Registration No.";
                                                                      END;
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Faktureres til/leverandõrnr.;
                                                              ENU=Bill-to/Pay-to No.] }
    { 13  ;   ;EU 3-Party Trade    ;Boolean       ;OnValidate=BEGIN
                                                                VALIDATE(Type);
                                                              END;

                                                   CaptionML=[DAN=Trekantshandel;
                                                              ENU=EU 3-Party Trade] }
    { 14  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 15  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code];
                                                   Editable=No }
    { 16  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code];
                                                   Editable=No }
    { 17  ;   ;Closed by Entry No. ;Integer       ;TableRelation="VAT Entry";
                                                   CaptionML=[DAN=Lukket af lõbenr.;
                                                              ENU=Closed by Entry No.];
                                                   Editable=No }
    { 18  ;   ;Closed              ;Boolean       ;CaptionML=[DAN=Lukket;
                                                              ENU=Closed];
                                                   Editable=No }
    { 19  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   OnValidate=BEGIN
                                                                VALIDATE(Type);
                                                                VALIDATE("VAT Registration No.");
                                                              END;

                                                   CaptionML=[DAN=Lande-/omrÜdekode;
                                                              ENU=Country/Region Code] }
    { 20  ;   ;Internal Ref. No.   ;Text30        ;CaptionML=[DAN=Internt referencenr.;
                                                              ENU=Internal Ref. No.];
                                                   Editable=No }
    { 21  ;   ;Transaction No.     ;Integer       ;CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.];
                                                   Editable=No }
    { 22  ;   ;Unrealized Amount   ;Decimal       ;CaptionML=[DAN=Urealiseret belõb;
                                                              ENU=Unrealized Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 23  ;   ;Unrealized Base     ;Decimal       ;CaptionML=[DAN=Urealiseret grundlag;
                                                              ENU=Unrealized Base];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 24  ;   ;Remaining Unrealized Amount;Decimal;CaptionML=[DAN=Urealiseret belõb - rest;
                                                              ENU=Remaining Unrealized Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 25  ;   ;Remaining Unrealized Base;Decimal  ;CaptionML=[DAN=Urealiseret grundlag - rest;
                                                              ENU=Remaining Unrealized Base];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 26  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.];
                                                   Editable=No }
    { 28  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 29  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=SkatteomrÜdekode;
                                                              ENU=Tax Area Code];
                                                   Editable=No }
    { 30  ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable];
                                                   Editable=No }
    { 31  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code];
                                                   Editable=No }
    { 32  ;   ;Use Tax             ;Boolean       ;CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax];
                                                   Editable=No }
    { 33  ;   ;Tax Jurisdiction Code;Code10       ;TableRelation="Tax Jurisdiction";
                                                   CaptionML=[DAN=Skatteregionkode;
                                                              ENU=Tax Jurisdiction Code];
                                                   Editable=No }
    { 34  ;   ;Tax Group Used      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Anvendt skattegruppe;
                                                              ENU=Tax Group Used];
                                                   Editable=No }
    { 35  ;   ;Tax Type            ;Option        ;CaptionML=[DAN=Skattetype;
                                                              ENU=Tax Type];
                                                   OptionCaptionML=[DAN=Sales Tax,Excise Tax;
                                                                    ENU=Sales Tax,Excise Tax];
                                                   OptionString=Sales Tax,Excise Tax;
                                                   Editable=No }
    { 36  ;   ;Tax on Tax          ;Boolean       ;CaptionML=[DAN=Skatters-skat;
                                                              ENU=Tax on Tax];
                                                   Editable=No }
    { 37  ;   ;Sales Tax Connection No.;Integer   ;CaptionML=[DAN=Sales tax forbindelsesnr.;
                                                              ENU=Sales Tax Connection No.];
                                                   Editable=No }
    { 38  ;   ;Unrealized VAT Entry No.;Integer   ;TableRelation="VAT Entry";
                                                   CaptionML=[DAN=Urealiseret momslõbenr.;
                                                              ENU=Unrealized VAT Entry No.];
                                                   Editable=No }
    { 39  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group];
                                                   Editable=No }
    { 40  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group];
                                                   Editable=No }
    { 43  ;   ;Additional-Currency Amount;Decimal ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Ekstra valuta (belõb);
                                                              ENU=Additional-Currency Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 44  ;   ;Additional-Currency Base;Decimal   ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Ekstra valuta (basis);
                                                              ENU=Additional-Currency Base];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 45  ;   ;Add.-Currency Unrealized Amt.;Decimal;
                                                   CaptionML=[DAN=Urealiseret belõb - eks. val.;
                                                              ENU=Add.-Currency Unrealized Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 46  ;   ;Add.-Currency Unrealized Base;Decimal;
                                                   CaptionML=[DAN=Ureal. grundlag - eks. val.;
                                                              ENU=Add.-Currency Unrealized Base];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 48  ;   ;VAT Base Discount % ;Decimal       ;CaptionML=[DAN=Momsgrundlagsrabat %;
                                                              ENU=VAT Base Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 49  ;   ;Add.-Curr. Rem. Unreal. Amount;Decimal;
                                                   CaptionML=[DAN=Ureal. restbelõb - eks. valuta;
                                                              ENU=Add.-Curr. Rem. Unreal. Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 50  ;   ;Add.-Curr. Rem. Unreal. Base;Decimal;
                                                   CaptionML=[DAN=Ureal. restgrdl. - eks. valuta;
                                                              ENU=Add.-Curr. Rem. Unreal. Base];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 51  ;   ;VAT Difference      ;Decimal       ;CaptionML=[DAN=Momsdifference;
                                                              ENU=VAT Difference];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 52  ;   ;Add.-Curr. VAT Difference;Decimal  ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Momsdifference (ekstra valuta);
                                                              ENU=Add.-Curr. VAT Difference];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 53  ;   ;Ship-to/Order Address Code;Code10  ;TableRelation=IF (Type=CONST(Purchase)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.))
                                                                 ELSE IF (Type=CONST(Sale)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.));
                                                   CaptionML=[DAN=Leverings-/Best.adressekode;
                                                              ENU=Ship-to/Order Address Code] }
    { 54  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date];
                                                   Editable=No }
    { 55  ;   ;VAT Registration No.;Text20        ;OnValidate=VAR
                                                                VATRegNoFormat@1000 : Record 381;
                                                              BEGIN
                                                                VATRegNoFormat.Test("VAT Registration No.","Country/Region Code",'',0);
                                                              END;

                                                   CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 56  ;   ;Reversed            ;Boolean       ;CaptionML=[DAN=Tilbagefõrt;
                                                              ENU=Reversed] }
    { 57  ;   ;Reversed by Entry No.;Integer      ;TableRelation="VAT Entry";
                                                   CaptionML=[DAN=Tilbagefõrt af lõbenr.;
                                                              ENU=Reversed by Entry No.];
                                                   BlankZero=Yes }
    { 58  ;   ;Reversed Entry No.  ;Integer       ;TableRelation="VAT Entry";
                                                   CaptionML=[DAN=Tilbagefõrt lõbenr.;
                                                              ENU=Reversed Entry No.];
                                                   BlankZero=Yes }
    { 59  ;   ;EU Service          ;Boolean       ;CaptionML=[DAN=EU-service;
                                                              ENU=EU Service];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Type,Closed,VAT Bus. Posting Group,VAT Prod. Posting Group,Posting Date;
                                                   SumIndexFields=Base,Amount,Additional-Currency Base,Additional-Currency Amount,Remaining Unrealized Amount,Remaining Unrealized Base,Add.-Curr. Rem. Unreal. Amount,Add.-Curr. Rem. Unreal. Base }
    {    ;Type,Closed,Tax Jurisdiction Code,Use Tax,Posting Date;
                                                   SumIndexFields=Base,Amount,Unrealized Amount,Unrealized Base,Remaining Unrealized Amount }
    {    ;Type,Country/Region Code,VAT Registration No.,VAT Bus. Posting Group,VAT Prod. Posting Group,Posting Date;
                                                   SumIndexFields=Base,Additional-Currency Base }
    {    ;Document No.,Posting Date                }
    {    ;Transaction No.                          }
    {    ;Tax Jurisdiction Code,Tax Group Used,Tax Type,Use Tax,Posting Date }
    {    ;Type,Bill-to/Pay-to No.,Transaction No. ;MaintainSQLIndex=No }
    {    ;Document Date                            }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Posting Date,Document Type,Document No.,Posting Date }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke ëndre indholdet af dette felt, nÜr %1 er %2.;ENU=You cannot change the contents of this field when %1 is %2.';
      Cust@1001 : Record 18;
      Vend@1002 : Record 23;
      GLSetup@1003 : Record 98;
      GLSetupRead@1004 : Boolean;

    LOCAL PROCEDURE GetCurrencyCode@1() : Code[10];
    BEGIN
      IF NOT GLSetupRead THEN BEGIN
        GLSetup.GET;
        GLSetupRead := TRUE;
      END;
      EXIT(GLSetup."Additional Reporting Currency");
    END;

    [External]
    PROCEDURE GetUnrealizedVATPart@2(SettledAmount@1003 : Decimal;Paid@1005 : Decimal;Full@1001 : Decimal;TotalUnrealVATAmountFirst@1006 : Decimal;TotalUnrealVATAmountLast@1007 : Decimal) : Decimal;
    VAR
      UnrealizedVATType@1000 : ' ,Percentage,First,Last,First (Fully Paid),Last (Fully Paid)';
    BEGIN
      IF (Type <> 0) AND
         (Amount = 0) AND
         (Base = 0)
      THEN BEGIN
        UnrealizedVATType := GetUnrealizedVATType;
        IF (UnrealizedVATType = UnrealizedVATType::" ") OR
           (("Remaining Unrealized Amount" = 0) AND
            ("Remaining Unrealized Base" = 0))
        THEN
          EXIT(0);

        IF ABS(Paid) = ABS(Full) THEN
          EXIT(1);

        CASE UnrealizedVATType OF
          UnrealizedVATType::Percentage:
            BEGIN
              IF ABS(Full) = ABS(Paid) - ABS(SettledAmount) THEN
                EXIT(1);
              EXIT(ABS(SettledAmount) / (ABS(Full) - (ABS(Paid) - ABS(SettledAmount))));
            END;
          UnrealizedVATType::First:
            BEGIN
              IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN
                EXIT(1);
              IF ABS(Paid) < ABS(TotalUnrealVATAmountFirst) THEN
                EXIT(ABS(SettledAmount) / ABS(TotalUnrealVATAmountFirst));
              EXIT(1);
            END;
          UnrealizedVATType::"First (Fully Paid)":
            BEGIN
              IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN
                EXIT(1);
              IF ABS(Paid) < ABS(TotalUnrealVATAmountFirst) THEN
                EXIT(0);
              EXIT(1);
            END;
          UnrealizedVATType::"Last (Fully Paid)":
            EXIT(0);
          UnrealizedVATType::Last:
            BEGIN
              IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN
                EXIT(0);
              IF ABS(Paid) > ABS(Full) - ABS(TotalUnrealVATAmountLast) THEN
                EXIT((ABS(Paid) - (ABS(Full) - ABS(TotalUnrealVATAmountLast))) / ABS(TotalUnrealVATAmountLast));
              EXIT(0);
            END;
        END;
      END ELSE
        EXIT(0);
    END;

    LOCAL PROCEDURE GetUnrealizedVATType@3() UnrealizedVATType : Integer;
    VAR
      VATPostingSetup@1001 : Record 325;
      TaxJurisdiction@1000 : Record 320;
    BEGIN
      IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN BEGIN
        TaxJurisdiction.GET("Tax Jurisdiction Code");
        UnrealizedVATType := TaxJurisdiction."Unrealized VAT Type";
      END ELSE BEGIN
        VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
        UnrealizedVATType := VATPostingSetup."Unrealized VAT Type";
      END;
    END;

    [External]
    PROCEDURE CopyFromGenJnlLine@5(GenJnlLine@1000 : Record 81);
    BEGIN
      CopyPostingGroupsFromGenJnlLine(GenJnlLine);
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Date" := GenJnlLine."Document Date";
      "Document No." := GenJnlLine."Document No.";
      "External Document No." := GenJnlLine."External Document No.";
      "Document Type" := GenJnlLine."Document Type";
      Type := GenJnlLine."Gen. Posting Type";
      "VAT Calculation Type" := GenJnlLine."VAT Calculation Type";
      "Source Code" := GenJnlLine."Source Code";
      "Reason Code" := GenJnlLine."Reason Code";
      "Ship-to/Order Address Code" := GenJnlLine."Ship-to/Order Address Code";
      "EU 3-Party Trade" := GenJnlLine."EU 3-Party Trade";
      "User ID" := USERID;
      "No. Series" := GenJnlLine."Posting No. Series";
      "VAT Base Discount %" := GenJnlLine."VAT Base Discount %";
      "Bill-to/Pay-to No." := GenJnlLine."Bill-to/Pay-to No.";
      "Country/Region Code" := GenJnlLine."Country/Region Code";
      "VAT Registration No." := GenJnlLine."VAT Registration No.";

      OnAfterCopyFromGenJnlLine(Rec,GenJnlLine);
    END;

    LOCAL PROCEDURE CopyPostingGroupsFromGenJnlLine@4(GenJnlLine@1000 : Record 81);
    BEGIN
      "Gen. Bus. Posting Group" := GenJnlLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := GenJnlLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := GenJnlLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := GenJnlLine."VAT Prod. Posting Group";
      "Tax Area Code" := GenJnlLine."Tax Area Code";
      "Tax Liable" := GenJnlLine."Tax Liable";
      "Tax Group Code" := GenJnlLine."Tax Group Code";
      "Use Tax" := GenJnlLine."Use Tax";
    END;

    [External]
    PROCEDURE CopyAmountsFromVATEntry@6(VATEntry@1000 : Record 254;WithOppositeSign@1001 : Boolean);
    VAR
      Sign@1002 : Decimal;
    BEGIN
      IF WithOppositeSign THEN
        Sign := -1
      ELSE
        Sign := 1;
      Base := Sign * VATEntry.Base;
      Amount := Sign * VATEntry.Amount;
      "Unrealized Amount" := Sign * VATEntry."Unrealized Amount";
      "Unrealized Base" := Sign * VATEntry."Unrealized Base";
      "Remaining Unrealized Amount" := Sign * VATEntry."Remaining Unrealized Amount";
      "Remaining Unrealized Base" := Sign * VATEntry."Remaining Unrealized Base";
      "Additional-Currency Amount" := Sign * VATEntry."Additional-Currency Amount";
      "Additional-Currency Base" := Sign * VATEntry."Additional-Currency Base";
      "Add.-Currency Unrealized Amt." := Sign * VATEntry."Add.-Currency Unrealized Amt.";
      "Add.-Currency Unrealized Base" := Sign * VATEntry."Add.-Currency Unrealized Base";
      "Add.-Curr. Rem. Unreal. Amount" := Sign * VATEntry."Add.-Curr. Rem. Unreal. Amount";
      "Add.-Curr. Rem. Unreal. Base" := Sign * VATEntry."Add.-Curr. Rem. Unreal. Base";
      "VAT Difference" := Sign * VATEntry."VAT Difference";
      "Add.-Curr. VAT Difference" := Sign * VATEntry."Add.-Curr. VAT Difference";
    END;

    [External]
    PROCEDURE SetUnrealAmountsToZero@7();
    BEGIN
      "Unrealized Amount" := 0;
      "Unrealized Base" := 0;
      "Remaining Unrealized Amount" := 0;
      "Remaining Unrealized Base" := 0;
      "Add.-Currency Unrealized Amt." := 0;
      "Add.-Currency Unrealized Base" := 0;
      "Add.-Curr. Rem. Unreal. Amount" := 0;
      "Add.-Curr. Rem. Unreal. Base" := 0;
    END;

    [Integration]
    PROCEDURE OnAfterCopyFromGenJnlLine@8(VAR VATEntry@1000 : Record 254;GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    BEGIN
    END.
  }
}


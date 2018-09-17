OBJECT Table 311 Sales & Receivables Setup
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019,NAVDK11.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opsëtning af Salg;
               ENU=Sales & Receivables Setup];
    LookupPageID=Page459;
    DrillDownPageID=Page459;
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Primërnõgle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Discount Posting    ;Option        ;CaptionML=[DAN=Bogfõring med rabat;
                                                              ENU=Discount Posting];
                                                   OptionCaptionML=[DAN=Ingen rabat,Fakturarabat,Linjerabat,Alle rabatter;
                                                                    ENU=No Discounts,Invoice Discounts,Line Discounts,All Discounts];
                                                   OptionString=No Discounts,Invoice Discounts,Line Discounts,All Discounts }
    { 4   ;   ;Credit Warnings     ;Option        ;CaptionML=[DAN=Kreditmeddelelser;
                                                              ENU=Credit Warnings];
                                                   OptionCaptionML=[DAN=Begge meddelelser,Kreditmaksimum,Forfaldne belõb,Ingen meddelelse;
                                                                    ENU=Both Warnings,Credit Limit,Overdue Balance,No Warning];
                                                   OptionString=Both Warnings,Credit Limit,Overdue Balance,No Warning }
    { 5   ;   ;Stockout Warning    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Beholdningsadvarsel;
                                                              ENU=Stockout Warning] }
    { 6   ;   ;Shipment on Invoice ;Boolean       ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Lev. ved fakturering;
                                                              ENU=Shipment on Invoice] }
    { 7   ;   ;Invoice Rounding    ;Boolean       ;CaptionML=[DAN=Fakturaafrunding;
                                                              ENU=Invoice Rounding] }
    { 8   ;   ;Ext. Doc. No. Mandatory;Boolean    ;CaptionML=[DAN=Eksternt bilagsnr. obl.;
                                                              ENU=Ext. Doc. No. Mandatory] }
    { 9   ;   ;Customer Nos.       ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Debitornumre;
                                                              ENU=Customer Nos.] }
    { 10  ;   ;Quote Nos.          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Tilbudsnumre;
                                                              ENU=Quote Nos.] }
    { 11  ;   ;Order Nos.          ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Ordrenumre;
                                                              ENU=Order Nos.] }
    { 12  ;   ;Invoice Nos.        ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Fakturanumre;
                                                              ENU=Invoice Nos.] }
    { 13  ;   ;Posted Invoice Nos. ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogfõrte fakturanumre;
                                                              ENU=Posted Invoice Nos.] }
    { 14  ;   ;Credit Memo Nos.    ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Kreditnotanumre;
                                                              ENU=Credit Memo Nos.] }
    { 15  ;   ;Posted Credit Memo Nos.;Code20     ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogf. kreditnotanumre;
                                                              ENU=Posted Credit Memo Nos.] }
    { 16  ;   ;Posted Shipment Nos.;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Bogf. salgslev.numre;
                                                              ENU=Posted Shipment Nos.] }
    { 17  ;   ;Reminder Nos.       ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Rykkernumre;
                                                              ENU=Reminder Nos.] }
    { 18  ;   ;Issued Reminder Nos.;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Udstedte rykkernumre;
                                                              ENU=Issued Reminder Nos.] }
    { 19  ;   ;Fin. Chrg. Memo Nos.;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Rentenotanumre;
                                                              ENU=Fin. Chrg. Memo Nos.] }
    { 20  ;   ;Issued Fin. Chrg. M. Nos.;Code20   ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Udstedte rentenotanumre;
                                                              ENU=Issued Fin. Chrg. M. Nos.] }
    { 21  ;   ;Posted Prepmt. Inv. Nos.;Code20    ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogfõrte forudbetalingsfakturanr.;
                                                              ENU=Posted Prepmt. Inv. Nos.] }
    { 22  ;   ;Posted Prepmt. Cr. Memo Nos.;Code20;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogfõrte forudbetalingskreditnotanr.;
                                                              ENU=Posted Prepmt. Cr. Memo Nos.] }
    { 23  ;   ;Blanket Order Nos.  ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Rammeordrenr.;
                                                              ENU=Blanket Order Nos.] }
    { 24  ;   ;Calc. Inv. Discount ;Boolean       ;CaptionML=[DAN=Beregn fakturarabat;
                                                              ENU=Calc. Inv. Discount] }
    { 25  ;   ;Appln. between Currencies;Option   ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Valutaudligning;
                                                              ENU=Appln. between Currencies];
                                                   OptionCaptionML=[DAN=Ingen,ùMU,Alle;
                                                                    ENU=None,EMU,All];
                                                   OptionString=None,EMU,All }
    { 26  ;   ;Copy Comments Blanket to Order;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Kopier bemërk. t. ordre;
                                                              ENU=Copy Comments Blanket to Order] }
    { 27  ;   ;Copy Comments Order to Invoice;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Kopier bemërk. t. fakt.;
                                                              ENU=Copy Comments Order to Invoice] }
    { 28  ;   ;Copy Comments Order to Shpt.;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Kopier bemërk. til lev.;
                                                              ENU=Copy Comments Order to Shpt.] }
    { 29  ;   ;Allow VAT Difference;Boolean       ;CaptionML=[DAN=Tillad momsdifference;
                                                              ENU=Allow VAT Difference] }
    { 30  ;   ;Calc. Inv. Disc. per VAT ID;Boolean;CaptionML=[DAN=Beregn fak.rabat pr. moms-id;
                                                              ENU=Calc. Inv. Disc. per VAT ID] }
    { 31  ;   ;Logo Position on Documents;Option  ;CaptionML=[DAN=Logoplacering pÜ dokumenter;
                                                              ENU=Logo Position on Documents];
                                                   OptionCaptionML=[DAN=Intet logo,Venstrestillet,Centreret,Hõjrestillet;
                                                                    ENU=No Logo,Left,Center,Right];
                                                   OptionString=No Logo,Left,Center,Right }
    { 32  ;   ;Check Prepmt. when Posting;Boolean ;CaptionML=[DAN=Kontroller forudbetaling ved bogfõring;
                                                              ENU=Check Prepmt. when Posting] }
    { 35  ;   ;Default Posting Date;Option        ;CaptionML=[DAN=Standardbogfõringsdato;
                                                              ENU=Default Posting Date];
                                                   OptionCaptionML=[DAN=Arbejdsdato,Ingen dato;
                                                                    ENU=Work Date,No Date];
                                                   OptionString=Work Date,No Date }
    { 36  ;   ;Default Quantity to Ship;Option    ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Standardantal til levering;
                                                              ENU=Default Quantity to Ship];
                                                   OptionCaptionML=[DAN=Resterende,Tom;
                                                                    ENU=Remainder,Blank];
                                                   OptionString=Remainder,Blank }
    { 37  ;   ;Archive Quotes and Orders;Boolean  ;CaptionML=[DAN=Arkiver tilbud og ordrer;
                                                              ENU=Archive Quotes and Orders] }
    { 38  ;   ;Post with Job Queue ;Boolean       ;CaptionML=[DAN=Bogfõr med opgavekõen;
                                                              ENU=Post with Job Queue] }
    { 39  ;   ;Job Queue Category Code;Code10     ;TableRelation="Job Queue Category";
                                                   CaptionML=[DAN=Opgavekõkategorikode;
                                                              ENU=Job Queue Category Code] }
    { 40  ;   ;Job Queue Priority for Post;Integer;InitValue=1000;
                                                   OnValidate=BEGIN
                                                                IF "Job Queue Priority for Post" < 0 THEN
                                                                  ERROR(Text001);
                                                              END;

                                                   CaptionML=[DAN=Opgavekõprioritet for bogfõring;
                                                              ENU=Job Queue Priority for Post];
                                                   MinValue=0 }
    { 41  ;   ;Post & Print with Job Queue;Boolean;CaptionML=[DAN=Bogfõr & udskriv med opgavekõen;
                                                              ENU=Post & Print with Job Queue] }
    { 42  ;   ;Job Q. Prio. for Post & Print;Integer;
                                                   InitValue=1000;
                                                   OnValidate=BEGIN
                                                                IF "Job Queue Priority for Post" < 0 THEN
                                                                  ERROR(Text001);
                                                              END;

                                                   CaptionML=[DAN=Opgavekõprioritet for bogfõring og udskrivning;
                                                              ENU=Job Q. Prio. for Post & Print];
                                                   MinValue=0 }
    { 43  ;   ;Notify On Success   ;Boolean       ;CaptionML=[DAN=Informer i tilfëlde af succes;
                                                              ENU=Notify On Success] }
    { 44  ;   ;VAT Bus. Posting Gr. (Price);Code20;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirks.bogf.gruppe (pris);
                                                              ENU=VAT Bus. Posting Gr. (Price)] }
    { 45  ;   ;Direct Debit Mandate Nos.;Code20   ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Direct Debit-betalingsaftalenumre;
                                                              ENU=Direct Debit Mandate Nos.] }
    { 46  ;   ;Allow Document Deletion Before;Date;CaptionML=[DAN=Tillad sletning af dokument fõr;
                                                              ENU=Allow Document Deletion Before] }
    { 50  ;   ;Default Item Quantity;Boolean      ;CaptionML=[DAN=Standardvareantal;
                                                              ENU=Default Item Quantity] }
    { 51  ;   ;Create Item from Description;Boolean;
                                                   CaptionML=[DAN=Opret vare ud fra beskrivelse;
                                                              ENU=Create Item from Description] }
    { 61  ;   ;Ignore Updated Addresses;Boolean   ;CaptionML=[DAN=Ignore Updated Addresses;
                                                              ENU=Ignore Updated Addresses] }
    { 5329;   ;Write-in Product Type;Option       ;CaptionML=[DAN=Produkttype, der skal rekvireres;
                                                              ENU=Write-in Product Type];
                                                   OptionCaptionML=[DAN=Vare,Ressource;
                                                                    ENU=Item,Resource];
                                                   OptionString=Item,Resource }
    { 5330;   ;Write-in Product No.;Code20        ;TableRelation=IF (Write-in Product Type=CONST(Item)) Item.No. WHERE (Type=CONST(Service))
                                                                 ELSE IF (Write-in Product Type=CONST(Resource)) Resource.No.;
                                                   CaptionML=[DAN=Nr. pÜ produkt, der skal rekvireres;
                                                              ENU=Write-in Product No.] }
    { 5800;   ;Posted Return Receipt Nos.;Code20  ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Bogfõrte returvaremodt.numre;
                                                              ENU=Posted Return Receipt Nos.] }
    { 5801;   ;Copy Cmts Ret.Ord. to Ret.Rcpt;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Kopier bem.til returkvit.;
                                                              ENU=Copy Cmts Ret.Ord. to Ret.Rcpt] }
    { 5802;   ;Copy Cmts Ret.Ord. to Cr. Memo;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Kopier bem. til kreditnota;
                                                              ENU=Copy Cmts Ret.Ord. to Cr. Memo] }
    { 6600;   ;Return Order Nos.   ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Returvareordrenumre;
                                                              ENU=Return Order Nos.] }
    { 6601;   ;Return Receipt on Credit Memo;Boolean;
                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Returvarekvit. pÜ kreditnota;
                                                              ENU=Return Receipt on Credit Memo] }
    { 6602;   ;Exact Cost Reversing Mandatory;Boolean;
                                                   CaptionML=[DAN=Obl. belõbstilbagefõrsel;
                                                              ENU=Exact Cost Reversing Mandatory] }
    { 7101;   ;Customer Group Dimension Code;Code20;
                                                   TableRelation=Dimension;
                                                   CaptionML=[DAN=Dimensionskode for kundegruppe;
                                                              ENU=Customer Group Dimension Code] }
    { 7102;   ;Salesperson Dimension Code;Code20  ;TableRelation=Dimension;
                                                   CaptionML=[DAN=Dimensionskode for sëlger;
                                                              ENU=Salesperson Dimension Code] }
    { 7103;   ;Freight G/L Acc. No.;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                CheckGLAccPostingTypeBlockedAndGenProdPostingType("Freight G/L Acc. No.");
                                                              END;

                                                   CaptionML=[DAN=Finanskontonr. for fragt;
                                                              ENU=Freight G/L Acc. No.] }
    { 13600;  ;OIOUBL Invoice Path ;Text250       ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-fakturasti;
                                                              ENU=OIOUBL Invoice Path] }
    { 13601;  ;OIOUBL Cr. Memo Path;Text250       ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-kreditnotasti;
                                                              ENU=OIOUBL Cr. Memo Path] }
    { 13602;  ;OIOUBL Reminder Path;Text250       ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-rykkersti;
                                                              ENU=OIOUBL Reminder Path] }
    { 13603;  ;OIOUBL Fin. Chrg. Memo Path;Text250;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-rentenotasti;
                                                              ENU=OIOUBL Fin. Chrg. Memo Path] }
    { 13604;  ;Default OIOUBL Profile Code;Code10 ;TableRelation="OIOUBL Profile";
                                                   OnValidate=VAR
                                                                OIOUBLProfile@1060000 : Record 13600;
                                                              BEGIN
                                                                OIOUBLProfile.UpdateEmptyOIOUBLProfileCodes("Default OIOUBL Profile Code",xRec."Default OIOUBL Profile Code");
                                                              END;

                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Standardkoden for OIOUBL-profil;
                                                              ENU=Default OIOUBL Profile Code] }
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
    VAR
      Text001@1000 : TextConst 'DAN=Opgavekõens prioritet skal vëre nul eller positiv.;ENU=Job Queue Priority must be zero or positive.';
      SetupOIOUBLQst@1060000 : TextConst 'DAN=OIOUBL-stien til OIOMXL-filen mangler. Vil du opdatere den nu?;ENU=OIOUBL path of the OIOMXL file is missing. Do you want to update it now?';
      MissingSetupOIOUBLErr@1060001 : TextConst 'DAN=OIOUBL-stien til OIOMXL-filen mangler. Ret den venligst.;ENU=OIOUBL path of the OIOMXL file is missing. Please Correct it.';

    [External]
    PROCEDURE GetLegalStatement@11() : Text;
    BEGIN
      EXIT('');
    END;

    [External]
    PROCEDURE JobQueueActive@1() : Boolean;
    BEGIN
      GET;
      EXIT("Post with Job Queue" OR "Post & Print with Job Queue");
    END;

    LOCAL PROCEDURE IsOIOUBLPathSetupAvailble@1060000("Document Type"@1060000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Finance Charge,Reminder') : Boolean;
    VAR
      SalesSetup@1060001 : Record 311;
      FileMgt@1060002 : Codeunit 419;
    BEGIN
      IF NOT FileMgt.CanRunDotNetOnClient THEN
        EXIT(TRUE);
      CASE "Document Type" OF
        "Document Type"::Order,"Document Type"::Invoice:
          EXIT("OIOUBL Invoice Path" <> '');
        "Document Type"::"Return Order","Document Type"::"Credit Memo":
          EXIT("OIOUBL Cr. Memo Path" <> '');
        "Document Type"::"Finance Charge":
          EXIT("OIOUBL Fin. Chrg. Memo Path" <> '');
        "Document Type"::Reminder:
          EXIT("OIOUBL Reminder Path" <> '');
      ELSE
        EXIT(TRUE);
      END;
    END;

    PROCEDURE VerifyAndSetOIOUBLPathSetup@1060002("Document Type"@1060000 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Finance Charge,Reminder');
    VAR
      OIOUBLsetupPage@1060001 : Page 13601;
    BEGIN
      GET;
      IF IsOIOUBLPathSetupAvailble("Document Type") THEN
        EXIT;

      IF CONFIRM(SetupOIOUBLQst,TRUE) THEN BEGIN
        OIOUBLsetupPage.SETRECORD(Rec);
        OIOUBLsetupPage.EDITABLE(TRUE);
        IF OIOUBLsetupPage.RUNMODAL = ACTION::OK THEN
          OIOUBLsetupPage.GETRECORD(Rec);
      END;

      IF NOT IsOIOUBLPathSetupAvailble("Document Type") THEN
        ERROR(MissingSetupOIOUBLErr);
    END;

    LOCAL PROCEDURE CheckGLAccPostingTypeBlockedAndGenProdPostingType@2(AccNo@1000 : Code[20]);
    VAR
      GLAcc@1002 : Record 15;
    BEGIN
      IF AccNo <> '' THEN BEGIN
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
        GLAcc.TESTFIELD("Gen. Prod. Posting Group");
      END;
    END;

    BEGIN
    END.
  }
}


OBJECT Table 312 Purchases & Payables Setup
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opsëtning af Kõb;
               ENU=Purchases & Payables Setup];
    LookupPageID=Page460;
    DrillDownPageID=Page460;
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
    { 6   ;   ;Receipt on Invoice  ;Boolean       ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Lev. ved fakturering;
                                                              ENU=Receipt on Invoice] }
    { 7   ;   ;Invoice Rounding    ;Boolean       ;CaptionML=[DAN=Fakturaafrunding;
                                                              ENU=Invoice Rounding] }
    { 8   ;   ;Ext. Doc. No. Mandatory;Boolean    ;InitValue=Yes;
                                                   CaptionML=[DAN=Eksternt bilagsnr. obl.;
                                                              ENU=Ext. Doc. No. Mandatory] }
    { 9   ;   ;Vendor Nos.         ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Kreditornumre;
                                                              ENU=Vendor Nos.] }
    { 10  ;   ;Quote Nos.          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Rekvisitionsnumre;
                                                              ENU=Quote Nos.] }
    { 11  ;   ;Order Nos.          ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 120=R;
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
    { 16  ;   ;Posted Receipt Nos. ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Bogf. kõbslev. numre;
                                                              ENU=Posted Receipt Nos.] }
    { 19  ;   ;Blanket Order Nos.  ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Rammeordrenr.;
                                                              ENU=Blanket Order Nos.] }
    { 20  ;   ;Calc. Inv. Discount ;Boolean       ;AccessByPermission=TableData 24=R;
                                                   CaptionML=[DAN=Beregn fakturarabat;
                                                              ENU=Calc. Inv. Discount] }
    { 21  ;   ;Appln. between Currencies;Option   ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Valutaudligning;
                                                              ENU=Appln. between Currencies];
                                                   OptionCaptionML=[DAN=Ingen,ùMU,Alle;
                                                                    ENU=None,EMU,All];
                                                   OptionString=None,EMU,All }
    { 22  ;   ;Copy Comments Blanket to Order;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Kopier bemërk. t. ordre;
                                                              ENU=Copy Comments Blanket to Order] }
    { 23  ;   ;Copy Comments Order to Invoice;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Kopier bemërk. t. fakt.;
                                                              ENU=Copy Comments Order to Invoice] }
    { 24  ;   ;Copy Comments Order to Receipt;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Kopier bemërk. t. lev.;
                                                              ENU=Copy Comments Order to Receipt] }
    { 25  ;   ;Allow VAT Difference;Boolean       ;CaptionML=[DAN=Tillad momsdifference;
                                                              ENU=Allow VAT Difference] }
    { 26  ;   ;Calc. Inv. Disc. per VAT ID;Boolean;CaptionML=[DAN=Beregn fak.rabat pr. moms-id;
                                                              ENU=Calc. Inv. Disc. per VAT ID] }
    { 27  ;   ;Posted Prepmt. Inv. Nos.;Code20    ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogfõrte forudbetalingsfakturanr.;
                                                              ENU=Posted Prepmt. Inv. Nos.] }
    { 28  ;   ;Posted Prepmt. Cr. Memo Nos.;Code20;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogfõrte forudbetalingskreditnotanr.;
                                                              ENU=Posted Prepmt. Cr. Memo Nos.] }
    { 29  ;   ;Check Prepmt. when Posting;Boolean ;CaptionML=[DAN=Kontroller forudbetaling ved bogfõring;
                                                              ENU=Check Prepmt. when Posting] }
    { 35  ;   ;Default Posting Date;Option        ;CaptionML=[DAN=Standardbogfõringsdato;
                                                              ENU=Default Posting Date];
                                                   OptionCaptionML=[DAN=Arbejdsdato,Ingen dato;
                                                                    ENU=Work Date,No Date];
                                                   OptionString=Work Date,No Date }
    { 36  ;   ;Default Qty. to Receive;Option     ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Std.ant.til modt.;
                                                              ENU=Default Qty. to Receive];
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
    { 46  ;   ;Allow Document Deletion Before;Date;CaptionML=[DAN=Tillad sletning af dokument fõr;
                                                              ENU=Allow Document Deletion Before] }
    { 56  ;   ;Ignore Updated Addresses;Boolean   ;CaptionML=[DAN=Ignore Updated Addresses;
                                                              ENU=Ignore Updated Addresses] }
    { 1217;   ;Debit Acc. for Non-Item Lines;Code20;
                                                   TableRelation="G/L Account" WHERE (Direct Posting=CONST(Yes),
                                                                                      Account Type=CONST(Posting),
                                                                                      Blocked=CONST(No));
                                                   CaptionML=[DAN=Debetkonto til ikke-varelinjer;
                                                              ENU=Debit Acc. for Non-Item Lines] }
    { 1218;   ;Credit Acc. for Non-Item Lines;Code20;
                                                   TableRelation="G/L Account" WHERE (Direct Posting=CONST(Yes),
                                                                                      Account Type=CONST(Posting),
                                                                                      Blocked=CONST(No));
                                                   CaptionML=[DAN=Kreditkonto til ikke-varelinjer;
                                                              ENU=Credit Acc. for Non-Item Lines] }
    { 5800;   ;Posted Return Shpt. Nos.;Code20    ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Bogfõrte returvarekvit.numre;
                                                              ENU=Posted Return Shpt. Nos.] }
    { 5801;   ;Copy Cmts Ret.Ord. to Ret.Shpt;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Kopier bem. til returvarekvit.;
                                                              ENU=Copy Cmts Ret.Ord. to Ret.Shpt] }
    { 5802;   ;Copy Cmts Ret.Ord. to Cr. Memo;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Kopier bem. til kreditnota;
                                                              ENU=Copy Cmts Ret.Ord. to Cr. Memo] }
    { 6600;   ;Return Order Nos.   ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Returvareordrenumre;
                                                              ENU=Return Order Nos.] }
    { 6601;   ;Return Shipment on Credit Memo;Boolean;
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Returvarekvit. pÜ kreditnota;
                                                              ENU=Return Shipment on Credit Memo] }
    { 6602;   ;Exact Cost Reversing Mandatory;Boolean;
                                                   CaptionML=[DAN=Obl. belõbstilbagefõrsel;
                                                              ENU=Exact Cost Reversing Mandatory] }
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

    [External]
    PROCEDURE JobQueueActive@1() : Boolean;
    BEGIN
      GET;
      EXIT("Post with Job Queue" OR "Post & Print with Job Queue");
    END;

    BEGIN
    END.
  }
}


OBJECT Table 381 VAT Registration No. Format
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=SE/CVR-nr.format;
               ENU=VAT Registration No. Format];
  }
  FIELDS
  {
    { 1   ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Format              ;Text20        ;CaptionML=[DAN=Format;
                                                              ENU=Format] }
  }
  KEYS
  {
    {    ;Country/Region Code,Line No.            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Det indtastede SE/CVR-nr. stemmer ikke overens med det angivne format for lande-/omr�dekoden %1.\;ENU=The entered VAT Registration number is not in agreement with the format specified for Country/Region Code %1.\';
      Text001@1001 : TextConst '@@@=1 - format list;DAN=F�lgende formater er mulige: %1;ENU=The following formats are acceptable: %1';
      Text002@1002 : TextConst 'DAN=Dette SE/CVR-nr. er allerede angivet for f�lgende debitorer:\ %1;ENU=This VAT registration number has already been entered for the following customers:\ %1';
      Text003@1003 : TextConst 'DAN=Dette SE/CVR-nr. er allerede angivet for f�lgende kreditorer:\ %1;ENU=This VAT registration number has already been entered for the following vendors:\ %1';
      Text004@1004 : TextConst 'DAN=Dette SECVR-nr. er allerede angivet for f�lgende kontakter:\ %1;ENU=This VAT registration number has already been entered for the following contacts:\ %1';
      Text005@1005 : TextConst 'DAN=ABCDEFGHIJKLMNOPQRSTUVWXYZ���;ENU=ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      InvalidVatNumberErr@1010 : TextConst 'DAN=Angiv et gyldigt momsnummer, f.eks. ''GB123456789''.;ENU=Enter a valid VAT number, for example ''GB123456789''.';
      IdentityManagement@1011 : Codeunit 9801;

    [External]
    PROCEDURE Test@1(VATRegNo@1000 : Text[20];CountryCode@1001 : Code[10];Number@1002 : Code[20];TableID@1003 : Option) : Boolean;
    VAR
      CompanyInfo@1005 : Record 79;
      Check@1004 : Boolean;
      Finish@1007 : Boolean;
      t@1006 : Text;
    BEGIN
      VATRegNo := UPPERCASE(VATRegNo);
      IF VATRegNo = '' THEN
        EXIT;
      Check := TRUE;

      IF CountryCode = '' THEN BEGIN
        IF NOT CompanyInfo.GET THEN
          EXIT;
        SETRANGE("Country/Region Code",CompanyInfo."Country/Region Code");
      END ELSE
        SETRANGE("Country/Region Code",CountryCode);
      SETFILTER(Format,'<> %1','');
      IF FINDSET THEN
        REPEAT
          AppendString(t,Finish,Format);
          Check := Compare(VATRegNo,Format);
        UNTIL Check OR (NEXT = 0);

      IF NOT Check THEN BEGIN
        IF IdentityManagement.IsInvAppId THEN
          ERROR(InvalidVatNumberErr);
        ERROR(STRSUBSTNO('%1%2',STRSUBSTNO(Text000,"Country/Region Code"),STRSUBSTNO(Text001,t)));
      END;

      CASE TableID OF
        DATABASE::Customer:
          CheckCust(VATRegNo,Number);
        DATABASE::Vendor:
          CheckVendor(VATRegNo,Number);
        DATABASE::Contact:
          CheckContact(VATRegNo,Number);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckCust@3(VATRegNo@1000 : Text[20];Number@1002 : Code[20]);
    VAR
      Cust@1003 : Record 18;
      Check@1004 : Boolean;
      Finish@1001 : Boolean;
      t@1005 : Text;
      CustomerIdentification@1006 : Text[50];
    BEGIN
      Check := TRUE;
      t := '';
      Cust.SETCURRENTKEY("VAT Registration No.");
      Cust.SETRANGE("VAT Registration No.",VATRegNo);
      Cust.SETFILTER("No.",'<>%1',Number);
      IF Cust.FINDSET THEN BEGIN
        Check := FALSE;
        Finish := FALSE;
        REPEAT
          IF IdentityManagement.IsInvAppId THEN
            CustomerIdentification := Cust.Name
          ELSE
            CustomerIdentification := Cust."No.";

          AppendString(t,Finish,CustomerIdentification);
        UNTIL (Cust.NEXT = 0) OR Finish;
      END;
      IF Check = FALSE THEN
        MESSAGE(STRSUBSTNO(Text002,t));
    END;

    LOCAL PROCEDURE CheckVendor@4(VATRegNo@1000 : Text[20];Number@1002 : Code[20]);
    VAR
      Vend@1003 : Record 23;
      Check@1004 : Boolean;
      Finish@1001 : Boolean;
      t@1005 : Text;
    BEGIN
      Check := TRUE;
      t := '';
      Vend.SETCURRENTKEY("VAT Registration No.");
      Vend.SETRANGE("VAT Registration No.",VATRegNo);
      Vend.SETFILTER("No.",'<>%1',Number);
      IF Vend.FINDSET THEN BEGIN
        Check := FALSE;
        Finish := FALSE;
        REPEAT
          AppendString(t,Finish,Vend."No.");
        UNTIL (Vend.NEXT = 0) OR Finish;
      END;
      IF Check = FALSE THEN
        MESSAGE(STRSUBSTNO(Text003,t));
    END;

    LOCAL PROCEDURE CheckContact@5(VATRegNo@1000 : Text[20];Number@1002 : Code[20]);
    VAR
      Cont@1003 : Record 5050;
      Check@1004 : Boolean;
      Finish@1001 : Boolean;
      t@1005 : Text;
    BEGIN
      Check := TRUE;
      t := '';
      Cont.SETCURRENTKEY("VAT Registration No.");
      Cont.SETRANGE("VAT Registration No.",VATRegNo);
      Cont.SETFILTER("No.",'<>%1',Number);
      IF Cont.FINDSET THEN BEGIN
        Check := FALSE;
        Finish := FALSE;
        REPEAT
          AppendString(t,Finish,Cont."No.");
        UNTIL (Cont.NEXT = 0) OR Finish;
      END;
      IF Check = FALSE THEN
        MESSAGE(STRSUBSTNO(Text004,t));
    END;

    [External]
    PROCEDURE Compare@2(VATRegNo@1000 : Text[20];Format@1001 : Text[20]) : Boolean;
    VAR
      i@1002 : Integer;
      Cf@1003 : Text[1];
      Ce@1004 : Text[1];
      Check@1005 : Boolean;
    BEGIN
      Check := TRUE;
      IF STRLEN(VATRegNo) = STRLEN(Format) THEN
        FOR i := 1 TO STRLEN(VATRegNo) DO BEGIN
          Cf := COPYSTR(Format,i,1);
          Ce := COPYSTR(VATRegNo,i,1);
          CASE Cf OF
            '#':
              IF NOT ((Ce >= '0') AND (Ce <= '9')) THEN
                Check := FALSE;
            '@':
              IF STRPOS(Text005,UPPERCASE(Ce)) = 0 THEN
                Check := FALSE;
            ELSE
              IF NOT ((Cf = Ce) OR (Cf = '?')) THEN
                Check := FALSE
          END;
        END
      ELSE
        Check := FALSE;
      EXIT(Check);
    END;

    LOCAL PROCEDURE AppendString@6(VAR String@1000 : Text;VAR Finish@1001 : Boolean;AppendText@1002 : Text);
    BEGIN
      CASE TRUE OF
        Finish:
          EXIT;
        String = '':
          String := AppendText;
        STRLEN(String) + STRLEN(AppendText) + 5 <= 250:
          String += ', ' + AppendText;
        ELSE BEGIN
          String += '...';
          Finish := TRUE;
        END;
      END;
    END;

    BEGIN
    END.
  }
}


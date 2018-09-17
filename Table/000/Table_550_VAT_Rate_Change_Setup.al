OBJECT Table 550 VAT Rate Change Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfiguration af ‘ndring af momssats;
               ENU=VAT Rate Change Setup];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim‘rn›gle;
                                                              ENU=Primary Key] }
    { 10  ;   ;Update Gen. Prod. Post. Groups;Option;
                                                   InitValue=VAT Prod. Posting Group;
                                                   CaptionML=[DAN=Opdat. gen. prod.bogf.grupper;
                                                              ENU=Update Gen. Prod. Post. Groups];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,,,Nr.;
                                                                    ENU=VAT Prod. Posting Group,,,No];
                                                   OptionString=VAT Prod. Posting Group,,,No }
    { 15  ;   ;Update G/L Accounts ;Option        ;InitValue=Both;
                                                   CaptionML=[DAN=Opdater finanskonti;
                                                              ENU=Update G/L Accounts];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 17  ;   ;Update Items        ;Option        ;InitValue=Both;
                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Opdater varer;
                                                              ENU=Update Items];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 18  ;   ;Update Item Templates;Option       ;InitValue=Both;
                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Opdater vareskabeloner;
                                                              ENU=Update Item Templates];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 19  ;   ;Update Item Charges ;Option        ;InitValue=Both;
                                                   AccessByPermission=TableData 5800=R;
                                                   CaptionML=[DAN=Opdater varegebyrer;
                                                              ENU=Update Item Charges];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 21  ;   ;Update Resources    ;Option        ;InitValue=Both;
                                                   AccessByPermission=TableData 156=R;
                                                   CaptionML=[DAN=Opdater ressourcer;
                                                              ENU=Update Resources];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 30  ;   ;Update Gen. Journal Lines;Option   ;InitValue=Both;
                                                   CaptionML=[DAN=Opdater gen. kladdelinjer;
                                                              ENU=Update Gen. Journal Lines];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 31  ;   ;Update Gen. Journal Allocation;Option;
                                                   InitValue=Both;
                                                   AccessByPermission=TableData 221=R;
                                                   CaptionML=[DAN=Opdater gen. kladdefordeling;
                                                              ENU=Update Gen. Journal Allocation];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 32  ;   ;Update Std. Gen. Jnl. Lines;Option ;InitValue=Both;
                                                   CaptionML=[DAN=Opd. std. gen. kladdelin.;
                                                              ENU=Update Std. Gen. Jnl. Lines];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 33  ;   ;Update Res. Journal Lines;Option   ;InitValue=Gen. Prod. Posting Group;
                                                   AccessByPermission=TableData 156=R;
                                                   CaptionML=[DAN=Opdater ress.kladdelinjer;
                                                              ENU=Update Res. Journal Lines];
                                                   OptionCaptionML=[DAN=,Gen. prod.bogf.gruppe,,Nr.;
                                                                    ENU=,Gen. Prod. Posting Group,,No];
                                                   OptionString=,Gen. Prod. Posting Group,,No }
    { 35  ;   ;Update Job Journal Lines;Option    ;InitValue=Gen. Prod. Posting Group;
                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Opdater sagskladdelinjer;
                                                              ENU=Update Job Journal Lines];
                                                   OptionCaptionML=[DAN=,Gen. prod.bogf.gruppe,,Nr.;
                                                                    ENU=,Gen. Prod. Posting Group,,No];
                                                   OptionString=,Gen. Prod. Posting Group,,No }
    { 37  ;   ;Update Requisition Lines;Option    ;InitValue=Gen. Prod. Posting Group;
                                                   AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Opdater rekvisitionslinjer;
                                                              ENU=Update Requisition Lines];
                                                   OptionCaptionML=[DAN=,Gen. prod.bogf.gruppe,,Nr.;
                                                                    ENU=,Gen. Prod. Posting Group,,No];
                                                   OptionString=,Gen. Prod. Posting Group,,No }
    { 39  ;   ;Update Std. Item Jnl. Lines;Option ;InitValue=Gen. Prod. Posting Group;
                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Opd. std.varekladdelinjer;
                                                              ENU=Update Std. Item Jnl. Lines];
                                                   OptionCaptionML=[DAN=,Gen. prod.bogf.gruppe,,Nr.;
                                                                    ENU=,Gen. Prod. Posting Group,,No];
                                                   OptionString=,Gen. Prod. Posting Group,,No }
    { 41  ;   ;Update Service Docs.;Option        ;InitValue=Both;
                                                   AccessByPermission=TableData 5900=R;
                                                   CaptionML=[DAN=Opdater servicedok.;
                                                              ENU=Update Service Docs.];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 43  ;   ;Update Serv. Price Adj. Detail;Option;
                                                   InitValue=Gen. Prod. Posting Group;
                                                   AccessByPermission=TableData 5900=R;
                                                   CaptionML=[DAN=Opd. serviceprisreg.det.;
                                                              ENU=Update Serv. Price Adj. Detail];
                                                   OptionCaptionML=[DAN=,Gen. prod.bogf.gruppe,,Nr.;
                                                                    ENU=,Gen. Prod. Posting Group,,No];
                                                   OptionString=,Gen. Prod. Posting Group,,No }
    { 50  ;   ;Update Sales Documents;Option      ;InitValue=Both;
                                                   AccessByPermission=TableData 36=R;
                                                   CaptionML=[DAN=Opdater salgsdokumenter;
                                                              ENU=Update Sales Documents];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 55  ;   ;Update Purchase Documents;Option   ;InitValue=Both;
                                                   AccessByPermission=TableData 38=R;
                                                   CaptionML=[DAN=Opdater k›bsdokumenter;
                                                              ENU=Update Purchase Documents];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,Gen. prod.bogf.gruppe,Begge,Nr.;
                                                                    ENU=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No];
                                                   OptionString=VAT Prod. Posting Group,Gen. Prod. Posting Group,Both,No }
    { 60  ;   ;Update Production Orders;Option    ;InitValue=Gen. Prod. Posting Group;
                                                   AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Opdater produktionsordrer;
                                                              ENU=Update Production Orders];
                                                   OptionCaptionML=[DAN=,Gen. prod.bogf.gruppe,,Nr.;
                                                                    ENU=,Gen. Prod. Posting Group,,No];
                                                   OptionString=,Gen. Prod. Posting Group,,No }
    { 62  ;   ;Update Work Centers ;Option        ;InitValue=Gen. Prod. Posting Group;
                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Opdater arbejdscentre;
                                                              ENU=Update Work Centers];
                                                   OptionCaptionML=[DAN=,Gen. prod.bogf.gruppe,,Nr.;
                                                                    ENU=,Gen. Prod. Posting Group,,No];
                                                   OptionString=,Gen. Prod. Posting Group,,No }
    { 64  ;   ;Update Machine Centers;Option      ;InitValue=Gen. Prod. Posting Group;
                                                   AccessByPermission=TableData 99000758=R;
                                                   CaptionML=[DAN=Opdater produktionsressourcer;
                                                              ENU=Update Machine Centers];
                                                   OptionCaptionML=[DAN=,Gen. prod.bogf.gruppe,,Nr.;
                                                                    ENU=,Gen. Prod. Posting Group,,No];
                                                   OptionString=,Gen. Prod. Posting Group,,No }
    { 70  ;   ;Update Reminders    ;Option        ;InitValue=VAT Prod. Posting Group;
                                                   AccessByPermission=TableData 36=R;
                                                   CaptionML=[DAN=Opdater rykkere;
                                                              ENU=Update Reminders];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,,,Nr.;
                                                                    ENU=VAT Prod. Posting Group,,,No];
                                                   OptionString=VAT Prod. Posting Group,,,No }
    { 75  ;   ;Update Finance Charge Memos;Option ;InitValue=VAT Prod. Posting Group;
                                                   CaptionML=[DAN=Opdater rentenotaer;
                                                              ENU=Update Finance Charge Memos];
                                                   OptionCaptionML=[DAN=Momsprod.bogf.gruppe,,,Nr.;
                                                                    ENU=VAT Prod. Posting Group,,,No];
                                                   OptionString=VAT Prod. Posting Group,,,No }
    { 90  ;   ;VAT Rate Change Tool Completed;Boolean;
                                                   InitValue=No;
                                                   CaptionML=[DAN=Momssats‘ndringsv‘rkt›jet afsluttet;
                                                              ENU=VAT Rate Change Tool Completed] }
    { 91  ;   ;Ignore Status on Sales Docs.;Boolean;
                                                   InitValue=Yes;
                                                   CaptionML=[DAN=Ignorer status p† salgsdok.;
                                                              ENU=Ignore Status on Sales Docs.] }
    { 92  ;   ;Ignore Status on Purch. Docs.;Boolean;
                                                   InitValue=Yes;
                                                   CaptionML=[DAN=Ignorer status p† k›bsdok.;
                                                              ENU=Ignore Status on Purch. Docs.] }
    { 93  ;   ;Perform Conversion  ;Boolean       ;CaptionML=[DAN=Udf›r konvertering;
                                                              ENU=Perform Conversion] }
    { 100 ;   ;Item Filter         ;Text250       ;ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Varefilter;
                                                              ENU=Item Filter] }
    { 101 ;   ;Account Filter      ;Text250       ;ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kontofilter;
                                                              ENU=Account Filter] }
    { 102 ;   ;Resource Filter     ;Text250       ;ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Ressourcefilter;
                                                              ENU=Resource Filter] }
    { 103 ;   ;Ignore Status on Service Docs.;Boolean;
                                                   InitValue=Yes;
                                                   CaptionML=[DAN=Ignorer status p† servicedok.;
                                                              ENU=Ignore Status on Service Docs.] }
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

    [Internal]
    PROCEDURE LookUpItemFilter@57(VAR Text@1001 : Text[250]) : Boolean;
    VAR
      Item@1000 : Record 27;
      ItemList@1003 : Page 31;
    BEGIN
      ItemList.LOOKUPMODE(TRUE);
      ItemList.SETTABLEVIEW(Item);
      IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ItemList.GETRECORD(Item);
        Text := ItemList.GetSelectionFilter;
        EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    [External]
    PROCEDURE LookUpResourceFilter@1(VAR Text@1001 : Text[250]) : Boolean;
    VAR
      Resource@1000 : Record 156;
      ResourceList@1003 : Page 77;
    BEGIN
      ResourceList.LOOKUPMODE(TRUE);
      ResourceList.SETTABLEVIEW(Resource);
      IF ResourceList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ResourceList.GETRECORD(Resource);
        Text := Resource."No.";
        EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    [Internal]
    PROCEDURE LookUpGLAccountFilter@2(VAR Text@1001 : Text[250]) : Boolean;
    VAR
      GLAccount@1000 : Record 15;
      GLAccountList@1003 : Page 18;
    BEGIN
      GLAccountList.LOOKUPMODE(TRUE);
      GLAccountList.SETTABLEVIEW(GLAccount);
      IF GLAccountList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        GLAccountList.GETRECORD(GLAccount);
        Text := GLAccountList.GetSelectionFilter;
        EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    BEGIN
    END.
  }
}


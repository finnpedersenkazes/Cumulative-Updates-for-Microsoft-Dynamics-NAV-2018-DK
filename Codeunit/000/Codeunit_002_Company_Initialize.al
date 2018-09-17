OBJECT Codeunit 2 Company-Initialize
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348,NAVDK11.00.00.20348;
  }
  PROPERTIES
  {
    Permissions=TableData 314=i,
                TableData 315=i,
                TableData 843=i,
                TableData 870=i,
                TableData 905=i,
                TableData 1006=i,
                TableData 5218=i,
                TableData 5603=i;
    OnRun=VAR
            BankPmtApplRule@1003 : Record 1252;
            TransformationRule@1005 : Record 1237;
            ApplicationLaunchMgt@1001 : Codeunit 403;
            AddOnIntegrMgt@1000 : Codeunit 5403;
            WorkflowSetup@1004 : Codeunit 1502;
            VATRegistrationLogMgt@1006 : Codeunit 249;
            Window@1002 : Dialog;
          BEGIN
            Window.OPEN(Text000);

            InitSetupTables;
            AddOnIntegrMgt.InitMfgSetup;
            InitSourceCodeSetup;
            InitStandardTexts;
            InitReportSelection;
            InitJobWIPMethods;
            InitBankExportImportSetup;
            InitBankDataConversionPmtType;
            InitBankClearingStandard;
            InitBankDataConvServiceSetup;
            InitDocExchServiceSetup;
            BankPmtApplRule.InsertDefaultMatchingRules;
            ApplicationLaunchMgt.InsertStyleSheets;
            InsertClientAddIns;
            VATRegistrationLogMgt.InitServiceSetup;
            WorkflowSetup.InitWorkflow;
            TransformationRule.CreateDefaultTransformations;
            InitElectronicFormats;
            InitApplicationAreasForSaaS;

            OnCompanyInitialize;

            Window.CLOSE;

            COMMIT;
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Regnskabet opsëttes...;ENU=Initializing company...';
      SEPACTCodeTxt@1076 : TextConst '@@@=No need to translate - but can be translated at will.;DAN=SEPACT;ENU=SEPACT';
      SEPACTNameTxt@1083 : TextConst 'DAN=SEPA Kreditoverfõrsel;ENU=SEPA Credit Transfer';
      SEPADDCodeTxt@1033 : TextConst '@@@=No need to translate - but can be translated at will.;DAN=SEPADD;ENU=SEPADD';
      SEPADDNameTxt@1020 : TextConst 'DAN=SEPA Direct Debit;ENU=SEPA Direct Debit';
      Text001@1001 : TextConst 'DAN=SALG;ENU=SALES';
      Text002@1002 : TextConst 'DAN=Salg;ENU=Sales';
      Text003@1003 : TextConst 'DAN=KùB;ENU=PURCHASES';
      Text004@1004 : TextConst 'DAN=Kõb;ENU=Purchases';
      Text005@1005 : TextConst 'DAN=SLET;ENU=DELETE';
      Text006@1006 : TextConst 'DAN=LAGERREG;ENU=INVTPCOST';
      Text007@1007 : TextConst 'DAN=KURSREG;ENU=EXCHRATADJ';
      Text010@1010 : TextConst 'DAN=NULSTILRES;ENU=CLSINCOME';
      Text011@1011 : TextConst 'DAN=KONSOLID;ENU=CONSOLID';
      Text012@1012 : TextConst 'DAN=Konsolidering;ENU=Consolidation';
      Text013@1013 : TextConst 'DAN=KASSEKLD;ENU=GENJNL';
      Text014@1014 : TextConst 'DAN=SALGKLD;ENU=SALESJNL';
      Text015@1015 : TextConst 'DAN=KùBKLD;ENU=PURCHJNL';
      Text016@1016 : TextConst 'DAN=INDBETKLD;ENU=CASHRECJNL';
      Text017@1017 : TextConst 'DAN=UDBETKLD;ENU=PAYMENTJNL';
      Text018@1018 : TextConst 'DAN=VAREKLD;ENU=ITEMJNL';
      Text020@1019 : TextConst 'DAN=LAGOPGKLD;ENU=PHYSINVJNL';
      Text022@1021 : TextConst 'DAN=RESSKLD;ENU=RESJNL';
      Text023@1022 : TextConst 'DAN=SAGKLD;ENU=JOBJNL';
      Text024@1023 : TextConst 'DAN=DEBEFTUDL;ENU=SALESAPPL';
      Text025@1024 : TextConst 'DAN=Debitorefterudligning;ENU=Sales Entry Application';
      PaymentReconJnlTok@1169 : TextConst '@@@=Payment Reconciliation Journal Code;DAN=BETAFSTEM;ENU=PAYMTRECON';
      Text026@1025 : TextConst 'DAN=KREDEFTUDL;ENU=PURCHAPPL';
      Text027@1026 : TextConst 'DAN=Kreditorefterudligning;ENU=Purchase Entry Application';
      EmployeeEntryApplicationCodeTxt@1175 : TextConst '@@@=EMPL stands for employee, APPL stands for application;DAN=MDARBPGRM;ENU=EMPLAPPL';
      EmployeeEntryApplicationTxt@1174 : TextConst 'DAN=Medarbejderefterudligning;ENU=Employee Entry Application';
      Text028@1027 : TextConst 'DAN=MOMSAFREGN;ENU=VATSTMT';
      Text029@1028 : TextConst 'DAN=KOMPFIN;ENU=COMPRGL';
      Text030@1029 : TextConst 'DAN=KOMPMOMS;ENU=COMPRVAT';
      Text031@1030 : TextConst 'DAN=KOMPDEB;ENU=COMPRCUST';
      Text032@1031 : TextConst 'DAN=KOMPKRED;ENU=COMPRVEND';
      Text035@1034 : TextConst 'DAN=KOMPRRES;ENU=COMPRRES';
      Text036@1035 : TextConst 'DAN=KOMPSAG;ENU=COMPRJOB';
      Text037@1036 : TextConst 'DAN=KOMPBANK;ENU=COMPRBANK';
      Text038@1037 : TextConst 'DAN=KOMPRCHECK;ENU=COMPRCHECK';
      Text039@1038 : TextConst 'DAN=ANTILBFCHK;ENU=FINVOIDCHK';
      Text040@1039 : TextConst 'DAN=Annulleret og tilbagef. check;ENU=Financially Voided Check';
      Text041@1040 : TextConst 'DAN=RYKKERMED;ENU=REMINDER';
      Text042@1041 : TextConst 'DAN=Rykkermeddelelse;ENU=Reminder';
      Text043@1042 : TextConst 'DAN=RENTE;ENU=FINCHRG';
      Text044@1043 : TextConst 'DAN=Rentenota;ENU=Finance Charge Memo';
      Text045@1044 : TextConst 'DAN=ANLFINKLD;ENU=FAGLJNL';
      Text046@1045 : TextConst 'DAN=ANLKLD;ENU=FAJNL';
      Text047@1046 : TextConst 'DAN=FORSIKKLD;ENU=INSJNL';
      Text048@1047 : TextConst 'DAN=KOMPRANL;ENU=COMPRFA';
      Text049@1048 : TextConst 'DAN=KOMPRREP;ENU=COMPRMAINT';
      Text050@1049 : TextConst 'DAN=KOMPFORSIK;ENU=COMPRINS';
      Text051@1050 : TextConst 'DAN=REGEKSVAL;ENU=ADJADDCURR';
      Text052@1051 : TextConst 'DAN=MA;ENU=MD';
      Text053@1052 : TextConst 'DAN=MÜnedsafskrivning;ENU=Monthly Depreciation';
      Text054@1053 : TextConst 'DAN=LG;ENU=SC';
      Text055@1054 : TextConst 'DAN=Leveringsgebyr;ENU=Shipping Charge';
      Text056@1055 : TextConst 'DAN=KT;ENU=SUC';
      Text057@1056 : TextConst 'DAN=Kontraktsalg;ENU=Sale under Contract';
      Text058@1057 : TextConst 'DAN=RO;ENU=TE';
      Text059@1058 : TextConst 'DAN=Rejseomkostninger;ENU=Travel Expenses';
      Text063@1062 : TextConst 'DAN=OVERFùRSEL;ENU=TRANSFER';
      Text064@1063 : TextConst 'DAN=Overfõrsel;ENU=Transfer';
      Text065@1064 : TextConst 'DAN=OMPOSTKLD.;ENU=RECLASSJNL';
      Text066@1065 : TextConst 'DAN=VíRDIRGKLD;ENU=REVALJNL';
      Text067@1066 : TextConst 'DAN=FORBRUGKLD;ENU=CONSUMPJNL';
      Text068@1067 : TextConst 'DAN=LAGERREGL.;ENU=INVTADJMT';
      Text069@1069 : TextConst 'DAN=POINDUDKLD;ENU=POINOUTJNL';
      Text070@1073 : TextConst 'DAN=KAPKLD;ENU=CAPACITJNL';
      Text071@1107 : TextConst 'DAN=LAGVARE;ENU=WHITEM';
      Text072@1105 : TextConst 'DAN=LAGFYSLOG;ENU=WHPHYSINVT';
      Text073@1068 : TextConst 'DAN=LAGOMPOSKL;ENU=WHRCLSSJNL';
      Text074@1070 : TextConst 'DAN=SERVICE;ENU=SERVICE';
      Text075@1074 : TextConst 'DAN=Service;ENU=Service Management';
      Text076@1075 : TextConst 'DAN=AFSTEMN;ENU=BANKREC';
      Text077@1077 : TextConst 'DAN=LíGPèLAGER;ENU=WHPUTAWAY';
      Text078@1078 : TextConst 'DAN=LAGPLUK;ENU=WHPICK';
      Text079@1079 : TextConst 'DAN=LAGBEVíG;ENU=WHMOVEMENT';
      Text080@1080 : TextConst 'DAN=Lëg-pÜ-lager (logistik);ENU=Whse. Put-away';
      Text081@1081 : TextConst 'DAN=Pluk (logistik);ENU=Whse. Pick';
      Text082@1082 : TextConst 'DAN=Bev. (logistik);ENU=Whse. Movement';
      Text083@1100 : TextConst 'DAN=KOMPRLAGER;ENU=COMPRWHSE';
      Text084@1106 : TextConst 'DAN=INTHANDEL;ENU=INTERCOMP';
      Text085@1108 : TextConst 'DAN=Intercompany-handel;ENU=Intercompany';
      Text086@1114 : TextConst 'DAN=IKKUDLSALG;ENU=UNAPPSALES';
      Text087@1113 : TextConst 'DAN=Annulleret debitorefterudligning;ENU=Unapplied Sales Entry Application';
      UnappliedEmplEntryApplnCodeTxt@1173 : TextConst '@@@=EMPL stands for employee, UNAPP stands for unapply;DAN=ANLUDLMDRB;ENU=UNAPPEMPL';
      UnappliedEmplEntryApplnTxt@1059 : TextConst 'DAN=Annulleret medarbejderefterudligning;ENU=Unapplied Employee Entry Application';
      Text088@1112 : TextConst 'DAN=IKKEUDLKùB;ENU=UNAPPPURCH';
      Text089@1111 : TextConst 'DAN=Annulleret kreditorefterudligning;ENU=Unapplied Purchase Entry Application';
      Text090@1110 : TextConst 'DAN=TLBGFùRSEL;ENU=REVERSAL';
      Text091@1109 : TextConst 'DAN="Tilbagefõrselspost ";ENU="Reversal Entry "';
      Text092@1115 : TextConst 'DAN=PRODORDRE;ENU=PRODORDER';
      Text99000004@1071 : TextConst 'DAN=TRíK;ENU=FLUSHING';
      Text99000005@1072 : TextConst 'DAN=Trëk;ENU=Flushing';
      Text096@1008 : TextConst 'DAN=SAGSKLADDE;ENU=JOBGLJNL';
      Text097@1009 : TextConst 'DAN=VIASAG;ENU=JOBGLWIP';
      Text098@1122 : TextConst 'DAN=VIA-post;ENU=WIP Entry';
      Text099@1123 : TextConst 'DAN=Komprimeringsdato for sag;ENU=Date Compress Job Ledge';
      Text100@1032 : TextConst '@@@="{Locked} ";DAN=COMPRIBUDG;ENU=COMPRIBUDG';
      Text101@1117 : TextConst 'DAN=Afsluttet kontrakt;ENU=Completed Contract';
      Text102@1116 : TextConst 'DAN=Salgsomkostning;ENU=Cost of Sales';
      Text103@1101 : TextConst 'DAN=Kostvërdi;ENU=Cost Value';
      Text104@1061 : TextConst 'DAN=Salgsvërdi;ENU=Sales Value';
      Text105@1060 : TextConst 'DAN=Fërdiggõrelsesgrad;ENU=Percentage of Completion';
      Text106@1084 : TextConst 'DAN=FíG;ENU=POC';
      Text109@1127 : TextConst '@@@=Uppercase of the translation of cash flow work sheet with a max of 10 char;DAN=LIKKLD;ENU=CFWKSH';
      Text110@1128 : TextConst 'DAN=Pengestrõmskladde;ENU=Cash Flow Worksheet';
      Text107@1121 : TextConst '@@@=Uppercase of the translation of assembly with a max of 10 char;DAN=MONTAGE;ENU=ASSEMBLY';
      Text108@1125 : TextConst 'DAN=Montage;ENU=Assembly';
      Text111@1130 : TextConst 'DAN=FINANS;ENU=GL';
      Text112@1131 : TextConst 'DAN=Finanspost til omkostningsregnskab;ENU=G/L Entry to Cost Accounting';
      Text113@1132 : TextConst '@@@=Uppercase of the translation of cost accounting journal with a max of 10 char;DAN=OMKKLD;ENU=CAJOUR';
      Text114@1133 : TextConst 'DAN=Omkostningskladde;ENU=Cost Journal';
      Text115@1134 : TextConst '@@@=Uppercase of the translation of allocation with a max of 10 char;DAN=FORDE;ENU=ALLOC';
      Text116@1135 : TextConst 'DAN=Omkostningsfordeling;ENU=Cost Allocation';
      Text117@1137 : TextConst '@@@=Uppercase of the translation of Transfer Budget to Actual with a max of 10 char;DAN=OVEBUD;ENU=TRABUD';
      Text118@1138 : TextConst 'DAN=Overfõr budget til faktisk;ENU=Transfer Budget to Actual';
      BankClearingStandardCode1Tok@1085 : TextConst '@@@={Locked};DAN=AustrianBankleitzahl;ENU=AustrianBankleitzahl';
      BankClearingStandardDesc1Txt@1086 : TextConst 'DAN=ùstrigsk BLZ-nummer;ENU=Austrian BLZ number';
      BankClearingStandardCode2Tok@1088 : TextConst '@@@={Locked};DAN=CanadianPaymentsARN;ENU=CanadianPaymentsARN';
      BankClearingStandardDesc2Txt@1087 : TextConst 'DAN=Canadisk ARN-nummer;ENU=Canadian ARN number';
      BankClearingStandardCode3Tok@1090 : TextConst '@@@={Locked};DAN=CHIPSParticipant;ENU=CHIPSParticipant';
      BankClearingStandardDesc3Txt@1089 : TextConst 'DAN=Amerikansk CHIPS-nummer;ENU=American CHIPS number';
      BankClearingStandardCode4Tok@1092 : TextConst '@@@={Locked};DAN=CHIPSUniversal;ENU=CHIPSUniversal';
      BankClearingStandardDesc4Txt@1091 : TextConst 'DAN=Universelt amerikansk CHIPS-nummer;ENU=American CHIPS universal number';
      BankClearingStandardCode5Tok@1094 : TextConst '@@@={Locked};DAN=ExtensiveBranchNetwork;ENU=ExtensiveBranchNetwork';
      BankClearingStandardDesc5Txt@1093 : TextConst 'DAN=Nummer pÜ udvidet afdelingsnetvërk;ENU=Extensive branch network number';
      BankClearingStandardCode6Tok@1096 : TextConst '@@@={Locked};DAN=FedwireRoutingNumber;ENU=FedwireRoutingNumber';
      BankClearingStandardDesc6Txt@1095 : TextConst 'DAN=Amerikansk Fedwire/ABA-rutenummer;ENU=American Fedwire/ABA routing number';
      BankClearingStandardCode7Tok@1098 : TextConst '@@@={Locked};DAN=GermanBankleitzahl;ENU=GermanBankleitzahl';
      BankClearingStandardDesc7Txt@1097 : TextConst 'DAN=Tysk BLZ-nummer;ENU=German BLZ number';
      BankClearingStandardCode8Tok@1102 : TextConst '@@@={Locked};DAN=HongKongBank;ENU=HongKongBank';
      BankClearingStandardDesc8Txt@1099 : TextConst 'DAN=Hongkong-afdelingsnummer;ENU=Hong Kong branch number';
      BankClearingStandardCode9Tok@1104 : TextConst '@@@={Locked};DAN=IrishNSC;ENU=IrishNSC';
      BankClearingStandardDesc9Txt@1103 : TextConst 'DAN=Irsk NSC-nummer;ENU=Irish NSC number';
      BankClearingStandardCode10Tok@1119 : TextConst '@@@={Locked};DAN=ItalianDomestic;ENU=ItalianDomestic';
      BankClearingStandardDesc10Txt@1118 : TextConst 'DAN=Italiensk indenlandsk kode;ENU=Italian domestic code';
      BankClearingStandardCode11Tok@1124 : TextConst '@@@={Locked};DAN=NewZealandNCC;ENU=NewZealandNCC';
      BankClearingStandardDesc11Txt@1120 : TextConst 'DAN=Newzealandsk NCC-nummer;ENU=New Zealand NCC number';
      BankClearingStandardCode12Tok@1129 : TextConst '@@@={Locked};DAN=PortugueseNCC;ENU=PortugueseNCC';
      BankClearingStandardDesc12Txt@1126 : TextConst 'DAN=Portugisisk NCC-nummer;ENU=Portuguese NCC number';
      BankClearingStandardCode13Tok@1139 : TextConst '@@@={Locked};DAN=RussianCentralBankIdentificationCode;ENU=RussianCentralBankIdentificationCode';
      BankClearingStandardDesc13Txt@1136 : TextConst 'DAN=Russisk CBI-kode;ENU=Russian CBI code';
      BankClearingStandardCode14Tok@1143 : TextConst '@@@={Locked};DAN=SouthAfricanNCC;ENU=SouthAfricanNCC';
      BankClearingStandardDesc14Txt@1142 : TextConst 'DAN=Sydafrikansk NCC-nummer;ENU=South African NCC number';
      BankClearingStandardCode15Tok@1145 : TextConst '@@@={Locked};DAN=SpanishDomesticInterbanking;ENU=SpanishDomesticInterbanking';
      BankClearingStandardDesc15Txt@1144 : TextConst 'DAN=Spansk indenlandsk interbanknummer;ENU=Spanish domestic interbanking number';
      BankClearingStandardCode16Tok@1147 : TextConst '@@@={Locked};DAN=SwissBC;ENU=SwissBC';
      BankClearingStandardDesc16Txt@1146 : TextConst 'DAN=Schweizisk BC-nummer;ENU=Swiss BC number';
      BankClearingStandardCode17Tok@1151 : TextConst '@@@={Locked};DAN=SwissSIC;ENU=SwissSIC';
      BankClearingStandardDesc17Txt@1150 : TextConst 'DAN=Schweizisk SIC-nummer;ENU=Swiss SIC number';
      BankClearingStandardCode18Tok@1149 : TextConst '@@@={Locked};DAN=UKDomesticSortCode;ENU=UKDomesticSortCode';
      BankClearingStandardDesc18Txt@1148 : TextConst 'DAN=Britisk sorteringskode;ENU=British sorting code';
      BankDataConvPmtTypeCode1Tok@1140 : TextConst '@@@={Locked};DAN=IntAcc2Acc;ENU=IntAcc2Acc';
      BankDataConvPmtTypeDesc1Txt@1141 : TextConst 'DAN=International konto til konto-overfõrsel (standard);ENU=International account to account transfer (standard)';
      BankDataConvPmtTypeCode2Tok@1152 : TextConst '@@@={Locked};DAN=IntAcc2AccExp;ENU=IntAcc2AccExp';
      BankDataConvPmtTypeDesc2Txt@1153 : TextConst 'DAN=International konto til konto-overfõrsel (ekspres);ENU=International account to account transfer (express)';
      BankDataConvPmtTypeCode3Tok@1155 : TextConst '@@@={Locked};DAN=IntAcc2AccFoFa;ENU=IntAcc2AccFoFa';
      BankDataConvPmtTypeDesc3Txt@1154 : TextConst 'DAN=International konto til konto-overfõrsel;ENU=International account to account transfer';
      BankDataConvPmtTypeCode4Tok@1157 : TextConst '@@@={Locked};DAN=IntAcc2AccHighVal;ENU=IntAcc2AccHighVal';
      BankDataConvPmtTypeDesc4Txt@1156 : TextConst 'DAN=International konto til konto-overfõrsel (hõj vërdi);ENU=International account to account transfer (high value)';
      BankDataConvPmtTypeCode5Tok@1159 : TextConst '@@@={Locked};DAN=IntAcc2AccInterComp;ENU=IntAcc2AccInterComp';
      BankDataConvPmtTypeDesc5Txt@1158 : TextConst 'DAN=International konto til konto-overfõrsel (koncernintern);ENU=International account to account transfer (inter company)';
      BankDataConvPmtTypeCode6Tok@1161 : TextConst '@@@={Locked};DAN=DomAcc2Acc;ENU=DomAcc2Acc';
      BankDataConvPmtTypeDesc6Txt@1160 : TextConst 'DAN=Indenlandsk konto til konto-overfõrsel;ENU=Domestic account to account transfer';
      BankDataConvPmtTypeCode7Tok@1163 : TextConst '@@@={Locked};DAN=DomAcc2AccHighVal;ENU=DomAcc2AccHighVal';
      BankDataConvPmtTypeDesc7Txt@1162 : TextConst 'DAN=Indenlandsk konto til konto-overfõrsel (hõj vërdi);ENU=Domestic account to account transfer (high value)';
      BankDataConvPmtTypeCode8Tok@1165 : TextConst '@@@={Locked};DAN=DomAcc2AccInterComp;ENU=DomAcc2AccInterComp';
      BankDataConvPmtTypeDesc8Txt@1164 : TextConst 'DAN=Indenlandsk konto til konto-overfõrsel (koncernintern);ENU=Domestic account to account transfer (inter company)';
      BankDataConvPmtTypeCode9Tok@1167 : TextConst '@@@={Locked};DAN=EurAcc2AccSepa;ENU=EurAcc2AccSepa';
      BankDataConvPmtTypeDesc9Txt@1166 : TextConst 'DAN=SEPA Kreditoverfõrsel;ENU=SEPA credit transfer';
      PEPPOL21_ElectronicFormatTxt@1168 : TextConst '@@@={Locked};DAN=PEPPOL 2.1;ENU=PEPPOL 2.1';
      PEPPOL21_ElectronicFormatDescriptionTxt@1170 : TextConst 'DAN=PEPPOL 2.1-format (Pan-European Public Procurement Online);ENU=PEPPOL 2.1 Format (Pan-European Public Procurement Online)';
      PEPPOL20_ElectronicFormatTxt@1172 : TextConst '@@@={Locked};DAN=PEPPOL 2.0;ENU=PEPPOL 2.0';
      PEPPOL20_ElectronicFormatDescriptionTxt@1171 : TextConst 'DAN=PEPPOL 2.0-format (Pan-European Public Procurement Online);ENU=PEPPOL 2.0 Format (Pan-European Public Procurement Online)';
      OIOUBLFormatTxt@1060001 : TextConst '@@@={Locked};DAN=OIOUBL;ENU=OIOUBL';
      OIOUBLFormatDescriptionTxt@1060000 : TextConst 'DAN=OIOUBL-format (Offentlig Information Online Universal Business Language);ENU=OIOUBL Format (Offentlig Information Online Universal Business Language)';

    PROCEDURE InitSetupTables@3();
    VAR
      GLSetup@1025 : Record 98;
      SalesSetup@1024 : Record 311;
      PurchSetup@1023 : Record 312;
      InvtSetup@1022 : Record 313;
      ResourcesSetup@1021 : Record 314;
      JobsSetup@1020 : Record 315;
      HumanResourcesSetup@1019 : Record 5218;
      MarketingSetup@1018 : Record 5079;
      InteractionTemplateSetup@1017 : Record 5122;
      ServiceMgtSetup@1016 : Record 5911;
      NonstockItemSetup@1015 : Record 5719;
      FASetup@1014 : Record 5603;
      CashFlowSetup@1007 : Record 843;
      CostAccSetup@1006 : Record 1108;
      WhseSetup@1004 : Record 5769;
      AssemblySetup@1002 : Record 905;
      VATReportSetup@1000 : Record 743;
      TaxSetup@1026 : Record 326;
      ConfigSetup@1001 : Record 8627;
      DataMigrationSetup@1009 : Record 1806;
      IncomingDocumentsSetup@1008 : Record 131;
      CompanyInfo@1003 : Record 79;
      SocialListeningSetup@1005 : Record 870;
    BEGIN
      WITH GLSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH SalesSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH MarketingSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH InteractionTemplateSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH ServiceMgtSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH SocialListeningSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT(TRUE);
        END;

      WITH PurchSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH InvtSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH ResourcesSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH JobsSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH FASetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH HumanResourcesSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH WhseSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH NonstockItemSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH CashFlowSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH CostAccSetup DO
        IF WRITEPERMISSION THEN
          IF NOT FINDFIRST THEN BEGIN
            INIT;
            INSERT;
          END;

      WITH AssemblySetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH VATReportSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH TaxSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH ConfigSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH DataMigrationSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH IncomingDocumentsSetup DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          INSERT;
        END;

      WITH CompanyInfo DO
        IF NOT FINDFIRST THEN BEGIN
          INIT;
          "Created DateTime" := CURRENTDATETIME;
          INSERT;
        END;
    END;

    LOCAL PROCEDURE InitSourceCodeSetup@9();
    VAR
      SourceCode@1001 : Record 230;
      SourceCodeSetup@1000 : Record 242;
    BEGIN
      IF NOT (SourceCodeSetup.FINDFIRST OR SourceCode.FINDFIRST) THEN
        WITH SourceCodeSetup DO BEGIN
          INIT;
          InsertSourceCode(Sales,Text001,Text002);
          InsertSourceCode(Purchases,Text003,Text004);
          InsertSourceCode("Deleted Document",Text005,COPYSTR(FIELDCAPTION("Deleted Document"),1,30));
          InsertSourceCode("Inventory Post Cost",Text006,ReportName(REPORT::"Post Inventory Cost to G/L"));
          InsertSourceCode("Exchange Rate Adjmt.",Text007,ReportName(REPORT::"Adjust Exchange Rates"));
          InsertSourceCode("Close Income Statement",Text010,ReportName(REPORT::"Close Income Statement"));
          InsertSourceCode(Consolidation,Text011,Text012);
          InsertSourceCode("General Journal",Text013,PageName(PAGE::"General Journal"));
          InsertSourceCode("Sales Journal",Text014,PageName(PAGE::"Sales Journal"));
          InsertSourceCode("Purchase Journal",Text015,PageName(PAGE::"Purchase Journal"));
          InsertSourceCode("Cash Receipt Journal",Text016,PageName(PAGE::"Cash Receipt Journal"));
          InsertSourceCode("Payment Journal",Text017,PageName(PAGE::"Payment Journal"));
          InsertSourceCode("Payment Reconciliation Journal",PaymentReconJnlTok,PageName(PAGE::"Payment Reconciliation Journal"));
          InsertSourceCode("Item Journal",Text018,PageName(PAGE::"Item Journal"));
          InsertSourceCode(Transfer,Text063,Text064);
          InsertSourceCode("Item Reclass. Journal",Text065,PageName(PAGE::"Item Reclass. Journal"));
          InsertSourceCode("Phys. Inventory Journal",Text020,PageName(PAGE::"Phys. Inventory Journal"));
          InsertSourceCode("Revaluation Journal",Text066,PageName(PAGE::"Revaluation Journal"));
          InsertSourceCode("Consumption Journal",Text067,PageName(PAGE::"Consumption Journal"));
          InsertSourceCode("Output Journal",Text069,PageName(PAGE::"Output Journal"));
          InsertSourceCode("Production Journal",Text092,PageName(PAGE::"Production Journal"));
          InsertSourceCode("Capacity Journal",Text070,PageName(PAGE::"Capacity Journal"));
          InsertSourceCode("Resource Journal",Text022,PageName(PAGE::"Resource Journal"));
          InsertSourceCode("Job Journal",Text023,PageName(PAGE::"Job Journal"));
          InsertSourceCode("Job G/L Journal",Text096,PageName(PAGE::"Job G/L Journal"));
          InsertSourceCode("Job G/L WIP",Text097,Text098);
          InsertSourceCode("Sales Entry Application",Text024,Text025);
          InsertSourceCode("Unapplied Sales Entry Appln.",Text086,Text087);
          InsertSourceCode("Unapplied Purch. Entry Appln.",Text088,Text089);
          InsertSourceCode("Unapplied Empl. Entry Appln.",UnappliedEmplEntryApplnCodeTxt,UnappliedEmplEntryApplnTxt);
          InsertSourceCode(Reversal,Text090,Text091);
          InsertSourceCode("Purchase Entry Application",Text026,Text027);
          InsertSourceCode("Employee Entry Application",EmployeeEntryApplicationCodeTxt,EmployeeEntryApplicationTxt);
          InsertSourceCode("VAT Settlement",Text028,ReportName(REPORT::"Calc. and Post VAT Settlement"));
          InsertSourceCode("Compress G/L",Text029,ReportName(REPORT::"Date Compress General Ledger"));
          InsertSourceCode("Compress VAT Entries",Text030,ReportName(REPORT::"Date Compress VAT Entries"));
          InsertSourceCode("Compress Cust. Ledger",Text031,ReportName(REPORT::"Date Compress Customer Ledger"));
          InsertSourceCode("Compress Vend. Ledger",Text032,ReportName(REPORT::"Date Compress Vendor Ledger"));
          InsertSourceCode("Compress Res. Ledger",Text035,ReportName(REPORT::"Date Compress Resource Ledger"));
          InsertSourceCode("Compress Job Ledger",Text036,Text099);
          InsertSourceCode("Compress Bank Acc. Ledger",Text037,ReportName(REPORT::"Date Compress Bank Acc. Ledger"));
          InsertSourceCode("Compress Check Ledger",Text038,ReportName(REPORT::"Delete Check Ledger Entries"));
          InsertSourceCode("Financially Voided Check",Text039,Text040);
          InsertSourceCode(Reminder,Text041,Text042);
          InsertSourceCode("Finance Charge Memo",Text043,Text044);
          InsertSourceCode("Trans. Bank Rec. to Gen. Jnl.",Text076,ReportName(REPORT::"Trans. Bank Rec. to Gen. Jnl."));
          InsertSourceCode("Fixed Asset G/L Journal",Text045,PageName(PAGE::"Fixed Asset G/L Journal"));
          InsertSourceCode("Fixed Asset Journal",Text046,PageName(PAGE::"Fixed Asset Journal"));
          InsertSourceCode("Insurance Journal",Text047,PageName(PAGE::"Insurance Journal"));
          InsertSourceCode("Compress FA Ledger",Text048,ReportName(REPORT::"Date Compress FA Ledger"));
          InsertSourceCode("Compress Maintenance Ledger",Text049,ReportName(REPORT::"Date Compress Maint. Ledger"));
          InsertSourceCode("Compress Insurance Ledger",Text050,ReportName(REPORT::"Date Compress Insurance Ledger"));
          InsertSourceCode("Adjust Add. Reporting Currency",Text051,ReportName(REPORT::"Adjust Add. Reporting Currency"));
          InsertSourceCode(Flushing,Text99000004,Text99000005);
          InsertSourceCode("Adjust Cost",Text068,ReportName(REPORT::"Adjust Cost - Item Entries"));
          InsertSourceCode("Compress Item Budget",Text100,ReportName(REPORT::"Date Comp. Item Budget Entries"));
          InsertSourceCode("Whse. Item Journal",Text071,PageName(PAGE::"Whse. Item Journal"));
          InsertSourceCode("Whse. Phys. Invt. Journal",Text072,PageName(PAGE::"Whse. Phys. Invt. Journal"));
          InsertSourceCode("Whse. Reclassification Journal",Text073,PageName(PAGE::"Whse. Reclassification Journal"));
          InsertSourceCode("Compress Whse. Entries",Text083,ReportName(REPORT::"Date Compress Whse. Entries"));
          InsertSourceCode("Whse. Put-away",Text077,Text080);
          InsertSourceCode("Whse. Pick",Text078,Text081);
          InsertSourceCode("Whse. Movement",Text079,Text082);
          InsertSourceCode("Service Management",Text074,Text075);
          InsertSourceCode("IC General Journal",Text084,Text085);
          InsertSourceCode("Cash Flow Worksheet",Text109,Text110);
          InsertSourceCode(Assembly,Text107,Text108);
          InsertSourceCode("G/L Entry to CA",Text111,Text112);
          InsertSourceCode("Cost Journal",Text113,Text114);
          InsertSourceCode("Cost Allocation",Text115,Text116);
          InsertSourceCode("Transfer Budget to Actual",Text117,Text118);
          INSERT;
        END;
    END;

    LOCAL PROCEDURE InitStandardTexts@11();
    VAR
      StandardText@1000 : Record 7;
    BEGIN
      IF NOT StandardText.FINDFIRST THEN BEGIN
        InsertStandardText(Text052,Text053);
        InsertStandardText(Text054,Text055);
        InsertStandardText(Text056,Text057);
        InsertStandardText(Text058,Text059);
      END;
    END;

    LOCAL PROCEDURE InitReportSelection@13();
    VAR
      ReportSelections@1000 : Record 77;
    BEGIN
      WITH ReportSelections DO
        IF NOT FINDFIRST THEN BEGIN
          InsertRepSelection(Usage::"Pro Forma S. Invoice",'1',REPORT::"Standard Sales - Pro Forma Inv");
          InsertRepSelection(Usage::"S.Invoice Draft",'1',REPORT::"Standard Sales - Draft Invoice");
          InsertRepSelection(Usage::"S.Quote",'1',REPORT::"Standard Sales - Quote");
          InsertRepSelection(Usage::"S.Blanket",'1',REPORT::"Blanket Sales Order");
          InsertRepSelection(Usage::"S.Order",'1',REPORT::"Standard Sales - Order Conf.");
          InsertRepSelection(Usage::"S.Work Order",'1',REPORT::"Work Order");
          InsertRepSelection(Usage::"S.Invoice",'1',REPORT::"Standard Sales - Invoice");
          InsertRepSelection(Usage::"S.Return",'1',REPORT::"Return Order Confirmation");
          InsertRepSelection(Usage::"S.Cr.Memo",'1',REPORT::"Standard Sales - Credit Memo");
          InsertRepSelection(Usage::"S.Shipment",'1',REPORT::"Sales - Shipment");
          InsertRepSelection(Usage::"S.Ret.Rcpt.",'1',REPORT::"Sales - Return Receipt");
          InsertRepSelection(Usage::"S.Test",'1',REPORT::"Sales Document - Test");
          InsertRepSelection(Usage::"P.Quote",'1',REPORT::"Purchase - Quote");
          InsertRepSelection(Usage::"P.Blanket",'1',REPORT::"Blanket Purchase Order");
          InsertRepSelection(Usage::"P.Order",'1',REPORT::Order);
          InsertRepSelection(Usage::"P.Invoice",'1',REPORT::"Purchase - Invoice");
          InsertRepSelection(Usage::"P.Return",'1',REPORT::"Return Order");
          InsertRepSelection(Usage::"P.Cr.Memo",'1',REPORT::"Purchase - Credit Memo");
          InsertRepSelection(Usage::"P.Receipt",'1',REPORT::"Purchase - Receipt");
          InsertRepSelection(Usage::"P.Ret.Shpt.",'1',REPORT::"Purchase - Return Shipment");
          InsertRepSelection(Usage::"P.Test",'1',REPORT::"Purchase Document - Test");
          InsertRepSelection(Usage::"B.Stmt",'1',REPORT::"Bank Account Statement");
          InsertRepSelection(Usage::"B.Recon.Test",'1',REPORT::"Bank Acc. Recon. - Test");
          InsertRepSelection(Usage::"B.Check",'1',REPORT::Check);
          InsertRepSelection(Usage::Reminder,'1',REPORT::Reminder);
          InsertRepSelection(Usage::"Fin.Charge",'1',REPORT::"Finance Charge Memo");
          InsertRepSelection(Usage::"Rem.Test",'1',REPORT::"Reminder - Test");
          InsertRepSelection(Usage::"F.C.Test",'1',REPORT::"Finance Charge Memo - Test");
          InsertRepSelection(Usage::Inv1,'1',REPORT::"Transfer Order");
          InsertRepSelection(Usage::Inv2,'1',REPORT::"Transfer Shipment");
          InsertRepSelection(Usage::Inv3,'1',REPORT::"Transfer Receipt");
          InsertRepSelection(Usage::"Invt. Period Test",'1',REPORT::"Close Inventory Period - Test");
          InsertRepSelection(Usage::"Prod. Order",'1',REPORT::"Prod. Order - Job Card");
          InsertRepSelection(Usage::M1,'1',REPORT::"Prod. Order - Job Card");
          InsertRepSelection(Usage::M2,'1',REPORT::"Prod. Order - Mat. Requisition");
          InsertRepSelection(Usage::M3,'1',REPORT::"Prod. Order - Shortage List");
          InsertRepSelection(Usage::"SM.Quote",'1',REPORT::"Service Quote");
          InsertRepSelection(Usage::"SM.Order",'1',REPORT::"Service Order");
          InsertRepSelection(Usage::"SM.Invoice",'1',REPORT::"Service - Invoice");
          InsertRepSelection(Usage::"SM.Credit Memo",'1',REPORT::"Service - Credit Memo");
          InsertRepSelection(Usage::"SM.Shipment",'1',REPORT::"Service - Shipment");
          InsertRepSelection(Usage::"SM.Contract Quote",'1',REPORT::"Service Contract Quote");
          InsertRepSelection(Usage::"SM.Contract",'1',REPORT::"Service Contract");
          InsertRepSelection(Usage::"SM.Test",'1',REPORT::"Service Document - Test");
          InsertRepSelection(Usage::"Asm. Order",'1',REPORT::"Assembly Order");
          InsertRepSelection(Usage::"P.Assembly Order",'1',REPORT::"Posted Assembly Order");
          InsertRepSelection(Usage::"S.Test Prepmt.",'1',REPORT::"Sales Prepmt. Document Test");
          InsertRepSelection(Usage::"P.Test Prepmt.",'1',REPORT::"Purchase Prepmt. Doc. - Test");
          InsertRepSelection(Usage::"S.Arch. Quote",'1',REPORT::"Archived Sales Quote");
          InsertRepSelection(Usage::"S.Arch. Order",'1',REPORT::"Archived Sales Order");
          InsertRepSelection(Usage::"P.Arch. Quote",'1',REPORT::"Archived Purchase Quote");
          InsertRepSelection(Usage::"P.Arch. Order",'1',REPORT::"Archived Purchase Order");
          InsertRepSelection(Usage::"P. Arch. Return Order",'1',REPORT::"Arch.Purch. Return Order");
          InsertRepSelection(Usage::"S. Arch. Return Order",'1',REPORT::"Arch. Sales Return Order");
          InsertRepSelection(Usage::"S.Order Pick Instruction",'1',REPORT::"Pick Instruction");
          InsertRepSelection(Usage::"C.Statement",'1',REPORT::"Standard Statement");
        END;
    END;

    LOCAL PROCEDURE InitJobWIPMethods@15();
    VAR
      JobWIPMethod@1000 : Record 1006;
    BEGIN
      IF NOT JobWIPMethod.FINDFIRST THEN BEGIN
        InsertJobWIPMethod(Text101,Text101,JobWIPMethod."Recognized Costs"::"At Completion",
          JobWIPMethod."Recognized Sales"::"At Completion",4);
        InsertJobWIPMethod(Text102,Text102,JobWIPMethod."Recognized Costs"::"Cost of Sales",
          JobWIPMethod."Recognized Sales"::"Contract (Invoiced Price)",2);
        InsertJobWIPMethod(Text103,Text103,JobWIPMethod."Recognized Costs"::"Cost Value",
          JobWIPMethod."Recognized Sales"::"Contract (Invoiced Price)",0);
        InsertJobWIPMethod(Text104,Text104,JobWIPMethod."Recognized Costs"::"Usage (Total Cost)",
          JobWIPMethod."Recognized Sales"::"Sales Value",1);
        InsertJobWIPMethod(Text106,Text105,JobWIPMethod."Recognized Costs"::"Usage (Total Cost)",
          JobWIPMethod."Recognized Sales"::"Percentage of Completion",3);
      END;
    END;

    LOCAL PROCEDURE InitBankExportImportSetup@14();
    VAR
      BankExportImportSetup@1000 : Record 1200;
    BEGIN
      IF NOT BankExportImportSetup.FINDFIRST THEN BEGIN
        InsertBankExportImportSetup(SEPACTCodeTxt,SEPACTNameTxt,BankExportImportSetup.Direction::Export,
          CODEUNIT::"SEPA CT-Export File",XMLPORT::"SEPA CT pain.001.001.03",CODEUNIT::"SEPA CT-Check Line");
        InsertBankExportImportSetup(SEPADDCodeTxt,SEPADDNameTxt,BankExportImportSetup.Direction::Export,
          CODEUNIT::"SEPA DD-Export File",XMLPORT::"SEPA DD pain.008.001.02",CODEUNIT::"SEPA DD-Check Line");
      END;
    END;

    LOCAL PROCEDURE InitBankClearingStandard@18();
    VAR
      BankClearingStandard@1000 : Record 1280;
    BEGIN
      IF NOT BankClearingStandard.FINDFIRST THEN BEGIN
        InsertBankClearingStandard(BankClearingStandardCode1Tok,BankClearingStandardDesc1Txt);
        InsertBankClearingStandard(BankClearingStandardCode2Tok,BankClearingStandardDesc2Txt);
        InsertBankClearingStandard(BankClearingStandardCode3Tok,BankClearingStandardDesc3Txt);
        InsertBankClearingStandard(BankClearingStandardCode4Tok,BankClearingStandardDesc4Txt);
        InsertBankClearingStandard(BankClearingStandardCode5Tok,BankClearingStandardDesc5Txt);
        InsertBankClearingStandard(BankClearingStandardCode6Tok,BankClearingStandardDesc6Txt);
        InsertBankClearingStandard(BankClearingStandardCode7Tok,BankClearingStandardDesc7Txt);
        InsertBankClearingStandard(BankClearingStandardCode8Tok,BankClearingStandardDesc8Txt);
        InsertBankClearingStandard(BankClearingStandardCode9Tok,BankClearingStandardDesc9Txt);
        InsertBankClearingStandard(BankClearingStandardCode10Tok,BankClearingStandardDesc10Txt);
        InsertBankClearingStandard(BankClearingStandardCode11Tok,BankClearingStandardDesc11Txt);
        InsertBankClearingStandard(BankClearingStandardCode12Tok,BankClearingStandardDesc12Txt);
        InsertBankClearingStandard(BankClearingStandardCode13Tok,BankClearingStandardDesc13Txt);
        InsertBankClearingStandard(BankClearingStandardCode14Tok,BankClearingStandardDesc14Txt);
        InsertBankClearingStandard(BankClearingStandardCode15Tok,BankClearingStandardDesc15Txt);
        InsertBankClearingStandard(BankClearingStandardCode16Tok,BankClearingStandardDesc16Txt);
        InsertBankClearingStandard(BankClearingStandardCode17Tok,BankClearingStandardDesc17Txt);
        InsertBankClearingStandard(BankClearingStandardCode18Tok,BankClearingStandardDesc18Txt);
      END;
    END;

    LOCAL PROCEDURE InitBankDataConvServiceSetup@19();
    VAR
      BankDataConvServiceSetup@1000 : Record 1260;
    BEGIN
      WITH BankDataConvServiceSetup DO BEGIN
        IF NOT GET THEN BEGIN
          INIT;
          INSERT(TRUE);
        END;
        IF "Sign-up URL" = 'http://www.amcbanking.dk/nav/register' THEN BEGIN
          "Sign-up URL" := 'https://amcbanking.com/store/amc-banking/microsoft-dynamics-nav/version-2015-2016/';
          MODIFY;
        END;
      END;
    END;

    LOCAL PROCEDURE InitDocExchServiceSetup@25();
    VAR
      DocExchServiceSetup@1000 : Record 1275;
    BEGIN
      WITH DocExchServiceSetup DO
        IF NOT GET THEN BEGIN
          INIT;
          SetURLsToDefault;
          INSERT;
        END;
    END;

    LOCAL PROCEDURE InitBankDataConversionPmtType@21();
    VAR
      BankDataConversionPmtType@1000 : Record 1281;
    BEGIN
      IF NOT BankDataConversionPmtType.FINDFIRST THEN BEGIN
        InsertBankDataConversionPmtType(BankDataConvPmtTypeCode1Tok,BankDataConvPmtTypeDesc1Txt);
        InsertBankDataConversionPmtType(BankDataConvPmtTypeCode2Tok,BankDataConvPmtTypeDesc2Txt);
        InsertBankDataConversionPmtType(BankDataConvPmtTypeCode3Tok,BankDataConvPmtTypeDesc3Txt);
        InsertBankDataConversionPmtType(BankDataConvPmtTypeCode4Tok,BankDataConvPmtTypeDesc4Txt);
        InsertBankDataConversionPmtType(BankDataConvPmtTypeCode5Tok,BankDataConvPmtTypeDesc5Txt);
        InsertBankDataConversionPmtType(BankDataConvPmtTypeCode6Tok,BankDataConvPmtTypeDesc6Txt);
        InsertBankDataConversionPmtType(BankDataConvPmtTypeCode7Tok,BankDataConvPmtTypeDesc7Txt);
        InsertBankDataConversionPmtType(BankDataConvPmtTypeCode8Tok,BankDataConvPmtTypeDesc8Txt);
        InsertBankDataConversionPmtType(BankDataConvPmtTypeCode9Tok,BankDataConvPmtTypeDesc9Txt);
      END;
    END;

    LOCAL PROCEDURE InitElectronicFormats@23();
    VAR
      ElectronicDocumentFormat@1000 : Record 61;
    BEGIN
      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        CODEUNIT::"Export Sales Inv. - PEPPOL 2.1",0,ElectronicDocumentFormat.Usage::"Sales Invoice");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        CODEUNIT::"Export Sales Cr.M. - PEPPOL2.1",0,ElectronicDocumentFormat.Usage::"Sales Credit Memo");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        CODEUNIT::"Export Serv. Inv. - PEPPOL 2.1",0,ElectronicDocumentFormat.Usage::"Service Invoice");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        CODEUNIT::"Exp. Service Cr.M. - PEPPOL2.1",0,ElectronicDocumentFormat.Usage::"Service Credit Memo");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        CODEUNIT::"PEPPOL Validation",0,ElectronicDocumentFormat.Usage::"Sales Validation");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        CODEUNIT::"PEPPOL Service Validation",0,ElectronicDocumentFormat.Usage::"Service Validation");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        CODEUNIT::"Export Sales Inv. - PEPPOL 2.0",0,ElectronicDocumentFormat.Usage::"Sales Invoice");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        CODEUNIT::"Export Sales Cr.M. - PEPPOL2.0",0,ElectronicDocumentFormat.Usage::"Sales Credit Memo");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        CODEUNIT::"Export Serv. Inv. - PEPPOL 2.0",0,ElectronicDocumentFormat.Usage::"Service Invoice");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        CODEUNIT::"Exp. Service Cr.M. - PEPPOL2.0",0,ElectronicDocumentFormat.Usage::"Service Credit Memo");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        CODEUNIT::"PEPPOL Validation",0,ElectronicDocumentFormat.Usage::"Sales Validation");

      ElectronicDocumentFormat.InsertElectronicFormat(
        PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        CODEUNIT::"PEPPOL Service Validation",0,ElectronicDocumentFormat.Usage::"Service Validation");

      // OIOUBL
      ElectronicDocumentFormat.InsertElectronicFormat(
        OIOUBLFormatTxt,OIOUBLFormatDescriptionTxt,
        CODEUNIT::"OIOUBL Export Sales Invoice",0,ElectronicDocumentFormat.Usage::"Sales Invoice");

      ElectronicDocumentFormat.InsertElectronicFormat(
        OIOUBLFormatTxt,OIOUBLFormatDescriptionTxt,
        CODEUNIT::"OIOUBL Export Sales Cr. Memo",0,ElectronicDocumentFormat.Usage::"Sales Credit Memo");

      ElectronicDocumentFormat.InsertElectronicFormat(
        OIOUBLFormatTxt,OIOUBLFormatDescriptionTxt,
        CODEUNIT::"OIOUBL Check Sales Header",0,ElectronicDocumentFormat.Usage::"Sales Validation");
    END;

    LOCAL PROCEDURE InsertSourceCode@1(VAR SourceCodeDefCode@1000 : Code[10];Code@1001 : Code[10];Description@1002 : Text[50]);
    VAR
      SourceCode@1003 : Record 230;
    BEGIN
      SourceCodeDefCode := Code;
      SourceCode.INIT;
      SourceCode.Code := Code;
      SourceCode.Description := Description;
      SourceCode.INSERT;
    END;

    LOCAL PROCEDURE InsertStandardText@4(Code@1000 : Code[20];Description@1001 : Text[50]);
    VAR
      StandardText@1002 : Record 7;
    BEGIN
      StandardText.INIT;
      StandardText.Code := Code;
      StandardText.Description := Description;
      StandardText.INSERT;
    END;

    LOCAL PROCEDURE InsertRepSelection@2(ReportUsage@1000 : Integer;Sequence@1001 : Code[10];ReportID@1002 : Integer);
    VAR
      ReportSelections@1003 : Record 77;
    BEGIN
      ReportSelections.INIT;
      ReportSelections.Usage := ReportUsage;
      ReportSelections.Sequence := Sequence;
      ReportSelections."Report ID" := ReportID;
      ReportSelections.INSERT;
    END;

    LOCAL PROCEDURE PageName@5(PageID@1000 : Integer) : Text[50];
    VAR
      ObjectTranslation@1001 : Record 377;
    BEGIN
      EXIT(COPYSTR(ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Page,PageID),1,30));
    END;

    LOCAL PROCEDURE ReportName@6(ReportID@1000 : Integer) : Text[50];
    VAR
      ObjectTranslation@1001 : Record 377;
    BEGIN
      EXIT(COPYSTR(ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Report,ReportID),1,30));
    END;

    LOCAL PROCEDURE InsertClientAddIns@8();
    VAR
      ClientAddIn@1000 : Record 2000000069;
    BEGIN
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.DynamicsOnlineConnect','31bf3856ad364e35','',
        ClientAddIn.Category::"DotNet Control Add-in",
        'Microsoft Dynamics Online Connect control add-in','');
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.BusinessChart','31bf3856ad364e35','',
        ClientAddIn.Category::"JavaScript Control Add-in",
        'Microsoft Dynamics BusinessChart control add-in',
        APPLICATIONPATH + 'Add-ins\BusinessChart\Microsoft.Dynamics.Nav.Client.BusinessChart.zip');
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.TimelineVisualization','31bf3856ad364e35','',
        ClientAddIn.Category::"DotNet Control Add-in",
        'Interactive visualizion for a timeline of events','');
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.PingPong','31bf3856ad364e35','',
        ClientAddIn.Category::"DotNet Control Add-in",
        'Microsoft Dynamics PingPong control add-in','');
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.VideoPlayer','31bf3856ad364e35','',
        ClientAddIn.Category::"JavaScript Control Add-in",
        'Microsoft Dynamics VideoPlayer control add-in',
        APPLICATIONPATH + 'Add-ins\VideoPlayer\Microsoft.Dynamics.Nav.Client.VideoPlayer.zip');
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.PageReady','31bf3856ad364e35','',
        ClientAddIn.Category::"JavaScript Control Add-in",
        'Microsoft Dynamics PageReady control add-in',
        APPLICATIONPATH + 'Add-ins\PageReady\Microsoft.Dynamics.Nav.Client.PageReady.zip');
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.SocialListening','31bf3856ad364e35','',
        ClientAddIn.Category::"JavaScript Control Add-in",
        'Microsoft Social Listening control add-in',
        APPLICATIONPATH + 'Add-ins\SocialListening\Microsoft.Dynamics.Nav.Client.SocialListening.zip');
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.WebPageViewer','31bf3856ad364e35','',
        ClientAddIn.Category::"JavaScript Control Add-in",
        'Microsoft Web Page Viewer control add-in',
        APPLICATIONPATH + 'Add-ins\WebPageViewer\Microsoft.Dynamics.Nav.Client.WebPageViewer.zip');
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.OAuthIntegration','31bf3856ad364e35','',
        ClientAddIn.Category::"JavaScript Control Add-in",
        'Microsoft OAuth Integration control add-in',
        APPLICATIONPATH + 'Add-ins\OAuthIntegration\Microsoft.Dynamics.Nav.Client.OAuthIntegration.zip');
      InsertClientAddIn(
        'Microsoft.Dynamics.Nav.Client.FlowIntegration','31bf3856ad364e35','',
        ClientAddIn.Category::"JavaScript Control Add-in",
        'Microsoft Flow Integration control add-in',
        APPLICATIONPATH + 'Add-ins\FlowIntegration\Microsoft.Dynamics.Nav.Client.FlowIntegration.zip');
    END;

    LOCAL PROCEDURE InsertClientAddIn@17(ControlAddInName@1000 : Text[220];PublicKeyToken@1001 : Text[20];Version@1002 : Text[25];Category@1006 : Option;Description@1003 : Text[250];ResourceFilePath@1005 : Text[250]);
    VAR
      ClientAddIn@1004 : Record 2000000069;
    BEGIN
      IF ClientAddIn.GET(ControlAddInName,PublicKeyToken,Version) THEN
        EXIT;

      ClientAddIn.INIT;
      ClientAddIn."Add-in Name" := ControlAddInName;
      ClientAddIn."Public Key Token" := PublicKeyToken;
      ClientAddIn.Version := Version;
      ClientAddIn.Category := Category;
      ClientAddIn.Description := Description;
      IF EXISTS(ResourceFilePath) THEN
        ClientAddIn.Resource.IMPORT(ResourceFilePath);
      IF ClientAddIn.INSERT THEN;
    END;

    LOCAL PROCEDURE InsertJobWIPMethod@7(Code@1000 : Code[20];Description@1001 : Text[50];RecognizedCosts@1002 : Option;RecognizedSales@1003 : Option;SystemDefinedIndex@1004 : Integer);
    VAR
      JobWIPMethod@1005 : Record 1006;
    BEGIN
      JobWIPMethod.INIT;
      JobWIPMethod.Code := Code;
      JobWIPMethod.Description := Description;
      JobWIPMethod."WIP Cost" := TRUE;
      JobWIPMethod."WIP Sales" := TRUE;
      JobWIPMethod."Recognized Costs" := RecognizedCosts;
      JobWIPMethod."Recognized Sales" := RecognizedSales;
      JobWIPMethod.Valid := TRUE;
      JobWIPMethod."System Defined" := TRUE;
      JobWIPMethod."System-Defined Index" := SystemDefinedIndex;
      JobWIPMethod.INSERT;
    END;

    LOCAL PROCEDURE InsertBankExportImportSetup@16(CodeTxt@1000 : Text[20];NameTxt@1001 : Text[100];DirectionOpt@1002 : Option;CodeunitID@1003 : Integer;XMLPortID@1004 : Integer;CheckCodeunitID@1006 : Integer);
    VAR
      BankExportImportSetup@1005 : Record 1200;
    BEGIN
      WITH BankExportImportSetup DO BEGIN
        INIT;
        Code := CodeTxt;
        Name := NameTxt;
        Direction := DirectionOpt;
        "Processing Codeunit ID" := CodeunitID;
        "Processing XMLport ID" := XMLPortID;
        "Check Export Codeunit" := CheckCodeunitID;
        "Preserve Non-Latin Characters" := FALSE;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE InsertBankClearingStandard@12(CodeText@1001 : Text[50];DescriptionText@1002 : Text[80]);
    VAR
      BankClearingStandard@1000 : Record 1280;
    BEGIN
      WITH BankClearingStandard DO BEGIN
        INIT;
        Code := CodeText;
        Description := DescriptionText;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE InsertBankDataConversionPmtType@20(CodeText@1001 : Text[50];DescriptionText@1002 : Text[80]);
    VAR
      BankDataConversionPmtType@1000 : Record 1281;
    BEGIN
      WITH BankDataConversionPmtType DO BEGIN
        INIT;
        Code := CodeText;
        Description := DescriptionText;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE InitApplicationAreasForSaaS@22();
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
      PermissionManager@1000 : Codeunit 9002;
    BEGIN
      IF PermissionManager.SoftwareAsAService THEN
        ApplicationAreaSetup.ResetNonSelectableApplicationAreas;
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnCompanyInitialize@27();
    BEGIN
    END;

    [EventSubscriber(Table,2000000006,OnAfterDeleteEvent)]
    LOCAL PROCEDURE OnAfterCompanyDeleteRemoveReferences@10(VAR Rec@1000 : Record 2000000006;RunTrigger@1001 : Boolean);
    VAR
      AssistedCompanySetupStatus@1002 : Record 1802;
      UserGroupMember@1003 : Record 9001;
      UserGroupAccessControl@1004 : Record 9002;
      ApplicationAreaSetup@1005 : Record 9178;
      CustomReportLayout@1006 : Record 9650;
      ReportLayoutSelection@1007 : Record 9651;
    BEGIN
      IF Rec.ISTEMPORARY THEN
        EXIT;

      AssistedCompanySetupStatus.SETRANGE("Company Name",Rec.Name);
      AssistedCompanySetupStatus.DELETEALL;
      UserGroupMember.SETRANGE("Company Name",Rec.Name);
      UserGroupMember.DELETEALL;
      UserGroupAccessControl.SETRANGE("Company Name",Rec.Name);
      UserGroupAccessControl.DELETEALL;
      ApplicationAreaSetup.SETRANGE("Company Name",Rec.Name);
      ApplicationAreaSetup.DELETEALL;
      CustomReportLayout.SETRANGE("Company Name",Rec.Name);
      CustomReportLayout.DELETEALL;
      ReportLayoutSelection.SETRANGE("Company Name",Rec.Name);
      ReportLayoutSelection.DELETEALL;
    END;

    BEGIN
    END.
  }
}


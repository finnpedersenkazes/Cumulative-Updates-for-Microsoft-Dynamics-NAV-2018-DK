OBJECT Page 344 Navigate
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Naviger;
               ENU=Navigate];
    SaveValues=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table265;
    DataCaptionExpr=GetCaptionText;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,S�g efter;
                                ENU=New,Process,Report,Find By];
    OnInit=BEGIN
             SourceNameEnable := TRUE;
             SourceNoEnable := TRUE;
             SourceTypeEnable := TRUE;
             DocTypeEnable := TRUE;
             PrintEnable := TRUE;
             ShowEnable := TRUE;
             DocumentVisible := TRUE;
             FindBasedOn := FindBasedOn::Document;
           END;

    OnOpenPage=BEGIN
                 UpdateForm := TRUE;
                 FindRecordsOnOpen;
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;ActionGroup;
                      Name=Process;
                      CaptionML=[DAN=Proces;
                                 ENU=Process] }
      { 21      ;2   ;Action    ;
                      Name=Show;
                      CaptionML=[DAN=&Vis relaterede poster;
                                 ENU=&Show Related Entries];
                      ToolTipML=[DAN=Vis de relaterede poster af den valgte type.;
                                 ENU=View the related entries of the type that you have chosen.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=ShowEnable;
                      PromotedIsBig=Yes;
                      Image=ViewDocumentLine;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowRecords;
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=Find;
                      CaptionML=[DAN=S&�g;
                                 ENU=Fi&nd];
                      ToolTipML=[DAN=Anvend et filter for at s�ge p� denne side.;
                                 ENU=Apply a filter to search on this page.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Find;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 FindPush;
                                 FilterSelectionChangedTxtVisible := FALSE;
                               END;
                                }
      { 34      ;2   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f�r vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=PrintEnable;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ItemTrackingNavigate@1002 : Report 6529;
                                 DocumentEntries@1001 : Report 35;
                               BEGIN
                                 IF ItemTrackingSearch THEN BEGIN
                                   CLEAR(ItemTrackingNavigate);
                                   ItemTrackingNavigate.TransferDocEntries(Rec);
                                   ItemTrackingNavigate.TransferRecordBuffer(TempRecordBuffer);
                                   ItemTrackingNavigate.TransferFilters(SerialNoFilter,LotNoFilter,'','');
                                   ItemTrackingNavigate.RUN;
                                 END ELSE BEGIN
                                   DocumentEntries.TransferDocEntries(Rec);
                                   DocumentEntries.TransferFilters(DocNoFilter,PostingDateFilter);
                                   DocumentEntries.RUN;
                                 END;
                               END;
                                }
      { 4       ;1   ;ActionGroup;
                      Name=FindGroup;
                      CaptionML=[DAN=S�g efter;
                                 ENU=Find by] }
      { 2       ;2   ;Action    ;
                      Name=FindByDocument;
                      CaptionML=[DAN=S�g efter dokument;
                                 ENU=Find by Document];
                      ToolTipML=[DAN=Vis poster ud fra det angivne bilagsnummer.;
                                 ENU=View entries based on the specified document number.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Documents;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FindBasedOn := FindBasedOn::Document;
                                 UpdateFindByGroupsVisibility;
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Name=FindByBusinessContact;
                      CaptionML=[DAN=S�g efter forretningskontakt;
                                 ENU=Find by Business Contact];
                      ToolTipML=[DAN=Filtrer poster ud fra den angivne kontakt eller kontakttype.;
                                 ENU=Filter entries based on the specified contact or contact type.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ContactPerson;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FindBasedOn := FindBasedOn::"Business Contact";
                                 UpdateFindByGroupsVisibility;
                               END;
                                }
      { 28      ;2   ;Action    ;
                      Name=FindByItemReference;
                      CaptionML=[DAN=S�g efter varereference;
                                 ENU=Find by Item Reference];
                      ToolTipML=[DAN=Filtrer poster ud fra det angivne serienummer eller lotnummer.;
                                 ENU=Filter entries based on the specified serial number or lot number.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ItemTracking;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FindBasedOn := FindBasedOn::"Item Reference";
                                 UpdateFindByGroupsVisibility;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 9   ;1   ;Group     ;
                Name=Document;
                CaptionML=[DAN=Bilag;
                           ENU=Document];
                Visible=DocumentVisible;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Bilagsnr.;
                           ENU=Document No.];
                ToolTipML=[DAN=Angiver bilagsnummeret p� en post, som bruges til at finde alle bilag med samme bilagsnummer. Du kan inds�tte et nyt bilagsnummer i feltet, hvis du vil s�ge efter andre bilag.;
                           ENU=Specifies the document number of an entry that is used to find all documents that have the same document number. You can enter a new document number in this field to search for another set of documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DocNoFilter;
                OnValidate=BEGIN
                             SetDocNo(DocNoFilter);
                             ContactType := ContactType::" ";
                             ContactNo := '';
                             ExtDocNo := '';
                             ClearTrackingInfo;
                             DocNoFilterOnAfterValidate;
                             FilterSelectionChanged;
                           END;
                            }

    { 1   ;2   ;Field     ;
                CaptionML=[DAN=Bogf�ringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for det bilag, du s�ger efter. Du kan inds�tte et filter, hvis du vil s�ge efter et bestemt interval af datoer.;
                           ENU=Specifies the posting date for the document that you are searching for. You can insert a filter if you want to search for a certain interval of dates.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PostingDateFilter;
                OnValidate=BEGIN
                             SetPostingDate(PostingDateFilter);
                             ContactType := ContactType::" ";
                             ContactNo := '';
                             ExtDocNo := '';
                             ClearTrackingInfo;
                             PostingDateFilterOnAfterValida;
                             FilterSelectionChanged;
                           END;
                            }

    { 15  ;1   ;Group     ;
                Name=Business Contact;
                CaptionML=[DAN=Forretningskontakt;
                           ENU=Business Contact];
                Visible=BusinessContactVisible;
                GroupType=Group }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Type;
                           ENU=Business Contact Type];
                ToolTipML=[DAN=Angiver, om du vil s�ge efter debitorer, kreditorer eller bankkonti. Dit valg fasts�tter den liste, som du kan f� adgang til i feltet Nummer.;
                           ENU=Specifies if you want to search for customers, vendors, or bank accounts. Your choice determines the list that you can access in the Business Contact No. field.];
                OptionCaptionML=[DAN=" ,Kreditor,Debitor";
                                 ENU=" ,Vendor,Customer"];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ContactType;
                OnValidate=BEGIN
                             SetDocNo('');
                             SetPostingDate('');
                             ClearTrackingInfo;
                             ContactTypeOnAfterValidate;
                             FilterSelectionChanged;
                           END;
                            }

    { 11  ;2   ;Field     ;
                CaptionML=[DAN=Nummer;
                           ENU=Business Contact No.];
                ToolTipML=[DAN=Angiver nummeret p� den debitor, kreditor eller bankkonto, som du vil finde poster til.;
                           ENU=Specifies the number of the customer, vendor, or bank account that you want to find entries for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ContactNo;
                OnValidate=BEGIN
                             SetDocNo('');
                             SetPostingDate('');
                             ClearTrackingInfo;
                             ContactNoOnAfterValidate;
                             FilterSelectionChanged;
                           END;

                OnLookup=VAR
                           Vend@1002 : Record 23;
                           Cust@1003 : Record 18;
                         BEGIN
                           CASE ContactType OF
                             ContactType::Vendor:
                               IF PAGE.RUNMODAL(0,Vend) = ACTION::LookupOK THEN BEGIN
                                 Text := Vend."No.";
                                 EXIT(TRUE);
                               END;
                             ContactType::Customer:
                               IF PAGE.RUNMODAL(0,Cust) = ACTION::LookupOK THEN BEGIN
                                 Text := Cust."No.";
                                 EXIT(TRUE);
                               END;
                           END;
                         END;
                          }

    { 13  ;2   ;Field     ;
                CaptionML=[DAN=Eksternt bilagsnr.;
                           ENU=External Document No.];
                ToolTipML=[DAN=Angiver bilagsnummer, som kreditoren har angivet.;
                           ENU=Specifies the document number assigned by the vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ExtDocNo;
                OnValidate=BEGIN
                             SetDocNo('');
                             SetPostingDate('');
                             ClearTrackingInfo;
                             ExtDocNoOnAfterValidate;
                             FilterSelectionChanged;
                           END;
                            }

    { 26  ;1   ;Group     ;
                Name=Item Reference;
                CaptionML=[DAN=Varereference;
                           ENU=Item Reference];
                Visible=ItemReferenceVisible;
                GroupType=Group }

    { 5   ;2   ;Field     ;
                Name=SerialNoFilter;
                CaptionML=[DAN=Serienr.;
                           ENU=Serial No.];
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for bilaget, n�r du har �bnet vinduet Naviger fra et bilag. Postens bilagsnummer er vist i feltet Bilagsnr.;
                           ENU=Specifies the posting date of the document when you have opened the Navigate window from the document. The entry's document number is shown in the Document No. field.];
                ApplicationArea=#ItemTracking;
                SourceExpr=SerialNoFilter;
                OnValidate=BEGIN
                             ClearInfo;
                             SerialNoFilterOnAfterValidate;
                             FilterSelectionChanged;
                           END;

                OnLookup=VAR
                           SerialNoInformationList@1001 : Page 6509;
                         BEGIN
                           CLEAR(SerialNoInformationList);
                           IF SerialNoInformationList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             Text := SerialNoInformationList.GetSelectionFilter;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 6   ;2   ;Field     ;
                Name=LotNoFilter;
                CaptionML=[DAN=Lotnr.;
                           ENU=Lot No.];
                ToolTipML=[DAN=Angiver det nummer, som du vil f inde poster til.;
                           ENU=Specifies the number that you want to find entries for.];
                ApplicationArea=#ItemTracking;
                SourceExpr=LotNoFilter;
                OnValidate=BEGIN
                             ClearInfo;
                             LotNoFilterOnAfterValidate;
                             FilterSelectionChanged;
                           END;

                OnLookup=VAR
                           LotNoInformationList@1002 : Page 6508;
                         BEGIN
                           CLEAR(LotNoInformationList);
                           IF LotNoInformationList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             Text := LotNoInformationList.GetSelectionFilter;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 25  ;1   ;Group     ;
                Name=Notification;
                CaptionML=[DAN=Notifikation;
                           ENU=Notification];
                Visible=FilterSelectionChangedTxtVisible;
                GroupType=Group;
                InstructionalTextML=[DAN=Filteret er �ndret. V�lg S�g for at opdatere listen over relaterede poster.;
                                     ENU=The filter has been changed. Choose Find to update the list of related entries.] }

    { 16  ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tabel, som posten er gemt i.;
                           ENU=Specifies the table that the entry is stored in.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Table ID";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Relaterede poster;
                           ENU=Related Entries];
                ToolTipML=[DAN=Angiver navnet p� den tabel, hvor funktionen Naviger har fundet poster med det valgte bilagsnummer og/eller den valgte bogf�ringsdato.;
                           ENU=Specifies the name of the table where the Navigate facility has found entries with the selected document number and/or posting date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Table Name" }

    { 19  ;2   ;Field     ;
                DrillDown=Yes;
                CaptionML=[DAN=Antal poster;
                           ENU=No. of Entries];
                ToolTipML=[DAN=Angiver det antal bilag, som funktionen Naviger har fundet i tabellen med de valgte poster.;
                           ENU=Specifies the number of documents that the Navigate facility has found in the table with the selected entries.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Records";
                OnDrillDown=BEGIN
                              ShowRecords;
                            END;
                             }

    { 7   ;1   ;Group     ;
                CaptionML=[DAN=Kilde;
                           ENU=Source] }

    { 8   ;2   ;Field     ;
                Name=DocType;
                CaptionML=[DAN=Bilagstype;
                           ENU=Document Type];
                ToolTipML=[DAN=Angiver typen p� det valgte bilag. Lad feltet Dokumenttype st� tomt, hvis du vil s�ge efter bogf�ringsdato. Bilagsnummeret p� den valgte post kan ses i feltet Bilagsnr.;
                           ENU=Specifies the type of the selected document. Leave the Document Type field blank if you want to search by posting date. The entry's document number is shown in the Document No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DocType;
                Enabled=DocTypeEnable;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                Name=SourceType;
                CaptionML=[DAN=Kildetype;
                           ENU=Source Type];
                ToolTipML=[DAN=Angiver kildetypen p� det valgte bilag - feltet er tomt, hvis du s�ger p� bogf�ringsdato. Bilagsnummeret p� den valgte post kan ses i feltet Bilagsnr.;
                           ENU=Specifies the source type of the selected document or remains blank if you search by posting date. The entry's document number is shown in the Document No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SourceType;
                Enabled=SourceTypeEnable;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                Name=SourceNo;
                CaptionML=[DAN=Kildenr.;
                           ENU=Source No.];
                ToolTipML=[DAN=Angiver kildenummeret p� det valgte bilag. Bilagsnummeret p� den valgte post kan ses i feltet Bilagsnr.;
                           ENU=Specifies the source number of the selected document. The entry's document number is shown in the Document No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SourceNo;
                Enabled=SourceNoEnable;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                Name=SourceName;
                CaptionML=[DAN=Kildenavn;
                           ENU=Source Name];
                ToolTipML=[DAN=Angiver kildenavnet p� det valgte post. Bilagsnummeret p� den valgte post kan ses i feltet Bilagsnr.;
                           ENU=Specifies the source name on the selected entry. The entry's document number is shown in the Document No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SourceName;
                Enabled=SourceNameEnable;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der er ikke valgt en type.;ENU=The business contact type was not specified.';
      Text001@1001 : TextConst 'DAN=Der er ingen bogf�rte records med dette eksterne bilagsnummer.;ENU=There are no posted records with this external document number.';
      Text002@1002 : TextConst 'DAN=Opt�ller records...;ENU=Counting records...';
      Text003@1003 : TextConst 'DAN=Bogf�rt salgsfaktura;ENU=Posted Sales Invoice';
      Text004@1004 : TextConst 'DAN=Bogf�rt salgskreditnota;ENU=Posted Sales Credit Memo';
      Text005@1005 : TextConst 'DAN=Bogf�rt salgsleverance;ENU=Posted Sales Shipment';
      Text006@1006 : TextConst 'DAN=Udstedt rykker;ENU=Issued Reminder';
      Text007@1007 : TextConst 'DAN=Udstedt rentenota;ENU=Issued Finance Charge Memo';
      Text008@1008 : TextConst 'DAN=Bogf�rt k�bsfaktura;ENU=Posted Purchase Invoice';
      Text009@1009 : TextConst 'DAN=Bogf�rt k�bskreditnota;ENU=Posted Purchase Credit Memo';
      Text010@1010 : TextConst 'DAN=Bogf�rt k�bsleverance;ENU=Posted Purchase Receipt';
      Text011@1011 : TextConst 'DAN=Bilagsnummeret er anvendt flere gange.;ENU=The document number has been used more than once.';
      Text012@1012 : TextConst 'DAN=Denne kombinationen af bilagsnummer og bogf�ringsdato er anvendt flere gange.;ENU=This combination of document number and posting date has been used more than once.';
      Text013@1013 : TextConst 'DAN=Der er ingen bogf�rte records med dette bilagsnummer.;ENU=There are no posted records with this document number.';
      Text014@1014 : TextConst 'DAN=Der er ingen bogf�rte records med denne kombination af bilagsnrummer og bogf�ringsdato.;ENU=There are no posted records with this combination of document number and posting date.';
      Text015@1015 : TextConst 'DAN=S�gningen resulterer i for mange eksterne bilag. Angiv et nummer.;ENU=The search results in too many external documents. Specify a business contact no.';
      Text016@1016 : TextConst 'DAN=S�gningen giver for mange eksterne bilag. Brug Naviger fra de relevante poster.;ENU=The search results in too many external documents. Use Navigate from the relevant ledger entries.';
      Text017@1017 : TextConst 'DAN=Bogf�rt returvaremodt.;ENU=Posted Return Receipt';
      Text018@1018 : TextConst 'DAN=Bogf�rt returvareleverance;ENU=Posted Return Shipment';
      Text019@1019 : TextConst 'DAN=Bogf�rt overflytningsleverance;ENU=Posted Transfer Shipment';
      Text020@1020 : TextConst 'DAN=Bogf. overflytningskvittering;ENU=Posted Transfer Receipt';
      Text021@1061 : TextConst 'DAN=Salgsordre;ENU=Sales Order';
      Text022@1080 : TextConst 'DAN=Salgsfaktura;ENU=Sales Invoice';
      Text023@1081 : TextConst 'DAN=Salgsreturvareordre;ENU=Sales Return Order';
      Text024@1082 : TextConst 'DAN=Salgskreditnota;ENU=Sales Credit Memo';
      Text025@1097 : TextConst 'DAN=Bogf�rt montageordre;ENU=Posted Assembly Order';
      sText003@1096 : TextConst 'DAN=Bogf�rt servicefaktura;ENU=Posted Service Invoice';
      sText004@1095 : TextConst 'DAN=Bogf�rt servicekreditnota;ENU=Posted Service Credit Memo';
      sText005@1092 : TextConst 'DAN=Bogf�rt serviceleverance;ENU=Posted Service Shipment';
      sText021@1094 : TextConst 'DAN=Serviceordre;ENU=Service Order';
      sText022@1093 : TextConst 'DAN=Servicefaktura;ENU=Service Invoice';
      sText024@1036 : TextConst 'DAN=Servicekreditnota;ENU=Service Credit Memo';
      Text99000000@1021 : TextConst 'DAN=Produktionsordre;ENU=Production Order';
      Cust@1023 : Record 18 SECURITYFILTERING(Filtered);
      Vend@1024 : Record 23 SECURITYFILTERING(Filtered);
      SOSalesHeader@1083 : Record 36;
      SISalesHeader@1084 : Record 36;
      SROSalesHeader@1086 : Record 36;
      SCMSalesHeader@1085 : Record 36;
      SalesShptHeader@1025 : Record 110 SECURITYFILTERING(Filtered);
      SalesInvHeader@1026 : Record 112 SECURITYFILTERING(Filtered);
      ReturnRcptHeader@1027 : Record 6660 SECURITYFILTERING(Filtered);
      SalesCrMemoHeader@1028 : Record 114 SECURITYFILTERING(Filtered);
      SOServHeader@1091 : Record 5900;
      SIServHeader@1090 : Record 5900;
      SCMServHeader@1059 : Record 5900;
      ServShptHeader@1058 : Record 5990 SECURITYFILTERING(Filtered);
      ServInvHeader@1057 : Record 5992 SECURITYFILTERING(Filtered);
      ServCrMemoHeader@1022 : Record 5994 SECURITYFILTERING(Filtered);
      IssuedReminderHeader@1029 : Record 297 SECURITYFILTERING(Filtered);
      IssuedFinChrgMemoHeader@1030 : Record 304 SECURITYFILTERING(Filtered);
      PurchRcptHeader@1031 : Record 120 SECURITYFILTERING(Filtered);
      PurchInvHeader@1032 : Record 122 SECURITYFILTERING(Filtered);
      ReturnShptHeader@1033 : Record 6650 SECURITYFILTERING(Filtered);
      PurchCrMemoHeader@1034 : Record 124 SECURITYFILTERING(Filtered);
      ProductionOrderHeader@1035 : Record 5405 SECURITYFILTERING(Filtered);
      PostedAssemblyHeader@1065 : Record 910 SECURITYFILTERING(Filtered);
      TransShptHeader@1037 : Record 5744 SECURITYFILTERING(Filtered);
      TransRcptHeader@1038 : Record 5746 SECURITYFILTERING(Filtered);
      PostedWhseRcptLine@1087 : Record 7319 SECURITYFILTERING(Filtered);
      PostedWhseShptLine@1088 : Record 7323 SECURITYFILTERING(Filtered);
      GLEntry@1039 : Record 17 SECURITYFILTERING(Filtered);
      VATEntry@1040 : Record 254 SECURITYFILTERING(Filtered);
      CustLedgEntry@1041 : Record 21 SECURITYFILTERING(Filtered);
      DtldCustLedgEntry@1042 : Record 379 SECURITYFILTERING(Filtered);
      VendLedgEntry@1043 : Record 25 SECURITYFILTERING(Filtered);
      DtldVendLedgEntry@1044 : Record 380 SECURITYFILTERING(Filtered);
      EmplLedgEntry@1109 : Record 5222 SECURITYFILTERING(Filtered);
      DtldEmplLedgEntry@1106 : Record 5223 SECURITYFILTERING(Filtered);
      ItemLedgEntry@1045 : Record 32 SECURITYFILTERING(Filtered);
      PhysInvtLedgEntry@1046 : Record 281 SECURITYFILTERING(Filtered);
      ResLedgEntry@1047 : Record 203 SECURITYFILTERING(Filtered);
      JobLedgEntry@1048 : Record 169 SECURITYFILTERING(Filtered);
      JobWIPEntry@1099 : Record 1004 SECURITYFILTERING(Filtered);
      JobWIPGLEntry@1100 : Record 1005 SECURITYFILTERING(Filtered);
      ValueEntry@1049 : Record 5802 SECURITYFILTERING(Filtered);
      BankAccLedgEntry@1050 : Record 271 SECURITYFILTERING(Filtered);
      CheckLedgEntry@1051 : Record 272 SECURITYFILTERING(Filtered);
      ReminderEntry@1052 : Record 300 SECURITYFILTERING(Filtered);
      FALedgEntry@1053 : Record 5601 SECURITYFILTERING(Filtered);
      MaintenanceLedgEntry@1054 : Record 5625 SECURITYFILTERING(Filtered);
      InsuranceCovLedgEntry@1055 : Record 5629 SECURITYFILTERING(Filtered);
      CapacityLedgEntry@1056 : Record 5832 SECURITYFILTERING(Filtered);
      ServLedgerEntry@1063 : Record 5907 SECURITYFILTERING(Filtered);
      WarrantyLedgerEntry@1064 : Record 5908 SECURITYFILTERING(Filtered);
      WhseEntry@1089 : Record 7312 SECURITYFILTERING(Filtered);
      TempRecordBuffer@1060 : TEMPORARY Record 6529;
      CostEntry@1098 : Record 1104 SECURITYFILTERING(Filtered);
      IncomingDocument@1101 : Record 130 SECURITYFILTERING(Filtered);
      ApplicationManagement@1066 : Codeunit 1;
      ItemTrackingNavigateMgt@1159 : Codeunit 6529;
      Window@1067 : Dialog;
      DocNoFilter@1068 : Text;
      PostingDateFilter@1069 : Text;
      NewDocNo@1070 : Code[20];
      ContactNo@1071 : Code[250];
      ExtDocNo@1072 : Code[250];
      NewPostingDate@1073 : Date;
      DocType@1074 : Text[50];
      SourceType@1075 : Text[30];
      SourceNo@1076 : Code[20];
      SourceName@1077 : Text[50];
      ContactType@1078 : ' ,Vendor,Customer';
      DocExists@1079 : Boolean;
      NewSerialNo@1136 : Code[20];
      NewLotNo@1122 : Code[20];
      SerialNoFilter@1157 : Text;
      LotNoFilter@1158 : Text;
      ShowEnable@19017131 : Boolean INDATASET;
      PrintEnable@19037407 : Boolean INDATASET;
      DocTypeEnable@19044345 : Boolean INDATASET;
      SourceTypeEnable@19078091 : Boolean INDATASET;
      SourceNoEnable@19029280 : Boolean INDATASET;
      SourceNameEnable@19028072 : Boolean INDATASET;
      UpdateForm@1062 : Boolean;
      FindBasedOn@1102 : 'Document,Business Contact,Item Reference';
      DocumentVisible@1103 : Boolean INDATASET;
      BusinessContactVisible@1104 : Boolean INDATASET;
      ItemReferenceVisible@1105 : Boolean INDATASET;
      FilterSelectionChangedTxtVisible@1107 : Boolean INDATASET;
      PageCaptionTxt@1108 : TextConst 'DAN=Markeret - %1;ENU=Selected - %1';

    [External]
    PROCEDURE SetDoc@1(PostingDate@1000 : Date;DocNo@1001 : Code[20]);
    BEGIN
      NewDocNo := DocNo;
      NewPostingDate := PostingDate;
    END;

    LOCAL PROCEDURE FindExtRecords@8();
    VAR
      VendLedgEntry2@1000 : Record 25 SECURITYFILTERING(Filtered);
      FoundRecords@1001 : Boolean;
      DateFilter2@1002 : Text;
      DocNoFilter2@1003 : Text;
    BEGIN
      FoundRecords := FALSE;
      CASE ContactType OF
        ContactType::Vendor:
          BEGIN
            VendLedgEntry2.SETCURRENTKEY("External Document No.");
            VendLedgEntry2.SETFILTER("External Document No.",ExtDocNo);
            VendLedgEntry2.SETFILTER("Vendor No.",ContactNo);
            IF VendLedgEntry2.FINDSET THEN BEGIN
              REPEAT
                MakeExtFilter(
                  DateFilter2,
                  VendLedgEntry2."Posting Date",
                  DocNoFilter2,
                  VendLedgEntry2."Document No.");
              UNTIL VendLedgEntry2.NEXT = 0;
              SetPostingDate(DateFilter2);
              SetDocNo(DocNoFilter2);
              FindRecords;
              FoundRecords := TRUE;
            END;
          END;
        ContactType::Customer:
          BEGIN
            DELETEALL;
            "Entry No." := 0;
            FindUnpostedSalesDocs(SOSalesHeader."Document Type"::Order,Text021,SOSalesHeader);
            FindUnpostedSalesDocs(SISalesHeader."Document Type"::Invoice,Text022,SISalesHeader);
            FindUnpostedSalesDocs(SROSalesHeader."Document Type"::"Return Order",Text023,SROSalesHeader);
            FindUnpostedSalesDocs(SCMSalesHeader."Document Type"::"Credit Memo",Text024,SCMSalesHeader);
            IF SalesShptHeader.READPERMISSION THEN BEGIN
              SalesShptHeader.RESET;
              SalesShptHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
              SalesShptHeader.SETFILTER("Sell-to Customer No.",ContactNo);
              SalesShptHeader.SETFILTER("External Document No.",ExtDocNo);
              InsertIntoDocEntry(
                DATABASE::"Sales Shipment Header",0,Text005,SalesShptHeader.COUNT);
            END;
            IF SalesInvHeader.READPERMISSION THEN BEGIN
              SalesInvHeader.RESET;
              SalesInvHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
              SalesInvHeader.SETFILTER("Sell-to Customer No.",ContactNo);
              SalesInvHeader.SETFILTER("External Document No.",ExtDocNo);
              InsertIntoDocEntry(
                DATABASE::"Sales Invoice Header",0,Text003,SalesInvHeader.COUNT);
            END;
            IF ReturnRcptHeader.READPERMISSION THEN BEGIN
              ReturnRcptHeader.RESET;
              ReturnRcptHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
              ReturnRcptHeader.SETFILTER("Sell-to Customer No.",ContactNo);
              ReturnRcptHeader.SETFILTER("External Document No.",ExtDocNo);
              InsertIntoDocEntry(
                DATABASE::"Return Receipt Header",0,Text017,ReturnRcptHeader.COUNT);
            END;
            IF SalesCrMemoHeader.READPERMISSION THEN BEGIN
              SalesCrMemoHeader.RESET;
              SalesCrMemoHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
              SalesCrMemoHeader.SETFILTER("Sell-to Customer No.",ContactNo);
              SalesCrMemoHeader.SETFILTER("External Document No.",ExtDocNo);
              InsertIntoDocEntry(
                DATABASE::"Sales Cr.Memo Header",0,Text004,SalesCrMemoHeader.COUNT);
            END;
            FindUnpostedServDocs(SOServHeader."Document Type"::Order,sText021,SOServHeader);
            FindUnpostedServDocs(SIServHeader."Document Type"::Invoice,sText022,SIServHeader);
            FindUnpostedServDocs(SCMServHeader."Document Type"::"Credit Memo",sText024,SCMServHeader);
            IF ServShptHeader.READPERMISSION THEN
              IF ExtDocNo = '' THEN BEGIN
                ServShptHeader.RESET;
                ServShptHeader.SETCURRENTKEY("Customer No.");
                ServShptHeader.SETFILTER("Customer No.",ContactNo);
                InsertIntoDocEntry(
                  DATABASE::"Service Shipment Header",0,sText005,ServShptHeader.COUNT);
              END;
            IF ServInvHeader.READPERMISSION THEN
              IF ExtDocNo = '' THEN BEGIN
                ServInvHeader.RESET;
                ServInvHeader.SETCURRENTKEY("Customer No.");
                ServInvHeader.SETFILTER("Customer No.",ContactNo);
                InsertIntoDocEntry(
                  DATABASE::"Service Invoice Header",0,sText003,ServInvHeader.COUNT);
              END;
            IF ServCrMemoHeader.READPERMISSION THEN
              IF ExtDocNo = '' THEN BEGIN
                ServCrMemoHeader.RESET;
                ServCrMemoHeader.SETCURRENTKEY("Customer No.");
                ServCrMemoHeader.SETFILTER("Customer No.",ContactNo);
                InsertIntoDocEntry(
                  DATABASE::"Service Cr.Memo Header",0,sText004,ServCrMemoHeader.COUNT);
              END;

            DocExists := FINDFIRST;

            UpdateFormAfterFindRecords;
            FoundRecords := DocExists;
          END;
        ELSE
          ERROR(Text000);
      END;

      IF NOT FoundRecords THEN BEGIN
        SetSource(0D,'','',0,'');
        MESSAGE(Text001);
      END;
    END;

    LOCAL PROCEDURE FindRecords@2();
    BEGIN
      Window.OPEN(Text002);
      RESET;
      DELETEALL;
      "Entry No." := 0;
      FindIncomingDocumentRecords;
      FindEmployeeRecords;
      FindSalesShipmentHeader;
      IF SalesInvHeader.READPERMISSION THEN BEGIN
        SalesInvHeader.RESET;
        SalesInvHeader.SETFILTER("No.",DocNoFilter);
        SalesInvHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Sales Invoice Header",0,Text003,SalesInvHeader.COUNT);
      END;
      IF ReturnRcptHeader.READPERMISSION THEN BEGIN
        ReturnRcptHeader.RESET;
        ReturnRcptHeader.SETFILTER("No.",DocNoFilter);
        ReturnRcptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Return Receipt Header",0,Text017,ReturnRcptHeader.COUNT);
      END;
      IF SalesCrMemoHeader.READPERMISSION THEN BEGIN
        SalesCrMemoHeader.RESET;
        SalesCrMemoHeader.SETFILTER("No.",DocNoFilter);
        SalesCrMemoHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Sales Cr.Memo Header",0,Text004,SalesCrMemoHeader.COUNT);
      END;
      IF ServShptHeader.READPERMISSION THEN BEGIN
        ServShptHeader.RESET;
        ServShptHeader.SETFILTER("No.",DocNoFilter);
        ServShptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Service Shipment Header",0,sText005,ServShptHeader.COUNT);
      END;
      IF ServInvHeader.READPERMISSION THEN BEGIN
        ServInvHeader.RESET;
        ServInvHeader.SETFILTER("No.",DocNoFilter);
        ServInvHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Service Invoice Header",0,sText003,ServInvHeader.COUNT);
      END;
      IF ServCrMemoHeader.READPERMISSION THEN BEGIN
        ServCrMemoHeader.RESET;
        ServCrMemoHeader.SETFILTER("No.",DocNoFilter);
        ServCrMemoHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Service Cr.Memo Header",0,sText004,ServCrMemoHeader.COUNT);
      END;
      IF IssuedReminderHeader.READPERMISSION THEN BEGIN
        IssuedReminderHeader.RESET;
        IssuedReminderHeader.SETFILTER("No.",DocNoFilter);
        IssuedReminderHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Issued Reminder Header",0,Text006,IssuedReminderHeader.COUNT);
      END;
      IF IssuedFinChrgMemoHeader.READPERMISSION THEN BEGIN
        IssuedFinChrgMemoHeader.RESET;
        IssuedFinChrgMemoHeader.SETFILTER("No.",DocNoFilter);
        IssuedFinChrgMemoHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Issued Fin. Charge Memo Header",0,Text007,
          IssuedFinChrgMemoHeader.COUNT);
      END;
      IF PurchRcptHeader.READPERMISSION THEN BEGIN
        PurchRcptHeader.RESET;
        PurchRcptHeader.SETFILTER("No.",DocNoFilter);
        PurchRcptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Purch. Rcpt. Header",0,Text010,PurchRcptHeader.COUNT);
      END;
      IF PurchInvHeader.READPERMISSION THEN BEGIN
        PurchInvHeader.RESET;
        PurchInvHeader.SETFILTER("No.",DocNoFilter);
        PurchInvHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Purch. Inv. Header",0,Text008,PurchInvHeader.COUNT);
      END;
      IF ReturnShptHeader.READPERMISSION THEN BEGIN
        ReturnShptHeader.RESET;
        ReturnShptHeader.SETFILTER("No.",DocNoFilter);
        ReturnShptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Return Shipment Header",0,Text018,ReturnShptHeader.COUNT);
      END;
      IF PurchCrMemoHeader.READPERMISSION THEN BEGIN
        PurchCrMemoHeader.RESET;
        PurchCrMemoHeader.SETFILTER("No.",DocNoFilter);
        PurchCrMemoHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Purch. Cr. Memo Hdr.",0,Text009,PurchCrMemoHeader.COUNT);
      END;
      IF ProductionOrderHeader.READPERMISSION THEN BEGIN
        ProductionOrderHeader.RESET;
        ProductionOrderHeader.SETRANGE(
          Status,
          ProductionOrderHeader.Status::Released,
          ProductionOrderHeader.Status::Finished);
        ProductionOrderHeader.SETFILTER("No.",DocNoFilter);
        InsertIntoDocEntry(
          DATABASE::"Production Order",0,Text99000000,ProductionOrderHeader.COUNT);
      END;
      IF PostedAssemblyHeader.READPERMISSION THEN BEGIN
        PostedAssemblyHeader.RESET;
        PostedAssemblyHeader.SETFILTER("No.",DocNoFilter);
        InsertIntoDocEntry(
          DATABASE::"Posted Assembly Header",0,Text025,PostedAssemblyHeader.COUNT);
      END;
      IF TransShptHeader.READPERMISSION THEN BEGIN
        TransShptHeader.RESET;
        TransShptHeader.SETFILTER("No.",DocNoFilter);
        TransShptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Transfer Shipment Header",0,Text019,TransShptHeader.COUNT);
      END;
      IF TransRcptHeader.READPERMISSION THEN BEGIN
        TransRcptHeader.RESET;
        TransRcptHeader.SETFILTER("No.",DocNoFilter);
        TransRcptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Transfer Receipt Header",0,Text020,TransRcptHeader.COUNT);
      END;
      IF PostedWhseShptLine.READPERMISSION THEN BEGIN
        PostedWhseShptLine.RESET;
        PostedWhseShptLine.SETCURRENTKEY("Posted Source No.","Posting Date");
        PostedWhseShptLine.SETFILTER("Posted Source No.",DocNoFilter);
        PostedWhseShptLine.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Posted Whse. Shipment Line",0,
          PostedWhseShptLine.TABLECAPTION,PostedWhseShptLine.COUNT);
      END;
      IF PostedWhseRcptLine.READPERMISSION THEN BEGIN
        PostedWhseRcptLine.RESET;
        PostedWhseRcptLine.SETCURRENTKEY("Posted Source No.","Posting Date");
        PostedWhseRcptLine.SETFILTER("Posted Source No.",DocNoFilter);
        PostedWhseRcptLine.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Posted Whse. Receipt Line",0,
          PostedWhseRcptLine.TABLECAPTION,PostedWhseRcptLine.COUNT);
      END;
      IF GLEntry.READPERMISSION THEN BEGIN
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("Document No.","Posting Date");
        GLEntry.SETFILTER("Document No.",DocNoFilter);
        GLEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"G/L Entry",0,GLEntry.TABLECAPTION,GLEntry.COUNT);
      END;
      IF VATEntry.READPERMISSION THEN BEGIN
        VATEntry.RESET;
        VATEntry.SETCURRENTKEY("Document No.","Posting Date");
        VATEntry.SETFILTER("Document No.",DocNoFilter);
        VATEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"VAT Entry",0,VATEntry.TABLECAPTION,VATEntry.COUNT);
      END;
      IF CustLedgEntry.READPERMISSION THEN BEGIN
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETFILTER("Document No.",DocNoFilter);
        CustLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Cust. Ledger Entry",0,CustLedgEntry.TABLECAPTION,CustLedgEntry.COUNT);
      END;
      IF DtldCustLedgEntry.READPERMISSION THEN BEGIN
        DtldCustLedgEntry.RESET;
        DtldCustLedgEntry.SETCURRENTKEY("Document No.");
        DtldCustLedgEntry.SETFILTER("Document No.",DocNoFilter);
        DtldCustLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Detailed Cust. Ledg. Entry",0,DtldCustLedgEntry.TABLECAPTION,DtldCustLedgEntry.COUNT);
      END;
      IF ReminderEntry.READPERMISSION THEN BEGIN
        ReminderEntry.RESET;
        ReminderEntry.SETCURRENTKEY(Type,"No.");
        ReminderEntry.SETFILTER("No.",DocNoFilter);
        ReminderEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Reminder/Fin. Charge Entry",0,ReminderEntry.TABLECAPTION,ReminderEntry.COUNT);
      END;
      IF VendLedgEntry.READPERMISSION THEN BEGIN
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETFILTER("Document No.",DocNoFilter);
        VendLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Vendor Ledger Entry",0,VendLedgEntry.TABLECAPTION,VendLedgEntry.COUNT);
      END;
      IF DtldVendLedgEntry.READPERMISSION THEN BEGIN
        DtldVendLedgEntry.RESET;
        DtldVendLedgEntry.SETCURRENTKEY("Document No.");
        DtldVendLedgEntry.SETFILTER("Document No.",DocNoFilter);
        DtldVendLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Detailed Vendor Ledg. Entry",0,DtldVendLedgEntry.TABLECAPTION,DtldVendLedgEntry.COUNT);
      END;
      IF ItemLedgEntry.READPERMISSION THEN BEGIN
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETCURRENTKEY("Document No.");
        ItemLedgEntry.SETFILTER("Document No.",DocNoFilter);
        ItemLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Item Ledger Entry",0,ItemLedgEntry.TABLECAPTION,ItemLedgEntry.COUNT);
      END;
      IF ValueEntry.READPERMISSION THEN BEGIN
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETFILTER("Document No.",DocNoFilter);
        ValueEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Value Entry",0,ValueEntry.TABLECAPTION,ValueEntry.COUNT);
      END;
      IF PhysInvtLedgEntry.READPERMISSION THEN BEGIN
        PhysInvtLedgEntry.RESET;
        PhysInvtLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        PhysInvtLedgEntry.SETFILTER("Document No.",DocNoFilter);
        PhysInvtLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Phys. Inventory Ledger Entry",0,PhysInvtLedgEntry.TABLECAPTION,PhysInvtLedgEntry.COUNT);
      END;
      IF ResLedgEntry.READPERMISSION THEN BEGIN
        ResLedgEntry.RESET;
        ResLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        ResLedgEntry.SETFILTER("Document No.",DocNoFilter);
        ResLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Res. Ledger Entry",0,ResLedgEntry.TABLECAPTION,ResLedgEntry.COUNT);
      END;
      FindJobRecords;
      IF BankAccLedgEntry.READPERMISSION THEN BEGIN
        BankAccLedgEntry.RESET;
        BankAccLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        BankAccLedgEntry.SETFILTER("Document No.",DocNoFilter);
        BankAccLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Bank Account Ledger Entry",0,BankAccLedgEntry.TABLECAPTION,BankAccLedgEntry.COUNT);
      END;
      IF CheckLedgEntry.READPERMISSION THEN BEGIN
        CheckLedgEntry.RESET;
        CheckLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        CheckLedgEntry.SETFILTER("Document No.",DocNoFilter);
        CheckLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Check Ledger Entry",0,CheckLedgEntry.TABLECAPTION,CheckLedgEntry.COUNT);
      END;
      IF FALedgEntry.READPERMISSION THEN BEGIN
        FALedgEntry.RESET;
        FALedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        FALedgEntry.SETFILTER("Document No.",DocNoFilter);
        FALedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"FA Ledger Entry",0,FALedgEntry.TABLECAPTION,FALedgEntry.COUNT);
      END;
      IF MaintenanceLedgEntry.READPERMISSION THEN BEGIN
        MaintenanceLedgEntry.RESET;
        MaintenanceLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        MaintenanceLedgEntry.SETFILTER("Document No.",DocNoFilter);
        MaintenanceLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Maintenance Ledger Entry",0,MaintenanceLedgEntry.TABLECAPTION,MaintenanceLedgEntry.COUNT);
      END;
      IF InsuranceCovLedgEntry.READPERMISSION THEN BEGIN
        InsuranceCovLedgEntry.RESET;
        InsuranceCovLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        InsuranceCovLedgEntry.SETFILTER("Document No.",DocNoFilter);
        InsuranceCovLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Ins. Coverage Ledger Entry",0,InsuranceCovLedgEntry.TABLECAPTION,InsuranceCovLedgEntry.COUNT);
      END;
      IF CapacityLedgEntry.READPERMISSION THEN BEGIN
        CapacityLedgEntry.RESET;
        CapacityLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        CapacityLedgEntry.SETFILTER("Document No.",DocNoFilter);
        CapacityLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Capacity Ledger Entry",0,CapacityLedgEntry.TABLECAPTION,CapacityLedgEntry.COUNT);
      END;
      IF WhseEntry.READPERMISSION THEN BEGIN
        WhseEntry.RESET;
        WhseEntry.SETCURRENTKEY("Reference No.","Registering Date");
        WhseEntry.SETFILTER("Reference No.",DocNoFilter);
        WhseEntry.SETFILTER("Registering Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Warehouse Entry",0,WhseEntry.TABLECAPTION,WhseEntry.COUNT);
      END;

      IF ServLedgerEntry.READPERMISSION THEN BEGIN
        ServLedgerEntry.RESET;
        ServLedgerEntry.SETCURRENTKEY("Document No.","Posting Date");
        ServLedgerEntry.SETFILTER("Document No.",DocNoFilter);
        ServLedgerEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Service Ledger Entry",0,ServLedgerEntry.TABLECAPTION,ServLedgerEntry.COUNT);
      END;
      IF WarrantyLedgerEntry.READPERMISSION THEN BEGIN
        WarrantyLedgerEntry.RESET;
        WarrantyLedgerEntry.SETCURRENTKEY("Document No.","Posting Date");
        WarrantyLedgerEntry.SETFILTER("Document No.",DocNoFilter);
        WarrantyLedgerEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Warranty Ledger Entry",0,WarrantyLedgerEntry.TABLECAPTION,WarrantyLedgerEntry.COUNT);
      END;

      IF CostEntry.READPERMISSION THEN BEGIN
        CostEntry.RESET;
        CostEntry.SETCURRENTKEY("Document No.","Posting Date");
        CostEntry.SETFILTER("Document No.",DocNoFilter);
        CostEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Cost Entry",0,CostEntry.TABLECAPTION,CostEntry.COUNT);
      END;
      OnAfterNavigateFindRecords(Rec,DocNoFilter,PostingDateFilter);
      DocExists := FINDFIRST;

      SetSource(0D,'','',0,'');
      IF DocExists THEN BEGIN
        IF (NoOfRecords(DATABASE::"Cust. Ledger Entry") + NoOfRecords(DATABASE::"Vendor Ledger Entry") <= 1) AND
           (NoOfRecords(DATABASE::"Sales Invoice Header") + NoOfRecords(DATABASE::"Sales Cr.Memo Header") +
            NoOfRecords(DATABASE::"Sales Shipment Header") + NoOfRecords(DATABASE::"Issued Reminder Header") +
            NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") + NoOfRecords(DATABASE::"Purch. Inv. Header") +
            NoOfRecords(DATABASE::"Return Shipment Header") + NoOfRecords(DATABASE::"Return Receipt Header") +
            NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") + NoOfRecords(DATABASE::"Purch. Rcpt. Header") +
            NoOfRecords(DATABASE::"Service Invoice Header") + NoOfRecords(DATABASE::"Service Cr.Memo Header") +
            NoOfRecords(DATABASE::"Service Shipment Header") +
            NoOfRecords(DATABASE::"Transfer Shipment Header") + NoOfRecords(DATABASE::"Transfer Receipt Header") <= 1)
        THEN BEGIN
          // Service Management
          IF NoOfRecords(DATABASE::"Service Ledger Entry") = 1 THEN BEGIN
            ServLedgerEntry.FINDFIRST;
            IF ServLedgerEntry.Type = ServLedgerEntry.Type::"Service Contract" THEN
              SetSource(
                ServLedgerEntry."Posting Date",FORMAT(ServLedgerEntry."Document Type"),ServLedgerEntry."Document No.",
                2,ServLedgerEntry."Service Contract No.")
            ELSE
              SetSource(
                ServLedgerEntry."Posting Date",FORMAT(ServLedgerEntry."Document Type"),ServLedgerEntry."Document No.",
                2,ServLedgerEntry."Service Order No.")
          END;
          IF NoOfRecords(DATABASE::"Warranty Ledger Entry") = 1 THEN BEGIN
            WarrantyLedgerEntry.FINDFIRST;
            SetSource(
              WarrantyLedgerEntry."Posting Date",'',WarrantyLedgerEntry."Document No.",
              2,WarrantyLedgerEntry."Service Order No.")
          END;

          // Sales
          IF NoOfRecords(DATABASE::"Cust. Ledger Entry") = 1 THEN BEGIN
            CustLedgEntry.FINDFIRST;
            SetSource(
              CustLedgEntry."Posting Date",FORMAT(CustLedgEntry."Document Type"),CustLedgEntry."Document No.",
              1,CustLedgEntry."Customer No.");
          END;
          IF NoOfRecords(DATABASE::"Detailed Cust. Ledg. Entry") = 1 THEN BEGIN
            DtldCustLedgEntry.FINDFIRST;
            SetSource(
              DtldCustLedgEntry."Posting Date",FORMAT(DtldCustLedgEntry."Document Type"),DtldCustLedgEntry."Document No.",
              1,DtldCustLedgEntry."Customer No.");
          END;
          IF NoOfRecords(DATABASE::"Sales Invoice Header") = 1 THEN BEGIN
            SalesInvHeader.FINDFIRST;
            SetSource(
              SalesInvHeader."Posting Date",FORMAT("Table Name"),SalesInvHeader."No.",
              1,SalesInvHeader."Bill-to Customer No.");
          END;
          IF NoOfRecords(DATABASE::"Sales Cr.Memo Header") = 1 THEN BEGIN
            SalesCrMemoHeader.FINDFIRST;
            SetSource(
              SalesCrMemoHeader."Posting Date",FORMAT("Table Name"),SalesCrMemoHeader."No.",
              1,SalesCrMemoHeader."Bill-to Customer No.");
          END;
          IF NoOfRecords(DATABASE::"Return Receipt Header") = 1 THEN BEGIN
            ReturnRcptHeader.FINDFIRST;
            SetSource(
              ReturnRcptHeader."Posting Date",FORMAT("Table Name"),ReturnRcptHeader."No.",
              1,ReturnRcptHeader."Sell-to Customer No.");
          END;
          IF NoOfRecords(DATABASE::"Sales Shipment Header") = 1 THEN BEGIN
            SalesShptHeader.FINDFIRST;
            SetSource(
              SalesShptHeader."Posting Date",FORMAT("Table Name"),SalesShptHeader."No.",
              1,SalesShptHeader."Sell-to Customer No.");
          END;
          IF NoOfRecords(DATABASE::"Posted Whse. Shipment Line") = 1 THEN BEGIN
            PostedWhseShptLine.FINDFIRST;
            SetSource(
              PostedWhseShptLine."Posting Date",FORMAT("Table Name"),PostedWhseShptLine."No.",
              1,PostedWhseShptLine."Destination No.");
          END;
          IF NoOfRecords(DATABASE::"Issued Reminder Header") = 1 THEN BEGIN
            IssuedReminderHeader.FINDFIRST;
            SetSource(
              IssuedReminderHeader."Posting Date",FORMAT("Table Name"),IssuedReminderHeader."No.",
              1,IssuedReminderHeader."Customer No.");
          END;
          IF NoOfRecords(DATABASE::"Issued Fin. Charge Memo Header") = 1 THEN BEGIN
            IssuedFinChrgMemoHeader.FINDFIRST;
            SetSource(
              IssuedFinChrgMemoHeader."Posting Date",FORMAT("Table Name"),IssuedFinChrgMemoHeader."No.",
              1,IssuedFinChrgMemoHeader."Customer No.");
          END;

          IF NoOfRecords(DATABASE::"Service Invoice Header") = 1 THEN BEGIN
            ServInvHeader.FINDFIRST;
            SetSource(
              ServInvHeader."Posting Date",FORMAT("Table Name"),ServInvHeader."No.",
              1,ServInvHeader."Bill-to Customer No.");
          END;
          IF NoOfRecords(DATABASE::"Service Cr.Memo Header") = 1 THEN BEGIN
            ServCrMemoHeader.FINDFIRST;
            SetSource(
              ServCrMemoHeader."Posting Date",FORMAT("Table Name"),ServCrMemoHeader."No.",
              1,ServCrMemoHeader."Bill-to Customer No.");
          END;
          IF NoOfRecords(DATABASE::"Service Shipment Header") = 1 THEN BEGIN
            ServShptHeader.FINDFIRST;
            SetSource(
              ServShptHeader."Posting Date",FORMAT("Table Name"),ServShptHeader."No.",
              1,ServShptHeader."Customer No.");
          END;

          // Purchase
          IF NoOfRecords(DATABASE::"Vendor Ledger Entry") = 1 THEN BEGIN
            VendLedgEntry.FINDFIRST;
            SetSource(
              VendLedgEntry."Posting Date",FORMAT(VendLedgEntry."Document Type"),VendLedgEntry."Document No.",
              2,VendLedgEntry."Vendor No.");
          END;
          IF NoOfRecords(DATABASE::"Detailed Vendor Ledg. Entry") = 1 THEN BEGIN
            DtldVendLedgEntry.FINDFIRST;
            SetSource(
              DtldVendLedgEntry."Posting Date",FORMAT(DtldVendLedgEntry."Document Type"),DtldVendLedgEntry."Document No.",
              2,DtldVendLedgEntry."Vendor No.");
          END;
          IF NoOfRecords(DATABASE::"Purch. Inv. Header") = 1 THEN BEGIN
            PurchInvHeader.FINDFIRST;
            SetSource(
              PurchInvHeader."Posting Date",FORMAT("Table Name"),PurchInvHeader."No.",
              2,PurchInvHeader."Pay-to Vendor No.");
          END;
          IF NoOfRecords(DATABASE::"Purch. Cr. Memo Hdr.") = 1 THEN BEGIN
            PurchCrMemoHeader.FINDFIRST;
            SetSource(
              PurchCrMemoHeader."Posting Date",FORMAT("Table Name"),PurchCrMemoHeader."No.",
              2,PurchCrMemoHeader."Pay-to Vendor No.");
          END;
          IF NoOfRecords(DATABASE::"Return Shipment Header") = 1 THEN BEGIN
            ReturnShptHeader.FINDFIRST;
            SetSource(
              ReturnShptHeader."Posting Date",FORMAT("Table Name"),ReturnShptHeader."No.",
              2,ReturnShptHeader."Buy-from Vendor No.");
          END;
          IF NoOfRecords(DATABASE::"Purch. Rcpt. Header") = 1 THEN BEGIN
            PurchRcptHeader.FINDFIRST;
            SetSource(
              PurchRcptHeader."Posting Date",FORMAT("Table Name"),PurchRcptHeader."No.",
              2,PurchRcptHeader."Buy-from Vendor No.");
          END;
          IF NoOfRecords(DATABASE::"Posted Whse. Receipt Line") = 1 THEN BEGIN
            PostedWhseRcptLine.FINDFIRST;
            SetSource(
              PostedWhseRcptLine."Posting Date",FORMAT("Table Name"),PostedWhseRcptLine."No.",
              2,'');
          END;
        END ELSE BEGIN
          IF DocNoFilter <> '' THEN
            IF PostingDateFilter = '' THEN
              MESSAGE(Text011)
            ELSE
              MESSAGE(Text012);
        END;
      END ELSE
        IF PostingDateFilter = '' THEN
          MESSAGE(Text013)
        ELSE
          MESSAGE(Text014);

      IF UpdateForm THEN
        UpdateFormAfterFindRecords;
      Window.CLOSE;
    END;

    LOCAL PROCEDURE FindJobRecords@26();
    BEGIN
      IF JobLedgEntry.READPERMISSION THEN BEGIN
        JobLedgEntry.RESET;
        JobLedgEntry.SETCURRENTKEY("Document No.","Posting Date");
        JobLedgEntry.SETFILTER("Document No.",DocNoFilter);
        JobLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Job Ledger Entry",0,JobLedgEntry.TABLECAPTION,JobLedgEntry.COUNT);
      END;
      IF JobWIPEntry.READPERMISSION THEN BEGIN
        JobWIPEntry.RESET;
        JobWIPEntry.SETFILTER("Document No.",DocNoFilter);
        JobWIPEntry.SETFILTER("WIP Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Job WIP Entry",0,JobWIPEntry.TABLECAPTION,JobWIPEntry.COUNT);
      END;
      IF JobWIPGLEntry.READPERMISSION THEN BEGIN
        JobWIPGLEntry.RESET;
        JobWIPGLEntry.SETCURRENTKEY("Document No.","Posting Date");
        JobWIPGLEntry.SETFILTER("Document No.",DocNoFilter);
        JobWIPGLEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Job WIP G/L Entry",0,JobWIPGLEntry.TABLECAPTION,JobWIPGLEntry.COUNT);
      END;
    END;

    LOCAL PROCEDURE FindIncomingDocumentRecords@27();
    BEGIN
      IF IncomingDocument.READPERMISSION THEN BEGIN
        IncomingDocument.RESET;
        IncomingDocument.SETFILTER("Document No.",DocNoFilter);
        IncomingDocument.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Incoming Document",0,IncomingDocument.TABLECAPTION,IncomingDocument.COUNT);
      END;
    END;

    LOCAL PROCEDURE FindSalesShipmentHeader@36();
    BEGIN
      IF SalesShptHeader.READPERMISSION THEN BEGIN
        SalesShptHeader.RESET;
        SalesShptHeader.SETFILTER("No.",DocNoFilter);
        SalesShptHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Sales Shipment Header",0,Text005,SalesShptHeader.COUNT);
      END;
    END;

    LOCAL PROCEDURE FindEmployeeRecords@29();
    BEGIN
      IF EmplLedgEntry.READPERMISSION THEN BEGIN
        EmplLedgEntry.RESET;
        EmplLedgEntry.SETCURRENTKEY("Document No.");
        EmplLedgEntry.SETFILTER("Document No.",DocNoFilter);
        EmplLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Employee Ledger Entry",0,EmplLedgEntry.TABLECAPTION,EmplLedgEntry.COUNT);
      END;
      IF DtldEmplLedgEntry.READPERMISSION THEN BEGIN
        DtldEmplLedgEntry.RESET;
        DtldEmplLedgEntry.SETCURRENTKEY("Document No.");
        DtldEmplLedgEntry.SETFILTER("Document No.",DocNoFilter);
        DtldEmplLedgEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Detailed Employee Ledger Entry",0,DtldEmplLedgEntry.TABLECAPTION,DtldEmplLedgEntry.COUNT);
      END;
    END;

    LOCAL PROCEDURE UpdateFormAfterFindRecords@15();
    BEGIN
      ShowEnable := DocExists;
      PrintEnable := DocExists;
      CurrPage.UPDATE(FALSE);
      DocExists := FINDFIRST;
      IF DocExists THEN;
    END;

    LOCAL PROCEDURE InsertIntoDocEntry@3(DocTableID@1000 : Integer;DocType@1003 : Option;DocTableName@1001 : Text[1024];DocNoOfRecords@1002 : Integer);
    BEGIN
      IF DocNoOfRecords = 0 THEN
        EXIT;
      INIT;
      "Entry No." := "Entry No." + 1;
      "Table ID" := DocTableID;
      "Document Type" := DocType;
      "Table Name" := COPYSTR(DocTableName,1,MAXSTRLEN("Table Name"));
      "No. of Records" := DocNoOfRecords;
      INSERT;
    END;

    LOCAL PROCEDURE NoOfRecords@4(TableID@1000 : Integer) : Integer;
    BEGIN
      SETRANGE("Table ID",TableID);
      IF NOT FINDFIRST THEN
        INIT;
      SETRANGE("Table ID");
      EXIT("No. of Records");
    END;

    LOCAL PROCEDURE SetSource@5(PostingDate@1000 : Date;DocType2@1001 : Text[50];DocNo@1002 : Text[50];SourceType2@1003 : Integer;SourceNo2@1004 : Code[20]);
    BEGIN
      IF SourceType2 = 0 THEN BEGIN
        DocType := '';
        SourceType := '';
        SourceNo := '';
        SourceName := '';
      END ELSE BEGIN
        DocType := DocType2;
        SourceNo := SourceNo2;
        SETRANGE("Document No.",DocNo);
        SETRANGE("Posting Date",PostingDate);
        DocNoFilter := GETFILTER("Document No.");
        PostingDateFilter := GETFILTER("Posting Date");
        CASE SourceType2 OF
          1:
            BEGIN
              SourceType := Cust.TABLECAPTION;
              IF NOT Cust.GET(SourceNo) THEN
                Cust.INIT;
              SourceName := Cust.Name;
            END;
          2:
            BEGIN
              SourceType := Vend.TABLECAPTION;
              IF NOT Vend.GET(SourceNo) THEN
                Vend.INIT;
              SourceName := Vend.Name;
            END;
        END;
      END;
      DocTypeEnable := SourceType2 <> 0;
      SourceTypeEnable := SourceType2 <> 0;
      SourceNoEnable := SourceType2 <> 0;
      SourceNameEnable := SourceType2 <> 0;
    END;

    LOCAL PROCEDURE ShowRecords@6();
    BEGIN
      IF ItemTrackingSearch THEN
        ItemTrackingNavigateMgt.Show("Table ID")
      ELSE
        CASE "Table ID" OF
          DATABASE::"Incoming Document":
            PAGE.RUN(PAGE::"Incoming Document",IncomingDocument);
          DATABASE::"Sales Header":
            ShowSalesHeaderRecords;
          DATABASE::"Sales Invoice Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvHeader)
            ELSE
              PAGE.RUN(PAGE::"Posted Sales Invoices",SalesInvHeader);
          DATABASE::"Sales Cr.Memo Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader)
            ELSE
              PAGE.RUN(PAGE::"Posted Sales Credit Memos",SalesCrMemoHeader);
          DATABASE::"Return Receipt Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Return Receipt",ReturnRcptHeader)
            ELSE
              PAGE.RUN(0,ReturnRcptHeader);
          DATABASE::"Sales Shipment Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Sales Shipment",SalesShptHeader)
            ELSE
              PAGE.RUN(0,SalesShptHeader);
          DATABASE::"Issued Reminder Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Issued Reminder",IssuedReminderHeader)
            ELSE
              PAGE.RUN(0,IssuedReminderHeader);
          DATABASE::"Issued Fin. Charge Memo Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Issued Finance Charge Memo",IssuedFinChrgMemoHeader)
            ELSE
              PAGE.RUN(0,IssuedFinChrgMemoHeader);
          DATABASE::"Purch. Inv. Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader)
            ELSE
              PAGE.RUN(PAGE::"Posted Purchase Invoices",PurchInvHeader);
          DATABASE::"Purch. Cr. Memo Hdr.":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHeader)
            ELSE
              PAGE.RUN(PAGE::"Posted Purchase Credit Memos",PurchCrMemoHeader);
          DATABASE::"Return Shipment Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Return Shipment",ReturnShptHeader)
            ELSE
              PAGE.RUN(0,ReturnShptHeader);
          DATABASE::"Purch. Rcpt. Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader)
            ELSE
              PAGE.RUN(0,PurchRcptHeader);
          DATABASE::"Production Order":
            PAGE.RUN(0,ProductionOrderHeader);
          DATABASE::"Posted Assembly Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Assembly Order",PostedAssemblyHeader)
            ELSE
              PAGE.RUN(0,PostedAssemblyHeader);
          DATABASE::"Transfer Shipment Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Transfer Shipment",TransShptHeader)
            ELSE
              PAGE.RUN(0,TransShptHeader);
          DATABASE::"Transfer Receipt Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Transfer Receipt",TransRcptHeader)
            ELSE
              PAGE.RUN(0,TransRcptHeader);
          DATABASE::"Posted Whse. Shipment Line":
            PAGE.RUN(0,PostedWhseShptLine);
          DATABASE::"Posted Whse. Receipt Line":
            PAGE.RUN(0,PostedWhseRcptLine);
          DATABASE::"G/L Entry":
            PAGE.RUN(0,GLEntry);
          DATABASE::"VAT Entry":
            PAGE.RUN(0,VATEntry);
          DATABASE::"Detailed Cust. Ledg. Entry":
            PAGE.RUN(0,DtldCustLedgEntry);
          DATABASE::"Cust. Ledger Entry":
            PAGE.RUN(0,CustLedgEntry);
          DATABASE::"Reminder/Fin. Charge Entry":
            PAGE.RUN(0,ReminderEntry);
          DATABASE::"Vendor Ledger Entry":
            PAGE.RUN(0,VendLedgEntry);
          DATABASE::"Detailed Vendor Ledg. Entry":
            PAGE.RUN(0,DtldVendLedgEntry);
          DATABASE::"Employee Ledger Entry":
            ShowEmployeeLedgerEntries;
          DATABASE::"Detailed Employee Ledger Entry":
            ShowDetailedEmployeeLedgerEntries;
          DATABASE::"Item Ledger Entry":
            PAGE.RUN(0,ItemLedgEntry);
          DATABASE::"Value Entry":
            PAGE.RUN(0,ValueEntry);
          DATABASE::"Phys. Inventory Ledger Entry":
            PAGE.RUN(0,PhysInvtLedgEntry);
          DATABASE::"Res. Ledger Entry":
            PAGE.RUN(0,ResLedgEntry);
          DATABASE::"Job Ledger Entry":
            PAGE.RUN(0,JobLedgEntry);
          DATABASE::"Job WIP Entry":
            PAGE.RUN(0,JobWIPEntry);
          DATABASE::"Job WIP G/L Entry":
            PAGE.RUN(0,JobWIPGLEntry);
          DATABASE::"Bank Account Ledger Entry":
            PAGE.RUN(0,BankAccLedgEntry);
          DATABASE::"Check Ledger Entry":
            PAGE.RUN(0,CheckLedgEntry);
          DATABASE::"FA Ledger Entry":
            PAGE.RUN(0,FALedgEntry);
          DATABASE::"Maintenance Ledger Entry":
            PAGE.RUN(0,MaintenanceLedgEntry);
          DATABASE::"Ins. Coverage Ledger Entry":
            PAGE.RUN(0,InsuranceCovLedgEntry);
          DATABASE::"Capacity Ledger Entry":
            PAGE.RUN(0,CapacityLedgEntry);
          DATABASE::"Warehouse Entry":
            PAGE.RUN(0,WhseEntry);
          DATABASE::"Service Header":
            ShowServiceHeaderRecords;
          DATABASE::"Service Invoice Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Service Invoice",ServInvHeader)
            ELSE
              PAGE.RUN(0,ServInvHeader);
          DATABASE::"Service Cr.Memo Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Service Credit Memo",ServCrMemoHeader)
            ELSE
              PAGE.RUN(0,ServCrMemoHeader);
          DATABASE::"Service Shipment Header":
            IF "No. of Records" = 1 THEN
              PAGE.RUN(PAGE::"Posted Service Shipment",ServShptHeader)
            ELSE
              PAGE.RUN(0,ServShptHeader);
          DATABASE::"Service Ledger Entry":
            PAGE.RUN(0,ServLedgerEntry);
          DATABASE::"Warranty Ledger Entry":
            PAGE.RUN(0,WarrantyLedgerEntry);
          DATABASE::"Cost Entry":
            PAGE.RUN(0,CostEntry);
        END;

      OnAfterNavigateShowRecords("Table ID",DocNoFilter,PostingDateFilter,ItemTrackingSearch);
    END;

    LOCAL PROCEDURE ShowSalesHeaderRecords@28();
    BEGIN
      TESTFIELD("Table ID",DATABASE::"Sales Header");

      CASE "Document Type" OF
        "Document Type"::Order:
          IF "No. of Records" = 1 THEN
            PAGE.RUN(PAGE::"Sales Order",SOSalesHeader)
          ELSE
            PAGE.RUN(0,SOSalesHeader);
        "Document Type"::Invoice:
          IF "No. of Records" = 1 THEN
            PAGE.RUN(PAGE::"Sales Invoice",SISalesHeader)
          ELSE
            PAGE.RUN(0,SISalesHeader);
        "Document Type"::"Return Order":
          IF "No. of Records" = 1 THEN
            PAGE.RUN(PAGE::"Sales Return Order",SROSalesHeader)
          ELSE
            PAGE.RUN(0,SROSalesHeader);
        "Document Type"::"Credit Memo":
          IF "No. of Records" = 1 THEN
            PAGE.RUN(PAGE::"Sales Credit Memo",SCMSalesHeader)
          ELSE
            PAGE.RUN(0,SCMSalesHeader);
      END;
    END;

    LOCAL PROCEDURE ShowServiceHeaderRecords@24();
    BEGIN
      TESTFIELD("Table ID",DATABASE::"Service Header");

      CASE "Document Type" OF
        "Document Type"::Order:
          IF "No. of Records" = 1 THEN
            PAGE.RUN(PAGE::"Service Order",SOServHeader)
          ELSE
            PAGE.RUN(0,SOServHeader);
        "Document Type"::Invoice:
          IF "No. of Records" = 1 THEN
            PAGE.RUN(PAGE::"Service Invoice",SIServHeader)
          ELSE
            PAGE.RUN(0,SIServHeader);
        "Document Type"::"Credit Memo":
          IF "No. of Records" = 1 THEN
            PAGE.RUN(PAGE::"Service Credit Memo",SCMServHeader)
          ELSE
            PAGE.RUN(0,SCMServHeader);
      END;
    END;

    LOCAL PROCEDURE ShowEmployeeLedgerEntries@39();
    BEGIN
      PAGE.RUN(PAGE::"Employee Ledger Entries",EmplLedgEntry);
    END;

    LOCAL PROCEDURE ShowDetailedEmployeeLedgerEntries@40();
    BEGIN
      PAGE.RUN(PAGE::"Detailed Empl. Ledger Entries",DtldEmplLedgEntry);
    END;

    LOCAL PROCEDURE SetPostingDate@9(PostingDate@1000 : Text);
    BEGIN
      IF ApplicationManagement.MakeDateFilter(PostingDate) = 0 THEN;
      SETFILTER("Posting Date",PostingDate);
      PostingDateFilter := GETFILTER("Posting Date");
    END;

    LOCAL PROCEDURE SetDocNo@10(DocNo@1000 : Text);
    BEGIN
      SETFILTER("Document No.",DocNo);
      DocNoFilter := GETFILTER("Document No.");
      PostingDateFilter := GETFILTER("Posting Date");
    END;

    LOCAL PROCEDURE ClearSourceInfo@7();
    BEGIN
      IF DocExists THEN BEGIN
        DocExists := FALSE;
        DELETEALL;
        ShowEnable := FALSE;
        SetSource(0D,'','',0,'');
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE MakeExtFilter@11(VAR DateFilter@1000 : Text;AddDate@1001 : Date;VAR DocNoFilter@1002 : Text;AddDocNo@1003 : Code[20]);
    BEGIN
      IF DateFilter = '' THEN
        DateFilter := FORMAT(AddDate)
      ELSE
        IF STRPOS(DateFilter,FORMAT(AddDate)) = 0 THEN
          IF MAXSTRLEN(DateFilter) >= STRLEN(DateFilter + '|' + FORMAT(AddDate)) THEN
            DateFilter := DateFilter + '|' + FORMAT(AddDate)
          ELSE
            TooLongFilter;

      IF DocNoFilter = '' THEN
        DocNoFilter := AddDocNo
      ELSE
        IF STRPOS(DocNoFilter,AddDocNo) = 0 THEN
          IF MAXSTRLEN(DocNoFilter) >= STRLEN(DocNoFilter + '|' + AddDocNo) THEN
            DocNoFilter := DocNoFilter + '|' + AddDocNo
          ELSE
            TooLongFilter;
    END;

    LOCAL PROCEDURE FindPush@13();
    BEGIN
      IF (DocNoFilter = '') AND (PostingDateFilter = '') AND
         (NOT ItemTrackingSearch) AND
         ((ContactType <> 0) OR (ContactNo <> '') OR (ExtDocNo <> ''))
      THEN
        FindExtRecords
      ELSE
        IF ItemTrackingSearch AND
           (DocNoFilter = '') AND (PostingDateFilter = '') AND
           (ContactType = 0) AND (ContactNo = '') AND (ExtDocNo = '')
        THEN
          FindTrackingRecords
        ELSE
          FindRecords;
    END;

    LOCAL PROCEDURE TooLongFilter@12();
    BEGIN
      IF ContactNo = '' THEN
        ERROR(Text015);

      ERROR(Text016);
    END;

    LOCAL PROCEDURE FindUnpostedSalesDocs@14(DocType@1001 : Option;DocTableName@1003 : Text[100];VAR SalesHeader@1000 : Record 36);
    BEGIN
      SalesHeader."SECURITYFILTERING"(SECURITYFILTER::Filtered);
      IF SalesHeader.READPERMISSION THEN BEGIN
        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
        SalesHeader.SETFILTER("Sell-to Customer No.",ContactNo);
        SalesHeader.SETFILTER("External Document No.",ExtDocNo);
        SalesHeader.SETRANGE("Document Type",DocType);
        InsertIntoDocEntry(DATABASE::"Sales Header",DocType,DocTableName,SalesHeader.COUNT);
      END;
    END;

    LOCAL PROCEDURE FindUnpostedServDocs@16(DocType@1001 : Option;DocTableName@1003 : Text[100];VAR ServHeader@1000 : Record 5900);
    BEGIN
      ServHeader."SECURITYFILTERING"(SECURITYFILTER::Filtered);
      IF ServHeader.READPERMISSION THEN
        IF ExtDocNo = '' THEN BEGIN
          ServHeader.RESET;
          ServHeader.SETCURRENTKEY("Customer No.");
          ServHeader.SETFILTER("Customer No.",ContactNo);
          ServHeader.SETRANGE("Document Type",DocType);
          InsertIntoDocEntry(DATABASE::"Service Header",DocType,DocTableName,ServHeader.COUNT);
        END;
    END;

    LOCAL PROCEDURE FindTrackingRecords@22();
    VAR
      DocNoOfRecords@1000 : Integer;
    BEGIN
      Window.OPEN(Text002);
      DELETEALL;
      "Entry No." := 0;

      CLEAR(ItemTrackingNavigateMgt);
      ItemTrackingNavigateMgt.FindTrackingRecords(SerialNoFilter,LotNoFilter,'','');

      ItemTrackingNavigateMgt.Collect(TempRecordBuffer);
      TempRecordBuffer.SETCURRENTKEY("Table No.","Record Identifier");
      IF TempRecordBuffer.FIND('-') THEN
        REPEAT
          TempRecordBuffer.SETRANGE("Table No.",TempRecordBuffer."Table No.");

          DocNoOfRecords := 0;
          IF TempRecordBuffer.FIND('-') THEN
            REPEAT
              TempRecordBuffer.SETRANGE("Record Identifier",TempRecordBuffer."Record Identifier");
              TempRecordBuffer.FIND('+');
              TempRecordBuffer.SETRANGE("Record Identifier");
              DocNoOfRecords += 1;
            UNTIL TempRecordBuffer.NEXT = 0;

          InsertIntoDocEntry(
            TempRecordBuffer."Table No.",0,TempRecordBuffer."Table Name",DocNoOfRecords);

          TempRecordBuffer.SETRANGE("Table No.");
        UNTIL TempRecordBuffer.NEXT = 0;

      OnAfterNavigateFindTrackingRecords(Rec,SerialNoFilter,LotNoFilter);

      DocExists := FIND('-');

      UpdateFormAfterFindRecords;
      Window.CLOSE;
    END;

    [External]
    PROCEDURE SetTracking@20(SerialNo@1000 : Code[20];LotNo@1001 : Code[20]);
    BEGIN
      NewSerialNo := SerialNo;
      NewLotNo := LotNo;
    END;

    LOCAL PROCEDURE ItemTrackingSearch@19() : Boolean;
    BEGIN
      EXIT((SerialNoFilter <> '') OR (LotNoFilter <> ''));
    END;

    LOCAL PROCEDURE ClearTrackingInfo@17();
    BEGIN
      SerialNoFilter := '';
      LotNoFilter := '';
    END;

    LOCAL PROCEDURE ClearInfo@18();
    BEGIN
      SetDocNo('');
      SetPostingDate('');
      ContactType := ContactType::" ";
      ContactNo := '';
      ExtDocNo := '';
    END;

    LOCAL PROCEDURE DocNoFilterOnAfterValidate@19079756();
    BEGIN
      ClearSourceInfo;
    END;

    LOCAL PROCEDURE PostingDateFilterOnAfterValida@19064000();
    BEGIN
      ClearSourceInfo;
    END;

    LOCAL PROCEDURE ExtDocNoOnAfterValidate@19035593();
    BEGIN
      ClearSourceInfo;
    END;

    LOCAL PROCEDURE ContactTypeOnAfterValidate@19057702();
    BEGIN
      ClearSourceInfo;
    END;

    LOCAL PROCEDURE ContactNoOnAfterValidate@19009577();
    BEGIN
      ClearSourceInfo;
    END;

    LOCAL PROCEDURE SerialNoFilterOnAfterValidate@19049364();
    BEGIN
      ClearSourceInfo;
    END;

    LOCAL PROCEDURE LotNoFilterOnAfterValidate@19054399();
    BEGIN
      ClearSourceInfo;
    END;

    [Internal]
    PROCEDURE FindRecordsOnOpen@21();
    BEGIN
      IF (NewDocNo = '') AND (NewPostingDate = 0D) AND (NewSerialNo = '') AND (NewLotNo = '') THEN BEGIN
        DELETEALL;
        ShowEnable := FALSE;
        PrintEnable := FALSE;
        SetSource(0D,'','',0,'');
      END ELSE
        IF (NewSerialNo <> '') OR (NewLotNo <> '') THEN BEGIN
          SetSource(0D,'','',0,'');
          SETRANGE("Serial No. Filter",NewSerialNo);
          SETRANGE("Lot No. Filter",NewLotNo);
          SerialNoFilter := GETFILTER("Serial No. Filter");
          LotNoFilter := GETFILTER("Lot No. Filter");
          ClearInfo;
          FindTrackingRecords;
        END ELSE BEGIN
          SETRANGE("Document No.",NewDocNo);
          SETRANGE("Posting Date",NewPostingDate);
          DocNoFilter := GETFILTER("Document No.");
          PostingDateFilter := GETFILTER("Posting Date");
          ContactType := ContactType::" ";
          ContactNo := '';
          ExtDocNo := '';
          ClearTrackingInfo;
          FindRecords;
        END;
    END;

    [External]
    PROCEDURE UpdateNavigateForm@23(UpdateFormFrom@1000 : Boolean);
    BEGIN
      UpdateForm := UpdateFormFrom;
    END;

    [External]
    PROCEDURE ReturnDocumentEntry@25(VAR TempDocumentEntry@1000 : TEMPORARY Record 265);
    BEGIN
      SETRANGE("Table ID");  // Clear filter.
      FINDSET;
      REPEAT
        TempDocumentEntry.INIT;
        TempDocumentEntry := Rec;
        TempDocumentEntry.INSERT;
      UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateFindByGroupsVisibility@34();
    BEGIN
      DocumentVisible := FALSE;
      BusinessContactVisible := FALSE;
      ItemReferenceVisible := FALSE;

      CASE FindBasedOn OF
        FindBasedOn::Document:
          DocumentVisible := TRUE;
        FindBasedOn::"Business Contact":
          BusinessContactVisible := TRUE;
        FindBasedOn::"Item Reference":
          ItemReferenceVisible := TRUE;
      END;

      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE FilterSelectionChanged@37();
    BEGIN
      FilterSelectionChangedTxtVisible := TRUE;
    END;

    LOCAL PROCEDURE GetCaptionText@48() : Text;
    BEGIN
      IF "Table Name" <> '' THEN
        EXIT(STRSUBSTNO(PageCaptionTxt,"Table Name"));

      EXIT('');
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterNavigateFindRecords@31(VAR DocumentEntry@1000 : Record 265;DocNoFilter@1001 : Text;PostingDateFilter@1002 : Text);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterNavigateFindTrackingRecords@33(VAR DocumentEntry@1000 : Record 265;SerialNoFilter@1001 : Text;LotNoFilter@1002 : Text);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterNavigateShowRecords@32(TableID@1001 : Integer;DocNoFilter@1002 : Text;PostingDateFilter@1003 : Text;ItemTrackingSearch@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}


OBJECT Page 188 Posted Docs. With No Inc. Doc.
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf›rte dokumenter uden indg†ende bilag;
               ENU=Posted Documents without Incoming Document];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table134;
    DataCaptionFields=Document No.,Posting Date,First Posting Description;
    PageType=List;
    SourceTableTemporary=Yes;
    PromotedActionCategoriesML=[DAN=Nye,Indg†ende bilag,Rapport;
                                ENU=New,Incoming Document,Report];
    ShowFilter=No;
    OnOpenPage=VAR
                 AccountingPeriod@1000 : Record 50;
                 FiscalStartDate@1002 : Date;
                 FilterGroupNo@1001 : Integer;
               BEGIN
                 IF DateFilter = '' THEN BEGIN
                   FiscalStartDate := AccountingPeriod.GetFiscalYearStartDate(WORKDATE);
                   IF FiscalStartDate <> 0D THEN
                     SETRANGE("Posting Date",FiscalStartDate,WORKDATE)
                   ELSE
                     SETRANGE("Posting Date",CALCDATE('<CY>',WORKDATE),WORKDATE);
                   DateFilter := COPYSTR(GETFILTER("Posting Date"),1,MAXSTRLEN(DateFilter));
                   SETRANGE("Posting Date");
                 END;
                 FilterGroupNo := 0;
                 WHILE (FilterGroupNo <= 4) AND (GLAccFilter = '') DO BEGIN
                   GLAccFilter := COPYSTR(GETFILTER("G/L Account No. Filter"),1,MAXSTRLEN(GLAccFilter));
                   FilterGroupNo += 2;
                 END;
                 SearchForDocNos;
               END;

    OnAfterGetRecord=BEGIN
                       HasIncomingDocument := IncomingDocumentExists;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 19      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;ActionGroup;
                      Name=IncomingDocument;
                      CaptionML=[DAN=Indg†ende bilag;
                                 ENU=Incoming Document];
                      ActionContainerType=NewDocumentItems;
                      Image=Documents }
      { 16      ;2   ;Action    ;
                      Name=IncomingDocCard;
                      CaptionML=[DAN=Vis indg†ende bilag;
                                 ENU=View Incoming Document];
                      ToolTipML=[DAN=Se alle indg†ende bilagsrecords og vedh‘ftede filer, der findes for posten eller bilaget.;
                                 ENU=View any incoming document records and file attachments that exist for the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=HasIncomingDocument;
                      Image=ViewOrder;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCard("Document No.","Posting Date");
                               END;
                                }
      { 15      ;2   ;Action    ;
                      Name=SelectIncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=V‘lg indg†ende bilag;
                                 ENU=Select Incoming Document];
                      ToolTipML=[DAN=V‘lg en indg†ende bilagsrecord og vedh‘ftet fil, der skal knyttes til posten eller bilaget.;
                                 ENU=Select an incoming document record and file attachment that you want to link to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=SelectLineToApply;
                      OnAction=BEGIN
                                 UpdateIncomingDocuments;
                               END;
                                }
      { 8       ;2   ;Action    ;
                      Name=IncomingDocAttachFile;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret indg†ende bilag ud fra fil;
                                 ENU=Create Incoming Document from File];
                      ToolTipML=[DAN=Opret en indg†ende bilagsrecord ved at v‘lge en fil, der skal vedh‘ftes, og knyt derefter den indg†ende bilagsrecord til posten eller bilaget.;
                                 ENU=Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT HasIncomingDocument;
                      Image=Attach;
                      OnAction=VAR
                                 IncomingDocumentAttachment@1000 : Record 133;
                               BEGIN
                                 IncomingDocumentAttachment.SETRANGE("Document No.","Document No.");
                                 IncomingDocumentAttachment.SETRANGE("Posting Date","Posting Date");
                                 IncomingDocumentAttachment.NewAttachment;
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=Naviger;
                                 ENU=Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Navigate@1000 : Page 344;
                               BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 9   ;1   ;Group     ;
                CaptionML=[DAN=Filtre;
                           ENU=Filters];
                GroupType=Group }

    { 11  ;2   ;Field     ;
                Name=DateFilter;
                CaptionML=[DAN=Datofilter;
                           ENU=Date Filter];
                ToolTipML=[DAN=Angiver et filter til bogf›ringsdatoen for bogf›rte k›bs- og salgsbilag uden indg†ende bilagsrecords, der vises. Som standard er filteret den f›rste dag i den igangv‘rende regnskabsperiode, indtil arbejdsdatoen.;
                           ENU=Specifies a filter for the posting date of the posted purchase and sales documents without incoming document records that are shown. By default, the filter is the first day of the current accounting period until the work date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DateFilter;
                Importance=Promoted;
                OnValidate=BEGIN
                             SearchForDocNos;
                           END;
                            }

    { 12  ;2   ;Field     ;
                Name=DocNoFilter;
                CaptionML=[DAN=Bilagsnummerfilter;
                           ENU=Document No. Filter];
                ToolTipML=[DAN=Angiver et filter til bilagsnummeret p† de bogf›rte k›bs- og salgsbilag uden indg†ende bilagsrecords, der vises.;
                           ENU=Specifies a filter for the document number on the posted purchase and sales documents without incoming document records that are shown.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DocNoFilter;
                Importance=Promoted;
                OnValidate=BEGIN
                             SearchForDocNos;
                           END;
                            }

    { 10  ;2   ;Field     ;
                Name=GLAccFilter;
                CaptionML=[DAN=Filter for finanskontonr.;
                           ENU=G/L Account No. Filter];
                ToolTipML=[DAN=Angiver et filter til den finanskonto, hvis bogf›rte k›bs- og salgsbilag uden indg†ende bilagsrecords, vises. Som standard inds‘ttes den finanskonto, hvortil du †bnede vinduet Bogf›rte dokumenter uden indg†ende bilag.;
                           ENU=Specifies a filter for the G/L account whose posted purchase and sales documents without incoming document records are shown. By default, the G/L account for which you opened the Posted Documents without Incoming Document window is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GLAccFilter;
                Importance=Promoted;
                OnValidate=BEGIN
                             SearchForDocNos;
                           END;
                            }

    { 18  ;2   ;Field     ;
                Name=ExternalDocNoFilter;
                CaptionML=[DAN=Eksternt bilagsnummerfilter;
                           ENU=External Doc. No. Filter];
                ToolTipML=[DAN=Angiver et filter til det eksterne bilagsnummer p† de bogf›rte k›bs- og salgsbilag uden indg†ende bilagsrecords, der vises.;
                           ENU=Specifies a filter for the external document number on the posted purchase and sales documents without incoming document records that are shown.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ExternalDocNoFilter;
                Importance=Promoted;
                OnValidate=BEGIN
                             SearchForDocNos;
                           END;
                            }

    { 2   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=Dokumenter;
                           ENU=Documents];
                Editable=FALSE;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af det bogf›rte k›bs- og salgsbilag, der ikke har en indg†ende bilagsrecord.;
                           ENU=Specifies the number of the posted purchase and sales document that does not have an incoming document record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for det bogf›rte k›bs- og salgsbilag, der ikke har en indg†ende bilagsrecord.;
                           ENU=Specifies the posting date of the posted purchase and sales document that does not have an incoming document record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="External Document No.";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den f›rste bogf›ringstransaktion i posten for det bogf›rte k›bs- og salgsbilag, der ikke har en indg†ende bilagsrecord.;
                           ENU=Specifies the description of the first posting transaction on the posted purchase and sales document that does not have an incoming document record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="First Posting Description";
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Debit Amount" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#Advanced;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 13  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 14  ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page193;
                PartType=Page }

  }
  CODE
  {
    VAR
      DateFilter@1006 : Text;
      DocNoFilter@1007 : Code[250];
      GLAccFilter@1004 : Code[250];
      ExternalDocNoFilter@1005 : Code[250];
      HasIncomingDocument@1000 : Boolean;

    LOCAL PROCEDURE SearchForDocNos@59();
    VAR
      PostedDocsWithNoIncBuf@1000 : Record 134;
    BEGIN
      PostedDocsWithNoIncBuf := Rec;
      GetDocNosWithoutIncomingDoc(Rec,DateFilter,DocNoFilter,GLAccFilter,ExternalDocNoFilter);
      Rec := PostedDocsWithNoIncBuf;
      IF FIND('=<>') THEN;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE IncomingDocumentExists@1() : Boolean;
    VAR
      IncomingDocument@1000 : Record 130;
    BEGIN
      IncomingDocument.SETRANGE(Posted,TRUE);
      IncomingDocument.SETRANGE("Document No.","Document No.");
      IncomingDocument.SETRANGE("Posting Date","Posting Date");
      EXIT(NOT IncomingDocument.ISEMPTY);
    END;

    BEGIN
    END.
  }
}


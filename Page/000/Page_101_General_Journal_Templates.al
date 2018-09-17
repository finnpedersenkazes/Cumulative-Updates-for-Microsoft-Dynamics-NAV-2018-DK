OBJECT Page 101 General Journal Templates
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finanskladdetyper;
               ENU=General Journal Templates];
    SourceTable=Table80;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Type;
                                 ENU=Te&mplate];
                      Image=Template }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Navne;
                                 ENU=Batches];
                      ToolTipML=[DAN=Vis eller rediger flere sagskladder for en bestemt skabelon. Du kan bruge k›rsler, hvis du har brug for flere kladder af en bestemt type.;
                                 ENU=View or edit multiple journals for a specific template. You can use batches when you need multiple journals of a certain type.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 251;
                      RunPageLink=Journal Template Name=FIELD(Name);
                      Image=Description }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kladdetype, du er ved at oprette.;
                           ENU=Specifies the name of the journal template you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af den kladdetype, du er ved at oprette.;
                           ENU=Specifies a brief description of the journal template you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kladdetypen. Typen bestemmer, hvordan vinduet kommer til at se ud.;
                           ENU=Specifies the journal type. The type determines what the window will look like.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kladdetypen skal v‘re a gentagelseskladde.;
                           ENU=Specifies whether the journal template will be a recurring journal.];
                ApplicationArea=#Suite;
                SourceExpr=Recurring }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf›res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account Type" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf›res til, f.eks. en kassekonto ved kontantk›b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bal. Account No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Series" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden p† den nummerserie, der skal bruges til at tildele bilagsnumre til finansposter, der bogf›res fra kladder ved hj‘lp af denne type.;
                           ENU=Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from journals using this template.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting No. Series" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reason Code" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktioner, der er bogf›rt i finanskladden, skal afstemmes efter dokumentnummer og -type udover efter dato.;
                           ENU=Specifies whether transactions that are posted in the general journal must balance by document number and document type, in addition to balancing by date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Force Doc. Balance" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om programmet skal beregne moms af konti og modkonti p† kladdelinjen for den valgte kladdetype.;
                           ENU=Specifies whether the program to calculate VAT for accounts and balancing accounts on the journal line of the selected journal template.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Copy VAT Setup to Jnl. Lines";
                OnValidate=BEGIN
                             IF "Copy VAT Setup to Jnl. Lines" <> xRec."Copy VAT Setup to Jnl. Lines" THEN
                               IF NOT CONFIRM(Text001,TRUE,FIELDCAPTION("Copy VAT Setup to Jnl. Lines")) THEN
                                 ERROR(Text002);
                           END;
                            }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om manuel regulering af momsbel›b i kladder skal tillades.;
                           ENU=Specifies whether to allow the manual adjustment of VAT amounts in journals.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow VAT Difference";
                OnValidate=BEGIN
                             IF "Allow VAT Difference" <> xRec."Allow VAT Difference" THEN
                               IF NOT CONFIRM(Text001,TRUE,FIELDCAPTION("Allow VAT Difference")) THEN
                                 ERROR(Text002);
                           END;
                            }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Advanced;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 15  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det viste navn p† den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the displayed name of the journal or worksheet that uses the template.];
                ApplicationArea=#Advanced;
                SourceExpr="Page Caption";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontrolrapport, der udskrives, n†r du klikker p† Kontroller.;
                           ENU=Specifies the test report that is printed when you click Test Report.];
                ApplicationArea=#Advanced;
                SourceExpr="Test Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 19  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den kontrolrapport, der udskrives, n†r du udskriver en kladde under denne kladdetype.;
                           ENU=Specifies the name of the test report that is printed when you print a journal under this journal template.];
                ApplicationArea=#Advanced;
                SourceExpr="Test Report Caption";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver journalrapport, der udskrives, n†r du v‘lger Bogf›r og udskriv.;
                           ENU=Specifies the posting report that is printed when you choose Post and Print.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 23  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den rapport, der udskrives, n†r du udskriver kladden.;
                           ENU=Specifies the name of the report that is printed when you print the journal.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Report Caption";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en rapport udskrives automatisk ved bogf›ring.;
                           ENU=Specifies whether a report is printed automatically when you post.];
                ApplicationArea=#Advanced;
                SourceExpr="Force Posting Report";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan der skal udskrives debitorkvitteringer, n†r du bogf›rer.;
                           ENU=Specifies how to print customer receipts when you post.];
                ApplicationArea=#Advanced;
                SourceExpr="Cust. Receipt Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 49  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, hvordan der skal udskrives debitorkvitteringer, n†r du bogf›rer.;
                           ENU=Specifies how to print customer receipts when you post.];
                ApplicationArea=#Advanced;
                SourceExpr="Cust. Receipt Report Caption";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan der skal udskrives debitorkvitteringer, n†r du bogf›rer.;
                           ENU=Specifies how to print customer receipts when you post.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Receipt Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 53  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, hvordan der skal udskrives kreditorkvitteringer, n†r du bogf›rer.;
                           ENU=Specifies how to print vendor receipts when you post.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Receipt Report Caption";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'DAN=Vil du opdatere feltet %1 i alle finanskladdenavne?;ENU=Do you want to update the %1 field on all general journal batches?';
      Text002@1001 : TextConst 'DAN=Annulleret.;ENU=Canceled.';

    BEGIN
    END.
  }
}


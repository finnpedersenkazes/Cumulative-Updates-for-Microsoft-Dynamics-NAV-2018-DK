OBJECT Page 116 G/L Registers
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Finansjournaler;
               ENU=G/L Registers];
    SourceTable=Table45;
    SourceTableView=SORTING(No.)
                    ORDER(Descending);
    PageType=List;
    OnOpenPage=BEGIN
                 IF FINDSET THEN;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Journal;
                                 ENU=&Register];
                      Image=Register }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Finansposter;
                                 ENU=General Ledger];
                      ToolTipML=[DAN=Se de finansposter, der medf›rte den aktuelle kladdepost.;
                                 ENU=View the general ledger entries that resulted in the current register entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 235;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=&Debitorposter;
                                 ENU=Customer &Ledger];
                      ToolTipML=[DAN=Se de debitorposter, der medf›rte den aktuelle kladdepost.;
                                 ENU=View the customer ledger entries that resulted in the current register entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 236;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CustomerLedger;
                      PromotedCategory=Process }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=&Kreditorposter;
                                 ENU=Ven&dor Ledger];
                      ToolTipML=[DAN=Se de kreditorposter, der medf›rte den aktuelle kladdepost.;
                                 ENU=View the vendor ledger entries that resulted in the current register entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 237;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=VendorLedger;
                      PromotedCategory=Process }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Bankkontoposter;
                                 ENU=Bank Account Ledger];
                      ToolTipML=[DAN=Se de bankkontoposter, der medf›rte den aktuelle kladdepost.;
                                 ENU=View the bank account ledger entries that resulted in the current register entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 377;
                      Promoted=Yes;
                      Image=BankAccountLedger;
                      PromotedCategory=Process }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=&Anl‘gsposter;
                                 ENU=Fixed &Asset Ledger];
                      ToolTipML=[DAN=Vis registre, der omfatter anl‘g.;
                                 ENU=View registers that involve fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Codeunit 5619;
                      Promoted=Yes;
                      Image=FixedAssetLedger;
                      PromotedCategory=Process }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Reparationsposter;
                                 ENU=Maintenance Ledger];
                      ToolTipML=[DAN=Vis reparationsposterne for det valgte anl‘g.;
                                 ENU=View the maintenance ledger entries for the selected fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Codeunit 5649;
                      Promoted=Yes;
                      Image=MaintenanceLedgerEntries;
                      PromotedCategory=Process }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=Momsposter;
                                 ENU=VAT Entries];
                      ToolTipML=[DAN=Se de momsposter, der er tilknyttet den aktuelle kladdepost.;
                                 ENU=View the VAT entries that are associated with the current register entry.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 238;
                      Promoted=Yes;
                      Image=VATLedger;
                      PromotedCategory=Process }
      { 5       ;2   ;Action    ;
                      Name=Employee Ledger;
                      CaptionML=[DAN=Medarbejderpost;
                                 ENU=Employee Ledger];
                      ToolTipML=[DAN=Se de medarbejderposter, der medf›rte kladdeposten.;
                                 ENU=View the employee ledger entries that resulted in the register entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EmployeeAgreement;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 EmployeeLedgerEntry@1000 : Record 5222;
                               BEGIN
                                 EmployeeLedgerEntry.SETRANGE("Entry No.","From Entry No.","To Entry No.");
                                 PAGE.RUN(PAGE::"Employee Ledger Entries",EmployeeLedgerEntry);
                               END;
                                }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Varerelation;
                                 ENU=Item Ledger Relation];
                      ToolTipML=[DAN=Vis tilknytningen mellem finansposter og v‘rdiposter.;
                                 ENU=View the link between the general ledger entries and the value entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5823;
                      RunPageView=SORTING(G/L Register No.);
                      RunPageLink=G/L Register No.=FIELD(No.);
                      Image=ItemLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 32      ;2   ;Action    ;
                      Name=ReverseRegister;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Tilbagef›r journal;
                                 ENU=Reverse Register];
                      ToolTipML=[DAN=Annuller poster, der er blevet bogf›rt forkert fra en finanskladdelinje eller fra en tidligere tilbagef›ring.;
                                 ENU=Undo entries that were incorrectly posted from a general journal line or from a previous reversal.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ReverseRegister;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReversalEntry@1000 : Record 179;
                               BEGIN
                                 TESTFIELD("No.");
                                 ReversalEntry.ReverseRegister("No.");
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1900670506;1 ;Action    ;
                      CaptionML=[DAN=Detaljeret r†balance;
                                 ENU=Detail Trial Balance];
                      ToolTipML=[DAN=Udskriv eller gem en detaljeret r†balance for finanskonti, du angiver.;
                                 ENU=Print or save a detail trial balance for the general ledger accounts that you specify.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 4;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904082706;1 ;Action    ;
                      CaptionML=[DAN=Balance;
                                 ENU=Trial Balance];
                      ToolTipML=[DAN=Udskriv eller gem kontoplanen med saldi og bev‘gelser.;
                                 ENU=Print or save the chart of accounts that have balances and net changes.];
                      ApplicationArea=#Suite;
                      RunObject=Report 8;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902174606;1 ;Action    ;
                      CaptionML=[DAN=R†balance efter periode;
                                 ENU=Trial Balance by Period];
                      ToolTipML=[DAN=Udskriv eller gem primosaldoen efter finanskonto, bev‘gelserne i den valgte periode (m†ned, kvartal eller †r), og den resulterende ultimosaldo.;
                                 ENU=Print or save the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 38;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900210206;1 ;Action    ;
                      CaptionML=[DAN=Finansjournal;
                                 ENU=G/L Register];
                      ToolTipML=[DAN=Vis bogf›rte finansposter.;
                                 ENU=View posted G/L entries.];
                      ApplicationArea=#Suite;
                      RunObject=Report 3;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finansjournal.;
                           ENU=Specifies the number of the general ledger register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for bogf›ringen af posterne i journalen.;
                           ENU=Specifies the date when the entries in the register were posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Creation Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildesporet for posterne i journalen.;
                           ENU=Specifies the source code for the entries in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den finanskladde, som posten blev bogf›rt fra.;
                           ENU=Specifies the name of the general journal that the entries were posted from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Journal Batch Name" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om journalen er blevet tilbagef›rt (annulleret) fra vinduet Tilbagef›r poster.;
                           ENU=Specifies if the register has been reversed (undone) from the Reverse Entries window.];
                ApplicationArea=#Advanced;
                SourceExpr=Reversed;
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste finanspostnummer i journalen.;
                           ENU=Specifies the first general ledger entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="From Entry No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste finanspostnummer i journalen.;
                           ENU=Specifies the last general ledger entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="To Entry No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det f›rste momspostnummer i journalen.;
                           ENU=Specifies the first VAT entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="From VAT Entry No." }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste momspostnummer i journalen.;
                           ENU=Specifies the last entry number in the register.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="To VAT Entry No." }

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

    BEGIN
    END.
  }
}


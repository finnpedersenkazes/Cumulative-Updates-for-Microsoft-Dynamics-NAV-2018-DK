OBJECT Page 5641 Maintenance Ledger Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Reparationsposter;
               ENU=Maintenance Ledger Entries];
    SourceTable=Table5625;
    DataCaptionFields=FA No.,Depreciation Book Code;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 26      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr�ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 32      ;2   ;Action    ;
                      Name=ReverseTransaction;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Tilbagef�r transaktion;
                                 ENU=Reverse Transaction];
                      ToolTipML=[DAN=Fortryd en fejlpostering i en kladde.;
                                 ENU=Undo an erroneous journal posting.];
                      ApplicationArea=#FixedAssets;
                      Image=ReverseRegister;
                      OnAction=VAR
                                 ReversalEntry@1000 : Record 179;
                               BEGIN
                                 CLEAR(ReversalEntry);
                                 IF Reversed THEN
                                   ReversalEntry.AlreadyReversedEntry(TABLECAPTION,"Entry No.");
                                 IF "Journal Batch Name" = '' THEN
                                   ReversalEntry.TestFieldError;
                                 IF "Transaction No." = 0 THEN
                                   ERROR(CannotUndoErr,"Entry No.","Depreciation Book Code");
                                 TESTFIELD("G/L Entry No.");
                                 ReversalEntry.ReverseTransaction("Transaction No.");
                               END;
                                }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf�ringsdatoen p� den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#FixedAssets;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for den relaterede anl�gstransaktion, f.eks. en afskrivning.;
                           ENU=Specifies the posting date of the related fixed asset transaction, such as a depreciation.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Posting Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken bilagstype posten tilh�rer.;
                           ENU=Specifies the document type that the entry belongs to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Document Type" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p� posten.;
                           ENU=Specifies the document number on the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Document No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver nummeret for det relaterede anl�g. ";
                           ENU="Specifies the number of the related fixed asset. "];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf�res til, hvis du har valgt Anl�gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Book Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for posten.;
                           ENU=Specifies the amount of the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Amount }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr�senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Credit Amount";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den reparationskode, som posten er tilknyttet.;
                           ENU=Specifies the maintenance code that the entry is linked to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Maintenance Code" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som en udlignende post bogf�res til, f.eks. BANK for en kassekonto.;
                           ENU=Specifies the type of account that a balancing entry is posted to, such as BANK for a cash account.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Bal. Account Type";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det finanskonto-, debitor-, kreditor- eller bankkontonummer, som udligningsposten bogf�res til, f.eks. en kassekonto ved kontantk�b.;
                           ENU=Specifies the number of the general ledger, customer, vendor, or bank account that the balancing entry is posted to, such as a cash account for cash purchases.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Bal. Account No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf�rt posten, der skal bruges, f.eks. i �ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#FixedAssets;
                SourceExpr="User ID";
                Visible=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er indg�et i en tilbagef�ringstransaktion (rettelse) foretaget med funktionen Tilbagef�r.;
                           ENU=Specifies whether the entry has been part of a reverse transaction (correction) made by the Reverse function.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Reversed;
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den korrigerende post.;
                           ENU=Specifies the number of the correcting entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reversed by Entry No.";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den oprindelige post, der blev annulleret ved tilbagef�rselstransaktionen.;
                           ENU=Specifies the number of the original entry that was undone by the reverse transaction.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reversed Entry No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf�ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Posting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l�benummeret p� den finanspost, som blev oprettet for reparationstransaktionen.;
                           ENU=Specifies the G/L number for the entry that was created for this maintenance transaction.];
                ApplicationArea=#FixedAssets;
                SourceExpr="G/L Entry No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Entry No." }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv�rdier. De faktiske v�rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Set ID";
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
      Navigate@1000 : Page 344;
      CannotUndoErr@1001 : TextConst 'DAN=Du kan ikke fortryde reparationspostnr. %1 ved hj�lp af funktionen Tilbagef�r transaktion, da afskrivningsprofilen %2 ikke har den rette konfiguration af finansintegration.;ENU=You cannot undo the Maintenance Ledger Entry No. %1 by using the Reverse Transaction function because Depreciation Book %2 does not have the appropriate G/L integration setup.';
      DimensionSetIDFilter@1002 : Page 481;

    BEGIN
    END.
  }
}


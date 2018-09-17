OBJECT Page 475 VAT Statement Preview Line
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
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table256;
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       VATStatement.CalcLineTotal(Rec,ColumnValue,0);
                       IF "Print with" = "Print with"::"Opposite Sign" THEN
                         ColumnValue := -ColumnValue;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer, som identificerer linjen.;
                           ENU=Specifies a number that identifies the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Row No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af momsangivelsen.;
                           ENU=Specifies a description of the VAT statement line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvad momsangivelseslinjen skal indeholde.;
                           ENU=Specifies what the VAT statement line will include.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om momsangivelseslinjen viser momsbel›bene eller de basisbel›b, hvorfra momsen beregnes.;
                           ENU=Specifies if the VAT statement line shows the VAT amounts, or the base amounts on which the VAT is calculated.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en skatteregionkode for udtoget.;
                           ENU=Specifies a tax jurisdiction code for the statement.];
                ApplicationArea=#Advanced;
                SourceExpr="Tax Jurisdiction Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du kun vil bruge poster fra tabellen Momspost med markeringen Use Tax sammentalt p† denne linje.;
                           ENU=Specifies whether to use only entries from the VAT Entry table that are marked as Use Tax to be totaled on this line.];
                ApplicationArea=#Advanced;
                SourceExpr="Use Tax";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                DrillDown=Yes;
                CaptionML=[DAN=Kolonnebel›b;
                           ENU=Column Amount];
                ToolTipML=[DAN=Angiver, hvilke posttyper der skal medtages i bel›bene i kolonnerne.;
                           ENU=Specifies the type of entries that will be included in the amounts in columns.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=ColumnValue;
                AutoFormatType=1;
                OnDrillDown=BEGIN
                              CASE Type OF
                                Type::"Account Totaling":
                                  BEGIN
                                    GLEntry.SETFILTER("G/L Account No.","Account Totaling");
                                    COPYFILTER("Date Filter",GLEntry."Posting Date");
                                    PAGE.RUN(PAGE::"General Ledger Entries",GLEntry);
                                  END;
                                Type::"VAT Entry Totaling":
                                  BEGIN
                                    VATEntry.RESET;
                                    IF NOT
                                       VATEntry.SETCURRENTKEY(
                                         Type,Closed,"VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date")
                                    THEN
                                      VATEntry.SETCURRENTKEY(
                                        Type,Closed,"Tax Jurisdiction Code","Use Tax","Posting Date");
                                    VATEntry.SETRANGE(Type,"Gen. Posting Type");
                                    VATEntry.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
                                    VATEntry.SETRANGE("VAT Prod. Posting Group","VAT Prod. Posting Group");
                                    VATEntry.SETRANGE("Tax Jurisdiction Code","Tax Jurisdiction Code");
                                    VATEntry.SETRANGE("Use Tax","Use Tax");
                                    IF GETFILTER("Date Filter") <> '' THEN
                                      IF PeriodSelection = PeriodSelection::"Before and Within Period" THEN
                                        VATEntry.SETRANGE("Posting Date",0D,GETRANGEMAX("Date Filter"))
                                      ELSE
                                        COPYFILTER("Date Filter",VATEntry."Posting Date");
                                    CASE Selection OF
                                      Selection::Open:
                                        VATEntry.SETRANGE(Closed,FALSE);
                                      Selection::Closed:
                                        VATEntry.SETRANGE(Closed,TRUE);
                                      Selection::"Open and Closed":
                                        VATEntry.SETRANGE(Closed);
                                    END;
                                    PAGE.RUN(PAGE::"VAT Entries",VATEntry);
                                  END;
                                Type::"Row Totaling",
                                Type::Description:
                                  ERROR(Text000,FIELDCAPTION(Type),Type);
                              END;
                            END;
                             }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Specificer er ikke muligt, n†r %1 er %2.;ENU=Drilldown is not possible when %1 is %2.';
      GLEntry@1001 : Record 17;
      VATEntry@1002 : Record 254;
      VATStatement@1004 : Report 12;
      ColumnValue@1005 : Decimal;
      Selection@1006 : 'Open,Closed,Open and Closed';
      PeriodSelection@1007 : 'Before and Within Period,Within Period';
      UseAmtsInAddCurr@1008 : Boolean;

    [External]
    PROCEDURE UpdateForm@1(VAR VATStmtName@1000 : Record 257;NewSelection@1001 : 'Open,Closed,Open and Closed';NewPeriodSelection@1002 : 'Before and Within Period,Within Period';NewUseAmtsInAddCurr@1003 : Boolean);
    BEGIN
      SETRANGE("Statement Template Name",VATStmtName."Statement Template Name");
      SETRANGE("Statement Name",VATStmtName.Name);
      VATStmtName.COPYFILTER("Date Filter","Date Filter");
      Selection := NewSelection;
      PeriodSelection := NewPeriodSelection;
      UseAmtsInAddCurr := NewUseAmtsInAddCurr;
      VATStatement.InitializeRequest(VATStmtName,Rec,Selection,PeriodSelection,FALSE,UseAmtsInAddCurr);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}


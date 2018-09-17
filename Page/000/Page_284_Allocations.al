OBJECT Page 284 Allocations
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Fordelinger;
               ENU=Allocations];
    SourceTable=Table221;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnInit=BEGIN
             TotalAllocationAmountVisible := TRUE;
             AllocationAmountVisible := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  UpdateAllocationAmount;
                  CLEAR(ShortcutDimCode);
                END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateAllocationAmount;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 38      ;2   ;Action    ;
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
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&onto;
                                 ENU=A&ccount];
                      Image=ChartOfAccounts }
      { 26      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om tildelingen.;
                                 ENU=View or change detailed information about the allocation.];
                      ApplicationArea=#Suite;
                      RunObject=Page 17;
                      RunPageLink=No.=FIELD(Account No.);
                      Image=EditLines }
      { 27      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf�rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 20;
                      RunPageView=SORTING(G/L Account No.);
                      RunPageLink=G/L Account No.=FIELD(Account No.);
                      Promoted=No;
                      Image=GLRegisters }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer, som allokeringen skal bogf�res p�.;
                           ENU=Specifies the account number that the allocation will be posted to.];
                ApplicationArea=#Suite;
                SourceExpr="Account No.";
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 33  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p� den konto, som fordelingen skal bogf�res for.;
                           ENU=Specifies the name of the account that the allocation will be posted to.];
                ApplicationArea=#Suite;
                SourceExpr="Account Name" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                           END;
                            }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                           END;
                            }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                           END;
                            }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                           END;
                            }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                           END;
                            }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionstypen.;
                           ENU=Specifies the type of transaction.];
                ApplicationArea=#Suite;
                SourceExpr="Gen. Posting Type" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Suite;
                SourceExpr="Gen. Bus. Posting Group" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Suite;
                SourceExpr="Gen. Prod. Posting Group" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf�ringsops�tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf�ringsops�tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, som bel�bet i allokeringskladdelinjen skal beregnes ud fra.;
                           ENU=Specifies the quantity that will be used to calculate the amount in the allocation journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Allocation Quantity";
                OnValidate=BEGIN
                             AllocationQuantityOnAfterValid;
                           END;
                            }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel, som bel�bet i allokeringskladdelinjen skal beregnes ud fra.;
                           ENU=Specifies the percentage that will be used to calculate the amount in the allocation journal line.];
                ApplicationArea=#Suite;
                SourceExpr="Allocation %";
                OnValidate=BEGIN
                             Allocation37OnAfterValidate;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel�b, som skal bogf�res p� allokeringskladdelinjen.;
                           ENU=Specifies the amount that will be posted from the allocation journal line.];
                ApplicationArea=#Suite;
                SourceExpr=Amount;
                OnValidate=BEGIN
                             AmountOnAfterValidate;
                           END;
                            }

    { 18  ;1   ;Group      }

    { 1902205101;2;Group  ;
                GroupType=FixedLayout }

    { 1903867001;3;Group  ;
                CaptionML=[DAN=Bel�b;
                           ENU=Amount] }

    { 19  ;4   ;Field     ;
                CaptionML=[DAN=Fordelingsbel�b;
                           ENU=AllocationAmount];
                ToolTipML=[DAN=Angiver det samlede bel�b, som er indtastet i fordelingskladden frem til den linje, hvor mark�ren er placeret.;
                           ENU=Specifies the total amount that has been entered in the allocation journal up to the line where the cursor is.];
                ApplicationArea=#All;
                SourceExpr=AllocationAmount + Amount - xRec.Amount;
                AutoFormatType=1;
                AutoFormatExpr=GetCurrencyCode;
                Visible=AllocationAmountVisible;
                Editable=FALSE }

    { 1902759801;3;Group  ;
                CaptionML=[DAN=Total andel i bel�b;
                           ENU=Total Amount] }

    { 21  ;4   ;Field     ;
                Name=TotalAllocationAmount;
                CaptionML=[DAN=Total andel i bel�b;
                           ENU=Total Amount];
                ToolTipML=[DAN=Angiver det samlede bel�b, som er fordelt i fordelingskladden.;
                           ENU=Specifies the total amount that is allocated in the allocation journal.];
                ApplicationArea=#All;
                SourceExpr=TotalAllocationAmount + Amount - xRec.Amount;
                AutoFormatType=1;
                AutoFormatExpr=GetCurrencyCode;
                Visible=TotalAllocationAmountVisible;
                Editable=FALSE }

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
      AllocationAmount@1000 : Decimal;
      TotalAllocationAmount@1001 : Decimal;
      ShowAllocationAmount@1002 : Boolean;
      ShowTotalAllocationAmount@1003 : Boolean;
      ShortcutDimCode@1004 : ARRAY [8] OF Code[20];
      AllocationAmountVisible@19037614 : Boolean INDATASET;
      TotalAllocationAmountVisible@19015479 : Boolean INDATASET;

    LOCAL PROCEDURE UpdateAllocationAmount@3();
    VAR
      TempGenJnlAlloc@1000 : Record 221;
    BEGIN
      TempGenJnlAlloc.COPYFILTERS(Rec);
      ShowTotalAllocationAmount := TempGenJnlAlloc.CALCSUMS(Amount);
      IF ShowTotalAllocationAmount THEN BEGIN
        TotalAllocationAmount := TempGenJnlAlloc.Amount;
        IF "Line No." = 0 THEN
          TotalAllocationAmount := TotalAllocationAmount + xRec.Amount;
      END;

      IF "Line No." <> 0 THEN BEGIN
        TempGenJnlAlloc.SETRANGE("Line No.",0,"Line No.");
        ShowAllocationAmount := TempGenJnlAlloc.CALCSUMS(Amount);
        IF ShowAllocationAmount THEN
          AllocationAmount := TempGenJnlAlloc.Amount;
      END ELSE BEGIN
        TempGenJnlAlloc.SETRANGE("Line No.",0,xRec."Line No.");
        ShowAllocationAmount := TempGenJnlAlloc.CALCSUMS(Amount);
        IF ShowAllocationAmount THEN BEGIN
          AllocationAmount := TempGenJnlAlloc.Amount;
          TempGenJnlAlloc.COPYFILTERS(Rec);
          TempGenJnlAlloc := xRec;
          IF TempGenJnlAlloc.NEXT = 0 THEN
            AllocationAmount := AllocationAmount + xRec.Amount;
        END;
      END;

      AllocationAmountVisible := ShowAllocationAmount;
      TotalAllocationAmountVisible := ShowTotalAllocationAmount;
    END;

    LOCAL PROCEDURE AllocationQuantityOnAfterValid@19051563();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE Allocation37OnAfterValidate@19044116();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE AmountOnAfterValidate@19024931();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}


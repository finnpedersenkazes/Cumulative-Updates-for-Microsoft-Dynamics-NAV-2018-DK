OBJECT Page 5603 Main Asset Statistics
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
    CaptionML=[DAN=Hovedanl�g - statistik;
               ENU=Main Asset Statistics];
    LinksAllowed=No;
    SourceTable=Table5612;
    DataCaptionExpr=Caption;
    PageType=Card;
    OnInit=BEGIN
             DispDateVisible := TRUE;
             GLPriceVisible := TRUE;
             DispPriceVisible := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       DispPriceVisible := FALSE;
                       GLPriceVisible := FALSE;
                       DispDateVisible := FALSE;

                       CLEARALL;
                       IF "Main Asset/Component" <> "Main Asset/Component"::"Main Asset" THEN
                         EXIT;
                       WITH FADeprBook DO BEGIN
                         SETCURRENTKEY("Depreciation Book Code","Component of Main Asset");
                         SETRANGE("Depreciation Book Code",Rec."Depreciation Book Code");
                         SETRANGE("Component of Main Asset",Rec."Component of Main Asset");
                         IF FIND('-') THEN
                           REPEAT
                             IF "Disposal Date" > 0D THEN BEGIN
                               NoOfSoldComponents := NoOfSoldComponents + 1;
                               CALCFIELDS("Proceeds on Disposal","Gain/Loss");
                               DisposalPrice := DisposalPrice + "Proceeds on Disposal";
                               GainLoss := GainLoss + "Gain/Loss";
                               DisposalDate := GetMinDate(DisposalDate,"Disposal Date");
                             END;
                             IF "Disposal Date" = 0D THEN BEGIN
                               IF "Last Acquisition Cost Date" > 0D THEN BEGIN
                                 NoOfComponents := NoOfComponents + 1;
                                 CALCFIELDS("Book Value","Depreciable Basis");
                                 BookValue := BookValue + "Book Value";
                                 DeprBasis := DeprBasis + "Depreciable Basis";
                                 GLAcqDate := GetMinDate(GLAcqDate,"G/L Acquisition Date");
                                 FAAcqDate := GetMinDate(FAAcqDate,"Acquisition Date");
                               END;
                               CalcAmount(LastAcqCost,AcquisitionCost,"Last Acquisition Cost Date",0);
                               CalcAmount(LastDepreciation,Depreciation2,"Last Depreciation Date",1);
                               CalcAmount(LastWriteDown,WriteDown,"Last Write-Down Date",2);
                               CalcAmount(LastAppreciation,Appreciation2,"Last Appreciation Date",3);
                               CalcAmount(LastCustom1,Custom1,"Last Custom 1 Date",4);
                               CalcAmount(LastCustom2,Custom2,"Last Custom 2 Date",5);
                               CalcAmount(LastMaintenance,Maintenance2,"Last Maintenance Date",7);
                               CalcAmount(LastSalvageValue,SalvageValue,"Last Salvage Value Date",8);
                             END;
                           UNTIL NEXT = 0;
                       END;
                       DispPriceVisible := DisposalDate > 0D;
                       GLPriceVisible := DisposalDate > 0D;
                       DispDateVisible := DisposalDate > 0D;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 21  ;2   ;Field     ;
                CaptionML=[DAN=Antal komponenter;
                           ENU=No. of Components];
                ToolTipML=[DAN=Angiver antallet af komponenter i hovedanl�gget.;
                           ENU=Specifies the number of components in the main asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=NoOfComponents }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Antal solgte komponenter;
                           ENU=No. of Sold Components];
                ToolTipML=[DAN=Angiver antallet af komponenter fra hovedanl�gget, som virksomheden har solgt.;
                           ENU=Specifies the number of components from the main asset that the company has sold.];
                ApplicationArea=#FixedAssets;
                SourceExpr=NoOfSoldComponents }

    { 27  ;2   ;Field     ;
                CaptionML=[DAN=Komponenter i alt;
                           ENU=Total Components];
                ToolTipML=[DAN=Angiver det antal komponenter, der har v�ret eller er en del af hovedanl�gget.;
                           ENU=Specifies the number of components that either have been or are part of the main asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=NoOfComponents + NoOfSoldComponents }

    { 54  ;2   ;Field     ;
                CaptionML=[DAN=Anskaffelsesdato;
                           ENU=Acquisition Date];
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for anl�gget for den f�rste bogf�rte anskaffelse.;
                           ENU=Specifies the FA posting date of the first posted acquisition cost.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FAAcqDate }

    { 55  ;2   ;Field     ;
                CaptionML=[DAN=Anskaffelsesdato (finans);
                           ENU=G/L Acquisition Date];
                ToolTipML=[DAN=Angiver finansbogf�ringsdatoen for den f�rste bogf�rte anskaffelse.;
                           ENU=Specifies G/L posting date of the first posted acquisition cost.];
                ApplicationArea=#FixedAssets;
                SourceExpr=GLAcqDate }

    { 56  ;2   ;Field     ;
                Name=DispDate;
                CaptionML=[DAN=Salgsdato;
                           ENU=Disposal Date];
                ToolTipML=[DAN=Angiver den dato, hvor anl�gget blev afh�ndet.;
                           ENU=Specifies the date when the fixed asset was disposed of.];
                ApplicationArea=#All;
                SourceExpr=DisposalDate;
                Visible=DispDateVisible }

    { 52  ;2   ;Field     ;
                Name=DispPrice;
                CaptionML=[DAN=Salg;
                           ENU=Proceeds on Disposal];
                ToolTipML=[DAN=Angiver den samlede fortjeneste p� afh�ndelse af anl�gsaktivet. V�rdien beregnes ved hj�lp af posterne i vinduet Anl�gsfinansposter.;
                           ENU=Specifies the total proceeds on disposals for the fixed asset. The value is calculated using the entries in the FA Ledger Entries window.];
                ApplicationArea=#All;
                SourceExpr=DisposalPrice;
                AutoFormatType=1;
                Visible=DispPriceVisible }

    { 53  ;2   ;Field     ;
                Name=GLPrice;
                CaptionML=[DAN=Tab/gevinst;
                           ENU=Gain/Loss];
                ToolTipML=[DAN=Angiver den samlede gevinst (kredit) eller det samlede tab (debet) for anl�gget. Feltets v�rdi beregnes automatisk p� baggrund af posterne i vinduet Anl�gsposter. Klik p� feltet for at se, hvilke poster der udg�r det viste bel�b.;
                           ENU=Specifies the total gain (credit) or loss (debit) for the fixed asset. The field is calculated using the entries in the FA Ledger Entries window. To see the ledger entries that make up the amount shown, click the field.];
                ApplicationArea=#All;
                SourceExpr=GainLoss;
                AutoFormatType=1;
                Visible=GLPriceVisible }

    { 1903895301;2;Group  ;
                GroupType=FixedLayout }

    { 1900295901;3;Group  ;
                CaptionML=[DAN=Sidste bogf�ringsdato for anl�g;
                           ENU=Last FA Posting Date] }

    { 30  ;4   ;Field     ;
                CaptionML=[DAN=Anskaffelse;
                           ENU=Acquisition Cost];
                ToolTipML=[DAN=Angiver den samlede procentdel af anskaffelsen, som kan allokeres, n�r anskaffelsen bogf�res.;
                           ENU=Specifies the total percentage of acquisition cost that can be allocated when acquisition cost is posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr=LastAcqCost }

    { 32  ;4   ;Field     ;
                CaptionML=[DAN=Afskrivning;
                           ENU=Depreciation];
                ToolTipML=[DAN=Angiver den samlede afskrivning for anl�gget.;
                           ENU=Specifies the total depreciation for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=LastDepreciation }

    { 34  ;4   ;Field     ;
                CaptionML=[DAN=Nedskrivning;
                           ENU=Write-Down];
                ToolTipML=[DAN=Angiver det samlede nedskrivningsbel�b i RV for anl�gget.;
                           ENU=Specifies the total LCY amount of write-down entries for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=LastWriteDown }

    { 36  ;4   ;Field     ;
                CaptionML=[DAN=Opskrivning;
                           ENU=Appreciation];
                ToolTipML=[DAN=Angiver den sum, der udlignes med afskrivninger.;
                           ENU=Specifies the sum that applies to appreciations.];
                ApplicationArea=#FixedAssets;
                SourceExpr=LastAppreciation }

    { 38  ;4   ;Field     ;
                CaptionML=[DAN=Bruger 1;
                           ENU=Custom 1];
                ToolTipML=[DAN=Angiver det samlede bel�b i RV for Bruger 1-poster for anl�gget.;
                           ENU=Specifies the total LCY amount for custom 1 entries for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=LastCustom1 }

    { 42  ;4   ;Field     ;
                CaptionML=[DAN=Skrapv�rdi;
                           ENU=Salvage Value];
                ToolTipML=[DAN=Angiver skrapv�rdien for anl�gget.;
                           ENU=Specifies the salvage value for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=LastSalvageValue }

    { 20  ;4   ;Field     ;
                CaptionML=[DAN=Bruger 2;
                           ENU=Custom 2];
                ToolTipML=[DAN=Angiver det samlede bel�b i RV for Bruger 2-poster for anl�gget.;
                           ENU=Specifies the total LCY amount for custom 2 entries for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=LastCustom2 }

    { 1901742301;3;Group  ;
                CaptionML=[DAN=Bel�b;
                           ENU=Amount] }

    { 6   ;4   ;Field     ;
                CaptionML=[DAN=Anskaffelse;
                           ENU=Acquisition Cost];
                ToolTipML=[DAN=Angiver den samlede procentdel af anskaffelsen, som kan allokeres, n�r anskaffelsen bogf�res.;
                           ENU=Specifies the total percentage of acquisition cost that can be allocated when acquisition cost is posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr=AcquisitionCost;
                AutoFormatType=1 }

    { 8   ;4   ;Field     ;
                CaptionML=[DAN=Afskrivning;
                           ENU=Depreciation];
                ToolTipML=[DAN=Angiver den samlede afskrivning for anl�gget.;
                           ENU=Specifies the total depreciation for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Depreciation2;
                AutoFormatType=1 }

    { 10  ;4   ;Field     ;
                CaptionML=[DAN=Nedskrivning;
                           ENU=Write-Down];
                ToolTipML=[DAN=Angiver det samlede nedskrivningsbel�b i RV for anl�gget.;
                           ENU=Specifies the total LCY amount of write-down entries for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=WriteDown;
                AutoFormatType=1 }

    { 12  ;4   ;Field     ;
                CaptionML=[DAN=Opskrivning;
                           ENU=Appreciation];
                ToolTipML=[DAN=Angiver den sum, der udlignes med afskrivninger.;
                           ENU=Specifies the sum that applies to appreciations.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Appreciation2;
                AutoFormatType=1 }

    { 14  ;4   ;Field     ;
                CaptionML=[DAN=Bruger 1;
                           ENU=Custom 1];
                ToolTipML=[DAN=Angiver det samlede bel�b i RV for Bruger 1-poster for anl�gget.;
                           ENU=Specifies the total LCY amount for custom 1 entries for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Custom1;
                AutoFormatType=1 }

    { 16  ;4   ;Field     ;
                CaptionML=[DAN=Bogf�rt v�rdi;
                           ENU=Book Value];
                ToolTipML=[DAN=Angiver den sum, der udlignes med bogf�rte v�rdier.;
                           ENU=Specifies the sum that applies to book values.];
                ApplicationArea=#FixedAssets;
                SourceExpr=BookValue;
                AutoFormatType=1 }

    { 24  ;4   ;Field     ;
                CaptionML=[DAN=Skrapv�rdi;
                           ENU=Salvage Value];
                ToolTipML=[DAN=Angiver skrapv�rdien for anl�gget.;
                           ENU=Specifies the salvage value for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=SalvageValue;
                AutoFormatType=1 }

    { 22  ;4   ;Field     ;
                CaptionML=[DAN=Afskrivningsgrundlag;
                           ENU=Depreciation Basis];
                ToolTipML=[DAN=Angiver afskrivningsgrundlaget for anl�gget.;
                           ENU=Specifies the depreciation basis amount for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=DeprBasis;
                AutoFormatType=1 }

    { 4   ;4   ;Field     ;
                CaptionML=[DAN=Bruger 2;
                           ENU=Custom 2];
                ToolTipML=[DAN=Angiver det samlede bel�b i RV for Bruger 2-poster for anl�gget.;
                           ENU=Specifies the total LCY amount for custom 2 entries for the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Custom2;
                AutoFormatType=1 }

    { 2   ;4   ;Field     ;
                CaptionML=[DAN=Reparation;
                           ENU=Maintenance];
                ToolTipML=[DAN=Angiver de totale reparationsomkostninger for anl�gsaktivet. De beregnes p� basis af reparationsposterne.;
                           ENU=Specifies the total maintenance cost for the fixed asset. This is calculated from the maintenance ledger entries.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Maintenance2;
                AutoFormatType=1 }

  }
  CODE
  {
    VAR
      FADeprBook@1000 : Record 5612;
      AcquisitionCost@1001 : Decimal;
      Depreciation2@1002 : Decimal;
      WriteDown@1003 : Decimal;
      Appreciation2@1004 : Decimal;
      Custom1@1005 : Decimal;
      Custom2@1006 : Decimal;
      BookValue@1007 : Decimal;
      DisposalPrice@1008 : Decimal;
      GainLoss@1009 : Decimal;
      DeprBasis@1010 : Decimal;
      SalvageValue@1011 : Decimal;
      Maintenance2@1012 : Decimal;
      GLAcqDate@1013 : Date;
      FAAcqDate@1014 : Date;
      LastAcqCost@1015 : Date;
      LastDepreciation@1016 : Date;
      LastWriteDown@1017 : Date;
      LastAppreciation@1018 : Date;
      LastCustom1@1019 : Date;
      LastCustom2@1020 : Date;
      LastSalvageValue@1021 : Date;
      LastMaintenance@1022 : Date;
      DisposalDate@1023 : Date;
      NoOfComponents@1025 : Integer;
      NoOfSoldComponents@1024 : Integer;
      DispPriceVisible@19000797 : Boolean INDATASET;
      GLPriceVisible@19022477 : Boolean INDATASET;
      DispDateVisible@19048061 : Boolean INDATASET;

    LOCAL PROCEDURE CalcAmount@1(VAR FADate@1000 : Date;VAR Amount@1001 : Decimal;FADate2@1002 : Date;FAPostingType@1003 : 'Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance,Salvage Value');
    BEGIN
      IF FADate2 = 0D THEN
        EXIT;
      WITH FADeprBook DO
        CASE FAPostingType OF
          FAPostingType::"Acquisition Cost":
            BEGIN
              CALCFIELDS("Acquisition Cost");
              Amount := Amount + "Acquisition Cost";
            END;
          FAPostingType::Depreciation:
            BEGIN
              CALCFIELDS(Depreciation);
              Amount := Amount + Depreciation;
            END;
          FAPostingType::"Write-Down":
            BEGIN
              CALCFIELDS("Write-Down");
              Amount := Amount + "Write-Down";
            END;
          FAPostingType::Appreciation:
            BEGIN
              CALCFIELDS(Appreciation);
              Amount := Amount + Appreciation;
            END;
          FAPostingType::"Custom 1":
            BEGIN
              CALCFIELDS("Custom 1");
              Amount := Amount + "Custom 1";
            END;
          FAPostingType::"Custom 2":
            BEGIN
              CALCFIELDS("Custom 2");
              Amount := Amount + "Custom 2";
            END;
          FAPostingType::Maintenance:
            BEGIN
              CALCFIELDS(Maintenance);
              Amount := Amount + Maintenance;
            END;
          FAPostingType::"Salvage Value":
            BEGIN
              CALCFIELDS("Salvage Value");
              Amount := Amount + "Salvage Value";
            END;
        END;
      IF FADate < FADate2 THEN
        FADate := FADate2;
    END;

    LOCAL PROCEDURE GetMinDate@2(Date1@1000 : Date;Date2@1001 : Date) : Date;
    BEGIN
      IF (Date1 = 0D) OR (Date2 < Date1) THEN
        EXIT(Date2);

      EXIT(Date1);
    END;

    BEGIN
    END.
  }
}


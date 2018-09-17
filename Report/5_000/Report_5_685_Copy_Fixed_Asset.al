OBJECT Report 5685 Copy Fixed Asset
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    Permissions=TableData 5612=ri;
    CaptionML=[DAN=Kopier anl‘g;
               ENU=Copy Fixed Asset];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  DefaultDim.LOCKTABLE;
                  FADeprBook.LOCKTABLE;
                  FA.LOCKTABLE;
                  IF FANo = '' THEN
                    ERROR(Text000,FA.TABLECAPTION,FA.FIELDCAPTION("No."));
                  IF (FirstFANo = '') AND NOT UseFANoSeries THEN
                    ERROR(Text001);
                  FA.GET(FANo);
                  FADeprBook."FA No." := FANo;
                  FADeprBook.SETRANGE("FA No.",FANo);
                  DefaultDim."Table ID" := DATABASE::"Fixed Asset";
                  DefaultDim."No." := FANo;
                  DefaultDim.SETRANGE("Table ID",DATABASE::"Fixed Asset");
                  DefaultDim.SETRANGE("No.",FANo);
                  DefaultDim2 := DefaultDim;
                  FOR I := 1 TO NumberofCopies DO BEGIN
                    FA2 := FA;
                    FA2."No." := '';
                    FA2."Last Date Modified" := 0D;
                    FA2."Main Asset/Component" := FA2."Main Asset/Component"::" ";
                    FA2."Component of Main Asset" := '';
                    IF UseFANoSeries THEN
                      FA2.INSERT(TRUE)
                    ELSE BEGIN
                      FA2."No." := FirstFANo;
                      IF NumberofCopies > 1 THEN
                        FirstFANo := INCSTR(FirstFANo);
                      IF FA2."No." = '' THEN
                        ERROR(Text002,FA.TABLECAPTION,FA.FIELDCAPTION("No."));
                      FA2.INSERT(TRUE);
                    END;
                    IF DefaultDim.FIND('-') THEN
                      REPEAT
                        DefaultDim2 := DefaultDim;
                        DefaultDim2."No." := FA2."No.";
                        DefaultDim2.INSERT(TRUE);
                      UNTIL DefaultDim.NEXT = 0;
                    IF FADeprBook.FIND('-') THEN
                      REPEAT
                        FADeprBook2 := FADeprBook;
                        FADeprBook2."FA No." := FA2."No.";
                        FADeprBook2.INSERT(TRUE);
                      UNTIL FADeprBook.NEXT = 0;
                    IF FA2.FIND THEN BEGIN;
                      FA2."Last Date Modified" := 0D;
                      FA2.MODIFY;
                    END;
                  END;
                END;

  }
  DATASET
  {
  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   IF NumberofCopies < 1 THEN
                     NumberofCopies := 1;
                   FANo := FANo2;

                   OnOpenRequestPage(FANo,NumberofCopies,FirstFANo,UseFANoSeries);
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Kopier fra anl‘gsnr.;
                             ENU=Copy from FA No.];
                  ToolTipML=[DAN=Angiver nummeret p† det anl‘g, du vil kopiere fra.;
                             ENU=Specifies the number of the fixed asset that you want to copy from.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=FANo;
                  TableRelation="Fixed Asset" }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Antal kopier;
                             ENU=No. of Copies];
                  ToolTipML=[DAN=Angiver antallet af nye anl‘g, der skal oprettes.;
                             ENU=Specifies the number of new fixed asset that you want to create.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=NumberofCopies;
                  MinValue=1 }

      { 9   ;2   ;Field     ;
                  CaptionML=[DAN=F›rste anl‘gsnr.;
                             ENU=First FA No.];
                  ToolTipML=[DAN=Angiver nummeret p† det f›rste anl‘g. Hvis Antal kopier er st›rre end 1, skal feltet F›rste anl‘gsnr. indeholde et tal, f.eks. A045.;
                             ENU=Specifies the number of the first fixed asset. If No. of Copies is greater than 1, the First FA No. field must include a number, for example FA045.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=FirstFANo;
                  OnValidate=BEGIN
                               IF FirstFANo <> '' THEN
                                 UseFANoSeries := FALSE;
                             END;
                              }

      { 7   ;2   ;Field     ;
                  CaptionML=[DAN=Brug anl‘gsnr.serie;
                             ENU=Use FA No. Series];
                  ToolTipML=[DAN=Angiver, om det nye anl‘g skal have et nummer fra den nummerserie, der er angivet i feltet Anl‘gsnumre i vinduet Anl‘gsops‘tning.;
                             ENU=Specifies if you want the new fixed asset to have a number from the number series specified in Fixed Asset Nos. field in the Fixed Asset Setup window.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=UseFANoSeries;
                  OnValidate=BEGIN
                               IF UseFANoSeries THEN
                                 FirstFANo := '';
                             END;
                              }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      DefaultDim@1008 : Record 352;
      DefaultDim2@1009 : Record 352;
      FA@1004 : Record 5600;
      FA2@1006 : Record 5600;
      FADeprBook@1010 : Record 5612;
      FADeprBook2@1011 : Record 5612;
      FANo@1000 : Code[20];
      FANo2@1015 : Code[20];
      FirstFANo@1002 : Code[20];
      UseFANoSeries@1001 : Boolean;
      NumberofCopies@1003 : Integer;
      I@1005 : Integer;
      Text000@1012 : TextConst '@@@="%1: TABLECAPTION(Fixed Asset); %2: Field(No.)";DAN=Du skal angive et nummer i feltet Kopi‚r fra feltet %1 %2.;ENU=You must specify a number in the Copy from %1 %2 field.';
      Text001@1013 : TextConst 'DAN=Du skal angive et nummer i feltet F›rste anl‘gsnr. eller bruge anl‘gsnummerserien.;ENU=You must specify a number in First FA No. field or use the FA No. Series.';
      Text002@1014 : TextConst '@@@="%1: TABLECAPTION(Fixed Asset); %2: Field(No.)";DAN=Du skal angive et nummer i feltet F›rste anl‘g %1 %2.;ENU=You must include a number in the First FA %1 %2 field.';

    PROCEDURE SetFANo@1(NewFANo@1000 : Code[20]);
    BEGIN
      FANo2 := NewFANo;
    END;

    PROCEDURE InitializeRequest@2(NewFANo@1000 : Code[20];NewNumberofCopies@1001 : Integer;NewFirstFANo@1002 : Code[20];NewUseFANoSeries@1003 : Boolean);
    BEGIN
      NumberofCopies := NewNumberofCopies;
      FirstFANo := NewFirstFANo;
      UseFANoSeries := NewUseFANoSeries;
      FANo := NewFANo;
    END;

    [Integration]
    LOCAL PROCEDURE OnOpenRequestPage@3(FANo@1000 : Code[20];NumberofCopies@1001 : Integer;FirstFANo@1002 : Code[20];UseFANoSeries@1003 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}


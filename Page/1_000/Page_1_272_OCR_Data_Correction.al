OBJECT Page 1272 OCR Data Correction
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Korrektion af OCR-data;
               ENU=OCR Data Correction];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table130;
    PageType=Document;
    OnAfterGetRecord=BEGIN
                       TempOriginalIncomingDocument := Rec;
                     END;

    OnModifyRecord=BEGIN
                     "OCR Data Corrected" := TRUE;
                     MODIFY;
                     EXIT(FALSE)
                   END;

    ActionList=ACTIONS
    {
      { 31      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 32      ;1   ;Action    ;
                      Name=Reset OCR Data;
                      CaptionML=[DAN=Nulstil OCR-data;
                                 ENU=Reset OCR Data];
                      ToolTipML=[DAN=Fortryd rettelser, du har foretaget, siden du �bnede vinduet Korrektion af OCR-data.;
                                 ENU=Undo corrections that you have made since you opened the OCR Data Correction window.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reuse;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ResetOriginalOCRData
                               END;
                                }
      { 33      ;1   ;Action    ;
                      Name=Send OCR Feedback;
                      CaptionML=[DAN=Send OCR-feedback;
                                 ENU=Send OCR Feedback];
                      ToolTipML=[DAN=Send rettelserne til OCR-tjenesten. Rettelserne inkluderes i de PDF- eller billedfiler, der indeholder dataene, n�ste gang tjenesten k�res.;
                                 ENU=Send the corrections to the OCR service. The corrections will be included PDF or image files that contain the data the next time the service processes.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Undo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF UploadCorrectedOCRData THEN
                                   CurrPage.CLOSE;
                               END;
                                }
      { 34      ;1   ;Action    ;
                      Name=ShowFile;
                      CaptionML=[DAN=Vis fil;
                                 ENU=Show File];
                      ToolTipML=[DAN=�bn PDF- eller billedfilen for at se de rettelser, du har foretaget.;
                                 ENU=Open the PDF or image file to see the corrections that you have made.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Export;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowMainAttachment
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 35  ;1   ;Group     ;
                GroupType=Group }

    { 2   ;2   ;Group     ;
                GroupType=GridLayout }

    { 16  ;3   ;Group     ;
                GroupType=Group }

    { 3   ;4   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kreditoren p� det indg�ende bilag. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the name of the vendor on the incoming document. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Name";
                ShowMandatory=TRUE }

    { 4   ;4   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens momsnummer, hvis bilaget indeholder dette nummer. Feltet kan blive udfyldt automatisk.;
                           ENU=Specifies the VAT registration number of the vendor, if the document contains that number. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor VAT Registration No." }

    { 5   ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nye v�rdi, som du �nsker, at OCR-tjenesten fremad skal oprette for dette felt.;
                           ENU=Specifies the new value that you want the OCR service to produce for this field going forward.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor IBAN" }

    { 6   ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nye v�rdi, som du �nsker, at OCR-tjenesten fremad skal oprette for dette felt.;
                           ENU=Specifies the new value that you want the OCR service to produce for this field going forward.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Bank Branch No." }

    { 7   ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nye v�rdi, som du �nsker, at OCR-tjenesten fremad skal oprette for dette felt.;
                           ENU=Specifies the new value that you want the OCR service to produce for this field going forward.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Bank Account No." }

    { 36  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nye v�rdi, som du �nsker, at OCR-tjenesten fremad skal oprette for dette felt.;
                           ENU=Specifies the new value that you want the OCR service to produce for this field going forward.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Phone No." }

    { 8   ;4   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for det oprindelige bilag, du modtog fra kreditoren. Du kan kr�ve bilagsnummeret til bogf�ring, eller du kan lade det v�re valgfrit. Det er p�kr�vet som standard, s� dette bilag refererer til originalen. Det fjerner et trin fra bogf�ringsprocessen at g�re bilagsnumre valgfri. Hvis du f.eks. vedh�fter den oprindelige faktura som en PDF-fil, beh�ver du m�ske ikke at angive bilagsnummeret. I vinduet K�bsops�tning kan du v�lge, om bilagsnumre er p�kr�vet ved at v�lge eller rydde markeringen i afkrydsningsfeltet Eksternt bilagsnr. obl.;
                           ENU=Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it's required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Invoice No." }

    { 9   ;4   ;Field     ;
                CaptionML=[DAN=Kreditors ordrenr.;
                           ENU=Vendor Order No.];
                ToolTipML=[DAN=Angiver ordrenummeret, hvis bilaget indeholder dette nummer. Feltet kan blive udfyldt automatisk.;
                           ENU=Specifies the order number, if the document contains that number. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order No." }

    { 10  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, der fremg�r af det indg�ende bilag. Det kan f.eks. v�re den dato, hvor kreditoren oprettede fakturaen. Feltet bliver muligvis udfyldt automatisk.;
                           ENU=Specifies the date that is printed on the incoming document. This is the date when the vendor created the invoice, for example. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date" }

    { 11  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kreditorbilaget skal v�re betalt. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the date when the vendor document must be paid. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 12  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden, hvis bilaget indeholder denne kode. Feltet kan blive udfyldt automatisk.;
                           ENU=Specifies the currency code, if the document contains that code. The field may be filled automatically.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 13  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver bel�b inkl. moms for hele bilaget. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the amount including VAT for the whole document. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Incl. VAT" }

    { 14  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver bel�b ekskl. moms for hele bilaget. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the amount excluding VAT for the whole document. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Excl. VAT" }

    { 15  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver momsbel�bet, som er inkluderet i totalbel�bet.;
                           ENU=Specifies the amount of VAT that is included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Amount" }

    { 18  ;3   ;Group     ;
                GroupType=Group }

    { 17  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Vendor Name";
                Editable=FALSE }

    { 19  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Vendor VAT Registration No.";
                Editable=FALSE }

    { 20  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Vendor IBAN";
                Editable=FALSE }

    { 21  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Vendor Bank Branch No.";
                Editable=FALSE }

    { 22  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Vendor Bank Account No.";
                Editable=FALSE }

    { 37  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Vendor Phone No." }

    { 23  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Vendor Invoice No.";
                Editable=FALSE }

    { 24  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Order No.";
                Editable=FALSE }

    { 25  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Document Date";
                Editable=FALSE }

    { 26  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Due Date";
                Editable=FALSE }

    { 27  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Suite;
                SourceExpr=TempOriginalIncomingDocument."Currency Code";
                Editable=FALSE }

    { 28  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Amount Incl. VAT";
                Editable=FALSE }

    { 29  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."Amount Excl. VAT";
                Editable=FALSE }

    { 30  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver den nuv�rende v�rdi, som du �nsker, at OCR-tjenesten opretter for dette felt.;
                           ENU=Specifies the existing value that the OCR service produces for this field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TempOriginalIncomingDocument."VAT Amount";
                Editable=FALSE }

  }
  CODE
  {
    VAR
      TempOriginalIncomingDocument@1013 : TEMPORARY Record 130;

    BEGIN
    END.
  }
}


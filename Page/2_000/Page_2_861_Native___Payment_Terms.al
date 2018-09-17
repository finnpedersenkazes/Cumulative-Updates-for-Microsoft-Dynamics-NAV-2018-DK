OBJECT Page 2861 Native - Payment Terms
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@={Locked};
               DAN=nativePaymentTerms;
               ENU=nativePaymentTerms];
    SourceTable=Table3;
    DelayedInsert=Yes;
    PageType=List;
    OnOpenPage=VAR
                 O365PaymentTermsList@1000 : Page 2153;
               BEGIN
                 BINDSUBSCRIPTION(NativeAPILanguageHandler);
                 SETFILTER(Code,'<>%1',O365PaymentTermsList.ExcludedPaymentTermCode);
               END;

    OnAfterGetRecord=VAR
                       O365SalesInitialSetup@1000 : Record 2110;
                     BEGIN
                       Default := O365SalesInitialSetup.IsDefaultPaymentTerms(Rec);
                       DescriptionInCurrentLanguage := GetDescriptionInCurrentLanguage;
                     END;

    OnInsertRecord=VAR
                     PaymentTerms@1000 : Record 3;
                     O365SalesInitialSetup@1004 : Record 2110;
                     GraphMgtGeneralTools@1001 : Codeunit 5465;
                     RecRef@1002 : RecordRef;
                   BEGIN
                     PaymentTerms.SETRANGE(Code,Code);
                     IF NOT PaymentTerms.ISEMPTY THEN
                       INSERT;

                     INSERT(TRUE);

                     RecRef.GETTABLE(Rec);
                     GraphMgtGeneralTools.ProcessNewRecordFromAPI(RecRef,TempFieldSet,CURRENTDATETIME);
                     RecRef.SETTABLE(Rec);

                     MODIFY(TRUE);

                     IF IsDefaultSet THEN BEGIN
                       O365SalesInitialSetup.UpdateDefaultPaymentTerms(Code);
                       FIND;
                     END;

                     EXIT(FALSE);
                   END;

    OnModifyRecord=VAR
                     PaymentTerms@1000 : Record 3;
                     O365SalesInitialSetup@1002 : Record 2110;
                     GraphMgtGeneralTools@1001 : Codeunit 5465;
                   BEGIN
                     IF xRec.Id <> Id THEN
                       GraphMgtGeneralTools.ErrorIdImmutable;
                     PaymentTerms.SETRANGE(Id,Id);
                     PaymentTerms.FINDFIRST;

                     IF Code = PaymentTerms.Code THEN
                       MODIFY(TRUE)
                     ELSE BEGIN
                       PaymentTerms.TRANSFERFIELDS(Rec,FALSE);
                       PaymentTerms.RENAME(Code);
                       TRANSFERFIELDS(PaymentTerms,TRUE);
                     END;

                     IF IsDefaultSet THEN BEGIN
                       O365SalesInitialSetup.UpdateDefaultPaymentTerms(Code);
                       FIND;
                     END;
                   END;

    ODataKeyFields=Id;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 10  ;2   ;Field     ;
                Name=id;
                CaptionML=[@@@={Locked};
                           DAN=Id;
                           ENU=Id];
                ApplicationArea=#All;
                SourceExpr=Id }

    { 3   ;2   ;Field     ;
                Name=code;
                CaptionML=[@@@={Locked};
                           DAN=Code;
                           ENU=Code];
                ApplicationArea=#All;
                SourceExpr=Code;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO(Code));
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=displayName;
                CaptionML=[@@@={Locked};
                           DAN=DisplayName;
                           ENU=DisplayName];
                ToolTipML=[DAN=Angiver displayName.;
                           ENU=Specifies the displayName.];
                ApplicationArea=#All;
                SourceExpr=DescriptionInCurrentLanguage;
                OnValidate=BEGIN
                             IF DescriptionInCurrentLanguage <> GetDescriptionInCurrentLanguage THEN BEGIN
                               VALIDATE(Description,COPYSTR(DescriptionInCurrentLanguage,1,MAXSTRLEN(Description)));
                               RegisterFieldSet(FIELDNO(Description));
                             END;
                           END;
                            }

    { 4   ;2   ;Field     ;
                Name=dueDateCalculation;
                CaptionML=[@@@={Locked};
                           DAN=DueDateCalculation;
                           ENU=DueDateCalculation];
                ApplicationArea=#All;
                SourceExpr="Due Date Calculation";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Due Date Calculation"));
                           END;
                            }

    { 5   ;2   ;Field     ;
                Name=discountDateCalculation;
                CaptionML=[@@@={Locked};
                           DAN=DiscountDateCalculation;
                           ENU=DiscountDateCalculation];
                ApplicationArea=#All;
                SourceExpr="Discount Date Calculation";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Discount Date Calculation"));
                           END;
                            }

    { 6   ;2   ;Field     ;
                Name=discountPercent;
                CaptionML=[@@@={Locked};
                           DAN=DiscountPercent;
                           ENU=DiscountPercent];
                ApplicationArea=#All;
                SourceExpr="Discount %";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Discount %"));
                           END;
                            }

    { 8   ;2   ;Field     ;
                Name=calculateDiscountOnCreditMemos;
                CaptionML=[@@@={Locked};
                           DAN=CalcPmtDiscOnCreditMemos;
                           ENU=CalcPmtDiscOnCreditMemos];
                ApplicationArea=#All;
                SourceExpr="Calc. Pmt. Disc. on Cr. Memos";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Calc. Pmt. Disc. on Cr. Memos"));
                           END;
                            }

    { 9   ;2   ;Field     ;
                Name=lastModifiedDateTime;
                CaptionML=[@@@={Locked};
                           DAN=LastModifiedDateTime;
                           ENU=LastModifiedDateTime];
                ApplicationArea=#All;
                SourceExpr="Last Modified Date Time" }

    { 11  ;2   ;Field     ;
                Name=default;
                CaptionML=[DAN=standard;
                           ENU=default];
                ToolTipML=[DAN=Angiver, at betalingsbetingelserne er standarden.;
                           ENU=Specifies that the payment terms are the default.];
                ApplicationArea=#All;
                SourceExpr=Default;
                OnValidate=BEGIN
                             IF Default = FALSE THEN
                               ERROR(CannotSetDefaultToFalseErr);

                             IsDefaultSet := TRUE;
                           END;
                            }

  }
  CODE
  {
    VAR
      TempFieldSet@1000 : TEMPORARY Record 2000000041;
      NativeAPILanguageHandler@1004 : Codeunit 2850;
      Default@1001 : Boolean;
      CannotSetDefaultToFalseErr@1002 : TextConst 'DAN=Det er ikke muligt at angive standarden til falsk. V‘lg en anden betalingsbetingelse som standard.;ENU=It is not possible to set the default to false. Select a different Payment Term as a default.';
      IsDefaultSet@1003 : Boolean;
      DescriptionInCurrentLanguage@1005 : Text;

    LOCAL PROCEDURE RegisterFieldSet@11(FieldNo@1000 : Integer);
    BEGIN
      IF TempFieldSet.GET(DATABASE::"Payment Terms",FieldNo) THEN
        EXIT;

      TempFieldSet.INIT;
      TempFieldSet.TableNo := DATABASE::"Payment Terms";
      TempFieldSet.VALIDATE("No.",FieldNo);
      TempFieldSet.INSERT(TRUE);
    END;

    BEGIN
    END.
  }
}


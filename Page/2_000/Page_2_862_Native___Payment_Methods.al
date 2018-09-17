OBJECT Page 2862 Native - Payment Methods
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
               DAN=nativePaymentMethods;
               ENU=nativePaymentMethods];
    SourceTable=Table289;
    DelayedInsert=Yes;
    PageType=List;
    OnOpenPage=BEGIN
                 BINDSUBSCRIPTION(NativeAPILanguageHandler);
               END;

    OnAfterGetRecord=VAR
                       O365SalesInitialSetup@1000 : Record 2110;
                     BEGIN
                       Default := O365SalesInitialSetup.IsDefaultPaymentMethod(Rec);
                       DescriptionInCurrentLanguage := GetDescriptionInCurrentLanguage;
                     END;

    OnInsertRecord=VAR
                     PaymentMethod@1002 : Record 289;
                     O365SalesInitialSetup@1004 : Record 2110;
                     GraphMgtGeneralTools@1001 : Codeunit 5465;
                     RecRef@1000 : RecordRef;
                   BEGIN
                     PaymentMethod.SETRANGE(Code,Code);
                     IF NOT PaymentMethod.ISEMPTY THEN
                       INSERT;

                     INSERT(TRUE);

                     RecRef.GETTABLE(Rec);
                     GraphMgtGeneralTools.ProcessNewRecordFromAPI(RecRef,TempFieldSet,CURRENTDATETIME);
                     RecRef.SETTABLE(Rec);

                     MODIFY(TRUE);

                     IF IsDefaultSet THEN BEGIN
                       O365SalesInitialSetup.UpdateDefaultPaymentMethod(Code);
                       FIND;
                     END;

                     EXIT(FALSE);
                   END;

    OnModifyRecord=VAR
                     PaymentMethod@1001 : Record 289;
                     O365SalesInitialSetup@1002 : Record 2110;
                     GraphMgtGeneralTools@1000 : Codeunit 5465;
                   BEGIN
                     IF xRec.Id <> Id THEN
                       GraphMgtGeneralTools.ErrorIdImmutable;
                     PaymentMethod.SETRANGE(Id,Id);
                     PaymentMethod.FINDFIRST;

                     IF Code = PaymentMethod.Code THEN
                       MODIFY(TRUE)
                     ELSE BEGIN
                       PaymentMethod.TRANSFERFIELDS(Rec,FALSE);
                       PaymentMethod.RENAME(Code);
                       TRANSFERFIELDS(PaymentMethod);
                     END;

                     IF IsDefaultSet THEN BEGIN
                       O365SalesInitialSetup.UpdateDefaultPaymentMethod(Code);
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

    { 3   ;2   ;Field     ;
                Name=id;
                CaptionML=[@@@={Locked};
                           DAN=Id;
                           ENU=Id];
                ApplicationArea=#All;
                SourceExpr=Id }

    { 4   ;2   ;Field     ;
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

    { 5   ;2   ;Field     ;
                Name=displayName;
                CaptionML=[@@@={Locked};
                           DAN=Description;
                           ENU=Description];
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

    { 7   ;2   ;Field     ;
                Name=default;
                CaptionML=[DAN=standard;
                           ENU=default];
                ToolTipML=[DAN=Angiver, at betalingsmetoderne er standarden.;
                           ENU=Specifies that the payment methods are the default.];
                ApplicationArea=#All;
                SourceExpr=Default;
                OnValidate=BEGIN
                             IF NOT Default THEN
                               ERROR(CannotSetDefaultToFalseErr);

                             IsDefaultSet := TRUE;
                           END;
                            }

    { 6   ;2   ;Field     ;
                Name=lastModifiedDateTime;
                CaptionML=[@@@={Locked};
                           DAN=LastModifiedDateTime;
                           ENU=LastModifiedDateTime];
                ApplicationArea=#All;
                SourceExpr="Last Modified Date Time" }

  }
  CODE
  {
    VAR
      TempFieldSet@1000 : TEMPORARY Record 2000000041;
      NativeAPILanguageHandler@1005 : Codeunit 2850;
      DescriptionInCurrentLanguage@1004 : Text;
      Default@1001 : Boolean;
      CannotSetDefaultToFalseErr@1002 : TextConst 'DAN=Det er ikke muligt at angive standarden til falsk. V‘lg en anden betalingsmetode som standard.;ENU=It is not possible to set the default to false. Select a different Payment Method as a default.';
      IsDefaultSet@1003 : Boolean;

    LOCAL PROCEDURE RegisterFieldSet@11(FieldNo@1000 : Integer);
    BEGIN
      IF TempFieldSet.GET(DATABASE::"Payment Method",FieldNo) THEN
        EXIT;

      TempFieldSet.INIT;
      TempFieldSet.TableNo := DATABASE::"Payment Method";
      TempFieldSet.VALIDATE("No.",FieldNo);
      TempFieldSet.INSERT(TRUE);
    END;

    BEGIN
    END.
  }
}


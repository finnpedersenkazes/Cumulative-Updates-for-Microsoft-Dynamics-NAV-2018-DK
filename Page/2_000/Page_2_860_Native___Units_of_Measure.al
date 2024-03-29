OBJECT Page 2860 Native - Units of Measure
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
               DAN=nativeInvoicingUnitsOfMeasure;
               ENU=nativeInvoicingUnitsOfMeasure];
    SourceTable=Table204;
    DelayedInsert=Yes;
    PageType=List;
    OnOpenPage=BEGIN
                 BINDSUBSCRIPTION(NativeAPILanguageHandler);
               END;

    OnAfterGetRecord=BEGIN
                       DescriptionInCurrentLanguage := GetDescriptionInCurrentLanguage;
                     END;

    OnInsertRecord=VAR
                     GraphMgtGeneralTools@1000 : Codeunit 5465;
                     RecRef@1001 : RecordRef;
                   BEGIN
                     INSERT(TRUE);

                     RecRef.GETTABLE(Rec);
                     GraphMgtGeneralTools.ProcessNewRecordFromAPI(RecRef,TempFieldSet,CURRENTDATETIME);
                     RecRef.SETTABLE(Rec);

                     EXIT(FALSE);
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

    { 6   ;2   ;Field     ;
                Name=id;
                CaptionML=[@@@={Locked};
                           DAN=id;
                           ENU=id];
                ApplicationArea=#All;
                SourceExpr=Id }

    { 3   ;2   ;Field     ;
                Name=code;
                CaptionML=[@@@={Locked};
                           DAN=code;
                           ENU=code];
                ApplicationArea=#All;
                SourceExpr=Code;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO(Code));
                           END;
                            }

    { 4   ;2   ;Field     ;
                Name=displayName;
                CaptionML=[@@@={Locked};
                           DAN=displayName;
                           ENU=displayName];
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

    { 5   ;2   ;Field     ;
                Name=internationalStandardCode;
                CaptionML=[@@@={Locked};
                           DAN=internationalStandardCode;
                           ENU=internationalStandardCode];
                ApplicationArea=#All;
                SourceExpr="International Standard Code";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("International Standard Code"));
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=lastModifiedDateTime;
                CaptionML=[@@@={Locked};
                           DAN=lastModifiedDateTime;
                           ENU=lastModifiedDateTime];
                ApplicationArea=#All;
                SourceExpr="Last Modified Date Time" }

  }
  CODE
  {
    VAR
      TempFieldSet@1000 : TEMPORARY Record 2000000041;
      NativeAPILanguageHandler@1001 : Codeunit 2850;
      DescriptionInCurrentLanguage@1002 : Text;

    LOCAL PROCEDURE RegisterFieldSet@11(FieldNo@1000 : Integer);
    BEGIN
      IF TempFieldSet.GET(DATABASE::"Unit of Measure",FieldNo) THEN
        EXIT;

      TempFieldSet.INIT;
      TempFieldSet.TableNo := DATABASE::"Unit of Measure";
      TempFieldSet.VALIDATE("No.",FieldNo);
      TempFieldSet.INSERT(TRUE);
    END;

    BEGIN
    END.
  }
}


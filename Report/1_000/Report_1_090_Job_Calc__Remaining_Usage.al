OBJECT Report 1090 Job Calc. Remaining Usage
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Beregn resterende forbrug for sag;
               ENU=Job Calc. Remaining Usage];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  JobCalcBatches.BatchError(PostingDate,DocNo);
                  JobCalcBatches.InitDiffBuffer;
                END;

    OnPostReport=BEGIN
                   JobCalcBatches.PostDiffBuffer(DocNo,PostingDate,TemplateName,BatchName);
                 END;

  }
  DATASET
  {
    { 2969;    ;DataItem;                    ;
               DataItemTable=Table1001;
               DataItemTableView=SORTING(Job No.,Job Task No.);
               ReqFilterFields=Job No.,Job Task No. }

    { 9714;1   ;DataItem;                    ;
               DataItemTable=Table1003;
               DataItemTableView=SORTING(Job No.,Job Task No.,Line No.);
               OnAfterGetRecord=BEGIN
                                  IF ("Job No." <> '') AND ("Job Task No." <> '') THEN
                                    JobCalcBatches.CreateJT("Job Planning Line");
                                END;

               ReqFilterFields=Type,No.,Planning Date,Currency Date,Location Code,Variant Code,Work Type Code;
               DataItemLink=Job No.=FIELD(Job No.),
                            Job Task No.=FIELD(Job Task No.) }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   TemplateName := TemplateName3;
                   BatchName := BatchName3;
                   DocNo := DocNo2;
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
                  Name=DocumentNo;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver nummeret p� det bilag, som beregningen g�lder for.;
                             ENU=Specifies the number of a document that the calculation will apply to.];
                  ApplicationArea=#Jobs;
                  SourceExpr=DocNo }

      { 3   ;2   ;Field     ;
                  Name=PostingDate;
                  CaptionML=[DAN=Bogf�ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver bogf�ringsdatoen for bilaget.;
                             ENU=Specifies the posting date for the document.];
                  ApplicationArea=#Jobs;
                  SourceExpr=PostingDate }

      { 5   ;2   ;Field     ;
                  Lookup=No;
                  CaptionML=[DAN=Typenavn;
                             ENU=Template Name];
                  ToolTipML=[DAN=Angiver skabelonnavnet for den sagskladde, hvor det resterende forbrug inds�ttes som linjer.;
                             ENU=Specifies the template name of the job journal where the remaining usage is inserted as lines.];
                  ApplicationArea=#Jobs;
                  SourceExpr=TemplateName;
                  TableRelation="Gen. Journal Template";
                  Editable=FALSE;
                  OnValidate=BEGIN
                               IF TemplateName = '' THEN BEGIN
                                 BatchName := '';
                                 EXIT;
                               END;
                               GenJnlTemplate.GET(TemplateName);
                               IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Jobs THEN BEGIN
                                 GenJnlTemplate.Type := GenJnlTemplate.Type::Jobs;
                                 ERROR(Text001,
                                   GenJnlTemplate.TABLECAPTION,GenJnlTemplate.FIELDCAPTION(Type),GenJnlTemplate.Type);
                               END;
                             END;
                              }

      { 7   ;2   ;Field     ;
                  Lookup=No;
                  CaptionML=[DAN=Kladdenavn;
                             ENU=Batch Name];
                  ToolTipML=[DAN=Angiver navnet p� den kladdek�rsel, et personligt kladdelayout, som kladden er baseret p�.;
                             ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                  ApplicationArea=#Jobs;
                  SourceExpr=BatchName;
                  Editable=FALSE;
                  OnValidate=BEGIN
                               JobJnlManagement.CheckName(BatchName,JobJnlLine);
                             END;

                  OnLookup=BEGIN
                             IF TemplateName = '' THEN
                               ERROR(Text000,JobJnlLine.FIELDCAPTION("Journal Template Name"));
                             JobJnlLine."Journal Template Name" := TemplateName;
                             JobJnlLine.FILTERGROUP := 2;
                             JobJnlLine.SETRANGE("Journal Template Name",TemplateName);
                             JobJnlLine.SETRANGE("Journal Batch Name",BatchName);
                             JobJnlManagement.LookupName(BatchName,JobJnlLine);
                             JobJnlManagement.CheckName(BatchName,JobJnlLine);
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
      GenJnlTemplate@1010 : Record 80;
      JobJnlLine@1009 : Record 210;
      JobCalcBatches@1000 : Codeunit 1005;
      JobJnlManagement@1008 : Codeunit 1020;
      DocNo@1001 : Code[20];
      DocNo2@1005 : Code[20];
      PostingDate@1002 : Date;
      TemplateName@1003 : Code[10];
      BatchName@1004 : Code[10];
      TemplateName3@1007 : Code[10];
      BatchName3@1006 : Code[10];
      Text000@1013 : TextConst 'DAN=Du skal indtaste %1.;ENU=You must specify %1.';
      Text001@1012 : TextConst 'DAN=%1 %2 skal v�re %3.;ENU=%1 %2 must be %3.';

    [External]
    PROCEDURE SetBatch@1(TemplateName2@1000 : Code[10];BatchName2@1001 : Code[10]);
    BEGIN
      TemplateName3 := TemplateName2;
      BatchName3 := BatchName2;
    END;

    [External]
    PROCEDURE SetDocNo@2(InputDocNo@1000 : Code[20]);
    BEGIN
      DocNo2 := InputDocNo;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}


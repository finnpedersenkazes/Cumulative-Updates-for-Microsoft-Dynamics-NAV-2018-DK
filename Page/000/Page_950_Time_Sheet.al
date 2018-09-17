OBJECT Page 950 Time Sheet
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Timeseddel;
               ENU=Time Sheet];
    SaveValues=Yes;
    SourceTable=Table951;
    DataCaptionFields=Time Sheet No.;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Naviger,Linjer;
                                ENU=New,Process,Report,Navigate,Lines];
    OnOpenPage=BEGIN
                 IF "Time Sheet No." <> '' THEN
                   CurrTimeSheetNo := "Time Sheet No."
                 ELSE
                   CurrTimeSheetNo := TimeSheetHeader.FindLastTimeSheetNo(TimeSheetHeader.FIELDNO("Owner User ID"));

                 TimeSheetMgt.SetTimeSheetNo(CurrTimeSheetNo,Rec);
                 UpdateControls;
               END;

    OnAfterGetRecord=BEGIN
                       AfterGetCurrentRecord;
                     END;

    OnNewRecord=BEGIN
                  AfterGetCurrentRecord;
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 34      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Timeseddel;
                                 ENU=&Time Sheet];
                      Image=Timesheet }
      { 7       ;2   ;Action    ;
                      Name=PreviousPeriod;
                      ShortCutKey=Ctrl+PgUp;
                      CaptionML=[DAN=&Forrige periode;
                                 ENU=&Previous Period];
                      ToolTipML=[DAN=FÜ vist oplysningerne baseret pÜ den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen fõr.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FindTimeSheet(SetWanted::Previous);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=NextPeriod;
                      ShortCutKey=Ctrl+PgDn;
                      CaptionML=[DAN=&Nëste periode;
                                 ENU=&Next Period];
                      ToolTipML=[DAN=FÜ vist oplysninger for den nëste periode.;
                                 ENU=View information for the next period.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FindTimeSheet(SetWanted::Next);
                               END;
                                }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Allokering af timeseddel;
                                 ENU=Time Sheet Allocation];
                      ToolTipML=[DAN=Tildel bogfõrte timer til ugens dage pÜ en timeseddel.;
                                 ENU=Allocate posted hours among days of the week on a time sheet.];
                      ApplicationArea=#Jobs;
                      Image=Allocate;
                      OnAction=BEGIN
                                 TimeAllocation;
                               END;
                                }
      { 37      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Aktivitets&detaljer;
                                 ENU=Activity &Details];
                      ToolTipML=[DAN=Vis antallet af timer for hver timeseddelstatus.;
                                 ENU=View the quantity of hours for each time sheet status.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 ShowLineDetails(FALSE);
                               END;
                                }
      { 38      ;1   ;ActionGroup;
                      Name=Comments;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      Image=ViewComments }
      { 39      ;2   ;Action    ;
                      Name=TimeSheetComments;
                      CaptionML=[DAN=&Bemërkninger til timeseddel;
                                 ENU=&Time Sheet Comments];
                      ToolTipML=[DAN=Vis bemërkninger til timesedlen.;
                                 ENU=View comments about the time sheet.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 955;
                      RunPageLink=No.=FIELD(Time Sheet No.),
                                  Time Sheet Line No.=CONST(0);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category5 }
      { 40      ;2   ;Action    ;
                      Name=LineComments;
                      CaptionML=[DAN=&Linjebemërkninger;
                                 ENU=&Line Comments];
                      ToolTipML=[DAN=Vis eller opret bemërkninger.;
                                 ENU=View or create comments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 955;
                      RunPageLink=No.=FIELD(Time Sheet No.),
                                  Time Sheet Line No.=FIELD(Line No.);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category5;
                      Scope=Repeater }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 35      ;2   ;Action    ;
                      Name=Submit;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Send;
                                 ENU=&Submit];
                      ToolTipML=[DAN=Send timesedlen til godkendelse.;
                                 ENU=Submit the time sheet for approval.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Submit;
                               END;
                                }
      { 46      ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=&Reopen];
                      ToolTipML=[DAN=èbn timesedlen igen, f.eks. efter den er blevet afvist. Godkenderen af timesedlen har tilladelse til at godkende, afvise eller genÜbne en timeseddel. Godkenderen kan ogsÜ sende en timeseddel til godkendelse.;
                                 ENU=Reopen the time sheet, for example, after it has been rejected. The approver of a time sheet has permission to approve, reject, or reopen a time sheet. The approver can also submit a time sheet for approval.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Reopen;
                               END;
                                }
      { 28      ;2   ;Separator  }
      { 30      ;2   ;Action    ;
                      Name=CopyLinesFromPrevTS;
                      CaptionML=[DAN=&KopiÇr linjer fra en tidligere timeseddel;
                                 ENU=&Copy lines from previous time sheet];
                      ToolTipML=[DAN=Kopier oplysninger fra den tidligere timeseddel, f.eks. type og beskrivelse, og rediger derefter linjerne. Hvis en linje er relateret til en sag, kopieres sagsnummeret.;
                                 ENU=Copy information from the previous time sheet, such as type and description, and then modify the lines. If a line is related to a job, the job number is copied.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=Copy;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 QtyToBeCopied@1001 : Integer;
                               BEGIN
                                 QtyToBeCopied := TimeSheetMgt.CalcPrevTimeSheetLines(TimeSheetHeader);
                                 IF QtyToBeCopied = 0 THEN
                                   MESSAGE(Text004)
                                 ELSE
                                   IF CONFIRM(Text009,TRUE,QtyToBeCopied) THEN
                                     TimeSheetMgt.CopyPrevTimeSheetLines(TimeSheetHeader);
                               END;
                                }
      { 31      ;2   ;Action    ;
                      Name=CreateLinesFromJobPlanning;
                      CaptionML=[DAN=Opret linjer fra &sagsplanlëgning;
                                 ENU=Create lines from &job planning];
                      ToolTipML=[DAN=Opret timeseddellinjer, der er baseret pÜ sagsplanlëgningslinjer.;
                                 ENU=Create time sheet lines that are based on job planning lines.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=CreateLinesFromJob;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 QtyToBeCreated@1001 : Integer;
                               BEGIN
                                 QtyToBeCreated := TimeSheetMgt.CalcLinesFromJobPlanning(TimeSheetHeader);
                                 IF QtyToBeCreated = 0 THEN
                                   MESSAGE(Text003)
                                 ELSE
                                   IF CONFIRM(Text010,TRUE,QtyToBeCreated) THEN
                                     TimeSheetMgt.CreateLinesFromJobPlanning(TimeSheetHeader);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 26  ;1   ;Group     ;
                GroupType=Group }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Timeseddelnr.;
                           ENU=Time Sheet No];
                ToolTipML=[DAN=Angiver nummeret pÜ timesedlen.;
                           ENU=Specifies the number of the time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr=CurrTimeSheetNo;
                OnValidate=BEGIN
                             TimeSheetHeader.RESET;
                             TimeSheetMgt.FilterTimeSheets(TimeSheetHeader,TimeSheetHeader.FIELDNO("Owner User ID"));
                             TimeSheetMgt.CheckTimeSheetNo(TimeSheetHeader,CurrTimeSheetNo);
                             CurrPage.SAVERECORD;
                             TimeSheetMgt.SetTimeSheetNo(CurrTimeSheetNo,Rec);
                             UpdateControls;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           TimeSheetMgt.LookupOwnerTimeSheet(CurrTimeSheetNo,Rec,TimeSheetHeader);
                           UpdateControls;
                         END;
                          }

    { 14  ;2   ;Field     ;
                Name=ResourceNo;
                CaptionML=[DAN=Ressourcenr.;
                           ENU=Resource No.];
                ToolTipML=[DAN=Angiver et nummer til ressourcen.;
                           ENU=Specifies a number for the resource.];
                ApplicationArea=#Jobs;
                SourceExpr=TimeSheetHeader."Resource No.";
                Editable=false }

    { 16  ;2   ;Field     ;
                Name=ApproverUserID;
                CaptionML=[DAN=Bruger-id pÜ godkender;
                           ENU=Approver User ID];
                ToolTipML=[DAN=Angiver id'et for timeseddelgodkenderen.;
                           ENU=Specifies the ID of the time sheet approver.];
                ApplicationArea=#Jobs;
                SourceExpr=TimeSheetHeader."Approver User ID";
                Visible=FALSE;
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                Name=StartingDate;
                CaptionML=[DAN=Startdato;
                           ENU=Starting Date];
                ToolTipML=[DAN=Angiver den dato, som rapporten eller kõrslen behandler oplysninger fra.;
                           ENU=Specifies the date from which the report or batch job processes information.];
                ApplicationArea=#Jobs;
                SourceExpr=TimeSheetHeader."Starting Date";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                Name=EndingDate;
                CaptionML=[DAN=Slutdato;
                           ENU=Ending Date];
                ToolTipML=[DAN=Angiver den dato, som rapporten eller kõrslen behandler oplysninger frem til.;
                           ENU=Specifies the date to which the report or batch job processes information.];
                ApplicationArea=#Jobs;
                SourceExpr=TimeSheetHeader."Ending Date";
                Editable=FALSE }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for timeseddellinjen.;
                           ENU=Specifies the type of time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr=Type;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             AfterGetCurrentRecord;
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den sag, som er knyttet til timeseddellinjen.;
                           ENU=Specifies the number for the job that is associated with the time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No.";
                Visible=FALSE;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af timeseddellinjen.;
                           ENU=Specifies a description of the time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr=Description;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;

                OnAssistEdit=BEGIN
                               IF "Line No." = 0 THEN
                                 EXIT;

                               ShowLineDetails(FALSE);
                               CurrPage.UPDATE(FALSE);
                             END;
                              }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en liste over standardfravërskoder, hvor du kan vëlge en kode.;
                           ENU=Specifies a list of standard absence codes, from which you may select one.];
                ApplicationArea=#Jobs;
                SourceExpr="Cause of Absence Code";
                Visible=FALSE;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om det forbrug, du bogfõrer, kan faktureres.;
                           ENU=Specifies if the usage that you are posting is chargeable.];
                ApplicationArea=#Jobs;
                SourceExpr=Chargeable;
                Visible=FALSE;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen udlignes med. Priserne opdateres ud fra denne post.;
                           ENU=Specifies which work type the resource applies to. Prices are updated based on this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code";
                Visible=FALSE;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serviceordrenummer, der er tilknyttet timeseddellinjen.;
                           ENU=Specifies the service order number that is associated with the time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr="Service Order No.";
                Visible=FALSE;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det montageordrenummer, der er tilknyttet timeseddellinjen.;
                           ENU=Specifies the assembly order number that is associated with the time sheet line.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembly Order No.";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                Name=Field1;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[1];
                CaptionClass='3,' + ColumnCaption[1];
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             ValidateQuantity(1);
                             CellDataOnAfterValidate;
                           END;
                            }

    { 15  ;2   ;Field     ;
                Name=Field2;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[2];
                CaptionClass='3,' + ColumnCaption[2];
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             ValidateQuantity(2);
                             CellDataOnAfterValidate;
                           END;
                            }

    { 17  ;2   ;Field     ;
                Name=Field3;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[3];
                CaptionClass='3,' + ColumnCaption[3];
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             ValidateQuantity(3);
                             CellDataOnAfterValidate;
                           END;
                            }

    { 19  ;2   ;Field     ;
                Name=Field4;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[4];
                CaptionClass='3,' + ColumnCaption[4];
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             ValidateQuantity(4);
                             CellDataOnAfterValidate;
                           END;
                            }

    { 21  ;2   ;Field     ;
                Name=Field5;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[5];
                CaptionClass='3,' + ColumnCaption[5];
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             ValidateQuantity(5);
                             CellDataOnAfterValidate;
                           END;
                            }

    { 25  ;2   ;Field     ;
                Name=Field6;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[6];
                CaptionClass='3,' + ColumnCaption[6];
                Visible=FALSE;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             ValidateQuantity(6);
                             CellDataOnAfterValidate;
                           END;
                            }

    { 27  ;2   ;Field     ;
                Name=Field7;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[7];
                CaptionClass='3,' + ColumnCaption[7];
                Visible=FALSE;
                Editable=AllowEdit;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             ValidateQuantity(7);
                             CellDataOnAfterValidate;
                           END;
                            }

    { 48  ;2   ;Field     ;
                DrillDown=No;
                CaptionML=[DAN=I alt;
                           ENU=Total];
                ToolTipML=[DAN=Angiver det samlede antal timer, der er angivet pÜ en timeseddel.;
                           ENU=Specifies the total number of hours that have been entered on a time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Quantity";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om status for en timeseddellinje.;
                           ENU=Specifies information about the status of a time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr=Status }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 12  ;1   ;Part      ;
                Name=TimeSheetStatusFactBox;
                CaptionML=[DAN=Timeseddelstatus;
                           ENU=Time Sheet Status];
                ApplicationArea=#Jobs;
                PagePartID=Page957;
                PartType=Page }

    { 1905767507;1;Part   ;
                Name=ActualSchedSummaryFactBox;
                CaptionML=[DAN=Faktisk/budgetteret oversigt;
                           ENU=Actual/Budgeted Summary];
                ApplicationArea=#Jobs;
                PagePartID=Page956;
                Visible=TRUE;
                PartType=Page }

    { 32  ;1   ;Part      ;
                Name=ActivityDetailsFactBox;
                CaptionML=[DAN=Aktivitetsdetaljer;
                           ENU=Activity Details];
                ApplicationArea=#Jobs;
                SubPageLink=Time Sheet No.=FIELD(Time Sheet No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page971;
                PartType=Page }

  }
  CODE
  {
    VAR
      TimeSheetHeader@1006 : Record 950;
      TimeSheetDetail@1003 : Record 952;
      ColumnRecords@1004 : ARRAY [32] OF Record 2000000007;
      TimeSheetMgt@1007 : Codeunit 950;
      TimeSheetApprovalMgt@1005 : Codeunit 951;
      NoOfColumns@1002 : Integer;
      CellData@1001 : ARRAY [32] OF Decimal;
      ColumnCaption@1000 : ARRAY [32] OF Text[1024];
      CurrTimeSheetNo@1008 : Code[20];
      SetWanted@1009 : 'Previous,Next';
      Text001@1010 : TextConst 'DAN=Typen af timeseddellinje mÜ ikke vëre tom.;ENU=The type of time sheet line cannot be empty.';
      Text003@1014 : TextConst 'DAN=Der blev ikke fundet sagsplanlëgningslinjer.;ENU=Could not find job planning lines.';
      Text004@1015 : TextConst 'DAN=Der er ingen timeseddellinjer at kopiere.;ENU=There are no time sheet lines to copy.';
      Text009@1018 : TextConst 'DAN=Vil du kopiere linjer fra den forrige timeseddel (%1)?;ENU=Do you want to copy lines from the previous time sheet (%1)?';
      Text010@1019 : TextConst 'DAN=Vil du oprette linjer ud fra sagsplanlëgning (%1)?;ENU=Do you want to create lines from job planning (%1)?';
      AllowEdit@1011 : Boolean;

    [Internal]
    PROCEDURE SetColumns@11();
    VAR
      Calendar@1003 : Record 2000000007;
    BEGIN
      CLEAR(ColumnCaption);
      CLEAR(ColumnRecords);
      CLEAR(Calendar);
      CLEAR(NoOfColumns);

      TimeSheetHeader.GET(CurrTimeSheetNo);
      Calendar.SETRANGE("Period Type",Calendar."Period Type"::Date);
      Calendar.SETRANGE("Period Start",TimeSheetHeader."Starting Date",TimeSheetHeader."Ending Date");
      IF Calendar.FINDSET THEN
        REPEAT
          NoOfColumns += 1;
          ColumnRecords[NoOfColumns]."Period Start" := Calendar."Period Start";
          ColumnCaption[NoOfColumns] := TimeSheetMgt.FormatDate(Calendar."Period Start",1);
        UNTIL Calendar.NEXT = 0;
    END;

    LOCAL PROCEDURE AfterGetCurrentRecord@8();
    VAR
      i@1000 : Integer;
    BEGIN
      i := 0;
      WHILE i < NoOfColumns DO BEGIN
        i := i + 1;
        IF ("Line No." <> 0) AND TimeSheetDetail.GET(
             "Time Sheet No.",
             "Line No.",
             ColumnRecords[i]."Period Start")
        THEN
          CellData[i] := TimeSheetDetail.Quantity
        ELSE
          CellData[i] := 0;
      END;
      UpdateFactBoxes;
      AllowEdit := Status IN [Status::Open,Status::Rejected];
    END;

    LOCAL PROCEDURE ValidateQuantity@1(ColumnNo@1000 : Integer);
    BEGIN
      IF (CellData[ColumnNo] <> 0) AND (Type = Type::" ") THEN
        ERROR(Text001);

      IF TimeSheetDetail.GET(
           "Time Sheet No.",
           "Line No.",
           ColumnRecords[ColumnNo]."Period Start")
      THEN BEGIN
        IF CellData[ColumnNo] <> TimeSheetDetail.Quantity THEN
          TestTimeSheetLineStatus;

        IF CellData[ColumnNo] = 0 THEN
          TimeSheetDetail.DELETE
        ELSE BEGIN
          TimeSheetDetail.Quantity := CellData[ColumnNo];
          TimeSheetDetail.MODIFY(TRUE);
        END;
      END ELSE
        IF CellData[ColumnNo] <> 0 THEN BEGIN
          TestTimeSheetLineStatus;

          TimeSheetDetail.INIT;
          TimeSheetDetail.CopyFromTimeSheetLine(Rec);
          TimeSheetDetail.Date := ColumnRecords[ColumnNo]."Period Start";
          TimeSheetDetail.Quantity := CellData[ColumnNo];
          TimeSheetDetail.INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE Process@4(Action@1000 : 'Submit Selected,Submit All,Reopen Selected,Reopen All');
    VAR
      TimeSheetLine@1001 : Record 951;
      ActionType@1002 : 'Submit,Reopen';
    BEGIN
      CurrPage.SAVERECORD;
      CASE Action OF
        Action::"Submit All":
          FilterAllLines(TimeSheetLine,ActionType::Submit);
        Action::"Reopen All":
          FilterAllLines(TimeSheetLine,ActionType::Reopen);
        ELSE
          CurrPage.SETSELECTIONFILTER(TimeSheetLine);
      END;
      IF TimeSheetLine.FINDSET THEN
        REPEAT
          CASE Action OF
            Action::"Submit Selected",
            Action::"Submit All":
              TimeSheetApprovalMgt.Submit(TimeSheetLine);
            Action::"Reopen Selected",
            Action::"Reopen All":
              TimeSheetApprovalMgt.ReopenSubmitted(TimeSheetLine);
          END;
        UNTIL TimeSheetLine.NEXT = 0;
      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE CellDataOnAfterValidate@6();
    BEGIN
      UpdateFactBoxes;
      CALCFIELDS("Total Quantity");
    END;

    LOCAL PROCEDURE FindTimeSheet@7(Which@1000 : Option);
    BEGIN
      CurrTimeSheetNo := TimeSheetMgt.FindTimeSheet(TimeSheetHeader,Which);
      TimeSheetMgt.SetTimeSheetNo(CurrTimeSheetNo,Rec);
      UpdateControls;
    END;

    LOCAL PROCEDURE UpdateFactBoxes@9();
    BEGIN
      CurrPage.ActualSchedSummaryFactBox.PAGE.UpdateData(TimeSheetHeader);
      CurrPage.TimeSheetStatusFactBox.PAGE.UpdateData(TimeSheetHeader);
      IF "Line No." = 0 THEN
        CurrPage.ActivityDetailsFactBox.PAGE.SetEmptyLine;
    END;

    LOCAL PROCEDURE UpdateControls@12();
    BEGIN
      SetColumns;
      UpdateFactBoxes;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE TestTimeSheetLineStatus@10();
    VAR
      TimeSheetLine@1000 : Record 951;
    BEGIN
      TimeSheetLine.GET("Time Sheet No.","Line No.");
      TimeSheetLine.TestStatus;
    END;

    LOCAL PROCEDURE Submit@2();
    VAR
      Action@1001 : 'Submit Selected,Submit All,Reopen Selected,Reopen All';
      ActionType@1002 : 'Submit,Reopen';
    BEGIN
      CASE ShowDialog(ActionType::Submit) OF
        1:
          Process(Action::"Submit All");
        2:
          Process(Action::"Submit Selected");
      END;
    END;

    LOCAL PROCEDURE Reopen@14();
    VAR
      ActionType@1002 : 'Submit,Reopen';
      Action@1001 : 'Submit Selected,Submit All,Reopen Selected,Reopen All';
    BEGIN
      CASE ShowDialog(ActionType::Reopen) OF
        1:
          Process(Action::"Reopen All");
        2:
          Process(Action::"Reopen Selected");
      END;
    END;

    LOCAL PROCEDURE TimeAllocation@3();
    VAR
      TimeSheetAllocation@1000 : Page 970;
      AllocatedQty@1002 : ARRAY [7] OF Decimal;
    BEGIN
      TESTFIELD(Posted,TRUE);
      CALCFIELDS("Total Quantity");
      TimeSheetAllocation.InitParameters("Time Sheet No.","Line No.","Total Quantity");
      IF TimeSheetAllocation.RUNMODAL = ACTION::OK THEN BEGIN
        TimeSheetAllocation.GetAllocation(AllocatedQty);
        TimeSheetMgt.UpdateTimeAllocation(Rec,AllocatedQty);
      END;
    END;

    LOCAL PROCEDURE GetDialogText@16(ActionType@1000 : 'Submit,Reopen') : Text[100];
    VAR
      TimeSheetLine@1003 : Record 951;
    BEGIN
      FilterAllLines(TimeSheetLine,ActionType);
      EXIT(TimeSheetApprovalMgt.GetTimeSheetDialogText(ActionType,TimeSheetLine.COUNT));
    END;

    LOCAL PROCEDURE FilterAllLines@22(VAR TimeSheetLine@1000 : Record 951;ActionType@1001 : 'Submit,Reopen');
    BEGIN
      TimeSheetLine.SETRANGE("Time Sheet No.",CurrTimeSheetNo);
      TimeSheetLine.COPYFILTERS(Rec);
      TimeSheetLine.FILTERGROUP(2);
      TimeSheetLine.SETFILTER(Type,'<>%1',TimeSheetLine.Type::" ");
      TimeSheetLine.FILTERGROUP(0);
      CASE ActionType OF
        ActionType::Submit:
          TimeSheetLine.SETFILTER(Status,'%1|%2',TimeSheetLine.Status::Open,TimeSheetLine.Status::Rejected);
        ActionType::Reopen:
          TimeSheetLine.SETRANGE(Status,TimeSheetLine.Status::Submitted);
      END;
    END;

    LOCAL PROCEDURE ShowDialog@5(ActionType@1001 : 'Submit,Reopen') : Integer;
    BEGIN
      EXIT(STRMENU(GetDialogText(ActionType),1,TimeSheetApprovalMgt.GetTimeSheetDialogInstruction(ActionType)));
    END;

    BEGIN
    END.
  }
}


OBJECT Page 99000771 Work Ctr. Group Calendar
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Arbejdscentergruppekalender;
               ENU=Work Ctr. Group Calendar];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table99000756;
    DataCaptionExpr='';
    PageType=Card;
    OnOpenPage=BEGIN
                 MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                 MATRIX_UseNameForCaption := FALSE;
                 MATRIX_CurrentSetLenght := ARRAYLEN(MATRIX_CaptionSet);
                 MfgSetup.GET;
                 MfgSetup.TESTFIELD("Show Capacity In");
                 CapacityUoM := MfgSetup."Show Capacity In";
               END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 77      ;1   ;Action    ;
                      Name=ShowMatrix;
                      CaptionML=[DAN=Vi&s matrix;
                                 ENU=&Show Matrix];
                      ToolTipML=[DAN=Vis dataoversigten i henhold til de valgte filtre og indstillinger.;
                                 ENU=View the data overview according to the selected filters and options.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ShowMatrix;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 MatrixForm@1090 : Page 9295;
                               BEGIN
                                 CLEAR(MatrixForm);
                                 MatrixForm.Load(MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentSetLenght,CapacityUoM);
                                 MatrixForm.SETTABLEVIEW(Rec);
                                 MatrixForm.RUNMODAL;
                               END;
                                }
      { 1102    ;1   ;Action    ;
                      CaptionML=[DAN=Forrige s�t;
                                 ENU=Previous Set];
                      ToolTipML=[DAN=G� til det forrige datas�t.;
                                 ENU=Go to the previous set of data.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_SerWanted::Previus);
                               END;
                                }
      { 1104    ;1   ;Action    ;
                      CaptionML=[DAN=N�ste s�t;
                                 ENU=Next Set];
                      ToolTipML=[DAN=G� til det n�ste datas�t.;
                                 ENU=Go to the next set of data.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MATRIX_GenerateColumnCaptions(MATRIX_SerWanted::Next);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 13  ;1   ;Group     ;
                CaptionML=[DAN=Matrixindstillinger;
                           ENU=Matrix Options] }

    { 1099;2   ;Field     ;
                CaptionML=[DAN=Vis efter;
                           ENU=View by];
                ToolTipML=[DAN=Angiver, hvilken periode bel�bene vises for.;
                           ENU=Specifies by which period amounts are displayed.];
                OptionCaptionML=[DAN=Dag,Uge,M�ned,Kvartal,�r,Regnskabsperiode;
                                 ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                ApplicationArea=#Manufacturing;
                SourceExpr=PeriodType;
                OnValidate=BEGIN
                             MATRIX_GenerateColumnCaptions(SetWanted::Initial);
                           END;
                            }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Kapacitet vises i;
                           ENU=Capacity Shown In];
                ToolTipML=[DAN=Angiver, hvordan kapaciteten vises (minutter, dage eller timer).;
                           ENU=Specifies how the capacity is shown (minutes, days, or hours).];
                ApplicationArea=#Manufacturing;
                SourceExpr=CapacityUoM;
                TableRelation="Capacity Unit of Measure".Code }

    { 1101;2   ;Field     ;
                CaptionML=[DAN=Kolonnes�t;
                           ENU=Column Set];
                ToolTipML=[DAN=Angiver v�rdiintervaller, der vises i matrix-vinduet, f.eks. den samlede periode. Feltets indhold �ndres ved at v�lge N�ste s�t eller Forrige s�t.;
                           ENU=Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.];
                ApplicationArea=#Manufacturing;
                SourceExpr=MATRIX_CaptionRange;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      MATRIX_MatrixRecords@1091 : ARRAY [32] OF Record 2000000007;
      MfgSetup@1007 : Record 99000765;
      MatrixMgt@1000 : Codeunit 9200;
      MATRIX_CaptionSet@1092 : ARRAY [32] OF Text[80];
      MATRIX_CaptionRange@1093 : Text;
      MATRIX_SerWanted@1005 : 'Initial,Previus,Same,Next';
      MATRIX_PrimKeyFirstCaptionInCu@1097 : Text;
      MATRIX_CurrentSetLenght@1098 : Integer;
      MATRIX_UseNameForCaption@1003 : Boolean;
      MATRIX_DateFilter@1004 : Text;
      PeriodType@1001 : 'Day,Week,Month,Quarter,Year,Accounting Period';
      SetWanted@1006 : 'Initial,Previus,Same,Next';
      CapacityUoM@1008 : Code[10];

    LOCAL PROCEDURE MATRIX_GenerateColumnCaptions@1106(SetWanted@1002 : 'Initial,Previus,Same,Next');
    BEGIN
      MatrixMgt.GeneratePeriodMatrixData(SetWanted,ARRAYLEN(MATRIX_CaptionSet),MATRIX_UseNameForCaption,PeriodType,MATRIX_DateFilter,
        MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentSetLenght,MATRIX_MatrixRecords
        );
    END;

    BEGIN
    END.
  }
}


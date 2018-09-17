OBJECT Report 7300 Calculate Bin Replenishment
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Beregn genopfyldning;
               ENU=Calculate Bin Replenishment];
    ProcessingOnly=Yes;
  }
  DATASET
  {
    { 4810;    ;DataItem;                    ;
               DataItemTable=Table7302;
               DataItemTableView=SORTING(Location Code,Item No.,Variant Code,Warehouse Class Code,Fixed,Bin Ranking)
                                 ORDER(Descending)
                                 WHERE(Fixed=FILTER(Yes));
               OnPreDataItem=BEGIN
                               SETRANGE("Location Code",LocationCode);
                               Replenishmt.SetWhseWorksheet(
                                 WhseWkshTemplateName,WhseWkshName,LocationCode,DoNotFillQtytoHandle);
                             END;

               OnAfterGetRecord=BEGIN
                                  Replenishmt.ReplenishBin("Bin Content",AllowBreakbulk);
                                END;

               OnPostDataItem=BEGIN
                                IF NOT Replenishmt.InsertWhseWkshLine THEN
                                  IF NOT HideDialog THEN
                                    MESSAGE(Text000);
                              END;

               ReqFilterFields=Bin Code,Item No. }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  Name=WorksheetTemplateName;
                  CaptionML=[DAN=Worksheet Template Name;
                             ENU=Worksheet Template Name];
                  ToolTipML=[DAN=Specifies the name of the worksheet template that applies to the movement lines.;
                             ENU=Specifies the name of the worksheet template that applies to the movement lines.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=WhseWkshTemplateName;
                  TableRelation="Whse. Worksheet Template";
                  OnValidate=BEGIN
                               IF WhseWkshTemplateName = '' THEN
                                 WhseWkshName := '';
                             END;
                              }

      { 2   ;2   ;Field     ;
                  Name=WorksheetName;
                  CaptionML=[DAN=Worksheet Name;
                             ENU=Worksheet Name];
                  ToolTipML=[DAN=Specifies the name of the worksheet the movement lines will belong to.;
                             ENU=Specifies the name of the worksheet the movement lines will belong to.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=WhseWkshName;
                  OnValidate=BEGIN
                               WhseWorksheetName.GET(WhseWkshTemplateName,WhseWkshName,LocationCode);
                             END;

                  OnLookup=BEGIN
                             WhseWorksheetName.SETRANGE("Worksheet Template Name",WhseWkshTemplateName);
                             WhseWorksheetName.SETRANGE("Location Code",LocationCode);
                             IF PAGE.RUNMODAL(0,WhseWorksheetName) = ACTION::LookupOK THEN
                               WhseWkshName := WhseWorksheetName.Name;
                           END;
                            }

      { 3   ;2   ;Field     ;
                  Name=LocCode;
                  CaptionML=[DAN=Location Code;
                             ENU=Location Code];
                  ToolTipML=[DAN=Specifies the location at which bin replenishment will be calculated.;
                             ENU=Specifies the location at which bin replenishment will be calculated.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=LocationCode;
                  TableRelation=Location }

      { 5   ;2   ;Field     ;
                  CaptionML=[DAN=Tillad nedbrydning;
                             ENU=Allow Breakbulk];
                  ToolTipML=[DAN=Angiver, at placeringen skal genbestilles fra placeringsindhold, der er gemt i en anden m†leenhed, hvis varen ikke findes i den oprindelige m†leenhed.;
                             ENU=Specifies that the bin will be replenished from bin content that is stored in another unit of measure if the item is not found in the original unit of measure.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=AllowBreakbulk }

      { 7   ;2   ;Field     ;
                  CaptionML=[DAN=Udfyld ikke h†ndteringsantal;
                             ENU=Do Not Fill Qty. to Handle];
                  ToolTipML=[DAN="Angiver, at feltet Antal til h†ndtering p† hver kladdelinje skal udfyldes manuelt. ";
                             ENU="Specifies that the Quantity to Handle field on each worksheet line must be filled manually. "];
                  ApplicationArea=#Warehouse;
                  SourceExpr=DoNotFillQtytoHandle }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      WhseWorksheetName@1009 : Record 7327;
      Replenishmt@1000 : Codeunit 7308;
      WhseWkshTemplateName@1005 : Code[10];
      WhseWkshName@1004 : Code[10];
      LocationCode@1003 : Code[10];
      AllowBreakbulk@1001 : Boolean;
      HideDialog@1002 : Boolean;
      Text000@1006 : TextConst 'DAN=Der er ikke noget at genbestille.;ENU=There is nothing to replenish.';
      DoNotFillQtytoHandle@1007 : Boolean;

    [External]
    PROCEDURE InitializeRequest@1(WhseWkshTemplateName2@1004 : Code[10];WhseWkshName2@1003 : Code[10];LocationCode2@1002 : Code[10];AllowBreakbulk2@1000 : Boolean;HideDialog2@1001 : Boolean;DoNotFillQtytoHandle2@1005 : Boolean);
    BEGIN
      WhseWkshTemplateName := WhseWkshTemplateName2;
      WhseWkshName := WhseWkshName2;
      LocationCode := LocationCode2;
      AllowBreakbulk := AllowBreakbulk2;
      HideDialog := HideDialog2;
      DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}


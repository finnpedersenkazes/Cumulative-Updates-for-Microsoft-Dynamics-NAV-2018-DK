OBJECT Page 176 Standard Purchase Code Subform
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table174;
    DelayedInsert=Yes;
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=BEGIN
             TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Purchases);
             IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
           END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                       UpdateTypeText;
                     END;

    OnNewRecord=BEGIN
                  IF ApplicationAreaSetup.IsAdvanced THEN
                    Type := xRec.Type;
                  IF ApplicationAreaSetup.IsFoundationEnabled THEN
                    Type := Type::Item;
                  UpdateTypeText;

                  CLEAR(ShortcutDimCode);
                END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1900206304;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om linjen vedr›rer en finanskonto, en vare, et anl‘gsaktiv eller et varegebyr.;
                           ENU=Specifies whether the line is for a general ledger account, item, fixed asset or item charge.];
                ApplicationArea=#Advanced;
                SourceExpr=Type;
                OnValidate=BEGIN
                             TypeOnAfterValidate;
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=FilteredTypeField;
                CaptionML=[DAN=Type;
                           ENU=Type];
                ToolTipML=[DAN=Angiver, om linjen vedr›rer en finanskonto, en vare, et anl‘gsaktiv eller et varegebyr.;
                           ENU=Specifies whether the line is for a general ledger account, item, fixed asset or item charge.];
                ApplicationArea=#Suite;
                SourceExpr=TypeAsText;
                TableRelation="Option Lookup Buffer"."Option Caption" WHERE (Lookup Type=CONST(Purchases));
                Visible=IsFoundation;
                LookupPageID=Option Lookup List;
                OnValidate=BEGIN
                             IF TempOptionLookupBuffer.AutoCompleteOption(TypeAsText,TempOptionLookupBuffer."Lookup Type"::Purchases) THEN
                               VALIDATE(Type,TempOptionLookupBuffer.ID);
                             TempOptionLookupBuffer.ValidateOption(TypeAsText);
                             UpdateTypeText;
                             TypeOnAfterValidate;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† en finanskonto, vare, ressource, ekstra omkostning eller anl‘gsaktiv, afh‘ngigt af hvad du har valgt i feltet Type.;
                           ENU=Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.];
                ApplicationArea=#Suite;
                SourceExpr="No.";
                OnValidate=BEGIN
                             IF ApplicationAreaSetup.IsAdvanced THEN
                               EXIT;

                             IF "No." = xRec."No." THEN
                               EXIT;

                             UpdateTypeText;
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten, som er baseret p† indholdet af felterne Type og Nr.;
                           ENU=Specifies a description of the entry, which is based on the contents of the Type and No. fields.];
                ApplicationArea=#Suite;
                SourceExpr=Description;
                OnValidate=BEGIN
                             IF Description = xRec.Description THEN
                               EXIT;

                             IF "No." = '' THEN
                               Type := Type::" ";
                             UpdateTypeText;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antal enheder af varen p† linjen.;
                           ENU=Specifies the number of units of the item on the line.];
                ApplicationArea=#Suite;
                SourceExpr=Quantity }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Suite;
                SourceExpr="Unit of Measure Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nettobel›bet for standardk›bslinjen. Dette felt g‘lder kun for linjer af typen Finanskonto og Gebyr (vare).;
                           ENU=Specifies the net amount for the standard purchase line. This field only applies to lines of type G/L Account and Charge (Item).];
                ApplicationArea=#Suite;
                SourceExpr="Amount Excl. VAT";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                           END;
                            }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                           END;
                            }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                           END;
                            }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                           END;
                            }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                           END;
                            }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                           END;
                            }

  }
  CODE
  {
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
      TempOptionLookupBuffer@1004 : TEMPORARY Record 1670;
      ShortcutDimCode@1000 : ARRAY [8] OF Code[20];
      TypeAsText@1011 : Text[30];
      IsFoundation@1005 : Boolean;

    LOCAL PROCEDURE TypeOnAfterValidate@19069045();
    BEGIN
      CLEAR(ShortcutDimCode);
    END;

    LOCAL PROCEDURE UpdateTypeText@10();
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    BEGIN
    END.
  }
}


OBJECT Page 99000786 Production BOM
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Produktionsstykliste;
               ENU=Production BOM];
    SourceTable=Table99000771;
    PageType=ListPlus;
    OnAfterGetRecord=BEGIN
                       ActiveVersionCode := VersionMgt.GetBOMVersion("No.",WORKDATE,TRUE);
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&P.stykliste;
                                 ENU=&Prod. BOM];
                      Image=BOM }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000784;
                      RunPageLink=Table Name=CONST(Production BOM Header),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Versioner;
                                 ENU=Versions];
                      ToolTipML=[DAN=Vis alle alternative versioner af produktionsstyklisten.;
                                 ENU=View any alternate versions of the production BOM.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000800;
                      RunPageLink=Production BOM No.=FIELD(No.);
                      Promoted=Yes;
                      Image=BOMVersions;
                      PromotedCategory=Process }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=Matri&x pr. version;
                                 ENU=Ma&trix per Version];
                      ToolTipML=[DAN=Vis en liste over alle versioner og varer og det anvendte antal pr. vare i en produktionsstykliste. Du kan bruge matrixen til at sammenligne produktionsstyklisteversioner vedr�rende de anvendte varer pr. version.;
                                 ENU=View a list of all versions and items and the used quantity per item of a production BOM. You can use the matrix to compare different production BOM versions concerning the used items per version.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=ProdBOMMatrixPerVersion;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 BOMMatrixForm@1001 : Page 99000812;
                               BEGIN
                                 BOMMatrixForm.Set(Rec);

                                 BOMMatrixForm.RUNMODAL;
                                 CLEAR(BOMMatrixForm);
                               END;
                                }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Indg�r-i;
                                 ENU=Where-used];
                      ToolTipML=[DAN=F� vist en liste over styklister, hvor varen anvendes.;
                                 ENU=View a list of BOMs in which the item is used.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=Where-Used;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ProdBOMWhereUsed.SetProdBOM(Rec,WORKDATE);
                                 ProdBOMWhereUsed.RUNMODAL;
                                 CLEAR(ProdBOMWhereUsed);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 22      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier styk&liste;
                                 ENU=Copy &BOM];
                      ToolTipML=[DAN=Kopi�r en eksisterende produktionsstykliste, s� du hurtigt kan oprette en lignende stykliste.;
                                 ENU=Copy an existing production BOM to quickly create a similar BOM.];
                      ApplicationArea=#Manufacturing;
                      Image=CopyBOM;
                      OnAction=BEGIN
                                 TESTFIELD("No.");
                                 IF PAGE.RUNMODAL(0,ProdBOMHeader) = ACTION::LookupOK THEN
                                   ProductionBOMCopy.CopyBOM(ProdBOMHeader."No.",'',Rec,'');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af produkionsstyklisten.;
                           ENU=Specifies a description for the production BOM.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for produktionsstyklisten.;
                           ENU=Specifies the status of the production BOM.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Status }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s�ge efter den �nskede record, hvis du ikke kan huske v�rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Name" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det versionsnummer, som produktionsstyklisteversionerne henviser til.;
                           ENU=Specifies the version number series that the production BOM versions refer to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Version Nos." }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Aktiv version;
                           ENU=Active Version];
                ToolTipML=[DAN=Angiver, hvilken version af produktionsstyklisten der er gyldig.;
                           ENU=Specifies which version of the production BOM is valid.];
                ApplicationArea=#Manufacturing;
                SourceExpr=ActiveVersionCode;
                Editable=FALSE;
                OnLookup=VAR
                           ProdBOMVersion@1002 : Record 99000779;
                         BEGIN
                           ProdBOMVersion.SETRANGE("Production BOM No.","No.");
                           ProdBOMVersion.SETRANGE("Version Code",ActiveVersionCode);
                           PAGE.RUNMODAL(PAGE::"Production BOM Version",ProdBOMVersion);
                           ActiveVersionCode := VersionMgt.GetBOMVersion("No.",WORKDATE,TRUE);
                         END;
                          }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste �ndringsdato.;
                           ENU=Specifies the last date that was modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified" }

    { 27  ;1   ;Part      ;
                Name=ProdBOMLine;
                ApplicationArea=#Manufacturing;
                SubPageView=SORTING(Production BOM No.,Version Code,Line No.);
                SubPageLink=Production BOM No.=FIELD(No.),
                            Version Code=CONST();
                PagePartID=Page99000788;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ProdBOMHeader@1000 : Record 99000771;
      ProductionBOMCopy@1002 : Codeunit 99000768;
      VersionMgt@1003 : Codeunit 99000756;
      ProdBOMWhereUsed@1001 : Page 99000811;
      ActiveVersionCode@1004 : Code[20];

    BEGIN
    END.
  }
}


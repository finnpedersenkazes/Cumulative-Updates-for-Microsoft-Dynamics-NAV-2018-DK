OBJECT Page 8612 Config. Question Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table8612;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                MinValue=1 }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for feltet fra den tabel, som sp›rgsm†lsomr†det administrerer.;
                           ENU=Specifies the ID of the field from the table that the question area manages.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Field ID" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et sp›rgsm†l, som skal besvares p† konfigurationssp›rgeskemaet. Under fanen Handlinger i gruppen Sp›rgsm†l skal du v‘lge Opdater sp›rgsm†l for automatisk at udfylde sp›rgsm†lslisten baseret p† felterne i den tabel, som sp›rgsm†lsomr†det er baseret p†. Du kan redigere teksten, s† den bliver mere meningsfuld for den person, der har ansvaret for at udfylde sp›rgeskemaet. Du kunne f.eks. omskrive sp›rgsm†let Navn? til Hvad hedder din virksomhed?;
                           ENU=Specifies a question that is to be answered on the setup questionnaire. On the Actions tab, in the Question group, choose Update Questions to auto populate the question list based on the fields in the table on which the question area is based. You can modify the text to be more meaningful to the person responsible for filling out the questionnaire. For example, you could rewrite the Name? question as What is the name of your company?];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Question }

    { 16  ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver det format, som svaret p† sp›rgsm†let skal overholde. Hvis du f.eks. har et sp›rgsm†l om et navn, der skal besvares i overensstemmelse med navnefeltsformatet og datatypen i databasen, kan svarindstillingen angive Tekst.;
                           ENU=Specifies the format that the answer to the question needs to meet. For example, if you have a question about a name that needs to be answered, according to the name field format and data type set up in the database, the answer option can specify Text.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Answer Option" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver svaret p† sp›rgsm†let. Svaret p† sp›rgsm†let skal svare til formatet for svarindstillingen og skal v‘re en v‘rdi, der underst›ttes i databasen. Hvis dette ikke er tilf‘ldet, vil der opst† en fejl, n†r du anvender svaret.;
                           ENU=Specifies the answer to the question. The answer to the question should match the format of the answer option and must be a value that the database supports. If it does not, then there will be an error when you apply the answer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Answer }

    { 5   ;2   ;Field     ;
                Name=Field Value;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=LookupValue }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en url-adresse. Brug dette felt til at anf›re en url-adresse til en placering, der angiver oplysninger om sp›rgsm†let. Du kunne f.eks. anf›re adressen p† en side, som angiver oplysninger om konfigurationsovervejelser, som den person, der besvarer sp›rgeskemaet, skal overveje.;
                           ENU=Specifies a url address. Use this field to provide a url address to a location that Specifies information about the question. For example, you could provide the address of a page that Specifies information about setup considerations that the person answering the questionnaire should consider.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Reference }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† det felt, der underst›tter omr†det for konfigurationssp›rgeskemaet. Navnet kommer fra feltets navneegenskab.;
                           ENU=Specifies the name of the field that is supporting the setup questionnaire area. The name comes from the Name property of the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Field Name" }

    { 6   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver titlen p† det felt, der underst›tter omr†det for konfigurationssp›rgeskemaet. Titlen kommer fra feltets titelegenskab.;
                           ENU=Specifies the caption of the field that is supporting the setup questionnaire area. The caption comes from the Caption property of the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Field Caption" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sp›rgsm†lets oprindelse.;
                           ENU=Specifies the origin of the question.];
                ApplicationArea=#Advanced;
                SourceExpr="Question Origin";
                Visible=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}


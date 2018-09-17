OBJECT Page 1007 Job Planning Lines
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagsplanlëgningslinjer;
               ENU=Job Planning Lines];
    SourceTable=Table1003;
    DataCaptionExpr=Caption;
    PageType=List;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Outlook;
                                ENU=New,Process,Report,Outlook];
    OnInit=VAR
             SMTPMailSetup@1000 : Record 409;
             MailManagement@1001 : Codeunit 9520;
           BEGIN
             UnitCostEditable := TRUE;
             LineAmountEditable := TRUE;
             LineDiscountPctEditable := TRUE;
             LineDiscountAmountEditable := TRUE;
             UnitPriceEditable := TRUE;
             WorkTypeCodeEditable := TRUE;
             LocationCodeEditable := TRUE;
             VariantCodeEditable := TRUE;
             UnitOfMeasureCodeEditable := TRUE;
             DescriptionEditable := TRUE;
             NoEditable := TRUE;
             TypeEditable := TRUE;
             DocumentNoEditable := TRUE;
             CurrencyDateEditable := TRUE;
             PlanningDateEditable := TRUE;

             JobTaskNoVisible := TRUE;

             CanSendToCalendar := MailManagement.IsSMTPEnabled AND NOT SMTPMailSetup.ISEMPTY;
           END;

    OnOpenPage=VAR
                 Job@1000 : Record 167;
               BEGIN
                 IF Job.GET("Job No.") THEN
                   CurrPage.EDITABLE(NOT (Job.Blocked = Job.Blocked::All));

                 IF ActiveField = 1 THEN;
                 IF ActiveField = 2 THEN;
                 IF ActiveField = 3 THEN;
                 IF ActiveField = 4 THEN;
               END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                END;

    OnModifyRecord=BEGIN
                     IF "System-Created Entry" THEN BEGIN
                       IF CONFIRM(Text001,FALSE) THEN
                         "System-Created Entry" := FALSE
                       ELSE
                         ERROR('');
                     END;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           SetEditable("Qty. Transferred to Invoice" = 0);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 127     ;1   ;ActionGroup;
                      CaptionML=[DAN=Sagsplanlëgnings&linje;
                                 ENU=Job Planning &Line];
                      Image=Line }
      { 129     ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Tilknyttede sags&poster;
                                 ENU=Linked Job Ledger E&ntries];
                      ToolTipML=[DAN=Vis sagsposter, der er tilknyttet sagsplanlëgningslinjen.;
                                 ENU=View job ledger entries related to the job planning line.];
                      ApplicationArea=#Suite;
                      Image=JobLedger;
                      OnAction=VAR
                                 JobLedgerEntry@1001 : Record 169;
                                 JobUsageLink@1000 : Record 1020;
                               BEGIN
                                 JobUsageLink.SETRANGE("Job No.","Job No.");
                                 JobUsageLink.SETRANGE("Job Task No.","Job Task No.");
                                 JobUsageLink.SETRANGE("Line No.","Line No.");

                                 IF JobUsageLink.FINDSET THEN
                                   REPEAT
                                     JobLedgerEntry.GET(JobUsageLink."Entry No.");
                                     JobLedgerEntry.MARK := TRUE;
                                   UNTIL JobUsageLink.NEXT = 0;

                                 JobLedgerEntry.MARKEDONLY(TRUE);
                                 PAGE.RUN(PAGE::"Job Ledger Entries",JobLedgerEntry);
                               END;
                                }
      { 128     ;2   ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=&Reservationsposter;
                                 ENU=&Reservation Entries];
                      ToolTipML=[DAN=FÜ vist alle reservationer, der er foretaget for varen, enten manuelt eller automatisk.;
                                 ENU=View all reservations that are made for the item, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      Image=ReservationLedger;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 133     ;2   ;Separator  }
      { 134     ;2   ;Action    ;
                      Name=OrderPromising;
                      CaptionML=[DAN=Beregning af leverings&tid;
                                 ENU=Order &Promising];
                      ToolTipML=[DAN=Beregn afsendelses- og leveringsdatoerne ud fra varens kendte og forventede tilgëngelighedsdatoer, og oplys derefter datoerne til debitoren.;
                                 ENU=Calculate the shipment and delivery dates based on the item's known and expected availability dates, and then promise the dates to the customer.];
                      ApplicationArea=#Planning;
                      Image=OrderPromising;
                      OnAction=BEGIN
                                 ShowOrderPromisingLine;
                               END;
                                }
      { 22      ;2   ;Action    ;
                      Name=SendToCalendar;
                      AccessByPermission=TableData 1034=RIM;
                      CaptionML=[DAN=Send til kalender;
                                 ENU=Send to Calendar];
                      ToolTipML=[DAN=Opret en kalenderaftale for ressourcen pÜ hver sagsplanlëgningslinje.;
                                 ENU=Create a calendar appointment for the resource on each job planning line.];
                      ApplicationArea=#Jobs;
                      RunObject=Codeunit 1034;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Visible=CanSendToCalendar;
                      Image=CalendarChanged;
                      PromotedCategory=Category4 }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 91      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 19      ;2   ;Action    ;
                      Name=CreateJobJournalLines;
                      CaptionML=[DAN=Opret &sagskladdelinjer;
                                 ENU=Create Job &Journal Lines];
                      ToolTipML=[DAN=Brug en kõrsel som hjëlp til at oprette salgskladdelinjer for de involverede sagsplanlëgningslinjer.;
                                 ENU=Use a batch job to help you create sales journal lines for the involved job planning lines.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 JobPlanningLine@1002 : Record 1003;
                                 JobJnlLine@1004 : Record 210;
                                 JobTransferLine@1000 : Codeunit 1004;
                                 JobTransferJobPlanningLine@1003 : Page 1014;
                               BEGIN
                                 IF JobTransferJobPlanningLine.RUNMODAL = ACTION::OK THEN BEGIN
                                   JobPlanningLine.COPY(Rec);
                                   CurrPage.SETSELECTIONFILTER(JobPlanningLine);

                                   IF JobPlanningLine.FINDSET THEN
                                     REPEAT
                                       JobTransferLine.FromPlanningLineToJnlLine(
                                         JobPlanningLine,JobTransferJobPlanningLine.GetPostingDate,JobTransferJobPlanningLine.GetJobJournalTemplateName,
                                         JobTransferJobPlanningLine.GetJobJournalBatchName,JobJnlLine);
                                     UNTIL JobPlanningLine.NEXT = 0;

                                   CurrPage.UPDATE(FALSE);
                                   MESSAGE(Text002,JobPlanningLine.TABLECAPTION,JobJnlLine.TABLECAPTION);
                                 END;
                               END;
                                }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=&èbn sagskladde;
                                 ENU=&Open Job Journal];
                      ToolTipML=[DAN=èbn sagskladden for f.eks. at bogfõre forbruget for en sag.;
                                 ENU=Open the job journal, for example, to post usage for a job.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 201;
                      RunPageLink=Job No.=FIELD(Job No.),
                                  Job Task No.=FIELD(Job Task No.);
                      Promoted=Yes;
                      Image=Journals;
                      PromotedCategory=Process }
      { 16      ;2   ;Separator  }
      { 51      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret &salgsfaktura;
                                 ENU=Create &Sales Invoice];
                      ToolTipML=[DAN=Brug en kõrsel som hjëlp til at oprette salgsfakturaer for de involverede sagsopgaver.;
                                 ENU=Use a batch job to help you create sales invoices for the involved job tasks.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=JobSalesInvoice;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateSalesInvoice(FALSE);
                               END;
                                }
      { 60      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret salgs&kreditnota;
                                 ENU=Create Sales &Credit Memo];
                      ToolTipML=[DAN=Opret en salgskreditnota for den valgte sagsplanlëgningslinje.;
                                 ENU=Create a sales credit memo for the selected job planning line.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=CreditMemo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CreateSalesInvoice(TRUE);
                               END;
                                }
      { 69      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Salgs&fakturaer/kreditnotaer;
                                 ENU=Sales &Invoices/Credit Memos];
                      ToolTipML=[DAN=Vis salgsfakturaer eller salgskreditnotaer, der er relateret til den valgte sag.;
                                 ENU=View sales invoices or sales credit memos that are related to the selected job.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 JobCreateInvoice.GetJobPlanningLineInvoices(Rec);
                               END;
                                }
      { 123     ;2   ;Separator  }
      { 124     ;2   ;Action    ;
                      Name=Reserve;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=ReservÇr en eller flere enheder af varen pÜ sagsplanlëgningslinjen, enten fra lageret eller den indgÜende forsyning.;
                                 ENU=Reserve one or more units of the item on the job planning line, either from inventory or from incoming supply.];
                      ApplicationArea=#Advanced;
                      Image=Reserve;
                      OnAction=BEGIN
                                 ShowReservation;
                               END;
                                }
      { 132     ;2   ;Action    ;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den tilsvarende efterspõrgsel. PÜ denne mÜde kan du finde den oprindelige efterspõrgsel, der oprettede en specifik produktionsordre eller kõbsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#ItemTracking;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 ShowTracking;
                               END;
                                }
      { 130     ;2   ;Separator  }
      { 131     ;2   ;Action    ;
                      Name=DemandOverview;
                      CaptionML=[DAN=&Behovsoversigt;
                                 ENU=&Demand Overview];
                      ToolTipML=[DAN=FÜ et overblik over behovsplanlëgning i relation til sager som f.eks. tilgëngelighed for reservedele eller andre varer, som du mÜske skal bruge i en sag. Du kan f.eks. konstatere, om den krëvede vare findes pÜ lager, og hvis den ikke gõr, kan du finde ud af, hvornÜr varen af pÜ lager.;
                                 ENU=Get an overview of demand planning related to jobs, such as the availability of spare parts or other items that you may use in a job. For example, you can determine whether the item you need is in stock, and if it is not, you can determine when the item will be in stock.];
                      ApplicationArea=#Planning;
                      Image=Forecast;
                      OnAction=VAR
                                 DemandOverview@1000 : Page 5830;
                               BEGIN
                                 DemandOverview.SetCalculationParameter(TRUE);

                                 DemandOverview.Initialize(0D,3,"Job No.",'','');
                                 DemandOverview.RUNMODAL;
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903776506;1 ;Action    ;
                      CaptionML=[DAN=Sag - realiseret/budget;
                                 ENU=Job Actual to Budget];
                      ToolTipML=[DAN=Sammenlign de planlagte og faktiske forbrugsbelõb for de valgte sager. Alle linjer i den valgte sag viser antal, kostbelõb og linjebelõb.;
                                 ENU=Compare scheduled and usage amounts for selected jobs. All lines of the selected job show quantity, total cost, and line amount.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1009;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901542506;1 ;Action    ;
                      CaptionML=[DAN=Sagsanalyse;
                                 ENU=Job Analysis];
                      ToolTipML=[DAN=AnalysÇr sagen, f.eks. som de planlagte priser, forbrugspriser og kontraktpriser, og sammenlign derefter de tre sët priser.;
                                 ENU=Analyze the job, such as the scheduled prices, usage prices, and contract prices, and then compares the three sets of prices.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1008;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902943106;1 ;Action    ;
                      CaptionML=[DAN=Sag - planlëgningslinjer;
                                 ENU=Job - Planning Lines];
                      ToolTipML=[DAN=Vis alle planlëgningslinjer for sagen. Du kan bruge dette vindue til at planlëgge, hvilke varer, ressourcer og finansudgifter du forventer at bruge pÜ en sag (budget), eller du kan angive det faktiske belõb, som du har aftalt, at debitoren skal betale for sagen (fakturerbar).;
                                 ENU=View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (Budget) or you can specify what you actually agreed with your customer that he should pay for the job (Billable).];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1006;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903186006;1 ;Action    ;
                      CaptionML=[DAN=Sag - foreslÜet fakturering;
                                 ENU=Job - Suggested Billing];
                      ToolTipML=[DAN=Vis en liste over alle sager, grupperet efter debitor, hvor meget debitoren allerede har faktureret, og hvor meget der mangler at blive faktureret, dvs. den foreslÜede fakturering.;
                                 ENU=View a list of all jobs, grouped by customer, how much the customer has already been invoiced, and how much remains to be invoiced, that is, the suggested billing.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1011;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905285006;1 ;Action    ;
                      CaptionML=[DAN=Sag - kontokort;
                                 ENU=Jobs - Transaction Detail];
                      ToolTipML=[DAN=Vis alle de bogfõringer med poster for en bestemt sag i en nërmere angivet periode, som er blevet debiteret en bestemt sag. For hver sag sammentëlles salgsposter og forbrugsposter hver for sig.;
                                 ENU=View all postings with entries for a selected job for a selected period, which have been charged to a certain job. At the end of each job list, the amounts are totaled separately for the Sales and Usage entry types.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1007;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#All;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#All;
                SourceExpr="Job Task No.";
                Visible=JobTaskNoVisible }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen pÜ planlëgningslinjen.;
                           ENU=Specifies the type of planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Type" }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om feltet Anvendelseslink gëlder for sagsplanlëgningslinjen. NÜr dette afkrydsningsfelt er markeret, knyttes forbrugsposter til sagsplanlëgningslinjen. NÜr du markerer dette afkrydsningsfelt, oprettes et link til sagsplanlëgningslinjen fra de omrÜder, hvor forbruget er blevet bogfõrt, f.eks. sagskladden eller en kõbslinje. Du kan kun markere dette afkrydsningsfelt, hvis sagsplanlëgningslinjens type er Budget eller BÜde budget og Fakturerbar.;
                           ENU=Specifies whether the Usage Link field applies to the job planning line. When this check box is selected, usage entries are linked to the job planning line. Selecting this check box creates a link to the job planning line from places where usage has been posted, such as the job journal or a purchase line. You can select this check box only if the line type of the job planning line is Budget or Both Budget and Billable.];
                ApplicationArea=#Jobs;
                SourceExpr="Usage Link";
                Visible=FALSE;
                OnValidate=BEGIN
                             UsageLinkOnAfterValidate;
                           END;
                            }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for planlëgningslinjen. Du kan bruge planlëgningsdatoen til at filtrere summerne for sagen, f.eks. hvis du vil se det planlagte forbrug for en bestemt mÜned i Üret.;
                           ENU=Specifies the date of the planning line. You can use the planning date for filtering the totals of the job, for example, if you want to see the scheduled usage for a specific month of the year.];
                ApplicationArea=#Jobs;
                SourceExpr="Planning Date";
                Editable=PlanningDateEditable;
                OnValidate=BEGIN
                             PlanningDateOnAfterValidate;
                           END;
                            }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, der er planlagt til levering af varen i forbindelse med sagsplanlëgningslinjen. For en ressource er den planlagte leveringsdato den dato, hvor ressourcen udfõrer servicer i forhold til sagen.;
                           ENU=Specifies the date that is planned to deliver the item connected to the job planning line. For a resource, the planned delivery date is the date that the resource performs services with respect to the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Planned Delivery Date" }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, der bruges til at finde valutakursen for valutaen i feltet Valutadato.;
                           ENU=Specifies the date that will be used to find the exchange rate for the currency in the Currency Date field.];
                ApplicationArea=#Jobs;
                SourceExpr="Currency Date";
                Visible=FALSE;
                Editable=CurrencyDateEditable }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for planlëgningslinjen.;
                           ENU=Specifies a document number for the planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="Document No.";
                Editable=DocumentNoEditable }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver planlëgningslinjens postnummer.;
                           ENU=Specifies the planning line's entry number.];
                ApplicationArea=#Jobs;
                SourceExpr="Line No.";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontotype, som planlëgningslinjen vedrõrer.;
                           ENU=Specifies the type of account to which the planning line relates.];
                ApplicationArea=#Jobs;
                SourceExpr=Type;
                Editable=TypeEditable;
                OnValidate=BEGIN
                             NoOnAfterValidate;
                           END;
                            }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den konto, som ressourcen, varen eller finanskontoen er bogfõrt pÜ, afhëngigt af hvad du har valgt i feltet Type.;
                           ENU=Specifies the number of the account to which the resource, item or general ledger account is posted, depending on your selection in the Type field.];
                ApplicationArea=#Jobs;
                SourceExpr="No.";
                Editable=NoEditable;
                OnValidate=BEGIN
                             NoOnAfterValidate;
                           END;
                            }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den ressource, vare eller finanskonto, som posten vedrõrer. Du kan ëndre beskrivelsen. Der tillades maksimalt 50 tegn, bÜde tal og bogstaver.;
                           ENU=Specifies the name of the resource, item, or G/L account to which this entry applies. You can change the description. A maximum of 50 characters, both numbers and letters, are allowed.];
                ApplicationArea=#Jobs;
                SourceExpr=Description;
                Editable=DescriptionEditable }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE;
                Editable=VariantCodeEditable;
                OnValidate=BEGIN
                             VariantCodeOnAfterValidate;
                           END;
                            }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en lokationskode for en vare.;
                           ENU=Specifies a location code for an item.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE;
                Editable=LocationCodeEditable;
                OnValidate=BEGIN
                             LocationCodeOnAfterValidate;
                           END;
                            }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen udlignes med. Priserne opdateres ud fra denne post.;
                           ENU=Specifies which work type the resource applies to. Prices are updated based on this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code";
                Visible=FALSE;
                Editable=WorkTypeCodeEditable }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit of Measure Code";
                Visible=FALSE;
                Editable=UnitOfMeasureCodeEditable;
                OnValidate=BEGIN
                             UnitofMeasureCodeOnAfterValida;
                           END;
                            }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der kan foretages reservation af varer pÜ den aktuelle linje. Feltet er ikke relevant, hvis feltet Type er angivet til Ressource, Omkostning eller Finanskonto.;
                           ENU=Specifies whether or not a reservation can be made for items on the current line. The field is not applicable if the Type field is set to Resource, Cost, or G/L Account.];
                ApplicationArea=#Jobs;
                SourceExpr=Reserve;
                Visible=FALSE;
                OnValidate=BEGIN
                             ReserveOnAfterValidate;
                           END;
                            }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder for den ressource-, vare- eller finanskonto, der skal angives for planlëgningsfilen. Hvis du senere ëndrer nummeret, vil det angivne antal blive bevaret pÜ linjen.;
                           ENU=Specifies the number of units of the resource, item, or general ledger account that should be specified on the planning line. If you later change the No., the quantity you have entered remains on the line.];
                ApplicationArea=#Jobs;
                SourceExpr=Quantity;
                OnValidate=BEGIN
                             QuantityOnAfterValidate;
                           END;
                            }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varen, der er reserveret til sagsplanlëgningslinjen.;
                           ENU=Specifies the quantity of the item that is reserved for the job planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="Reserved Quantity";
                Visible=FALSE }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet specificeret i basisenheder.;
                           ENU=Specifies the quantity expressed in the base units of measure.];
                ApplicationArea=#Jobs;
                SourceExpr="Quantity (Base)";
                Visible=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende antal for den ressource, vare eller finanskonto, hvor en sag endnu ikke er fuldfõrt. Antallet beregnes som differencen mellem Antal og Bogf. antal.;
                           ENU=Specifies the remaining quantity of the resource, item, or G/L Account that remains to complete a job. The quantity is calculated as the difference between Quantity and Qty. Posted.];
                ApplicationArea=#Jobs;
                SourceExpr="Remaining Qty.";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen i den lokale valuta for en enhed af den vare eller ressource, der er valgt.;
                           ENU=Specifies the cost, in the local currency, of one unit of the selected item or resource.];
                ApplicationArea=#Jobs;
                SourceExpr="Direct Unit Cost (LCY)";
                Visible=FALSE;
                Editable=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost";
                Editable=UnitCostEditable }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbelõbet for planlëgningslinjen. Kostbelõbet er angivet i sagens valuta, som hentes fra feltet Valutakode pÜ jobkortet.;
                           ENU=Specifies the total cost for the planning line. The total cost is in the job currency, which comes from the Currency Code field in the Job Card.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Cost" }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende kostbelõb for planlëgningslinjen. Kostbelõbet er angivet i sagens valuta, som stammer fra feltet Valutakode pÜ jobkortet.;
                           ENU=Specifies the remaining total cost for the planning line. The total cost is in the job currency, which comes from the Currency Code field in the Job Card.];
                ApplicationArea=#Jobs;
                SourceExpr="Remaining Total Cost";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbelõbet for planlëgningslinjen. Belõbet er anfõrt i den lokale valuta.;
                           ENU=Specifies the total cost for the planning line. The amount is in the local currency.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Cost (LCY)";
                Visible=FALSE }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende kostbelõb i regnskabsvalutaen for planlëgningslinjen.;
                           ENU=Specifies the remaining total cost (LCY) for the planning line. The amount is in the local currency.];
                ApplicationArea=#Jobs;
                SourceExpr="Remaining Total Cost (LCY)";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for Çn enhed af varen eller ressourcen. Du kan angive en pris manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning pÜ det dertilhõrende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price";
                Editable=UnitPriceEditable }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for Çn enhed af varen eller ressourcen i RV. Du kan angive en pris manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning pÜ det dertilhõrende kort.;
                           ENU=Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Jobs;
                SourceExpr="Unit Price (LCY)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, som vil blive bogfõrt for sagsposten.;
                           ENU=Specifies the amount that will be posted to the job ledger.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Amount";
                Editable=LineAmountEditable }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, som vil blive bogfõrt for sagsposten.;
                           ENU=Specifies the amount that will be posted to the job ledger.];
                ApplicationArea=#Jobs;
                SourceExpr="Remaining Line Amount";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb i den lokale valuta, som vil blive bogfõrt for sagsposten.;
                           ENU=Specifies the amount in the local currency that will be posted to the job ledger.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Amount (LCY)";
                Visible=FALSE }

    { 108 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb i den lokale valuta, som vil blive bogfõrt for sagsposten.;
                           ENU=Specifies the amount in the local currency that will be posted to the job ledger.];
                ApplicationArea=#Jobs;
                SourceExpr="Remaining Line Amount (LCY)";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbelõb, der ydes pÜ varen, pÜ linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                Editable=LineDiscountAmountEditable }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen pÜ linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Jobs;
                SourceExpr="Line Discount %";
                Visible=FALSE;
                Editable=LineDiscountPctEditable }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede pris i sagens valuta pÜ planlëgningslinjen.;
                           ENU=Specifies the total price in the job currency on the planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Price";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede pris pÜ planlëgningslinjen. Den samlede pris vises i den lokale valuta.;
                           ENU=Specifies the total price on the planning line. The total price is in the local currency.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Price (LCY)";
                Visible=FALSE }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er blevet bogfõrt til sagsposten, hvis afkrydsningsfeltet Anvendelseslink er markeret.;
                           ENU=Specifies the quantity that has been posted to the job ledger, if the Usage Link check box has been selected.];
                ApplicationArea=#Jobs;
                SourceExpr="Qty. Posted";
                Visible=FALSE }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, du vil overfõre til sagskladden. Standardvërdien beregnes som antal minus det antal, der allerede er bogfõrt, hvis afkrydsningsfeltet Anvend anvendelseslink er markeret.;
                           ENU=Specifies the quantity you want to transfer to the job journal. Its default value is calculated as quantity minus the quantity that has already been posted, if the Apply Usage Link check box has been selected.];
                ApplicationArea=#Jobs;
                SourceExpr="Qty. to Transfer to Journal" }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kostbelõb, der er bogfõrt for sagsposten, hvis afkrydsningsfeltet Anvendelseslink er markeret.;
                           ENU=Specifies the total cost that has been posted to the job ledger, if the Usage Link check box has been selected.];
                ApplicationArea=#Jobs;
                SourceExpr="Posted Total Cost";
                Visible=FALSE }

    { 116 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kostbelõb i regnskabsvalutaen, der er bogfõrt for sagsposten, hvis afkrydsningsfeltet Anvendelseslink er markeret.;
                           ENU=Specifies the total cost (LCY) that has been posted to the job ledger, if the Usage Link check box has been selected.];
                ApplicationArea=#Jobs;
                SourceExpr="Posted Total Cost (LCY)";
                Visible=FALSE }

    { 118 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der er bogfõrt for sagsposten. Dette felt udfyldes kun, hvis afkrydsningsfeltet Anvend anvendelseslink er markeret pÜ jobkortet.;
                           ENU=Specifies the amount that has been posted to the job ledger. This field is only filled in if the Apply Usage Link check box selected on the job card.];
                ApplicationArea=#Jobs;
                SourceExpr="Posted Line Amount";
                Visible=FALSE }

    { 120 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb i den lokale valuta, der er bogfõrt for sagsposten. Dette felt udfyldes kun, hvis afkrydsningsfeltet Anvend anvendelseslink er markeret pÜ jobkortet.;
                           ENU=Specifies the amount in the local currency that has been posted to the job ledger. This field is only filled in if the Apply Usage Link check box selected on the job card.];
                ApplicationArea=#Jobs;
                SourceExpr="Posted Line Amount (LCY)";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er blevet overfõrt til en salgsfaktura eller kreditnota.;
                           ENU=Specifies the quantity that has been transferred to a sales invoice or credit memo.];
                ApplicationArea=#Jobs;
                SourceExpr="Qty. Transferred to Invoice";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              DrillDownJobInvoices;
                            END;
                             }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, du vil overflytte til salgsfakturaen eller kreditnotaen. Vërdien i dette felt beregnes som Antal - Antal overfõrt til faktura.;
                           ENU=Specifies the quantity you want to transfer to the sales invoice or credit memo. The value in this field is calculated as Quantity - Qty. Transferred to Invoice.];
                ApplicationArea=#Jobs;
                SourceExpr="Qty. to Transfer to Invoice";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er blevet bogfõrt gennem en salgsfaktura.;
                           ENU=Specifies the quantity that been posted through a sales invoice.];
                ApplicationArea=#Jobs;
                SourceExpr="Qty. Invoiced";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              DrillDownJobInvoices;
                            END;
                             }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive faktureret. Det beregnes som Antal - Faktureret antal.;
                           ENU=Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.];
                ApplicationArea=#Jobs;
                SourceExpr="Qty. to Invoice";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det salgsbelõb i den lokale valuta, som blev faktureret for denne planlëgningslinje.;
                           ENU=Specifies, in local currency, the sales amount that was invoiced for this planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="Invoiced Amount (LCY)";
                OnDrillDown=BEGIN
                              DrillDownJobInvoices;
                            END;
                             }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kostbelõb i den lokale valuta, som blev faktureret for denne planlëgningslinje.;
                           ENU=Specifies, in the local currency, the cost amount that was invoiced for this planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="Invoiced Cost Amount (LCY)";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              DrillDownJobInvoices;
                            END;
                             }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogfõrt posten, der skal bruges, f.eks. i ëndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Jobs;
                SourceExpr="User ID";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serienummer, der er anvendt til den bogfõrte vare, hvis planlëgningslinjen blev oprettet fra bogfõringen af en sagskladdelinje.;
                           ENU=Specifies the serial number that is applied to the posted item if the planning line was created from the posting of a job journal line.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det lotnummer, der er anvendt til den bogfõrte vare, hvis planlëgningslinjen blev oprettet fra bogfõringen af en sagskladdelinje.;
                           ENU=Specifies the lot number that is applied to the posted item if the planning line was created from the posting of a job journal line.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lõbenummeret pÜ den jobplanlëgningslinje, som salgslinjen er tilknyttet.;
                           ENU=Specifies the entry number of the job planning line that the sales line is linked to.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Contract Entry No.";
                Visible=FALSE }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sagspostens type, som er knyttet til planlëgningslinjen.;
                           ENU=Specifies the entry type of the job ledger entry associated with the planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="Ledger Entry Type";
                Visible=FALSE }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sagspostens nummer, som er knyttet til sagsplanlëgningslinjen.;
                           ENU=Specifies the entry number of the job ledger entry associated with the job planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="Ledger Entry No.";
                Visible=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der er oprettet en post af Dynamics NAV, og at den er relateret til en sagspost. Afkrydsningsfeltet markeres automatisk.;
                           ENU=Specifies that an entry has been created by Dynamics NAV and is related to a job ledger entry. The check box is selected automatically.];
                ApplicationArea=#Jobs;
                SourceExpr="System-Created Entry";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Forfald;
                           ENU=Overdue];
                ToolTipML=[DAN="Angiver, at sagen er forfalden. ";
                           ENU="Specifies that the job is overdue. "];
                ApplicationArea=#Jobs;
                SourceExpr=Overdue;
                Visible=FALSE;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      JobCreateInvoice@1000 : Codeunit 1002;
      ActiveField@1001 : ' ,Cost,CostLCY,PriceLCY,Price';
      Text001@1002 : TextConst 'DAN=Denne sagsplanlëgningslinje er genereret automatisk. Vil du fortsëtte?;ENU=This job planning line was automatically generated. Do you want to continue?';
      JobTaskNoVisible@19035147 : Boolean INDATASET;
      PlanningDateEditable@19058788 : Boolean INDATASET;
      CurrencyDateEditable@19063095 : Boolean INDATASET;
      DocumentNoEditable@19064841 : Boolean INDATASET;
      TypeEditable@19028748 : Boolean INDATASET;
      NoEditable@19005397 : Boolean INDATASET;
      DescriptionEditable@19061412 : Boolean INDATASET;
      UnitOfMeasureCodeEditable@19052748 : Boolean INDATASET;
      VariantCodeEditable@19003611 : Boolean INDATASET;
      LocationCodeEditable@19048234 : Boolean INDATASET;
      WorkTypeCodeEditable@19027008 : Boolean INDATASET;
      UnitPriceEditable@19072822 : Boolean INDATASET;
      LineDiscountAmountEditable@19003541 : Boolean INDATASET;
      LineDiscountPctEditable@19026131 : Boolean INDATASET;
      LineAmountEditable@19064331 : Boolean INDATASET;
      UnitCostEditable@19057007 : Boolean INDATASET;
      Text002@1005 : TextConst 'DAN=%1 blev overfõrt til en %2.;ENU=The %1 was successfully transferred to a %2.';
      CanSendToCalendar@1004 : Boolean;

    LOCAL PROCEDURE CreateSalesInvoice@1(CrMemo@1000 : Boolean);
    VAR
      JobPlanningLine@1007 : Record 1003;
      JobCreateInvoice@1006 : Codeunit 1002;
    BEGIN
      TESTFIELD("Line No.");
      JobPlanningLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(JobPlanningLine);
      JobCreateInvoice.CreateSalesInvoice(JobPlanningLine,CrMemo)
    END;

    LOCAL PROCEDURE SetEditable@2(Edit@1000 : Boolean);
    BEGIN
      PlanningDateEditable := Edit;
      CurrencyDateEditable := Edit;
      DocumentNoEditable := Edit;
      TypeEditable := Edit;
      NoEditable := Edit;
      DescriptionEditable := Edit;
      UnitOfMeasureCodeEditable := Edit;
      VariantCodeEditable := Edit;
      LocationCodeEditable := Edit;
      WorkTypeCodeEditable := Edit;
      UnitPriceEditable := Edit;
      LineDiscountAmountEditable := Edit;
      LineDiscountPctEditable := Edit;
      LineAmountEditable := Edit;
      UnitCostEditable := Edit;
    END;

    [External]
    PROCEDURE SetActiveField@3(ActiveField2@1000 : Integer);
    BEGIN
      ActiveField := ActiveField2;
    END;

    [External]
    PROCEDURE SetJobTaskNoVisible@5(NewJobTaskNoVisible@1000 : Boolean);
    BEGIN
      JobTaskNoVisible := NewJobTaskNoVisible;
    END;

    LOCAL PROCEDURE PerformAutoReserve@10();
    BEGIN
      IF (Reserve = Reserve::Always) AND
         ("Remaining Qty. (Base)" <> 0)
      THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE UsageLinkOnAfterValidate@19044160();
    BEGIN
      PerformAutoReserve;
    END;

    LOCAL PROCEDURE PlanningDateOnAfterValidate@19037512();
    BEGIN
      IF "Planning Date" <> xRec."Planning Date" THEN
        PerformAutoReserve;
    END;

    LOCAL PROCEDURE NoOnAfterValidate@19066594();
    BEGIN
      IF "No." <> xRec."No." THEN
        PerformAutoReserve;
    END;

    LOCAL PROCEDURE VariantCodeOnAfterValidate@19003320();
    BEGIN
      IF "Variant Code" <> xRec."Variant Code" THEN
        PerformAutoReserve;
    END;

    LOCAL PROCEDURE LocationCodeOnAfterValidate@19034787();
    BEGIN
      IF "Location Code" <> xRec."Location Code" THEN
        PerformAutoReserve;
    END;

    LOCAL PROCEDURE UnitofMeasureCodeOnAfterValida@19057939();
    BEGIN
      PerformAutoReserve;
    END;

    LOCAL PROCEDURE ReserveOnAfterValidate@19004502();
    BEGIN
      PerformAutoReserve;
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@19032465();
    BEGIN
      PerformAutoReserve;
      IF (Type = Type::Item) AND (Quantity <> xRec.Quantity) THEN
        CurrPage.UPDATE(TRUE);
    END;

    BEGIN
    END.
  }
}


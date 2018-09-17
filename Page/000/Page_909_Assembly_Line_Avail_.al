OBJECT Page 909 Assembly Line Avail.
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table901;
    SourceTableView=SORTING(Document Type,Document No.,Type)
                    ORDER(Ascending)
                    WHERE(Document Type=CONST(Order),
                          Type=CONST(Item),
                          No.=FILTER(<>''));
    PageType=ListPart;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             SetItemFilter(Item);
           END;

    OnOpenPage=BEGIN
                 RESET;
                 SETRANGE(Type,Type::Item);
                 SETFILTER("No.",'<>%1','');
                 SETFILTER("Quantity per",'<>%1',0);
               END;

    OnAfterGetRecord=BEGIN
                       SetItemFilter(Item);
                       CalcAvailToAssemble(
                         AssemblyHeader,
                         Item,
                         GrossRequirement,
                         ScheduledRcpt,
                         ExpectedInventory,
                         Inventory,
                         EarliestDate,
                         AbleToAssemble);
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 13  ;2   ;Field     ;
                Name=Inventory;
                CaptionML=[DAN=Lager;
                           ENU=Inventory];
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der findes p† lageret.;
                           ENU=Specifies how many units of the assembly component are in inventory.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr=Inventory;
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                Name=GrossRequirement;
                CaptionML=[DAN=Bruttobehov;
                           ENU=Gross Requirement];
                ToolTipML=[DAN=Angiver den samlede eftersp›rgsel p† montagekomponenten.;
                           ENU=Specifies the total demand for the assembly component.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr=GrossRequirement }

    { 24  ;2   ;Field     ;
                Name=ScheduledReceipt;
                CaptionML=[DAN=Fastlagt tilgang;
                           ENU=Scheduled Receipt];
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der er indg†ende p† ordrer.;
                           ENU=Specifies how many units of the assembly component are inbound on orders.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr=ScheduledRcpt }

    { 8   ;2   ;Field     ;
                Name=ExpectedAvailableInventory;
                CaptionML=[DAN=Forventet disponibel beholdning;
                           ENU=Expected Available Inventory];
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten, der er tilg‘ngelige for den aktuelle montageordre p† forfaldsdatoen.;
                           ENU=Specifies how many units of the assembly component are available for the current assembly order on the due date.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr=ExpectedInventory;
                Visible=True }

    { 4   ;2   ;Field     ;
                Name=CurrentQuantity;
                CaptionML=[DAN=Aktuelt antal;
                           ENU=Current Quantity];
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten der kr‘ves p† montageordrelinjen.;
                           ENU=Specifies how many units of the component are required on the assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Remaining Quantity" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten, der kr‘ves for at samle et montageelement.;
                           ENU=Specifies how many units of the assembly component are required to assemble one assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr="Quantity per" }

    { 15  ;2   ;Field     ;
                CaptionML=[DAN=Aktuelt reserveret antal;
                           ENU=Current Reserved Quantity];
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der er reserveret til montageordrelinjen.;
                           ENU=Specifies how many units of the assembly component have been reserved for this assembly order line.];
                ApplicationArea=#Planning;
                SourceExpr="Reserved Quantity";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                Name=EarliestAvailableDate;
                CaptionML=[DAN=Tidligste disponible dato;
                           ENU=Earliest Available Date];
                ToolTipML=[DAN=Angiver den forsinkede ankomstdato for en indg†ende forsyningsordre, som kan d‘kke den n›dvendige m‘ngde af montagekomponenten.;
                           ENU=Specifies the late arrival date of an inbound supply order that can cover the needed quantity of the assembly component.];
                ApplicationArea=#Assembly;
                SourceExpr=EarliestDate }

    { 10  ;2   ;Field     ;
                Name=AbleToAssemble;
                CaptionML=[DAN=Mulighed for montage;
                           ENU=Able to Assemble];
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet i montageordrehovedet der kan monteres ud fra tilg‘ngeligheden af komponenten.;
                           ENU=Specifies how many units of the assembly item on the assembly order header can be assembled, based on the availability of the component.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr=AbleToAssemble }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den genneml›bstid, der er defineret for montagekomponenten p† montagestyklisten.;
                           ENU=Specifies the lead-time offset that is defined for the assembly component on the assembly BOM.];
                ApplicationArea=#Assembly;
                SourceExpr="Lead-Time Offset" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, som du vil bogf›re forbruget af montagekomponenten for.;
                           ENU=Specifies the location from which you want to post consumption of the assembly component.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der findes en erstatning for varen p† montageordrelinjen.;
                           ENU=Specifies if a substitute is available for the item on the assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Substitution Available" }

  }
  CODE
  {
    VAR
      AssemblyHeader@1001 : Record 900;
      Item@1000 : Record 27;
      ExpectedInventory@1013 : Decimal;
      GrossRequirement@1016 : Decimal;
      ScheduledRcpt@1018 : Decimal;
      Inventory@1005 : Decimal;
      EarliestDate@1002 : Date;
      AbleToAssemble@1003 : Decimal;

    [External]
    PROCEDURE SetLinesRecord@1(VAR AssemblyLine@1000 : Record 901);
    BEGIN
      COPY(AssemblyLine,TRUE);
    END;

    [External]
    PROCEDURE SetHeader@3(AssemblyHeader2@1000 : Record 900);
    BEGIN
      AssemblyHeader := AssemblyHeader2;
    END;

    BEGIN
    END.
  }
}


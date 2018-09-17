OBJECT Page 7318 Warehouse Entries
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
    CaptionML=[DAN=Lagerposter;
               ENU=Warehouse Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table7312;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver posttypen, som kan v‘re Nedregulering, Opregulering eller Bev‘gelse.;
                           ENU=Specifies the entry type, which can be Negative Adjmt., Positive Adjmt., or Movement.];
                ApplicationArea=#Warehouse;
                SourceExpr="Entry Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Journal Batch Name";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den lagerdokumentlinje eller lagerkladdelinje, der blev registreret.;
                           ENU=Specifies the line number of the warehouse document line or warehouse journal line that was registered.];
                ApplicationArea=#Warehouse;
                SourceExpr="Line No.";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som posten er tilknyttet.;
                           ENU=Specifies the code of the location to which the entry is linked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret.;
                           ENU=Specifies the serial number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det lotnummer, der tildeles lagerposten.;
                           ENU=Specifies the lot number assigned to the warehouse entry.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver udl›bsdatoen for serienummeret.;
                           ENU=Specifies the expiration date of the serial number.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expiration Date";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, som posten er tilknyttet.;
                           ENU=Specifies the code of the zone to which the entry is linked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† varen i posten.;
                           ENU=Specifies the number of the item in the entry.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af lagerposten.;
                           ENU=Specifies a description of the warehouse entry.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder i vareposten.;
                           ENU=Specifies the number of units of the item in the warehouse entry.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for posten anf›rt i basisenheder.;
                           ENU=Specifies the quantity of the entry, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange basisenheder der g†r p† den enhed, der er angivet for varen p† linjen.;
                           ENU=Specifies the number of base units of measure that are in the unit of measure specified for the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tabelnummer, som er kilden for posten, f.eks. 39 for en k›bslinje eller 37 for en salgslinje.;
                           ENU=Specifies the table number that is the source of the entry line, for example, 39 for a purchase line, 37 for a sales line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildeundertypen for det bilag, som lagerpostlinjen vedr›rer.;
                           ENU=Specifies the source subtype of the document to which the warehouse entry line relates.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Subtype";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the line number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Line No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildeunderlinjenummeret p† det bilag, som posten stammer fra.;
                           ENU=Specifies the source subline number of the document from which the entry originates.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Subline No.";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Warehouse;
                SourceExpr="Reason Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Warehouse;
                SourceExpr="No. Series";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede rumm†l for varerne p† lagerpostlinjen.;
                           ENU=Specifies the total cubage of the items on the warehouse entry line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Cubage;
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘gten af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the weight of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr=Weight;
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kladdetypen - grundlaget for den kladdek›rsel, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal template, the basis of the journal batch, that the entries were posted from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Journal Template Name";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for det bilag, som posten stammer fra.;
                           ENU=Specifies the type of the document from which this entry originated.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document Type" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det lagerdokument, som posten stammer fra.;
                           ENU=Specifies the number of the warehouse document from which this entry originated.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document No." }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor posten blev registreret.;
                           ENU=Specifies the date the entry was registered.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registering Date" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Warehouse;
                SourceExpr="User ID";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Warehouse;
                SourceExpr="Entry No." }

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

    BEGIN
    END.
  }
}


OBJECT Page 5724 Cross Reference List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varereferenceoversigt;
               ENU=Cross Reference List];
    SourceTable=Table5717;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dine og din kreditors og debitors varenummer, vil dette nummer tilsides�tte standardvarenummeret, n�r du angiver krydsreferencenummeret p� et salgs- eller k�bsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cross-Reference No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver type referencepost.;
                           ENU=Specifies the type of the cross-reference entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cross-Reference Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et debitornummer, et kreditornummer eller en stregkode, afh�ngigt af, hvad du har valgt i feltet Type.;
                           ENU=Specifies a customer number, a vendor number, or a bar code, depending on what you have selected in the Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cross-Reference Type No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� varekortet, hvorfra du �bnede vinduet Varereferenceposter.;
                           ENU=Specifies the number on the item card from which you opened the Item Cross Reference Entries window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at programmet ikke skal forts�tte en stregkodereference.;
                           ENU=Specifies that you want the program to discontinue a bar code cross reference.];
                ApplicationArea=#Advanced;
                SourceExpr="Discontinue Bar Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den vare, der er knyttet til referencen.;
                           ENU=Specifies a description of the item that is linked to this cross reference.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

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


OBJECT Page 5924 Loaner Entries
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
    CaptionML=[DAN=Udl†nsvareposter;
               ENU=Loaner Entries];
    SourceTable=Table5914;
    DataCaptionFields=Loaner No.;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Service;
                SourceExpr="Entry No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om dokumenttypen for posten er et tilbud eller en ordre.;
                           ENU=Specifies whether the document type of the entry is a quote or order.];
                ApplicationArea=#Service;
                SourceExpr="Document Type" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det servicedokument, der angiver den serviceartikel, som du har erstattet med udl†nsvaren.;
                           ENU=Specifies the number of the service document specifying the service item you have replaced with the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Document No." }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceartikel, du her erstattet med udl†nsvaren.;
                           ENU=Specifies the number of the service item that you have replaced with the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceartikellinje, som udl†nsvaren blev l†nt ud for.;
                           ENU=Specifies the number of the service item line for which you have lent the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Line No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† udl†nsvaren.;
                           ENU=Specifies the number of the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Loaner No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceartikelgruppekoden for den serviceartikel, du har erstattet med udl†nsvaren.;
                           ENU=Specifies the service item group code of the service item that you have replaced with the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Group Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som udl†nsvaren blev l†nt ud til.;
                           ENU=Specifies the number of the customer to whom you have lent the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du udl†nte udl†nsvaren.;
                           ENU=Specifies the date when you lent the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Date Lent" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor du udl†nte udl†nsvaren.;
                           ENU=Specifies the time when you lent the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Time Lent" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du modtog udl†nsvaren.;
                           ENU=Specifies the date when you received the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Date Received" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor du modtog udl†nsvaren.;
                           ENU=Specifies the time when you received the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Time Received" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at udl†nsvaren er l†nt ud.;
                           ENU=Specifies that the loaner is lent.];
                ApplicationArea=#Service;
                SourceExpr=Lent }

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


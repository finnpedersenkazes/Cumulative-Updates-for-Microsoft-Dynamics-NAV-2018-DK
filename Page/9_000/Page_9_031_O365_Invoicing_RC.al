OBJECT Page 9031 O365 Invoicing RC
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@=Use same translation as 'Profile Description' (if applicable);
               DAN=Fakturering;
               ENU=Invoicing];
    PageType=RoleCenter;
    ActionList=ACTIONS
    {
      { 2       ;    ;ActionContainer;
                      ActionContainerType=HomeItems }
      { 4       ;1   ;Action    ;
                      CaptionML=[DAN=Debitorer;
                                 ENU=Customers];
                      ToolTipML=[DAN=FÜ vist eller rediger detaljerede oplysninger om de debitorer, som du handler med. Fra det enkelte debitorkort kan du fÜ adgang til relaterede oplysninger som f.eks. salgsstatistik og igangvërende ordrer, og du kan definere specialpriser og linjerabatter, som debitoren fÜr, nÜr bestemte betingelser er opfyldt.;
                                 ENU=View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.];
                      ApplicationArea=#Invoicing;
                      RunObject=Page 2116 }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=;
                      ApplicationArea=#Invoicing;
                      RunObject=Page 2190 }
      { 5       ;1   ;Action    ;
                      CaptionML=[DAN=Kladdefakturaer;
                                 ENU=Draft Invoices];
                      ToolTipML=[DAN=èbn listen over kladdefakturaer;
                                 ENU=Open the list of draft invoices];
                      ApplicationArea=#Invoicing;
                      RunObject=Page 2190;
                      RunPageView=WHERE(Posted=CONST(No)) }
      { 7       ;1   ;Action    ;
                      CaptionML=[DAN=Sendte fakturaer;
                                 ENU=Sent Invoices];
                      ToolTipML=[DAN=èbn listen over sendte fakturaer;
                                 ENU=Open the list of sent invoices];
                      ApplicationArea=#Invoicing;
                      RunObject=Page 2190;
                      RunPageView=WHERE(Posted=CONST(Yes)) }
      { 3       ;1   ;Action    ;
                      CaptionML=[DAN=Varer;
                                 ENU=Items];
                      ToolTipML=;
                      ApplicationArea=#Invoicing;
                      RunObject=Page 31 }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Indstillinger;
                                 ENU=Settings];
                      ToolTipML=[DAN=èbn listen over indstillinger;
                                 ENU=Open the list of settings];
                      ApplicationArea=#Invoicing;
                      RunObject=Page 2191 }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=RoleCenterArea }

    { 9   ;1   ;Part      ;
                AccessByPermission=TableData 17=R;
                ApplicationArea=#Invoicing;
                PagePartID=Page9077;
                PartType=Page }

    { 8   ;1   ;Part      ;
                AccessByPermission=TableData 1803=R;
                ToolTipML=[DAN=Angiver visningen af din virksomhedshjëlp;
                           ENU=Specifies the view of your business assistance];
                ApplicationArea=#Invoicing;
                PagePartID=Page1392;
                PartType=Page }

  }
  CODE
  {

    BEGIN
    END.
  }
}


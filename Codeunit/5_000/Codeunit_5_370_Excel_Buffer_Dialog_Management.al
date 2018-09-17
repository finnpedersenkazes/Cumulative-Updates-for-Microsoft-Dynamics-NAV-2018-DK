OBJECT Codeunit 5370 Excel Buffer Dialog Management
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Window@1000 : Dialog;
      Progress@1001 : Integer;
      WindowOpen@1002 : Boolean;

    [External]
    PROCEDURE Open@1(Text@1000 : Text);
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT;

      Window.OPEN(Text + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
      Window.UPDATE(1,0);
      WindowOpen := TRUE;
    END;

    [TryFunction]
    [External]
    PROCEDURE SetProgress@2(pProgress@1000 : Integer);
    BEGIN
      Progress := pProgress;
      IF WindowOpen THEN
        Window.UPDATE(1,Progress);
    END;

    [External]
    PROCEDURE Close@3();
    BEGIN
      IF WindowOpen THEN BEGIN
        Window.CLOSE;
        WindowOpen := FALSE;
      END;
    END;

    BEGIN
    END.
  }
}


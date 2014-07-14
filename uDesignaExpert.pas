unit uDesignaExpert;

interface

uses
  SysUtils,
  Classes,
  ToolsAPI,
  Dialogs,
  Menus;

type
  TDesignaExpert = class(TNotifierObject, IOTAKeyboardBinding)
  protected
    procedure CopyLine(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
    procedure MoveLineDown(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
    procedure MoveLineUp(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);

  public
    { IOTAKeyboardBinding }
    function GetBindingType: TBindingType;
    function GetDisplayName: String;
    function GetName: String;
    procedure BindKeyboard(const BindingServices: IOTAKeyBindingServices);
  end;

  procedure Register;

implementation

uses
  Windows;

procedure Register;
begin
  (BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TDesignaExpert.Create);
end;

{ TCopyLineExpert }

procedure TDesignaExpert.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
  with BindingServices do
  begin
    // Associa a combinação Ctrl+Shift+D
    AddKeyBinding([ShortCut(Ord('D'), [ssShift, ssCtrl])], CopyLine, nil);
    AddKeyBinding([ShortCut(VK_DOWN, [ssAlt, ssCtrl])], MoveLineDown, nil);
    AddKeyBinding([ShortCut(VK_UP, [ssAlt, ssCtrl])], MoveLineUp, nil);
  end;
end;

procedure TDesignaExpert.CopyLine(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
var
  Position : IOTAEditPosition;
  LineValue : String;

  EOL: Integer;
  AutoIndent: Boolean;
begin
  AutoIndent := Context.EditBuffer.BufferOptions.AutoIndent;
  Position := Context.EditBuffer.EditPosition;
  Position.Save;

  Position.MoveEOL;
  EOL := Position.Column;

  Position.MoveBOL;
  LineValue := Position.Read(EOL);

  Context.EditBuffer.BufferOptions.AutoIndent := False;
  Position.InsertText(LineValue);
  Context.EditBuffer.BufferOptions.AutoIndent := AutoIndent;

  Position.Restore;
  Position.Move(Position.Row+1, Position.Column);

  BindingResult := krHandled;
end;

function TDesignaExpert.GetBindingType: TBindingType;
begin
  Result := btPartial;
end;

function TDesignaExpert.GetDisplayName: String;
begin
  Result := 'Designa Expert';
end;

function TDesignaExpert.GetName: String;
begin
  Result := 'miac.DesignaExpert';
end;

procedure TDesignaExpert.MoveLineDown(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
var
  Position : IOTAEditPosition;
  LineValue : String;

  EOL: Integer;
  AutoIndent: Boolean;
begin
  AutoIndent := Context.EditBuffer.BufferOptions.AutoIndent;
  Position := Context.EditBuffer.EditPosition;

  Position.Save;

  Position.MoveEOL;
  EOL := Position.Column;

  Position.MoveBOL;
  LineValue := Position.Read(EOL);

  Context.EditBuffer.BufferOptions.AutoIndent := False;
  Position.Move(Position.Row+2, Position.Column);
  Position.InsertText(LineValue);
  Context.EditBuffer.BufferOptions.AutoIndent := AutoIndent;

  Position.Restore;
  Position.Delete(EOL);
  Position.Move(Position.Row+1, Position.Column);

  BindingResult := krHandled;
end;

procedure TDesignaExpert.MoveLineUp(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
var
  Position : IOTAEditPosition;
  LineValue : String;

  EOL: Integer;
  AutoIndent: Boolean;
begin
  AutoIndent := Context.EditBuffer.BufferOptions.AutoIndent;
  Position := Context.EditBuffer.EditPosition;

  if Position.Row = 1 then Exit;

  Position.Save;
  Position.MoveEOL;
  EOL := Position.Column;

  Position.MoveBOL;
  LineValue := Position.Read(EOL);

  Context.EditBuffer.BufferOptions.AutoIndent := False;
  Position.Move(Position.Row-1, Position.Column);
  Position.InsertText(LineValue);
  Context.EditBuffer.BufferOptions.AutoIndent := AutoIndent;

  Position.Restore;
  Position.Move(Position.Row+1, Position.Column);
  Position.Delete(EOL);
  Position.Move(Position.Row-2, Position.Column);

  BindingResult := krHandled;
end;

end.

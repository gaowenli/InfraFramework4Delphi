unit InfraFwk4D.Validation.Default.Validators;

interface

uses
  System.SysUtils,
  System.Rtti,
  System.DateUtils,
  System.Types,
  InfraFwk4D.Validation,
  InfraFwk4D.Validation.Default.Attributes,
  Data.DB;

type

  TAbstractValidator = class abstract(TInterfacedObject)
  private
    { private declarations }
  protected
    procedure Initialize(const attribute: ConstraintAttribute); virtual;
    function ProcessingMessage(const msg: string): string; virtual;
  public
    { public declarations }
  end;

  TAssertFalseValidator = class(TAbstractValidator, IConstraintValidator)
  private
    { private declarations }
  protected
    function IsValid(const value: TValue): Boolean;
  public
    { public declarations }
  end;

  TAssertTrueValidator = class(TAbstractValidator, IConstraintValidator)
  private
    { private declarations }
  protected
    function IsValid(const value: TValue): Boolean;
  public
    { public declarations }
  end;

  TMaxValidator = class(TAbstractValidator, IConstraintValidator)
  private
    fMaxValue: Integer;
  protected
    procedure Initialize(const attribute: ConstraintAttribute); override;
    function IsValid(const value: TValue): Boolean;
    function ProcessingMessage(const msg: string): string; override;
  public
    { public declarations }
  end;

  TMinValidator = class(TAbstractValidator, IConstraintValidator)
  private
    fMinValue: Integer;
  protected
    procedure Initialize(const attribute: ConstraintAttribute); override;
    function IsValid(const value: TValue): Boolean;
    function ProcessingMessage(const msg: string): string; override;
  public
    { public declarations }
  end;

  TSizeValidator = class(TAbstractValidator, IConstraintValidator)
  private
    fMinValue: Integer;
    fMaxValue: Integer;
  protected
    procedure Initialize(const attribute: ConstraintAttribute); override;
    function IsValid(const value: TValue): Boolean;
    function ProcessingMessage(const msg: string): string; override;
  public
    { public declarations }
  end;

  TDecimalMaxValidator = class(TAbstractValidator, IConstraintValidator)
  private
    fMaxValue: Double;
  protected
    procedure Initialize(const attribute: ConstraintAttribute); override;
    function IsValid(const value: TValue): Boolean;
    function ProcessingMessage(const msg: string): string; override;
  public
    { public declarations }
  end;

  TDecimalMinValidator = class(TAbstractValidator, IConstraintValidator)
  private
    fMinValue: Double;
  protected
    procedure Initialize(const attribute: ConstraintAttribute); override;
    function IsValid(const value: TValue): Boolean;
    function ProcessingMessage(const msg: string): string; override;
  public
    { public declarations }
  end;

  TNotNullValidator = class(TAbstractValidator, IConstraintValidator)
  private
    { private declarations }
  protected
    function IsValid(const value: TValue): Boolean;
  public
    { public declarations }
  end;

  TNullValidator = class(TAbstractValidator, IConstraintValidator)
  private
    { private declarations }
  protected
    function IsValid(const value: TValue): Boolean;
  public
    { public declarations }
  end;

  TPastValidator = class(TAbstractValidator, IConstraintValidator)
  private
    { private declarations }
  protected
    function IsValid(const value: TValue): Boolean;
  public
    { public declarations }
  end;

  TPresentValidator = class(TAbstractValidator, IConstraintValidator)
  private
    { private declarations }
  protected
    function IsValid(const value: TValue): Boolean;
  public
    { public declarations }
  end;

  TFutureValidator = class(TAbstractValidator, IConstraintValidator)
  private
    { private declarations }
  protected
    function IsValid(const value: TValue): Boolean;
  public
    { public declarations }
  end;

implementation

{ TAbstractValidator }

procedure TAbstractValidator.Initialize(const attribute: ConstraintAttribute);
begin
  { not used }
end;

function TAbstractValidator.ProcessingMessage(const msg: string): string;
begin
  Result := msg;
end;

{ TAssertFalseValidator }

function TAssertFalseValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit(value.AsType<TField>.AsBoolean = False)
    else
      Exit(True);

  if value.IsType<Boolean> then
    Exit(value.AsType<Boolean> = False);
end;

{ TAssertTrueValidator }

function TAssertTrueValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit(value.AsType<TField>.AsBoolean = True)
    else
      Exit(True);

  if value.IsType<Boolean> then
    Exit(value.AsType<Boolean> = True);
end;

{ TMaxValidator }

procedure TMaxValidator.Initialize(const attribute: ConstraintAttribute);
begin
  inherited;
  fMaxValue := MaxAttribute(attribute).Value;
end;

function TMaxValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit(value.AsType<TField>.AsInteger <= fMaxValue)
    else
      Exit(True);

  if value.IsType<Integer> then
    Exit(value.AsType<Integer> <= fMaxValue)
end;

function TMaxValidator.ProcessingMessage(const msg: string): string;
begin
  Result := msg.Replace('{value}', fMaxValue.ToString);
end;

{ TMinValidator }

function TMinValidator.ProcessingMessage(const msg: string): string;
begin
  Result := msg.Replace('{value}', fMinValue.ToString);
end;

procedure TMinValidator.Initialize(const attribute: ConstraintAttribute);
begin
  inherited;
  fMinValue := MinAttribute(attribute).Value;
end;

function TMinValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit(value.AsType<TField>.AsInteger >= fMinValue)
    else
      Exit(True);

  if value.IsType<Integer> then
    Exit(value.AsType<Integer> >= fMinValue);
end;

{ TSizeValidator }

procedure TSizeValidator.Initialize(const attribute: ConstraintAttribute);
begin
  inherited;
  fMinValue := SizeAttribute(attribute).Min;
  fMaxValue := SizeAttribute(attribute).Max;
end;

function TSizeValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit((value.AsType<TField>.AsString.Length >= fMinValue) and (value.AsType<TField>.AsString.Length <= fMaxValue))
    else
      Exit(True);

  if (value.IsType<string>) then
    Exit((value.AsType<string>.Length >= fMinValue) and (value.AsType<string>.Length <= fMaxValue));
end;

function TSizeValidator.ProcessingMessage(const msg: string): string;
begin
  Result := msg.Replace('{min}', fMinValue.ToString).Replace('{max}', fMaxValue.ToString);
end;

{ TNotNullValidator }

function TNotNullValidator.IsValid(const value: TValue): Boolean;
begin
  if (not value.IsEmpty) and (value.IsType<TField>) then
    case value.AsType<TField>.DataType of
      ftString, ftMemo, ftFmtMemo, ftWideString, ftFixedWideChar, ftWideMemo:
        Exit(not value.AsType<TField>.AsString.IsEmpty)
    else
      Exit(not value.AsType<TField>.IsNull);
    end;

  case value.Kind of
    tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
      Exit(not value.ToString.IsEmpty);
  else
    Exit(not value.IsEmpty);
  end;
end;

{ TNullValidator }

function TNullValidator.IsValid(const value: TValue): Boolean;
begin
  if (not value.IsEmpty) and (value.IsType<TField>) then
    case value.AsType<TField>.DataType of
      ftString, ftMemo, ftFmtMemo, ftWideString, ftFixedWideChar, ftWideMemo:
        Exit(value.AsType<TField>.AsString.IsEmpty)
    else
      Exit(value.AsType<TField>.IsNull);
    end;

  case value.Kind of
    tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
      Exit(value.ToString.IsEmpty);
  else
    Exit(value.IsEmpty);
  end;
end;

{ TPastValidator }

function TPastValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit(CompareDate(value.AsType<TField>.AsDateTime, Now) = LessThanValue)
    else
      Exit(True);

  if value.IsType<TDateTime> then
    Exit(CompareDate(value.AsType<TDateTime>, Now) = LessThanValue);
end;

{ TPresentValidator }

function TPresentValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit(CompareDate(value.AsType<TField>.AsDateTime, Now) = EqualsValue)
    else
      Exit(True);

  if value.IsType<TDateTime> then
    Exit(CompareDate(value.AsType<TDateTime>, Now) = EqualsValue);
end;

{ TFutureValidator }

function TFutureValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit(CompareDate(value.AsType<TField>.AsDateTime, Now) = GreaterThanValue)
    else
      Exit(True);

  if value.IsType<TDateTime> then
    Exit(CompareDate(value.AsType<TDateTime>, Now) = GreaterThanValue);
end;

{ TDecimalMaxValidator }

procedure TDecimalMaxValidator.Initialize(const attribute: ConstraintAttribute);
begin
  inherited;
  fMaxValue := DecimalMaxAttribute(attribute).Value;
end;

function TDecimalMaxValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit(value.AsType<TField>.AsFloat <= fMaxValue)
    else
      Exit(True);

  if value.IsType<Double> then
    Exit(value.AsType<Double> <= fMaxValue);
end;

function TDecimalMaxValidator.ProcessingMessage(const msg: string): string;
begin
  Result := msg.Replace('{value}', fMaxValue.ToString);
end;

{ TDecimalMinValidator }

procedure TDecimalMinValidator.Initialize(const attribute: ConstraintAttribute);
begin
  inherited;
  fMinValue := DecimalMaxAttribute(attribute).Value;
end;

function TDecimalMinValidator.IsValid(const value: TValue): Boolean;
begin
  Result := False;

  if (not value.IsEmpty) and (value.IsType<TField>) then
    if (not value.AsType<TField>.IsNull) then
      Exit(value.AsType<TField>.AsFloat >= fMinValue)
    else
      Exit(True);

  if value.IsType<Double> then
    Exit(value.AsType<Double> >= fMinValue);
end;

function TDecimalMinValidator.ProcessingMessage(const msg: string): string;
begin
  Result := msg.Replace('{value}', fMinValue.ToString);
end;

end.
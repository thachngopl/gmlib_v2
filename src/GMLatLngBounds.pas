{
  @abstract(@code(google.maps.LatLngBounds) class from Google Maps API.)
  @author(Xavier Martinez (cadetill) <cadetill@gmail.com>)
  @created(October 1, 2015)
  @lastmod(October 1, 2015)

  The GMLatLngBounds contains the implementation of TGMLatLngBounds class that encapsulate the @code(google.maps.LatLngBounds) class from Google Maps API.
}
unit GMLatLngBounds;

{$I ..\gmlib.inc}

interface

uses
  {$IFDEF DELPHIXE2}
  System.Classes,
  {$ELSE}
  Classes,
  {$ENDIF}

  GMClasses, GMSets, GMLatLng;

type
  { -------------------------------------------------------------------------- }
  // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.txt)
  TGMLatLngBounds = class(TGMPersistentStr, IGMControlChanges)
  private
    FLang: TGMLang;
    FNE: TGMLatLng;
    FSW: TGMLatLng;
  protected
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.GetOwnerLang.txt)
    function GetOwnerLang: TGMLang; override;

    // @exclude
    function GetAPIUrl: string; override;

    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.PropertyChanged.txt)
    procedure PropertyChanged(Prop: TPersistent);
  public
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Create_1.txt)
    constructor Create(SWLat: Real = 0; SWLng: Real = 0; NELat: Real = 0; NELng: Real = 0; Lang: TGMLang = lnEnglish); reintroduce; overload; virtual;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Create_2.txt)
    constructor Create(SW, NE: TGMLatLng; Lang: TGMLang = lnEnglish); reintroduce; overload; virtual;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Create_3.txt)
    constructor Create(AOwner: TPersistent; SWLat: Real = 0; SWLng: Real = 0; NELat: Real = 0; NELng: Real = 0); reintroduce; overload; virtual;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Create_4.txt)
    constructor Create(AOwner: TPersistent; SW, NE: TGMLatLng); reintroduce; overload; virtual;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Destroy.txt)
    destructor Destroy; override;

    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Assign.txt)
    procedure Assign(Source: TPersistent); override;

    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Extend.txt)
    procedure Extend(LatLng: TGMLatLng);
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Union.txt)
    procedure Union(Other: TGMLatLngBounds);
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.GetCenter.txt)
    procedure GetCenter(LatLng: TGMLatLng);
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.ToSpan.txt)
    procedure ToSpan(LatLng: TGMLatLng);
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Contains.txt)
    function Contains(LatLng: TGMLatLng): Boolean;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.IsEqual.txt)
    function IsEqual(Other: TGMLatLngBounds): Boolean;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.Intersects.txt)
    function Intersects(Other: TGMLatLngBounds): Boolean;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.IsEmpty.txt)
    function IsEmpty: Boolean;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.ToStr.txt)
    function ToStr(Precision: Integer = 6): string;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.ToUrlValue.txt)
    function ToUrlValue(Precision: Integer = 6): string;

    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.PropToString.txt)
    function PropToString: string; override;

    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.APIUrl.txt)
    property APIUrl;
  published
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.SW.txt)
    property SW: TGMLatLng read FSW write FSW;
    // @include(..\docs\GMLatLngBounds.TGMLatLngBounds.NE.txt)
    property NE: TGMLatLng read FNE write FNE;
  end;

implementation

uses
  {$IFDEF DELPHIXE2}
  System.SysUtils;
  {$ELSE}
  SysUtils;
  {$ENDIF}

{ TGMLatLngBounds }

constructor TGMLatLngBounds.Create(SW, NE: TGMLatLng; Lang: TGMLang);
begin
  inherited Create(nil);

  FSW := TGMLatLng.Create(SW.Lat, SW.Lng, False, Lang);
  FNE := TGMLatLng.Create(NE.Lat, NE.Lng, False, Lang);
  FLang := Lang;
end;

constructor TGMLatLngBounds.Create(SWLat, SWLng, NELat, NELng: Real;
  Lang: TGMLang);
begin
  inherited Create(nil);

  FSW := TGMLatLng.Create(SWLat, SWLng, False, Lang);
  FNE := TGMLatLng.Create(NELat, NELng, False, Lang);
  FLang := Lang;
end;

procedure TGMLatLngBounds.Assign(Source: TPersistent);
begin
  inherited;

  if Source is TGMLatLngBounds then
  begin
    SW.Assign(TGMLatLngBounds(Source).SW);
    NE.Assign(TGMLatLngBounds(Source).NE);
  end;
end;

function TGMLatLngBounds.Contains(LatLng: TGMLatLng): Boolean;
const
  StrParams = '%s,%s,%s,%s,%s,%s';
var
  Params: string;
  Intf: IGMExecJS;
begin
  if not Assigned(GetOwner()) then
    raise EGMWithoutOwner.Create(2, [], GetOwnerLang);
  if not Supports(GetOwner(), IGMExecJS, Intf) then
    raise EGMOwnerWithoutJS.Create(3, [], GetOwnerLang);
  if not Assigned(LatLng) then
    raise EGMUnassignedObject.Create(5, ['LatLng'], GetOwnerLang);

  Params := Format(StrParams, [LatLng.LatToStr,
                               LatLng.LngToStr,
                               FSW.LatToStr,
                               FSW.LngToStr,
                               FNE.LatToStr,
                               FNE.LngToStr
                               ]);
  if Intf.ExecuteScript('LLB_Contains', Params) then
  begin
    Result := True;
//    FSW.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLat), Precision);
//    FSW.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLng), Precision);
//    FNE.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELat), Precision);
//    FNE.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELng), Precision);
  end
  else
    raise EGMJSError.Create(4, ['LLB_Contains'], GetOwnerLang);
end;

constructor TGMLatLngBounds.Create(AOwner: TPersistent; SW, NE: TGMLatLng);
begin
  inherited Create(AOwner);

  FSW := TGMLatLng.Create(Self, SW.Lat, SW.Lng, False);
  FNE := TGMLatLng.Create(Self, NE.Lat, NE.Lng, False);
  FLang := lnUnknown;
end;

destructor TGMLatLngBounds.Destroy;
begin
  if Assigned(FSW) then FreeAndNil(FSW);
  if Assigned(FNE) then FreeAndNil(FNE);

  inherited;
end;

procedure TGMLatLngBounds.Extend(LatLng: TGMLatLng);
const
  StrParams = '%s,%s,%s,%s,%s,%s';
var
  Params: string;
  Intf: IGMExecJS;
begin
  if not Assigned(GetOwner()) then
    raise EGMWithoutOwner.Create(2, [], GetOwnerLang);
  if not Supports(GetOwner(), IGMExecJS, Intf) then
    raise EGMOwnerWithoutJS.Create(3, [], GetOwnerLang);
  if not Assigned(LatLng) then
    raise EGMUnassignedObject.Create(5, ['LatLng'], GetOwnerLang);

  Params := Format(StrParams, [LatLng.LatToStr,
                               LatLng.LngToStr,
                               FSW.LatToStr,
                               FSW.LngToStr,
                               FNE.LatToStr,
                               FNE.LngToStr
                               ]);
  if Intf.ExecuteScript('LLB_Extend', Params) then
  begin
//    FSW.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLat), Precision);
//    FSW.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLng), Precision);
//    FNE.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELat), Precision);
//    FNE.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELng), Precision);
  end
  else
    raise EGMJSError.Create(4, ['LLB_Extend'], GetOwnerLang);
end;

function TGMLatLngBounds.GetAPIUrl: string;
begin
  Result := 'https://developers.google.com/maps/documentation/javascript/reference#LatLngBounds';
end;

procedure TGMLatLngBounds.GetCenter(LatLng: TGMLatLng);
const
  StrParams = '%s,%s,%s,%s';
var
  Params: string;
  Intf: IGMExecJS;
begin
  if not Assigned(GetOwner()) then
    raise EGMWithoutOwner.Create(2, [], GetOwnerLang);
  if not Supports(GetOwner(), IGMExecJS, Intf) then
    raise EGMOwnerWithoutJS.Create(3, [], GetOwnerLang);

  Params := Format(StrParams, [FSW.LatToStr,
                               FSW.LngToStr,
                               FNE.LatToStr,
                               FNE.LngToStr
                               ]);
  if Intf.ExecuteScript('LLB_Center', Params) then
  begin
//    FSW.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLat), Precision);
//    FSW.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLng), Precision);
//    FNE.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELat), Precision);
//    FNE.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELng), Precision);
  end
  else
    raise EGMJSError.Create(4, ['LLB_Center'], GetOwnerLang);
end;

function TGMLatLngBounds.GetOwnerLang: TGMLang;
begin
  Result := FLang;
  if FLang = lnUnknown then
    inherited;
end;

function TGMLatLngBounds.Intersects(Other: TGMLatLngBounds): Boolean;
var
  Intf: IGMExecJS;
begin
  if not Assigned(GetOwner()) then
    raise EGMWithoutOwner.Create(2, [], GetOwnerLang);
  if not Supports(GetOwner(), IGMExecJS, Intf) then
    raise EGMOwnerWithoutJS.Create(3, [], GetOwnerLang);
  if not Assigned(Other) then
    raise EGMUnassignedObject.Create(5, ['Other'], GetOwnerLang);

  if Intf.ExecuteScript('LLB_Intersects', '') then
  begin
//    FSW.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLat), Precision);
//    FSW.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLng), Precision);
//    FNE.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELat), Precision);
//    FNE.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELng), Precision);
  end
  else
    raise EGMJSError.Create(4, ['LLB_Intersects'], GetOwnerLang);
end;

function TGMLatLngBounds.IsEmpty: Boolean;
begin
  Result := FSW.IsEqual(FNE);
end;

function TGMLatLngBounds.IsEqual(Other: TGMLatLngBounds): Boolean;
begin
  Result := FNE.IsEqual(Other.NE) and FSW.IsEqual(Other.SW);
end;

procedure TGMLatLngBounds.PropertyChanged(Prop: TPersistent);
begin
  ControlChanges;
end;

function TGMLatLngBounds.PropToString: string;
const
  Str = '%s,%s';
begin
  Result := inherited PropToString;
  if Result <> '' then Result := Result + ',';
  Result := Result +
            Format(Str, [FNE.PropToString,
                         FSW.PropToString
                         ]);
end;

procedure TGMLatLngBounds.ToSpan(LatLng: TGMLatLng);
var
  Intf: IGMExecJS;
begin
  if not Assigned(GetOwner()) then
    raise EGMWithoutOwner.Create(2, [], GetOwnerLang);
  if not Supports(GetOwner(), IGMExecJS, Intf) then
    raise EGMOwnerWithoutJS.Create(3, [], GetOwnerLang);

  if Intf.ExecuteScript('LLB_Span', '') then
  begin
//    FSW.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLat), Precision);
//    FSW.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLng), Precision);
//    FNE.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELat), Precision);
//    FNE.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELng), Precision);
  end
  else
    raise EGMJSError.Create(4, ['LLB_Span'], GetOwnerLang);
end;

function TGMLatLngBounds.ToStr(Precision: Integer): string;
const
  Str = '(%s, %s)';
begin
  Result := Format(Str, [FSW.ToStr(Precision), FNE.ToStr(Precision)]);
end;

function TGMLatLngBounds.ToUrlValue(Precision: Integer): string;
const
  Str = '%s,%s';
begin
  Result := Format(Str, [FSW.ToUrlValue(Precision), FNE.ToUrlValue(Precision)]);
end;

procedure TGMLatLngBounds.Union(Other: TGMLatLngBounds);
const
  StrParams = '%s,%s,%s,%s,%s,%s,%s,%s';
var
  Params: string;
  Intf: IGMExecJS;
begin
  if not Assigned(GetOwner()) then
    raise EGMWithoutOwner.Create(2, [], GetOwnerLang);
  if not Supports(GetOwner(), IGMExecJS, Intf) then
    raise EGMOwnerWithoutJS.Create(3, [], GetOwnerLang);
  if not Assigned(Other) then
    raise EGMUnassignedObject.Create(5, ['Other'], GetOwnerLang);

  Params := Format(StrParams, [Other.SW.LatToStr,
                               Other.SW.LngToStr,
                               Other.NE.LatToStr,
                               Other.NE.LngToStr,
                               FSW.LatToStr,
                               FSW.LngToStr,
                               FNE.LatToStr,
                               FNE.LngToStr
                               ]);
  if Intf.ExecuteScript('LLB_Union', Params) then
  begin
//    FSW.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLat), Precision);
//    FSW.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormSWLng), Precision);
//    FNE.Lat := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELat), Precision);
//    FNE.Lng := ControlPrecision(FWC.GetFloatField(LatLngBoundsForm, LatLngBoundsFormNELng), Precision);
  end
  else
    raise EGMJSError.Create(4, ['LLB_Union'], GetOwnerLang);
end;

constructor TGMLatLngBounds.Create(AOwner: TPersistent; SWLat, SWLng, NELat,
  NELng: Real);
begin
  inherited Create(AOwner);

  FSW := TGMLatLng.Create(Self, SWLat, SWLng, False);
  FNE := TGMLatLng.Create(Self, NELat, NELng, False);
  FLang := lnUnknown;
end;

end.
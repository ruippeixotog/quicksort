Program Quicksort(output);

procedure Swap(var Arr: Array of Integer; I, J: Integer);
var
  Tmp: Integer;
begin
  Tmp := Arr[I];
  Arr[I] := Arr[J];
  Arr[J] := Tmp
end;

procedure Quicksort(var Arr: Array of Integer; St, En: Integer);
var
  I, Sep: Integer;
begin
  if St = En then
    Exit;

  Sep := St;
  for I := St + 1 to En - 1 do
    if Arr[I] < Arr[St] then
      Swap(Arr, ++Sep, I);

  Swap(Arr, St, Sep);
  Quicksort(Arr, St, Sep);
  Quicksort(Arr, Sep + 1, En)
end;

var
  N, I: Integer;
  Arr: Array of Integer;
begin
  Read(N);
  SetLength(Arr, N);
  for I := 0 to N - 1 do  
    Read(Arr[I]);

  Quicksort(Arr, 0, N);

  if N > 0 then
    Write(Arr[0]);

  for I := 1 to N - 1 do
  begin
    Write(' ');
    Write(Arr[I])
  end;

  WriteLn
end.

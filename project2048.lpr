program project2048;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };

var
  i,
  a: array[1..16] of word;

function sum(a,b:word);
 begin
   sum:=a+b;
 end;

begin
end.


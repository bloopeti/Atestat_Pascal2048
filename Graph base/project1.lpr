program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this };
  Crt,
  Graph;

var
 a:string;
 GraphDriver, GraphMode: Integer;
 X1, Y1, X2, Y2: Integer;

begin
 GraphDriver := Detect;
 InitGraph(GraphDriver, GraphMode, 'x:\BGI');
 if GraphResult<> grOk then
   Halt(1);
 {felosztas}
   Rectangle(5, 5, getmaxy-5, getmaxy-5); {keret}
   {vizszintes}
   Line(5, getmaxy div 4, getmaxy-5, getmaxy div 4);         {1/4vonal}
   Line(5, getmaxy div 2, getmaxy-5, getmaxy div 2);         {1/2vonal}
   Line(5, getmaxy div 4 * 3, getmaxy-5, getmaxy div 4 * 3); {3/4vonal}
   {fuggoleges}
   Line(getmaxy div 4, 5, getmaxy div 4, getmaxy-5);         {1/4vonal}
   Line(getmaxy div 2, 5, getmaxy div 2, getmaxy-5);         {1/2vonal}
   Line(getmaxy div 4 * 3, 5, getmaxy div 4 * 3, getmaxy-5); {3/4vonal}


   settextstyle(0,0,3);
   outtextxy(getmaxy div 8-45, getmaxy div 8-10, chr(13));


 ReadLn;
 CloseGraph;
end.

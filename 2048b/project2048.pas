program project2048;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Crt;

type
  matrix= array[1..4,1..4] of word;

var
  a: matrix;
  ch: char;
  GraphDriver, GraphMode: integer;

{tabla inicializalasa}
procedure init(var a:matrix);
  var i,j:byte;
  begin
    for i:=1 to 4 do
      for j:=1 to 4 do
        a[i,j]:=0;
  end;

{uj random szam(2/4) generalasa}
function randNo(): byte;
  begin
    randNo:=((random(2)+1)*2);
  end;

{a fenti random szam poziciojanak generalasa}
function randPos(): byte;
  begin
    randPos:=(random(4)+1);
  end;

{uj elem(2/4) helyezese a tablara}
procedure ins(var a:matrix);
  var n,m:byte;
  begin
    n:=randPos();
    m:=randPos();
                 {write(n,'.',m,' ');}
    while a[n,m]<>0 do
      begin
        n:=randPos();
        m:=randPos();
                 {write(n,'.',m,' '); }
      end;
    a[n,m]:=randNo;
                 {writeln;}
  end;

{jatek kezdeti allapota
  friss tabla 2 elemmel}
procedure newG();
  begin
    init(a);
    ins(a);
    ins(a);
  end;


{elemek szama (oszlopon)}
function xNoo(j:byte; a:matrix):byte;
  var i,x:byte;
  begin
    x:=0;
    for i:=1 to 4 do
      if a[i,j]<>0 then
        x:=x+1;
    xNoo:=x;
  end;

{elemek szama (soron)}
function xNos(i:byte; a:matrix):byte;
  var j,x:byte;
  begin
    x:=0;
    for j:=1 to 4 do
      if a[i,j]<>0 then
        x:=x+1;
    xNos:=x;
  end;


{oszlopon}
{tolas (oszlopon, fel) ha 1 elem van}
procedure p1of(j:byte; var a:matrix);
  var i:byte;
  begin
    for i:=2 to 4 do
      if a[i,j]<>0 then
        begin
          a[1,j]:=a[i,j];
          a[i,j]:=0;
        end;
  end;

{tolas (oszlopon, le) ha 1 elem van}
procedure p1ol(j:byte; var a:matrix);
  var i:byte;
  begin
    for i:=3 downto 1 do
      if a[i,j]<>0 then
        begin
          a[4,j]:=a[i,j];
          a[i,j]:=0;
        end;
  end;

{soron}
{tolas (soron, balra) ha 1 elem van}
procedure p1sb(i:byte; var a:matrix);
  var j:byte;
  begin
    for j:=2 to 4 do
      if a[i,j]<>0 then
        begin
          a[i,1]:=a[i,j];
          a[i,j]:=0;
        end;
  end;

{tolas (soron, jobbra) ha 1 elem van}
procedure p1sj(i:byte; var a:matrix);
  var j:byte;
  begin
    for j:=3 downto 1 do
      if a[i,j]<>0 then
        begin
          a[i,4]:=a[i,j];
          a[i,j]:=0;
        end;
  end;


{oszlopon}
{tolas (oszlopon,fel) ha 2 elem van}
procedure p2of(j:byte; var a:matrix);
  var x,i:byte;
      t:word;
  begin
    x:=1;
    for i:=1 to 4 do
      begin
        if a[i,j]<>0 then
          begin
            t:=a[i,j];
            a[i,j]:=0;
            a[x,j]:=t;
            x:=x+1;
          end;
      end;
  end;

{tolas (oszlopon,le) ha 2 elem van}
procedure p2ol(j:byte; var a:matrix);
  var x,i:byte;
      t:word;
  begin
    x:=4;
    for i:=4 downto 1 do
      begin
        if a[i,j]<>0 then
          begin
            t:=a[i,j];
            a[i,j]:=0;
            a[x,j]:=t;
            x:=x-1;
          end;
      end;
  end;

{soron}
{tolas (soron, balra) ha 2 elem van}
procedure p2sb(i:byte; var a:matrix);
  var x,j:byte;
      t:word;
  begin
    x:=1;
    for j:=1 to 4 do
      begin
        if a[i,j]<>0 then
          begin
            t:=a[i,j];
            a[i,j]:=0;
            a[i,x]:=t;
            x:=x+1;
          end;
      end;
  end;

{tolas (soron, jobbra) ha 2 elem van}
procedure p2sj(i:byte; var a:matrix);
  var x,j:byte;
      t:word;
  begin
    x:=4;
    for j:=4 downto 1 do
      begin
        if a[i,j]<>0 then
          begin
            t:=a[i,j];
            a[i,j]:=0;
            a[i,x]:=t;
            x:=x-1;
          end;
      end;
  end;


{tolas (oszlopon, fel)}
procedure pof(var a:matrix);
  var j:byte;
  begin
    for j:=1 to 4 do
      begin
        if xNoo(j,a)=1 then
          p1of(j,a);
        if xNoo(j,a)>1 then
          p2of(j,a);
      end;
  end;

{tolas (oszlopon, le)}
procedure pol(var a:matrix);
  var j:byte;
  begin
    for j:=1 to 4 do
      begin
        if xNoo(j,a)=1 then
          p1ol(j,a);
        if xNoo(j,a)>1 then
          p2ol(j,a);
      end;
  end;


{tolas (soron, balra)}
procedure psb(var a:matrix);
  var i:byte;
  begin
    for i:=1 to 4 do
      begin
        if xNos(i,a)=1 then
          p1sb(i,a);
        if xNos(i,a)>1 then
          p2sb(i,a);
      end;
  end;

{tolas (soron, jobbra)}
procedure psj(var a:matrix);
  var i:byte;
  begin
    for i:=1 to 4 do
      begin
        if xNos(i,a)=1 then
          p1sj(i,a);
        if xNos(i,a)>1 then
          p2sj(i,a);
      end;
  end;


{tolas}
procedure push(var a:matrix);
  begin
    if (ch='w') or (ch='W') then
      pof(a);
    if (ch='s') or (ch='S') then
      pol(a);
    if (ch='a') or (ch='A') then
      psb(a);
    if (ch='d') or (ch='D') then
      psj(a);
  end;


{osszegzes (oszlopon, fel)}
procedure sof(var a:matrix);
  var i,j:byte;
  begin
    for j:=1 to 4 do
      for i:=1 to 3 do
        if a[i,j]=a[i+1,j] then
          begin
            a[i,j]:=a[i,j]*2;
            a[i+1,j]:=0;
          end;
  end;

{osszegzes (oszlopon, le)}
procedure sol(var a:matrix);
  var i,j:byte;
  begin
    for j:=1 to 4 do
      for i:=4 downto 2 do
        if a[i,j]=a[i-1,j] then
          begin
            a[i,j]:=a[i,j]*2;
            a[i-1,j]:=0;
          end;
  end;


{osszegzes (soron, balra)}
procedure ssb(var a:matrix);
  var i,j:byte;
  begin
    for i:=1 to 4 do
      for j:=1 to 3 do
        if a[i,j]=a[i,j+1] then
          begin
            a[i,j]:=a[i,j]*2;
            a[i,j+1]:=0;
          end;
  end;

{osszegzes (soron, jobbra)}
procedure ssj(var a:matrix);
  var i,j:byte;
  begin
    for i:=1 to 4 do
      for j:=4 downto 2 do
        if a[i,j]=a[i,j-1] then
          begin
            a[i,j]:=a[i,j]*2;
            a[i,j-1]:=0;
          end;
  end;


{osszegzes}
procedure sum(var a:matrix);
  begin
    if (ch='w') or (ch='W') then
      sof(a);
    if (ch='s') or (ch='S') then
      sol(a);
    if (ch='a') or (ch='A') then
      ssb(a);
    if (ch='d') or (ch='D') then
      ssj(a);
  end;


{gombnyomasra valo muvelet:
(jelenlegi tabla vegso formaja, uj elem)}
procedure stuff(var a:matrix);
  begin
    push(a);
    sum(a);
    push(a);
    ins(a);
  end;

{tabla kiirasa}
procedure display(a:matrix);
  var i,j:byte;
  begin
    for i:=1 to 4 do
    begin
      for j:=1 to 4 do
        begin
          write(a[i,j],' ');
        end;
      writeln;
    end;
  end;


{vegso feltetelek ellenorzese
  -letezik 2048 a tablaban? =1
  -van e meg hely? =2}
function fin(a:matrix):byte;
  var i,j,k,l,s:byte;
  begin
    k:=0;
    l:=0;
    s:=0;
    for i:=1 to 4 do
      for j:=1 to 4 do
        begin
          if a[i,j]=2048 then
            k:=1;
          if a[i,j]<>0 then
            s:=s+1;
        end;
    if s=16 then
      l:=2;
    if k=1 then
      fin:=k
      else
        if l=2 then
          fin:=l;
  end;


{tabla kiirasa}
procedure tDisplay();
  begin
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
  end;

{grafikus kiiras}
procedure gDisplay(a:matrix);
  var i,j:byte;
  begin
    {elso oszlop}
    outtextxy((getmaxy div 8)-45, (getmaxy div 8)-10, a[1,1]);      {1.1}
    outtextxy((getmaxy div 8)-45, (getmaxy div 8)*3-10, a[1,2]);    {1.2}
    outtextxy((getmaxy div 8)-45, (getmaxy div 8)*5-10, a[1,3]);    {1.3}
    outtextxy((getmaxy div 8)-45, (getmaxy div 8)*7-10, a[1,4]);    {1.4}

    {masodik oszlop}
    outtextxy((getmaxy div 8)*3-45, (getmaxy div 8)-10, a[2,1]);    {2.1}
    outtextxy((getmaxy div 8)*3-45, (getmaxy div 8)*3-10, a[2,2]);  {2.2}
    outtextxy((getmaxy div 8)*3-45, (getmaxy div 8)*5-10, a[2,3]);  {2.3}
    outtextxy((getmaxy div 8)*3-45, (getmaxy div 8)*7-10, a[2,4]);  {2.4}

    {harmadik oszlop}
    outtextxy((getmaxy div 8)*5-45, (getmaxy div 8)-10, a[3,1]);    {3.1}
    outtextxy((getmaxy div 8)*5-45, (getmaxy div 8)*3-10, a[3,2]);  {3.2}
    outtextxy((getmaxy div 8)*5-45, (getmaxy div 8)*5-10, a[3,3]);  {3.3}
    outtextxy((getmaxy div 8)*5-45, (getmaxy div 8)*7-10, a[3,4]);  {3.4}

    {negyedik oszlop}
    outtextxy((getmaxy div 8)*7-45, (getmaxy div 8)-10, a[4,1]);    {4.1}
    outtextxy((getmaxy div 8)*7-45, (getmaxy div 8)*3-10, a[4,2]);  {4.2}
    outtextxy((getmaxy div 8)*7-45, (getmaxy div 8)*5-10, a[4,3]);  {4.3}
    outtextxy((getmaxy div 8)*7-45, (getmaxy div 8)*7-10, a[4,4]);  {4.4}
  end;

{alternativ gDisplay}
procedure alt(a:matrix;)
  var i,j:byte;
      l:string;
  begin
  l:='0';
    for i:=1 to 4 do
      for j:=1 to 4 do
        begin
          str(a[i,j],l);
          outtextxy((getmaxy div 8)*(1+2*(i-1))-45, (getmaxy div 8)*(1+2*(j-1))-10, l);
        end;
  end;

{kiirasa mindennek}
procedure fDisplay();
  begin
   ClearDevice;
   tDisplay;
   gDisplay(a);
  end;


{jatek}
procedure g(a:matrix);
  begin
    repeat
      begin
        ch:=ReadKey;
        stuff(a);
        fDisplay;
      end;
    until (fin(a)<>0) or (ch='e') or (ch='E');
  end;


{foprogram}
begin
  GraphDriver := Detect;
  InitGraph(GraphDriver, GraphMode, ''); {/usr/lib/fpc/2.6.4/units/x86_64-linux/graph}
  if GraphResult<> grOk then
    Halt(1);
  settextstyle(0,0,3);

  randomize;
  newG;
  fDisplay;
  g(a);

  delay(100);
  readkey;
  ClearDevice;
  CloseGraph;
end.

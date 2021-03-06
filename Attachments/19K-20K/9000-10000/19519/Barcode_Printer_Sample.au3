
#include <file.au3>
#include <array.au3>

Dim $PS, $szDrive, $szDir, $szFName, $szExt
Const $File = FileOpen(@ScriptDir & "\Barcode.ps", 2)

$PS = ""

; Check if file opened for writing OK
If $File = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

$PS = '%!PS-Adobe-2.0' 
$PS = $PS & @CRLF & '% --BEGIN TEMPLATE--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --BEGIN ENCODER ean13--'
$PS = $PS & @CRLF & '% --DESC: EAN-13'
$PS = $PS & @CRLF & '% --EXAM: 977147396801'
$PS = $PS & @CRLF & '% --EXOP: includetext guardwhitespace'
$PS = $PS & @CRLF & '% --RNDR: renlinear'
$PS = $PS & @CRLF & '/ean13 {'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    0 begin'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /options exch def                  % We are given an option string'
$PS = $PS & @CRLF & '    /useropts options def'
$PS = $PS & @CRLF & '    /barcode exch def                  % We are given a barcode string'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /includetext false def             % Enable/disable text'
$PS = $PS & @CRLF & '    /textfont /Helvetica def'
$PS = $PS & @CRLF & '    /textsize 12 def'
$PS = $PS & @CRLF & '    /textyoffset -4 def'
$PS = $PS & @CRLF & '    /height 1 def'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    % Parse the input options'
$PS = $PS & @CRLF & '    options {'
$PS = $PS & @CRLF & '        token false eq {exit} if dup length string cvs (=) search'
$PS = $PS & @CRLF & '        true eq {cvlit exch pop exch def} {cvlit true def} ifelse'
$PS = $PS & @CRLF & '    } loop'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    /textfont textfont cvlit def'
$PS = $PS & @CRLF & '    /textsize textsize cvr def'
$PS = $PS & @CRLF & '    /textyoffset textyoffset cvr def'
$PS = $PS & @CRLF & '    /height height cvr def'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    /barlen barcode length def         % Length of the code'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Add checksum digit to barcode if length is even'
$PS = $PS & @CRLF & '    barlen 2 mod 0 eq {'
$PS = $PS & @CRLF & '        /pad barlen 1 add string def   % Create pad one bigger than barcode'
$PS = $PS & @CRLF & '        /checksum 0 def'
$PS = $PS & @CRLF & '        0 1 barlen 1 sub {'
$PS = $PS & @CRLF & '            /i exch def'
$PS = $PS & @CRLF & '            /barchar barcode i get 48 sub def'
$PS = $PS & @CRLF & '            i 2 mod 0 eq {'
$PS = $PS & @CRLF & '                /checksum barchar checksum add def'
$PS = $PS & @CRLF & '            } {'
$PS = $PS & @CRLF & '                /checksum barchar 3 mul checksum add def'
$PS = $PS & @CRLF & '            } ifelse'
$PS = $PS & @CRLF & '        } for'
$PS = $PS & @CRLF & '        /checksum 10 checksum 10 mod sub 10 mod def'
$PS = $PS & @CRLF & '        pad 0 barcode putinterval       % Add barcode to the start of the pad'
$PS = $PS & @CRLF & '        pad barlen checksum 48 add put  % Put ascii for checksum at end of pad'
$PS = $PS & @CRLF & '        /barcode pad def                % barcode=pad'
$PS = $PS & @CRLF & '        /barlen barlen 1 add def        % barlen++'
$PS = $PS & @CRLF & '    } if'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Create an array containing the character mappings'
$PS = $PS & @CRLF & '    /encs'
$PS = $PS & @CRLF & '    [ (3211) (2221) (2122) (1411) (1132)'
$PS = $PS & @CRLF & '      (1231) (1114) (1312) (1213) (3112)'
$PS = $PS & @CRLF & '      (111) (11111) (111)'
$PS = $PS & @CRLF & '    ] def'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Create a string of the available characters'
$PS = $PS & @CRLF & '    /barchars (0123456789) def'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Digits to mirror on left side'
$PS = $PS & @CRLF & '    /mirrormaps'
$PS = $PS & @CRLF & '    [ (000000) (001011) (001101) (001110) (010011)'
$PS = $PS & @CRLF & '      (011001) (011100) (010101) (010110) (011010)'
$PS = $PS & @CRLF & '    ] def'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /sbs barlen 1 sub 4 mul 11 add string def'
$PS = $PS & @CRLF & '    /txt barlen array def'
$PS = $PS & @CRLF & '  '
$PS = $PS & @CRLF & '    % Put the start character'
$PS = $PS & @CRLF & '    sbs 0 encs 10 get putinterval'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % First digit - determine mirrormap by this and show before guard bars'
$PS = $PS & @CRLF & '    /mirrormap mirrormaps barcode 0 get 48 sub get def'
$PS = $PS & @CRLF & '    txt 0 [barcode 0 1 getinterval -10 textyoffset textfont textsize] put'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Left side - performs mirroring'
$PS = $PS & @CRLF & '    1 1 6 {'
$PS = $PS & @CRLF & '        % Lookup the encoding for the each barcode character'
$PS = $PS & @CRLF & '        /i exch def'
$PS = $PS & @CRLF & '        barcode i 1 getinterval barchars exch search'
$PS = $PS & @CRLF & '        pop                            % Discard true leaving pre'
$PS = $PS & @CRLF & '        length /indx exch def          % indx is the length of pre'
$PS = $PS & @CRLF & '        pop pop                        % Discard seek and post'
$PS = $PS & @CRLF & '        /enc encs indx get def         % Get the indxth encoding'
$PS = $PS & @CRLF & '        mirrormap i 1 sub get 49 eq {   % Reverse enc if 1 in this position in mirrormap'
$PS = $PS & @CRLF & '            /enclen enc length def'
$PS = $PS & @CRLF & '            /revenc enclen string def'
$PS = $PS & @CRLF & '            0 1 enclen 1 sub {'
$PS = $PS & @CRLF & '                /j exch def'
$PS = $PS & @CRLF & '                /char enc j get def'
$PS = $PS & @CRLF & '                revenc enclen j sub 1 sub char put'
$PS = $PS & @CRLF & '            } for'
$PS = $PS & @CRLF & '            /enc revenc def'
$PS = $PS & @CRLF & '        } if'
$PS = $PS & @CRLF & '        sbs i 1 sub 4 mul 3 add enc putinterval   % Put encoded digit into sbs'
$PS = $PS & @CRLF & '        txt i [barcode i 1 getinterval i 1 sub 7 mul 4 add textyoffset textfont textsize] put'
$PS = $PS & @CRLF & '    } for'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Put the middle character'
$PS = $PS & @CRLF & '    sbs 7 1 sub 4 mul 3 add encs 11 get putinterval'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Right side'
$PS = $PS & @CRLF & '    7 1 12 {'
$PS = $PS & @CRLF & '        % Lookup the encoding for the each barcode character'
$PS = $PS & @CRLF & '        /i exch def'
$PS = $PS & @CRLF & '        barcode i 1 getinterval barchars exch search'
$PS = $PS & @CRLF & '        pop                            % Discard true leaving pre'
$PS = $PS & @CRLF & '        length /indx exch def          % indx is the length of pre'
$PS = $PS & @CRLF & '        pop pop                        % Discard seek and post'
$PS = $PS & @CRLF & '        /enc encs indx get def         % Get the indxth encoding'
$PS = $PS & @CRLF & '        sbs i 1 sub 4 mul 8 add enc putinterval  % Put encoded digit into sbs'
$PS = $PS & @CRLF & '        txt i [barcode i 1 getinterval i 1 sub 7 mul 8 add textyoffset textfont textsize] put'
$PS = $PS & @CRLF & '    } for'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Put the end character'
$PS = $PS & @CRLF & '    sbs barlen 1 sub 4 mul 8 add encs 12 get putinterval'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    % Return the arguments'
$PS = $PS & @CRLF & '    /retval 8 dict def'
$PS = $PS & @CRLF & '    retval (ren) (renlinear) put'
$PS = $PS & @CRLF & '    retval (sbs) [sbs {48 sub} forall] put'
$PS = $PS & @CRLF & '    includetext {'
$PS = $PS & @CRLF & '        retval (bhs) [height height 12{height .075 sub}repeat height height 12{height .075 sub}repeat height height] put'
$PS = $PS & @CRLF & '        retval (bbs) [0 0 12{.075}repeat 0 0 12{.075}repeat 0 0] put'
$PS = $PS & @CRLF & '        retval (txt) txt put'
$PS = $PS & @CRLF & '    } {'
$PS = $PS & @CRLF & '        retval (bhs) [30{height}repeat] put        '
$PS = $PS & @CRLF & '        retval (bbs) [30{0}repeat] put'
$PS = $PS & @CRLF & '    } ifelse'
$PS = $PS & @CRLF & '    retval (opt) useropts put'
$PS = $PS & @CRLF & '    retval (guardrightpos) 10 put'
$PS = $PS & @CRLF & '    retval (borderbottom) 5 put'
$PS = $PS & @CRLF & '    retval'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    end'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '} bind def'
$PS = $PS & @CRLF & '/ean13 load 0 1 dict put'
$PS = $PS & @CRLF & '% --END ENCODER ean13--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --BEGIN ENCODER raw--'
$PS = $PS & @CRLF & '% --DESC: Raw bar space succession for custom symbologies '
$PS = $PS & @CRLF & '% --EXAM: 331132131313411122131311333213114131131221323'
$PS = $PS & @CRLF & '% --EXOP: height=0.5'
$PS = $PS & @CRLF & '% --RNDR: renlinear'
$PS = $PS & @CRLF & '/raw {'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    0 begin                  % Confine variables to local scope'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /options exch def        % We are given an option string'
$PS = $PS & @CRLF & '    /useropts options def'
$PS = $PS & @CRLF & '    /sbs exch def        % We are given a barcode string'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /height 1 def'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Parse the input options'
$PS = $PS & @CRLF & '    options {'
$PS = $PS & @CRLF & '        token false eq {exit} if dup length string cvs (=) search'
$PS = $PS & @CRLF & '        true eq {cvlit exch pop exch def} {cvlit true def} ifelse'
$PS = $PS & @CRLF & '    } loop'
$PS = $PS & @CRLF & '    /height height cvr def'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Return the arguments'
$PS = $PS & @CRLF & '    /retval 8 dict def'
$PS = $PS & @CRLF & '    retval (ren) (renlinear) put'
$PS = $PS & @CRLF & '    retval (sbs) [sbs {48 sub} forall] put'
$PS = $PS & @CRLF & '    retval (bhs) [sbs length 1 add 2 idiv {height} repeat] put'
$PS = $PS & @CRLF & '    retval (bbs) [sbs length 1 add 2 idiv {0} repeat] put '
$PS = $PS & @CRLF & '    retval (opt) useropts put'
$PS = $PS & @CRLF & '    retval'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    end'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '} bind def'
$PS = $PS & @CRLF & '/raw load 0 1 dict put'
$PS = $PS & @CRLF & '% --END ENCODER raw--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --BEGIN ENCODER symbol--'
$PS = $PS & @CRLF & '% --DESC: Miscellaneous symbols'
$PS = $PS & @CRLF & '% --EXAM: fima'
$PS = $PS & @CRLF & '% --EXOP: backgroundcolor=DD000011'
$PS = $PS & @CRLF & '% --RNDR: renlinear'
$PS = $PS & @CRLF & '/symbol {'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    0 begin            % Confine variables to local scope'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /options exch def  % We are given an option string'
$PS = $PS & @CRLF & '    /barcode exch def  % We are given a barcode string'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    barcode (fima) eq {'
$PS = $PS & @CRLF & '        /sbs [2.25 2.25 2.25 11.25 2.25 11.25 2.25 2.25 2.25] def'
$PS = $PS & @CRLF & '        /bhs [.625 .625 .625 .625 .625] def'
$PS = $PS & @CRLF & '        /bbs [0 0 0 0 0] def'
$PS = $PS & @CRLF & '    } if'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    barcode (fimb) eq {'
$PS = $PS & @CRLF & '        /sbs [2.25 6.75 2.25 2.25 2.25 6.25 2.25 2.25 2.25 6.75 2.25] def'
$PS = $PS & @CRLF & '        /bhs [.625 .625 .625 .625 .625 .625] def'
$PS = $PS & @CRLF & '        /bbs [0 0 0 0 0 0] def'
$PS = $PS & @CRLF & '    } if'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    barcode (fimc) eq {'
$PS = $PS & @CRLF & '        /sbs [2.25 2.25 2.25 6.75 2.25 6.75 2.25 6.75 2.25 2.25 2.25] def'
$PS = $PS & @CRLF & '        /bhs [.625 .625 .625 .625 .625 .625] def'
$PS = $PS & @CRLF & '        /bbs [0 0 0 0 0 0] def'
$PS = $PS & @CRLF & '    } if'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    barcode (fimd) eq {'
$PS = $PS & @CRLF & '        /sbs [2.25 2.25 2.25 2.25 2.25 6.75 2.25 6.75 2.25 2.25 2.25 2.25 2.25] def'
$PS = $PS & @CRLF & '        /bhs [.625 .625 .625 .625 .625 .625 .625] def'
$PS = $PS & @CRLF & '        /bbs [0 0 0 0 0 0 0] def'
$PS = $PS & @CRLF & '    } if'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    % Return the arguments'
$PS = $PS & @CRLF & '    /retval 8 dict def'
$PS = $PS & @CRLF & '    retval (ren) (renlinear) put'
$PS = $PS & @CRLF & '    retval (sbs) sbs put'
$PS = $PS & @CRLF & '    retval (bhs) bhs put'
$PS = $PS & @CRLF & '    retval (bbs) bbs put'
$PS = $PS & @CRLF & '    retval (opt) options put'
$PS = $PS & @CRLF & '    retval'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    end'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '} bind def'
$PS = $PS & @CRLF & '/symbol load 0 1 dict put'
$PS = $PS & @CRLF & '% --END ENCODER symbol--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --BEGIN RENDERER renlinear--'
$PS = $PS & @CRLF & '/renlinear {'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    0 begin          % Confine variables to local scope'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /args exch def   % We are given some arguments'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Default options'
$PS = $PS & @CRLF & '    /sbs [] def'
$PS = $PS & @CRLF & '    /bhs [] def'
$PS = $PS & @CRLF & '    /bbs [] def'
$PS = $PS & @CRLF & '    /txt [] def'
$PS = $PS & @CRLF & '    /barcolor (unset) def'
$PS = $PS & @CRLF & '    /includetext false def'
$PS = $PS & @CRLF & '    /textcolor (unset) def'
$PS = $PS & @CRLF & '    /textxalign (unset) def'
$PS = $PS & @CRLF & '    /textyalign (unset) def'
$PS = $PS & @CRLF & '    /textfont (Courier) def'
$PS = $PS & @CRLF & '    /textsize 10 def'
$PS = $PS & @CRLF & '    /textxoffset 0 def'
$PS = $PS & @CRLF & '    /textyoffset 0 def'
$PS = $PS & @CRLF & '    /bordercolor (unset) def'
$PS = $PS & @CRLF & '    /backgroundcolor (unset) def'
$PS = $PS & @CRLF & '    /inkspread 0.15 def'
$PS = $PS & @CRLF & '    /width 0 def'
$PS = $PS & @CRLF & '    /barratio 1 def'
$PS = $PS & @CRLF & '    /spaceratio 1 def'
$PS = $PS & @CRLF & '    /showborder false def'
$PS = $PS & @CRLF & '    /borderleft 10 def'
$PS = $PS & @CRLF & '    /borderright 10 def'
$PS = $PS & @CRLF & '    /bordertop 1 def'
$PS = $PS & @CRLF & '    /borderbottom 1 def'
$PS = $PS & @CRLF & '    /borderwidth 0.5 def'
$PS = $PS & @CRLF & '    /guardwhitespace false def'
$PS = $PS & @CRLF & '    /guardleftpos 0 def'
$PS = $PS & @CRLF & '    /guardleftypos 0 def'
$PS = $PS & @CRLF & '    /guardrightpos 0 def'
$PS = $PS & @CRLF & '    /guardrightypos 0 def'
$PS = $PS & @CRLF & '    /guardwidth 6 def'
$PS = $PS & @CRLF & '    /guardheight 7 def'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    % Apply the renderer options'
$PS = $PS & @CRLF & '    args {exch cvlit exch def} forall'
$PS = $PS & @CRLF & ' '
$PS = $PS & @CRLF & '    % Parse the user options   '
$PS = $PS & @CRLF & '    opt {'
$PS = $PS & @CRLF & '        token false eq {exit} if dup length string cvs (=) search'
$PS = $PS & @CRLF & '        true eq {cvlit exch pop exch def} {cvlit true def} ifelse'
$PS = $PS & @CRLF & '    } loop'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /barcolor barcolor cvlit def'
$PS = $PS & @CRLF & '    /textcolor textcolor cvlit def'
$PS = $PS & @CRLF & '    /textxalign textxalign cvlit def'
$PS = $PS & @CRLF & '    /textyalign textyalign cvlit def'
$PS = $PS & @CRLF & '    /textfont textfont cvlit def'
$PS = $PS & @CRLF & '    /textsize textsize cvr def'
$PS = $PS & @CRLF & '    /textxoffset textxoffset cvr def'
$PS = $PS & @CRLF & '    /textyoffset textyoffset cvr def'
$PS = $PS & @CRLF & '    /bordercolor bordercolor cvlit def'
$PS = $PS & @CRLF & '    /backgroundcolor backgroundcolor cvlit def'
$PS = $PS & @CRLF & '    /inkspread inkspread cvr def'
$PS = $PS & @CRLF & '    /width width cvr def'
$PS = $PS & @CRLF & '    /barratio barratio cvr def'
$PS = $PS & @CRLF & '    /spaceratio spaceratio cvr def'
$PS = $PS & @CRLF & '    /borderleft borderleft cvr def'
$PS = $PS & @CRLF & '    /borderright borderright cvr def'
$PS = $PS & @CRLF & '    /bordertop bordertop cvr def'
$PS = $PS & @CRLF & '    /borderbottom borderbottom cvr def'
$PS = $PS & @CRLF & '    /borderwidth borderwidth cvr def'
$PS = $PS & @CRLF & '    /guardleftpos guardleftpos cvr def'
$PS = $PS & @CRLF & '    /guardleftypos guardleftypos cvr def'
$PS = $PS & @CRLF & '    /guardrightpos guardrightpos cvr def'
$PS = $PS & @CRLF & '    /guardrightypos guardrightypos cvr def'
$PS = $PS & @CRLF & '    /guardwidth guardwidth cvr def'
$PS = $PS & @CRLF & '    /guardheight guardheight cvr def'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    % Create bar elements and put them into the bars array'
$PS = $PS & @CRLF & '    /bars sbs length 1 add 2 idiv array def'
$PS = $PS & @CRLF & '    /x 0.00 def /maxh 0 def'
$PS = $PS & @CRLF & '    0 1 sbs length 1 add 2 idiv 2 mul 2 sub {'
$PS = $PS & @CRLF & '        /i exch def'
$PS = $PS & @CRLF & '        i 2 mod 0 eq {           % i is even'
$PS = $PS & @CRLF & '            /d sbs i get barratio mul barratio sub 1 add def  % d=digit*r-r+1 '
$PS = $PS & @CRLF & '            /h bhs i 2 idiv get 72 mul def  % Height from bhs'
$PS = $PS & @CRLF & '            /c d 2 div x add def            % Centre of the bar = x + d/2'
$PS = $PS & @CRLF & '            /y bbs i 2 idiv get 72 mul def  % Baseline from bbs'
$PS = $PS & @CRLF & '            /w d inkspread sub def          % bar width = digit - inkspread'
$PS = $PS & @CRLF & '            bars i 2 idiv [h c y w] put     % Add the bar entry'
$PS = $PS & @CRLF & '            h maxh gt {/maxh h def} if'
$PS = $PS & @CRLF & '        } {'
$PS = $PS & @CRLF & '            /d sbs i get spaceratio mul spaceratio sub 1 add def  % d=digit*r-r+1 '
$PS = $PS & @CRLF & '        } ifelse'
$PS = $PS & @CRLF & '        /x x d add def  % x+=d'
$PS = $PS & @CRLF & '    } for'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    gsave'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    currentpoint translate'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Force symbol to given width'
$PS = $PS & @CRLF & '    width 0 ne {'
$PS = $PS & @CRLF & '        width 72 mul x div 1 scale'
$PS = $PS & @CRLF & '    } if'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Set RGB or CMYK color depending on length of given hex string'
$PS = $PS & @CRLF & '    /setanycolor {'
$PS = $PS & @CRLF & '        /anycolor exch def'
$PS = $PS & @CRLF & '        anycolor length 6 eq {'
$PS = $PS & @CRLF & '            (<      >) 8 string copy dup 1 anycolor putinterval cvx exec {255 div} forall setrgbcolor'
$PS = $PS & @CRLF & '        } if'
$PS = $PS & @CRLF & '        anycolor length 8 eq {'
$PS = $PS & @CRLF & '            (<        >) 10 string copy dup 1 anycolor putinterval cvx exec {255 div} forall setcmykcolor'
$PS = $PS & @CRLF & '        } if'
$PS = $PS & @CRLF & '    } bind def'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Display the border and background'
$PS = $PS & @CRLF & '    newpath'
$PS = $PS & @CRLF & '    borderleft neg borderbottom neg moveto'
$PS = $PS & @CRLF & '    x borderleft add borderright add 0 rlineto'
$PS = $PS & @CRLF & '    0 maxh borderbottom add bordertop add rlineto'
$PS = $PS & @CRLF & '    x borderleft add borderright add neg 0 rlineto'
$PS = $PS & @CRLF & '    0 maxh borderbottom add bordertop add neg rlineto    '
$PS = $PS & @CRLF & '    closepath'
$PS = $PS & @CRLF & '    backgroundcolor (unset) ne { gsave backgroundcolor setanycolor fill grestore } if     '
$PS = $PS & @CRLF & '    showborder {'
$PS = $PS & @CRLF & '        gsave'
$PS = $PS & @CRLF & '        bordercolor (unset) ne { bordercolor setanycolor } if'
$PS = $PS & @CRLF & '        borderwidth setlinewidth stroke'
$PS = $PS & @CRLF & '        grestore'
$PS = $PS & @CRLF & '    } if    '
$PS = $PS & @CRLF & '   '
$PS = $PS & @CRLF & '    % Display the bars for elements in the bars array'
$PS = $PS & @CRLF & '    gsave'
$PS = $PS & @CRLF & '    barcolor (unset) ne { barcolor setanycolor } if'
$PS = $PS & @CRLF & '    bars {'
$PS = $PS & @CRLF & '        {} forall'
$PS = $PS & @CRLF & '        newpath setlinewidth moveto 0 exch rlineto stroke'
$PS = $PS & @CRLF & '    } forall'
$PS = $PS & @CRLF & '    grestore'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    % Display the text for elements in the text array'
$PS = $PS & @CRLF & '    textcolor (unset) ne { textcolor setanycolor } if'
$PS = $PS & @CRLF & '    includetext {'
$PS = $PS & @CRLF & '    textxalign (unset) eq textyalign (unset) eq and {'
$PS = $PS & @CRLF & '        /s 0 def /f () def'
$PS = $PS & @CRLF & '        txt {'
$PS = $PS & @CRLF & '            {} forall'
$PS = $PS & @CRLF & '            2 copy s ne exch f ne or {'
$PS = $PS & @CRLF & '                2 copy /s exch def /f exch def            '
$PS = $PS & @CRLF & '                exch findfont exch scalefont setfont          '
$PS = $PS & @CRLF & '            } {'
$PS = $PS & @CRLF & '                pop pop'
$PS = $PS & @CRLF & '            } ifelse'
$PS = $PS & @CRLF & '            moveto show'
$PS = $PS & @CRLF & '        } forall'
$PS = $PS & @CRLF & '    } {'
$PS = $PS & @CRLF & '        textfont findfont textsize scalefont setfont'
$PS = $PS & @CRLF & '        /txt [ txt { 0 get {} forall } forall ] def'
$PS = $PS & @CRLF & '        /tstr txt length string def'
$PS = $PS & @CRLF & '        0 1 txt length 1 sub { dup txt exch get tstr 3 1 roll put } for'
$PS = $PS & @CRLF & '        /textxpos textxoffset x tstr stringwidth pop sub 2 div add def'
$PS = $PS & @CRLF & '        textxalign (left) eq { /textxpos textxoffset def } if'
$PS = $PS & @CRLF & '        textxalign (right) eq { /textxpos x textxoffset sub tstr stringwidth pop sub def } if'
$PS = $PS & @CRLF & '        textxalign (offleft) eq { /textxpos tstr stringwidth pop textxoffset add neg def } if'
$PS = $PS & @CRLF & '        textxalign (offright) eq { /textxpos x textxoffset add def } if'
$PS = $PS & @CRLF & '        /textypos textyoffset textsize add 3 sub neg def'
$PS = $PS & @CRLF & '        textyalign (above) eq { /textypos textyoffset maxh add 1 add def } if'
$PS = $PS & @CRLF & '        textyalign (center) eq { /textypos textyoffset maxh textsize 4 sub sub 2 div add def } if'
$PS = $PS & @CRLF & '        textxpos textypos moveto tstr show'
$PS = $PS & @CRLF & '    } ifelse'
$PS = $PS & @CRLF & '    } if    '
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Display the guard elements'
$PS = $PS & @CRLF & '    guardwhitespace {'
$PS = $PS & @CRLF & '        0.75 setlinewidth'
$PS = $PS & @CRLF & '        guardleftpos 0 ne {'
$PS = $PS & @CRLF & '            newpath'
$PS = $PS & @CRLF & '            guardleftpos neg guardwidth add guardleftypos guardwidth 2 div add moveto'
$PS = $PS & @CRLF & '            guardwidth neg guardheight -2 div rlineto'
$PS = $PS & @CRLF & '            guardwidth guardheight -2 div rlineto'
$PS = $PS & @CRLF & '            stroke            '
$PS = $PS & @CRLF & '        } if'
$PS = $PS & @CRLF & '        guardrightpos 0 ne {'
$PS = $PS & @CRLF & '            newpath'
$PS = $PS & @CRLF & '            guardrightpos x add guardwidth sub guardrightypos guardheight 2 div add moveto'
$PS = $PS & @CRLF & '            guardwidth guardheight -2 div rlineto'
$PS = $PS & @CRLF & '            guardwidth neg guardheight -2 div rlineto'
$PS = $PS & @CRLF & '            stroke            '
$PS = $PS & @CRLF & '        } if'
$PS = $PS & @CRLF & '    } if'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    grestore'
$PS = $PS & @CRLF & '    '
$PS = $PS & @CRLF & '    end'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '} bind def'
$PS = $PS & @CRLF & '/renlinear load 0 1 dict put'
$PS = $PS & @CRLF & '% --END RENDERER renlinear--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --BEGIN RENDERER renmatrix--'
$PS = $PS & @CRLF & '/renmatrix {'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    0 begin'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /args exch def'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Default options'
$PS = $PS & @CRLF & '    /width 1 def'
$PS = $PS & @CRLF & '    /height 1 def'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Apply the renderer options'
$PS = $PS & @CRLF & '    args {exch cvlit exch def} forall'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Parse the user options'
$PS = $PS & @CRLF & '    opt {'
$PS = $PS & @CRLF & '        token false eq {exit} if dup length string cvs (=) search'
$PS = $PS & @CRLF & '        true eq {cvlit exch pop exch def} {cvlit true def} ifelse'
$PS = $PS & @CRLF & '    } loop'
$PS = $PS & @CRLF & ' '
$PS = $PS & @CRLF & '    /width width cvr def'
$PS = $PS & @CRLF & '    /height height cvr def'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Convert the bits into a string'
$PS = $PS & @CRLF & '    /imgstr pixs length string def'
$PS = $PS & @CRLF & '    0 1 pixs length 1 sub {'
$PS = $PS & @CRLF & '        dup imgstr 3 1 roll pixs exch get 1 exch sub 255 mul put'
$PS = $PS & @CRLF & '    } for'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Draw the image'
$PS = $PS & @CRLF & '    gsave'
$PS = $PS & @CRLF & '    currentpoint translate'
$PS = $PS & @CRLF & '    72 width mul 72 height mul scale'
$PS = $PS & @CRLF & '    pixx pixy 8 [ pixx 0 0 pixy neg 0 pixy ] {imgstr} image'
$PS = $PS & @CRLF & '    grestore'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    end'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '} bind def'
$PS = $PS & @CRLF & '/renmatrix load 0 1 dict put'
$PS = $PS & @CRLF & '% --END RENDERER renmatrix--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --BEGIN RENDERER renmaximatrix--'
$PS = $PS & @CRLF & '/renmaximatrix {'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    0 begin'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    /args exch def   % We are given some arguments'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Apply the renderer options'
$PS = $PS & @CRLF & '    args {exch cvlit exch def} forall'
$PS = $PS & @CRLF & ' '
$PS = $PS & @CRLF & '    % Parse the user options   '
$PS = $PS & @CRLF & '    opt {'
$PS = $PS & @CRLF & '        token false eq {exit} if dup length string cvs (=) search'
$PS = $PS & @CRLF & '        true eq {cvlit exch pop exch def} {cvlit true def} ifelse'
$PS = $PS & @CRLF & '    } loop'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    gsave'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    currentpoint translate'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    2.4945 dup scale  % from 1pt to 1.88mm'
$PS = $PS & @CRLF & '    0.5 0.5774 translate'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    pixs {'
$PS = $PS & @CRLF & '        dup '
$PS = $PS & @CRLF & '        /x exch 30 mod def '
$PS = $PS & @CRLF & '        /y exch 30 idiv def'
$PS = $PS & @CRLF & '        y 2 mod 0 eq {x} {x 0.5 add} ifelse'
$PS = $PS & @CRLF & '        32 y sub 0.8661 mul'
$PS = $PS & @CRLF & '        moveto'
$PS = $PS & @CRLF & '        0     0.5774 rmoveto'
$PS = $PS & @CRLF & '        -0.5 -0.2887 rlineto'
$PS = $PS & @CRLF & '        0    -0.5774 rlineto'
$PS = $PS & @CRLF & '        0.5  -0.2887 rlineto'
$PS = $PS & @CRLF & '        0.5   0.2887 rlineto'
$PS = $PS & @CRLF & '        0     0.5774 rlineto'
$PS = $PS & @CRLF & '        -0.5  0.2887 rlineto'
$PS = $PS & @CRLF & '        closepath fill'
$PS = $PS & @CRLF & '    } forall'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    % Plot the locator symbol'
$PS = $PS & @CRLF & '    newpath 14 13.8576 0.5774 0 360 arc closepath'
$PS = $PS & @CRLF & '    14 13.8576 1.3359 360 0 arcn closepath fill'
$PS = $PS & @CRLF & '    newpath 14 13.8576 2.1058 0 360 arc closepath'
$PS = $PS & @CRLF & '    14 13.8576 2.8644 360 0 arcn closepath fill'
$PS = $PS & @CRLF & '    newpath 14 13.8576 3.6229 0 360 arc closepath'
$PS = $PS & @CRLF & '    14 13.8576 4.3814 360 0 arcn closepath fill'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    grestore'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '    end'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '} bind def'
$PS = $PS & @CRLF & '/renmaximatrix load 0 1 dict put'
$PS = $PS & @CRLF & '% --END RENDERER renmaximatrix--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --BEGIN DISPATCHER--'
$PS = $PS & @CRLF & '/barcode {'
$PS = $PS & @CRLF & '    0 begin'
$PS = $PS & @CRLF & '    dup (ren) get cvx exec '
$PS = $PS & @CRLF & '    end'
$PS = $PS & @CRLF & '} bind def'
$PS = $PS & @CRLF & '/barcode load 0 1 dict put'
$PS = $PS & @CRLF & '% --END DISPATCHER--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --END TEMPLATE--'
$PS = $PS & @CRLF & '%!'
$PS = $PS & @CRLF & '% --BEGIN SAMPLE--'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% We call the procedures like this:'
$PS = $PS & @CRLF & '/Helvetica findfont 10 scalefont setfont'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '230 700 moveto (544900000043) (includetext) ean13 barcode'
$PS = $PS & @CRLF & '0 -17 rmoveto (EAN-13) show'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% Add Rotated Text'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '/Times-Roman findfont'
$PS = $PS & @CRLF & '32 scalefont'
$PS = $PS & @CRLF & 'setfont'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '100 200 translate'
$PS = $PS & @CRLF & '45 rotate'
$PS = $PS & @CRLF & '2 1 scale'
$PS = $PS & @CRLF & 'newpath'
$PS = $PS & @CRLF & '0 0 moveto'
$PS = $PS & @CRLF & '(AutoIT is Great !!) true charpath'
$PS = $PS & @CRLF & '0.5 setlinewidth'
$PS = $PS & @CRLF & '0.4 setgray'
$PS = $PS & @CRLF & 'stroke'
$PS = $PS & @CRLF 
$PS = $PS & @CRLF & '/inch {72 mul} def	% Convert inches->points (1/72 inch)'
$PS = $PS & @CRLF & '/Helvetica findfont 40 scalefont setfont %use 40 pt Helvetica font'
$PS = $PS & @CRLF & 'newpath			% Start a new path'
$PS = $PS & @CRLF & '1 inch 1 inch moveto	% an inch in from the lower left'
$PS = $PS & @CRLF & '2 inch 1 inch lineto	% bottom side'
$PS = $PS & @CRLF & '2 inch 2 inch lineto	% right side'
$PS = $PS & @CRLF & '1 inch 2 inch lineto	% top side'
$PS = $PS & @CRLF & '20 setlinewidth 	% fat line 20 pts wide'
$PS = $PS & @CRLF & 'closepath		% Automatically add left side to close path'
$PS = $PS & @CRLF & 'stroke			% nothing is drawn until you stroke the path!'
$PS = $PS & @CRLF & '1.5 inch 2 inch moveto %move to new point to start new object'	
$PS = $PS & @CRLF & '1 inch  .1 inch rlineto	% bottom side using relative movement' 
$PS = $PS & @CRLF & '-.1 inch 1 inch rlineto	% right side "'
$PS = $PS & @CRLF & '-1 inch -.1 inch rlineto 	% top side "'
$PS = $PS & @CRLF & 'closepath		% Automatically add left side to close path'
$PS = $PS & @CRLF & 'gsave			% Save the above path, for later reuse'
$PS = $PS & @CRLF & '.5 .2 0 setrgbcolor	% change the color to brown'
$PS = $PS & @CRLF & 'fill			% Fill in the box '
$PS = $PS & @CRLF & 'grestore		% restore the previous path, to reuse it'
$PS = $PS & @CRLF & '0 0 1 setrgbcolor %blue'
$PS = $PS & @CRLF & '10 setlinewidth 	% 10 pts wide'
$PS = $PS & @CRLF & 'stroke 			%draw the perimeter of the box'
$PS = $PS & @CRLF & '1 inch 1 inch moveto'
$PS = $PS & @CRLF & '52 rotate'
$PS = $PS & @CRLF & '1 0 0 setrgbcolor %red'
$PS = $PS & @CRLF & '(But is it art?) show'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & 'showpage'
$PS = $PS & @CRLF
$PS = $PS & @CRLF & '% --END SAMPLE--'

FileWriteLine($File, $PS)
FileClose($File)

ShellExecuteWait("prfile32.exe","Barcode.ps","")

FileDelete(@scriptdir & "\Barcode.ps")
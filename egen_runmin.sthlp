{smcl}
{* *! version 0.1.0 28oct2013}{...}

{title:Title}

{phang}
{bf : egen runmin} {hline 2} generate running min of a numeric variable{p_end}


{title:Syntax}
{p 8 17 2}{cmd:egen}
[{it:type}]
{it:newvar}
{cmd:=}
{cmd:runmin(}{it:varname}{cmd:)}
{ifin}
[{cmd:,} {it:options}]

{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt:{opth by(varlist)}}specify variables to group by when finding min 
	value; {cmd:runmin} will calculate the running min separately in each 
	group implied by {it:varlist}{p_end}
	
{synopt:{opth sort(varlist)}}specify variables to sort on before calculating
	the running min; the original sort order will be restored afterwards{p_end}
{synoptline}
{p2colreset}{...}


{title:Description}

{phang}
{cmd:runmin} generates a variable that contains the running min of the given
	numeric variable. Missing values will be excluded; the generated variable
	will be missing where the source variable was. If the option 
	{opt sort(varlist)} is specified, then the data is sorted by these
	variables before calculating the running min, with the original sort order
	restored afterwards. If {opt by(varlist)} is specified, then 
	{cmd:runmin} does the above separately for each group implied by the given 
	varlist. The generated variable will be missing where any {opt by}
	variable is missing.
	
{pmore}
	The type of the generated variable (whether specified or default) 
	will be overridden if it seems that a different type is needed to hold
	the results.

	
{title:Examples}

      {com}. clear
	  
      {com}. input  x  y
      {com}.       -2  .
      {com}.        .  .
      {com}.        4  0
      {com}.        0  1
      {com}.       -1  0
      {com}.       -4  1
      {com}.        7  0
      {com}.        .  1
      {com}.       -5  0
      {com}.        3  1
      {com}. end
      
      {com}. egen minx = runmin(x)
      {res}{txt}(2 missing values generated)
      
      {com}. list
      {txt}
           {c TLC}{hline 4}{c -}{hline 3}{c -}{hline 6}{c TRC}
           {c |} {res} x   y   minx {txt}{c |}
           {c LT}{hline 4}{c -}{hline 3}{c -}{hline 6}{c RT}
        1. {c |} {res}-2   .     -2 {txt}{c |}
        2. {c |} {res} .   .      . {txt}{c |}
        3. {c |} {res} 4   0     -2 {txt}{c |}
        4. {c |} {res} 0   1     -2 {txt}{c |}
        5. {c |} {res}-1   0     -2 {txt}{c |}
           {c LT}{hline 4}{c -}{hline 3}{c -}{hline 6}{c RT}
        6. {c |} {res}-4   1     -4 {txt}{c |}
        7. {c |} {res} 7   0     -4 {txt}{c |}
        8. {c |} {res} .   1      . {txt}{c |}
        9. {c |} {res}-5   0     -5 {txt}{c |}
       10. {c |} {res} 3   1     -5 {txt}{c |}
           {c BLC}{hline 4}{c -}{hline 3}{c -}{hline 6}{c BRC}
      
      {com}. egen minx_y = runmin(x) , by(y)
      {res}{txt}(3 missing values generated)
      
      {com}. list
      {txt}
           {c TLC}{hline 4}{c -}{hline 3}{c -}{hline 6}{c -}{hline 8}{c TRC}
           {c |} {res} x   y   minx   minx_y {txt}{c |}
           {c LT}{hline 4}{c -}{hline 3}{c -}{hline 6}{c -}{hline 8}{c RT}
        1. {c |} {res}-2   .     -2        . {txt}{c |}
        2. {c |} {res} .   .      .        . {txt}{c |}
        3. {c |} {res} 4   0     -2        4 {txt}{c |}
        4. {c |} {res} 0   1     -2        0 {txt}{c |}
        5. {c |} {res}-1   0     -2       -1 {txt}{c |}
           {c LT}{hline 4}{c -}{hline 3}{c -}{hline 6}{c -}{hline 8}{c RT}
        6. {c |} {res}-4   1     -4       -4 {txt}{c |}
        7. {c |} {res} 7   0     -4       -1 {txt}{c |}
        8. {c |} {res} .   1      .        . {txt}{c |}
        9. {c |} {res}-5   0     -5       -5 {txt}{c |}
       10. {c |} {res} 3   1     -5       -4 {txt}{c |}
           {c BLC}{hline 4}{c -}{hline 3}{c -}{hline 6}{c -}{hline 8}{c BRC}
      
      {com}. list x y minx_y if y == 0
      {txt}
           {c TLC}{hline 4}{c -}{hline 3}{c -}{hline 8}{c TRC}
           {c |} {res} x   y   minx_y {txt}{c |}
           {c LT}{hline 4}{c -}{hline 3}{c -}{hline 8}{c RT}
        3. {c |} {res} 4   0        4 {txt}{c |}
        5. {c |} {res}-1   0       -1 {txt}{c |}
        7. {c |} {res} 7   0       -1 {txt}{c |}
        9. {c |} {res}-5   0       -5 {txt}{c |}
           {c BLC}{hline 4}{c -}{hline 3}{c -}{hline 8}{c BRC}
      
      {com}. list x y minx_y if y == 1
      {txt}
           {c TLC}{hline 4}{c -}{hline 3}{c -}{hline 8}{c TRC}
           {c |} {res} x   y   minx_y {txt}{c |}
           {c LT}{hline 4}{c -}{hline 3}{c -}{hline 8}{c RT}
        4. {c |} {res} 0   1        0 {txt}{c |}
        6. {c |} {res}-4   1       -4 {txt}{c |}
        8. {c |} {res} .   1        . {txt}{c |}
       10. {c |} {res} 3   1       -4 {txt}{c |}
           {c BLC}{hline 4}{c -}{hline 3}{c -}{hline 8}{c BRC}


{title:Stored results}

{pstd}
{cmd:egen} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of missing values generated{p_end}
{p2colreset}{...}


{title:Author}

{pstd}
James Fiedler, Universities Space Research Association{break}
Email: {browse "mailto:jrfiedler@gmail.com":jrfiedler@gmail.com}

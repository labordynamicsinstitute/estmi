{smcl}
{* *! version 0.2  15may2012}{...}
{cmd:help estmi}
{hline}

{title:Title}

{phang}
{bf:estmi} {hline 2} Combine saved estimates from multiple completed or synthetic implicates


{title:Syntax}

{p 8 17 2}
{cmdab:estm:i}
[type]
[file_name]
[print_results]

{synoptset 20 tabbed}{...}
{synoptline}
{syntab:type}
{synopt:{opt cmp}} use estimates from completed GSF implicates{p_end}
{synopt:{opt syn}} use estimates from SSB implicates{p_end}
{synoptline}
{syntab:file_name}
{synopt:{opt {prefix}}} use file name prefix for user-saved estimates{p_end}
{synoptline}
{syntab:print_results}
{synopt:{opt list}} display a list of estimates [see 'Saved results'] or nothing if argument not given {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{title:Description}

{pstd}
{cmd:estmi} combines saved estimates across the four completed implicates of the SIPP Gold Standard File (GSF) or the sixteen synthetic implicates of the SIPP Synthetic Beta (SSB). 
The estimates from each implicate must have been saved using {cmd: estimates save} with a common filename prefix followed by m, m=1,4 for completed GSF or SSB and by r, r=1,4 for SSB (eg. {it:prefix}1 for GSF and {it:prefix}11 for SSB).  

{title:Saved results}

{pstd}
{cmd:estmi} saves the following in {cmd:e()}:
{synoptset 20 tabbed}{...}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(dof)}}degrees of freedom for each estimated coefficient{p_end}
{synopt:{cmd:e(tstat)}}t-statistics from tests of statistical significance of each estimated coefficients{p_end}
{synopt:{cmd:e(pvalue)}}p-values from tests of statistical significance of each estimated coefficients{p_end}
{synopt:{cmd:e(lower)}}lower bound of 95% confidence interval for each estimated coefficients{p_end}
{synopt:{cmd:e(upper)}}upper bound of 95% confidence interval for each estimated coefficients{p_end}

{title:Examples}
{p 4 25}
. estmi cmp myreg {hline 2} combines the set of files {myreg1,...,myreg4}{p_end}

{p 4 30}
. estmi syn myreg list {hline 2} combines {myreg11,...,myreg44} and prints results{p_end}

{title:Remarks}

{pstd}
{tab}If you have any questions or concerns regarding the implementation of 'estmi.ado', please contact Graton Gathright at graton.m.gathright@census.gov.

{title:References}

{phang}
Reiter, Jerome P. (2004). {it:Simultaneous Use of Multiple Imputation for Missing Data and Disclosure Limitation}. Duke University: Institute of Statistics and Decision Sciences.

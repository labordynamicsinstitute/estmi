*! version 0.2 15may2012

program estmi,eclass
version 11
noisily di "**Reminder: If you get the error 'matsize must be between 10 and 800', make sure you are using Stata/SE. To check, use 'about' command.**"
quietly set matsize 10000
clear matrix
clear
capture matrix drop q u m r coefid 

local cmpsyn="`1'"
if ("`cmpsyn'"=="gs"){
    estimates use `2'
    `e(cmd)'
    exit
}
else if("`cmpsyn'"!="syn" & "`cmpsyn'"!="cmp"){
    exit
}

forval m=1/4{
    forval r= 1/4{
        if("`cmpsyn'"=="syn"){
            estimates use `2'`m'`r'
        }
        else {
            estimates use `2'`m'
            
        }
        mat b=e(b)
        local k =colsof(b)
        forval i=1/`k'{
            mat coefid=nullmat(coefid) \ J(1,1,`i')
        }
        mat q= nullmat(q) \ b'
        mat u= nullmat(u) \ vecdiag(e(V))'
        mat m= nullmat(m) \ J(`k',1,`m')
        mat r= nullmat(r) \ J(`k',1,`r')
        if ("`cmpsyn'"=="cmp") {
            continue,break
        }
    }
}

quietly svmat coefid,names(coefid)
quietly svmat q,names(q)
quietly svmat u,names(u) 
quietly svmat m,names(m)  
quietly svmat r,names(r)  

rename coefid1 coefid
rename q1 q
rename u1 u
rename m1 m
rename r1 r

local m=4
local r=4

if("`cmpsyn'"=="syn"){
    collapse (mean) q u (sd) b_sqrt=q, by (coefid m) fast
    quietly gen b=b_sqrt^2
    collapse (mean) q b u (sd) capb_sqrt=q, by (coefid) fast
    quietly gen capb=capb_sqrt^2
    quietly gen T=(1+(1/`m'))*capb-(b/`r')+u
    quietly gen dof=min(2879910129,(((((1+(1/`m'))*capb)^2)/((`m'-1)*(T^2)))+(((b/`r')^2)/(`m'*(`r'-1)*(T^2))))^(-1))
}
else{
    collapse (mean) q u (sd) b_sqrt=q, by (coefid) fast
    quietly gen b=b_sqrt^2
    quietly gen T=( 1 + ( 1 / `m' ) ) * b + u
    quietly gen dof=min(2879910129,(`m'-1)*(1+u/((1+1/`m')*b))^2)
}

quietly gen coef=q
quietly gen se=sqrt(T)
keep coefid coef se dof
quietly gen tstat=coef/se
quietly gen pvalue= 2*ttail(dof,abs(tstat))
quietly gen lower=coef - invttail(dof,0.025)*se
quietly gen upper=coef + invttail(dof,0.025)*se

quietly gen regressor=""
local i=1
local names : colfullnames b
foreach name of local names{
    quietly replace regressor="`name'" if `i'<=`k' in `i++'
}

if ("`3'"=="list"){
    list regressor coef se tstat dof pvalue lower upper , noobs 
}

quietly gen v=se*se
foreach mat in coef v dof pvalue tstat lower upper{
    mkmat `mat' ,matrix(post_`mat') 
    matrix rownames post_`mat'= `names';
}

matrix b=post_coef'
matrix V=diag(post_v')

capture ereturn repost b=b V=V
capture ereturn matrix dof=post_dof
capture ereturn matrix pvalue=post_pvalue
capture ereturn matrix tstat=post_tstat
capture ereturn matrix lower=post_lower
capture ereturn matrix upper=post_upper
end

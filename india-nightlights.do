
*--------README--------------------------------------------------------

*	First Version:		Aug 30, 2018
*	This Version:		Aug 30, 2018
*	last modified by:	Martin Kornejew (WB ST Consultant)

*	This do file...
*		1)	...


*	Use the [-] button next to the curly brackets (or click on the line
*	below) to collapse the current section of the code.
*------------------------------------------------------------------------

use "india-nightlights.dta", clear	
	
encode id, gen(idcode)
xtset idcode date

** New variables
gen m = month(dofm(date)) // for seasonal effects

** Modelling
xtreg nightlight storm c.storm#c.storm i.m i.idcode#c.date, fe
xtreg nightlight L(0/3).storm i.m i.idcode#c.date, fe // hmmmm

** Visualisation
preserve
gen storm_mock = storm
qui xtreg nightlight storm_mock c.storm_mock#c.storm_mock i.m i.idcode#c.date, fe
	replace storm_mock = 0
	predict temp, xb
	replace nightlight = nightlight-temp // filtering seasonal effects and time trends 
*	twoway (scatter nightlight storm,  msize(tiny)) (lfit nightlight storm), by(id, cols(6) imargin(tiny))  xsize(10) ysize(20) 
	tsline nightlight storm, by(id, imargin(tiny) cols(4)) tlabel(, labsize(tiny))  xsize(10) ysize(20) legend(size(tiny) cols(1))
restore


** Time series analysis
xtset idcode
xtreg nightlight L(0/3).storm i.m, fe


clear all
set more off
set mem 1000m

global nlss2004         "E:\hhdbase\NGA\Nigeria_Household Survey_2003\Data\STATA"
global nlsstemp04       "E:\hhdbase\NGA\Nigeria_Household Survey_2003\stdfiles"
global nlssfintabs04    "E:\hhdbase\NGA\Nigeria_Household Survey_2003\tables"
global nlsslogs         "E:\hhdbase\NGA\Nigeria_Household Survey_2003\logfiles"

log using "$nlsslogs\NGA 2004 aggregate.log" , replace



*************************************************************************************************************************************
***Table 1: BASIC HH INFORMATION
*************************************************************************************************************************************
**HH size and adult equivalent scales (Country).
*roster (section 1) collects all persons in HH.
*however, filter out non-household members.  
*var=s1q20 determines who are the regular household members based on some country-specific criterion.


use "$nlss2004\Sec 1 roster.dta", clear

merge m:1 state sector ric using "$nlss2004\weights.dta"
tab _m
drop _m

sort hid pid 

merge 1:1 hid pid using "$nlss2004\Sec 2 education.dta"
tab _m
drop _m


**Modified Ghana measure which correlated slightly better than above and will be the measure used.
*Male Female: 0-1 yrs 0.25 0.25; 1-3 yrs 0.45 0.45; 4-6 yrs 0.62 0.62; 7-10 yrs 0.69 0.69.
*Male Female: 11-14 yrs 0.86 0.76; 15-18 yrs 1.04 0.76; 19-25 yrs 1.00  0.76; 26-50 yrs 1.00 0.76; 51 and above 0.79 0.66.

tab s1q5y
tab s1q2

gen ctry_ad=0.25  if (s1q5y<1) 
replace ctry_ad=0.45  if (s1q5y>=1 & s1q5y<=3) 
replace ctry_ad=0.62  if (s1q5y>=4 & s1q5y<=6) 
replace ctry_ad=0.69  if (s1q5y>=7 & s1q5y<=10) 
replace ctry_ad=0.86  if ((s1q5y>=11 & s1q5y<=14) & s1q2==1) 
replace ctry_ad=0.76  if ((s1q5y>=11 & s1q5y<=14) & s1q2==2) 
replace ctry_ad=1.04  if ((s1q5y>=15 & s1q5y<=18) & s1q2==1) 
replace ctry_ad=0.76  if ((s1q5y>=15 & s1q5y<=18) & s1q2==2) 
replace ctry_ad=1.00  if ((s1q5y>=19 & s1q5y<=25) & s1q2==1) 
replace ctry_ad=0.76  if ((s1q5y>=19 & s1q5y<=25) & s1q2==2) 
replace ctry_ad=1.00  if ((s1q5y>=26 & s1q5y<=50) & s1q2==1) 
replace ctry_ad=0.76  if ((s1q5y>=26 & s1q5y<=50) & s1q2==2) 
replace ctry_ad=0.79  if (s1q5y>=51 & s1q5y~=. & s1q2==1) 
replace ctry_ad=0.66  if (s1q5y>=51 & s1q5y~=. & s1q2==2) 


gen spouse=1 if s1q3==2

tab  s1q7a
gen sp_live=1 if (s1q3==1 & s1q7a==1) 
replace sp_live=2 if (s1q3==1 & s1q7a==2) 
lab define sp_live  1 "Yes"  2 "No"
lab val sp_live sp_live

*check if any heads are not household members.

count if  s1q3==1 & s1q20==2

*select only valid household members.

keep if s1q20==1

gen hhsiz=1 

bys hid: egen hhsize=total(hhsiz)
bys hid: egen ctry_adq=total(ctry_ad)
bys hid: egen spouses=total(spouse)


**country.
*use the ISO codes which assigns each country with a 2- or 3-letter code.

gen country = "NGA" 

**zone.

gen zone=.
replace zone=5  if (state==3  | state==6  | state==9  | state==10 | state==12  | state==32 )
replace zone=4  if (state==1  | state==4  | state==11 | state==14 | state==16 ) 
replace zone=6  if (state==13 | state==24 | state==27 | state==28 | state==29  | state==30 ) 
replace zone=1  if (state==7  | state==22 | state==23 | state==25 | state==26  | state==31 | state==37 ) 
replace zone=2  if (state==2  | state==5  | state==8  | state==15 | state==34  | state==35 ) 
replace zone=3  if (state==17 | state==18 | state==19 | state==20 | state==21  | state==33 | state==36 ) 
lab var zone "Zone"
lab define zone 1  "North Central" 2  "North East" 3  "North West" 4  "South East" 5  "South South" 6  "South West"
lab val zone zone

**state.

ren state state1

gen state="Abia"             	if state1==1
replace state="Adamawa"     	if state1==2
replace state="Akwa Ibom"   	if state1==3
replace state="Anambra"     	if state1==4
replace state="Bauchi"      	if state1==5
replace state="Bayelsa"     	if state1==6
replace state="Benue"       	if state1==7
replace state="Borno"       	if state1==8
replace state="Cross-rivers"    if state1==9
replace state="Delta"     		if state1==10
replace state="Ebonyi"     		if state1==11
replace state="Edo"     		if state1==12
replace state="Ekiti"     		if state1==13
replace state="Enugu"     		if state1==14
replace state="Gombe"     		if state1==15
replace state="Imo"     		if state1==16
replace state="Jigawa"     		if state1==17
replace state="Kaduna"     		if state1==18
replace state="Kano"     		if state1==19
replace state="Katsina"    		if state1==20
replace state="Kebbi"     		if state1==21
replace state="Kogi"     		if state1==22
replace state="Kwara"     		if state1==23
replace state="Lagos"     		if state1==24
replace state="Nassarawa"     	if state1==25
replace state="Niger"     		if state1==26
replace state="Ogun"     		if state1==27
replace state="Ondo"     		if state1==28
replace state="Osun"     		if state1==29
replace state="Oyo"     		if state1==30
replace state="Plateau"   		if state1==31
replace state="Rivers"     		if state1==32
replace state="Sokoto"     		if state1==33
replace state="Taraba"    		if state1==34
replace state="Yobe"     		if state1==35
replace state="Zamfara"   		if state1==36
replace state="FCT Abuja" 		if state1==37

**year.
*survey started Sept 2004 to Aug 2004.
*year when most field work occured.

gen surveyr=2004

**Area of residence.

recode sector  (1=2)  (2=1),gen(rururb)
lab define rururb  1  "Rural" 2  "Urban"
lab val rururb rururb

**weights.
*household weight (wta_hh) already derived.

gen wta_pop = wta_hh*hhsize
gen wta_cadq = wta_hh*ctry_adq

**derive HH head characteristics.

gen hhsex=s1q2 if s1q3==1
lab define hhsex  1 "Male" 2 "Female"
lab val hhsex hhsex

gen hhagey=s1q5y if s1q3==1

recode hhagey (10/14=1) (15/19=2) (20/24=3) (25/29=4) (30/34=5) (35/39=6) (40/44=7) (45/49=8) (50/54=9) (55/59=10) (60/64=11) (65/98=12) (99=99),gen(hhagrp)
replace hhagrp=99 if hhagey==.
lab define hhagrp 1 "10-14 years old" 2 "15-19 years old"  3 "20-24 years old"  4 "25-29 years old"  5 "30-34 years old"  6 "35-39 years old"  7 "40-44 years old"  8 "45-49 years old"  9 "50-54 years old"  10 "55-59 years old"  11 "60-64 years old"  12 "65 and above years old"  99 "Age of head missing"
lab val hhagrp hhagrp

recode s1q6  (7=1) (1=2) (2=3) (3=4) (4 5=5) (6=6) (.=9),gen(hhmarstat)
replace hhmarstat=1 if hhmarstat==.
lab define hhmarstat  1  "Never married"  2  "Married monogamous"  3  "Married polygamous"  4  "Living together"  5  "Divorced/Separated"  6  "Widowed"  9 "Missing marital status"
lab val hhmarstat hhmarstat

label list s2aq2
recode s2aq2 (0/3=1) (4/9=2) (16=2) (10/15=3) (17=3) (18/23=4) (24/25=6),gen(hghlevel)
lab define hghlevel 1 "None"  2 "Primary"  3 "Secondary"  4 "Post-secondary"  5 "Koranic"  6 "College degree"
lab val hghlevel hghlevel
tab hghlevel
replace hghlevel=1 if s2aq1==2 & hghlevel==. & s1q3==1

**generate demographic variables for each household

gen headmale=1 if hhsex==1 & s1q3==1
gen nevermarried=1 if hhmarstat==1
gen marriedmono=1 if hhmarstat==2
gen marriedpoly=1 if hhmarstat==3
gen divorcewidow=1 if hhmarstat==5 | hhmarstat==6

gen rural=1 if rururb==1
gen kids=1 if s1q5y>=0 & s1q5y<=4
gen tots=1 if s1q5y>=5 & s1q5y<=9
gen teens=1 if s1q5y>=10 & s1q5y<=17
gen fems=1 if s1q5y>=18 & s1q2==2
gen admals=1 if s1q5y>=18 & s1q2==1

egen kids0004=sum(tots), by(hid)
egen kids0509=sum(kids), by(hid)
egen kids1017=sum(teens), by(hid)
egen adfems=sum(fems), by(hid)
egen admales=sum(admals), by(hid)

drop kids tots teens fems admals

for K in var headmale nevermarried marriedmono marriedpoly divorcewidow rural: recode K (. = 0)

lab var country    		"Country code"
lab var zone       		"Geo-Political Zone"
lab var state      		"State (string variable)"
lab var state1     		"State (numeric variable)"
lab var hid        		"Household unique identifier (country derived)"
lab var surveyr    		"Year of survey"
lab var rururb     		"Area of residence"
lab var hhsize     		"Number of people in household"
lab var ctry_adq   		"Sum total of adult equivalent scales (Country-specific scales)"
lab var wta_hh     		"Household weighting coefficient"
lab var wta_pop    		"Population weighting coefficient"
lab var wta_cadq   		"Adult (Country) equivalent population weighting coefficient"
lab var sp_live    		"Does spouse live in household?" 
lab var hhsex      		"Sex of Household head"
lab var hhagey     		"Age of Household head"
lab var hhagrp     		"Broad age-groups of age of Household head"
lab var hhmarstat  		"Marital status of Household head"
lab var hghlevel 		"Highest education level attained of Household head"
lab var spouses    		"Number of spouses in household"
lab var headmale		"Head of household is male, dummy (1,0)"
lab var nevermarried	"Marital status is single"
lab var marriedmono		"Marital status is monogamous marriage"
lab var marriedpoly		"Marital status is polygamous marriage"
lab var divorcewidow	"Divorced, separated or widowed"
lab var rural			"Resident in a rural area"
lab var kids0004		"Children between 0 and 4 years old"
lab var kids0509		"Children between 5 and 9 years old"
lab var kids1017		"Children between 10 and 17 years old"
lab var adfems			"Adult females"
lab var admales			"Adult males"

ren hhno hh

sort hid 

keep if s1q3==1

keep case_id state state1 sector ric hh zone country hid surveyr rururb hhsize ctry_adq ///
	wta_hh wta_pop wta_cadq hhsex hhagey hhagrp hhmarstat hghlevel spouses sp_live headmale nevermarried ///
	marriedmono marriedpoly divorcewidow rural kids0004 kids0509 kids1017 adfems admales
	
order case_id state state1 sector ric hh zone country hid surveyr rururb hhsize ctry_adq ///
	wta_hh wta_pop wta_cadq hhsex hhagey hhagrp hhmarstat hghlevel spouses sp_live headmale nevermarried ///
	marriedmono marriedpoly divorcewidow rural kids0004 kids0509 kids1017 adfems admales

d
sort hid

compress
saveold "$nlssfintabs04\Table 1 basicinf04.dta", replace


keep case_id hid wta_hh hhsize ctry_adq 
sort hid

compress
saveold "$nlsstemp04\hhsize04.dta", replace




*************************************************************************************************************************************
***Table 2: FOOD PURCHASE
*************************************************************************************************************************************
*Purpose: To gather the variables from the raw data required for calculating food purchases.
*Data: Part B : Section 10 Part 10B: Food expenses.

use "$nlss2004\Sec 10B food purchase.dta", clear

sort hid s10bq0

*check for duplicates and drop.

duplicates tag,gen(dup)
tab dup
duplicates drop

**delete all cases where all variables missing including product code (0 cases).
*delete all cases where all expenditure variables missing (0 cases).

gen miss=1   if  s10bq0==. & s10bq1==. & s10bq2==. & s10bq3==. & s10bq4==. & s10bq5==. & s10bq6==.
gen miss1=1  if  s10bq1==. & s10bq2==. & s10bq3==. & s10bq4==. & s10bq5==. & s10bq6==.

count if miss==1
count if miss1==1
drop miss miss1

tab s10bq0
label list s10bq0


**********************************************************

**Step 1: outlier edits.
*of the 300,167 product code, 61 missing product code.
*if product code missing, this will be dropped.  

count if s10bq0==.
drop  if s10bq0==.
tab s10bq0

gen valid=1
sort hid
merge hid using "$nlss2004\date_interview.dta"
tab _m
keep if _m==3
drop _m

sort hid
merge m:1 hid using "$nlsstemp04\hhsize04.dta"
tab _m
drop _m
keep if valid==1
drop valid

tostring month,gen(month1) format(%02.0f)
replace year=2004 if year==3
replace year=2004 if year==4
tostring year,gen(year1)  format(%04.0f)
gen hyphen="-"
egen year_mth=concat(year1 hyphen month1)

**the monthly total cost of purchased quantity.

egen fmtot=rsum(s10bq1 s10bq2 s10bq3 s10bq4 s10bq5 s10bq6) 
lab var fmtot "Monthly Total"
recode fmtot (0=.)
gen ann_purch_ori=fmtot*(365/30) 
lab var ann_purch_ori "Annual consumption expenditure with outliers"
tabstat fmtot,by(s10bq0) s(N mean q sd max)  f(%12.2f)

**edit outliers.

bys state year_mth s10bq0: egen fmtot_mn=mean(fmtot)
bys state year_mth s10bq0: egen fmtot_md=median(fmtot)
bys state year_mth s10bq0: egen fmtot_sd=sd(fmtot)
tabstat  fmtot_mn fmtot_md fmtot_sd,by( s10bq0)   f(%12.2f)

gen pcfmtot=fmtot/hhsize
bys state year_mth s10bq0: egen pcfmtot_mn=mean(pcfmtot)
bys state year_mth s10bq0: egen pcfmtot_md=median(pcfmtot)
bys state year_mth s10bq0: egen pcfmtot_sd=sd(pcfmtot)

gen std=(pcfmtot- pcfmtot_mn)/pcfmtot_sd
lab var std "Z scores for a normal distribution"

gen fmtot1=fmtot
count if std>3 & std~=.
tab  s10bq0  if std>3 & std~=.
replace fmtot1=fmtot_md   if std>3 & std~=.

***derive CPI growth.
*2004-04 survey period: September 2004 to August 2004.
*2009-10 survey period: November 2009 to October 2010.
*2009 survey period: November and December 2009.
*May 2004=100.
*2004 all : Jan 97.3;  Feb 95.9;  Mar 94.8;  Apr 99.1;  May 100.0; June 105.2; July 109.5; Aug 108.1; Sep 113.4; Oct 114.4; Nov 115.9; Dec 117.9.
*2004 food: Jan 98.0;  Feb 96.1;  Mar 93.5;  Apr 98.3;  May 100.0; June 105.2; July 104.1; Aug 104.3; Sep 102.4; Oct 106.2; Nov 105.9; Dec 107.4.
*2004 all : Jan 119.1; Feb 119.7; Mar 116.1; Apr 116.4; May 119.8; June 120.0; July 121.2; Aug 122.2; Sep 123.8; Oct 126.6; Nov 127.6; Dec 129.7.
*2004 food: Jan 111.3; Feb 109.7; Mar 110.0; Apr 108.0; May 112.5; June	118.1; July 119.3; Aug 119.1; Sep 121.6; Oct 122.2; Nov 123.6; Dec 124.8.
*2009 all : Jan	193.6; Feb 195.1; Mar 196.2; Apr 197.4; May 201.0; June	204.7; July 209.0; Aug 211.3; Sep 212.4; Oct 213.4; Nov 214.8; Dec 219.5.
*2009 food: Jan 192.9; Feb 194.6; Mar 196.1; Apr 197.6; May 201.6; June	206.2; July 211.1; Aug 213.3; Sep 214.5; Oct 215.5; Nov 215.7; Dec 220.8.
*2010 all : Jan	221.4; Feb 225.5; Mar 225.3; Apr 227.0; May 227.0; June	233.7; July 236.0; Aug 240.3; Sep 241.4; Oct 242.1; Nov 242.3; Dec 245.3.
*2010 food: Jan 223.6; Feb 226.0; Mar 227.1; Apr 229.9; May 227.9; June	237.2; July 240.7; Aug 245.4; Sep 245.8; Oct 245.8; Nov 246.7; Dec 248.9.
*survey period average used as both surveys 12 month period.
*gen allCPI2004_04=118.008333333333
*gen allCPI2009_10=229.5
*label var allCPI2004     "All CPI growth for 2004"
*label var allCPI2009_10  "All CPI 2009-10"
*gen allCPI=(allCPI2004_04/allCPI2009_10)  
*label var allCPI "All CPI growth between 2004-04 and 2009-10"
*for 2008-09 edits any HH spending over 100K annually was top-coded to 100K.
*for 2004-04 shall deflate using CPI for top coding.
*allCPI deflator is 0.5141975
*2 observations top coded of total 299,826.

count if fmtot1>=51419.75 & fmtot1~=.
replace fmtot1=51419.75     if fmtot1>=51419.75 & fmtot1~=.

**computing the annual .

gen ann_purch=fmtot1*(365/30) 
lab var ann_purch "Annual consumption expenditure"

table  s10bq0 year_mth, c(sum  ann_purch_ori)  f(%10.2f)
table  s10bq0 year_mth, c(sum  ann_purch)      f(%10.2f)

sort state sector ric
merge m:1 state sector ric using "$nlss2004\Weights.dta"
tab _m
keep if _m==3
drop _m

**sort by item and costs.
*if item code more than once, keep one with highest value.

gsort hid s10bq0 -ann_purch
bys hid s10bq0: gen countdup=_n
keep if countdup==1
drop countdup

tabstat  ann_purch [aw=wta_hh],by( year_mth)  s(sum)   f(%18.2f)
tabstat  ann_purch [aw=wta_hh],by( year_mth)  s(mean)  f(%18.2f)

compress
saveold "$nlsstemp04\Sec10B_FoodFiltered.dta", replace


**below file will be used to derive basket of X% of population.
*see section FOOD BASKET

keep  state sector hid s10bq0 ann_purch
order state sector hid s10bq0 ann_purch

sort hid s10bq0

compress
saveold "$nlsstemp04\Sec10B_Household Expenditure_basket.dta", replace


**********************************************************

**Step 2: Filtering out items not consumed (non-food).
*select tobacco and products and save as separate file.
*exclude tobacco and tobacco products (762 cases) from food aggregate.

use "$nlsstemp04\Sec10B_FoodFiltered.dta", clear

keep if (s10bq0>=119 & s10bq0<=121)
tab s10bq0

gen tobacco = ann_purch
lab var tobacco "Annual tobacco Consumption"

keep  hid tobacco

order hid tobacco

compress
saveold "$nlsstemp04\tobaccoexp04.dta", replace


**********************************************************

**Step 3: Computing the total food consumption expenditure.
*Household diary with the calculations, done by the enumerator.
*the units of consumption this time around were keyed directly from the questionnaire for the, monthly consumption.
*Aggregating by broad food groups.
 
use "$nlsstemp04\Sec10B_FoodFiltered.dta", clear

keep if s10bq0<119 | s10bq0>121

gen fdmaizby=ann_purch if  (s10bq0==1 | s10bq0==3 | s10bq0==4 | s10bq0==8) 
gen fdriceby=ann_purch if  (s10bq0>=5 & s10bq0<=7) 
gen fdcereby=ann_purch if  (s10bq0==2 | s10bq0==15 | s10bq0==16 | (s10bq0>=122 & s10bq0<=125)) 
gen fdbrdby=ann_purch  if  (s10bq0>=9 & s10bq0<=11) 
gen fdtubby=ann_purch  if  ((s10bq0>=12 & s10bq0<=14) | (s10bq0>=17 & s10bq0<=26) | s10bq0==126) 
gen fdpoulby=ann_purch if  (s10bq0>=58 & s10bq0<=61) 
gen fdmeatby=ann_purch if  ((s10bq0>=77 & s10bq0<=82) | s10bq0==135 | s10bq0==136) 
gen fdfishby=ann_purch if  (s10bq0>=70 & s10bq0<=76) 
gen fddairby=ann_purch if  (s10bq0>=62 & s10bq0<=69) 
gen fdfatsby=ann_purch if  (s10bq0==32 | (s10bq0>=34 & s10bq0<=47) | s10bq0==129 | s10bq0==130)
gen fdfrutby=ann_purch if  ((s10bq0>=48 & s10bq0<=51) | s10bq0==53 | s10bq0==55 | s10bq0==56 | s10bq0==131 | s10bq0==132) 
gen fdvegby=ann_purch  if  (s10bq0>=83 & s10bq0<=92)  | s10bq0==133 | s10bq0==134
gen fdbeanby=ann_purch if  (s10bq0>=27 & s10bq0<=31)  | s10bq0==33 | s10bq0==127 | s10bq0==128
gen fdswtby=ann_purch  if  (s10bq0>=104 & s10bq0<=107) 
gen fdbevby=ann_purch  if  ((s10bq0>=93 & s10bq0<=96) | s10bq0==52 | s10bq0==54 | s10bq0==57 | s10bq0==109 | s10bq0==110)
gen fdalcby=ann_purch  if  (s10bq0>=111 & s10bq0<=118) 
gen fdrestby=ann_purch if  (s10bq0>=97 & s10bq0<=104) 
gen fdothby=ann_purch  if  (s10bq0==108)

collapse (sum) fdmaizby fdriceby fdcereby fdbrdby fdtubby fdpoulby fdmeatby fdfishby fddairby fdfatsby fdfrutby ///
	fdvegby fdbeanby fdswtby fdbevby fdalcby fdrestby fdothby, by(case_id hid)


**********************************************************

**Step 4.  Derive total food and other variables.

recode fd* ( . = 0 )

egen fdtotby = rsum(fdmaizby fdriceby fdcereby fdbrdby fdtubby fdpoulby fdmeatby fdfishby fddairby fdfatsby fdfrutby ///
	fdvegby fdbeanby fdswtby fdbevby fdalcby fdrestby fdothby) 
lab var fdtotby "Total purchased food expenditure"

lab var fdmaizby "Maize grain and flours purchased"
lab var fdriceby "Rice in all forms purchased"
lab var fdcereby "Other cereals purchased"
lab var fdbrdby  "Bread and the like purchased"
lab var fdtubby  "Bananas & tubers purchased"
lab var fdpoulby "Poultry purchased"
lab var fdmeatby "Meats purchased"
lab var fdfishby "Fish & seafood purchased"
lab var fddairby "Milk, cheese & eggs purchased"
lab var fdfatsby "Oils, fats & oil-rich nuts purchased"
lab var fdfrutby "Fruits purchased"
lab var fdvegby  "Vegetables excludes pulses (beans & peas) purchased"
lab var fdbeanby "Pulses (beans & peas) purchased"
lab var fdswtby  "Sugar, jam, honey, chocolate & confectionary purchased"
lab var fdbevby  "Non-alcoholic purchased"
lab var fdalcby  "Alcoholic beverages purchased"
lab var fdrestby "Food consumed in restaurants & canteens purchased"
lab var fdothby  "Food items not mentioned above purchased"
lab var fdtotby  "Total expenditure of purchased foods"


******* SEEMS THAT THEY USE DIARY BUT IN REALITY THEY USE RECALL. HERE IT APPEARS TO BE MORE FREQUENT THAN 7 DAYS. 
******* 6 VISITS IN A MONTH AT REGULAR INTERVAL IS A VISIT EVERY 5 DAYS!!!!!

gen fdby_tr = 2 
lab var fdby_tr "Food purchases recall period"
lab val fdby_tr fdby_tr
lab define fdby_tr  1 "Day" 2 "Less than Week"  3 "Two-week"  4 "Month"  5 "Quarterly"  6 "Semi-annual"  7 "Annual"


**********************************************************

**Step 5: count how many households have zero purchases.
*HHs that have zero food (food purchases and own food) will be dropped.

gen fdby0=1  if   (fdtotby==0)
lab var fdby0 "Zero or missing food purchased expenditure"
tab fdby0

sum fdmaizby fdriceby fdcereby fdbrdby fdtubby fdpoulby fdmeatby fdfishby fddairby fdfatsby fdfrutby fdvegby ///
	fdbeanby fdswtby fdbevby fdalcby fdrestby fdothby fdtotby 

keep  case_id hid fdby_tr fdmaizby fdriceby fdcereby fdbrdby  fdtubby  fdpoulby fdmeatby fdfishby fddairby fdfatsby ///
	fdfrutby fdvegby  fdbeanby fdswtby  fdbevby  fdalcby  fdrestby fdothby fdtotby

order case_id hid fdby_tr fdmaizby fdriceby fdcereby fdbrdby  fdtubby  fdpoulby fdmeatby fdfishby fddairby fdfatsby ///
	fdfrutby fdvegby  fdbeanby fdswtby  fdbevby  fdalcby  fdrestby fdothby fdtotby
 
d
sort hid

compress
saveold "$nlssfintabs04\Table 2 foodpurchexp04.dta", replace




*************************************************************************************************************************************
***Table 3: FOOD OWN CONSUMPTION
*************************************************************************************************************************************
*Purpose: To gather the variables from the raw data required for calculating food own consumption.
*Data: Section 9: Agriculture Part 9H: Consumption of own produce.
*bear in mind that own-consumption refers, farm food produce, food from enterprise and food stocks.

use "$nlss2004\Sec 9H own consumption.dta", clear

sort hid s9hq0

drop s9hq3jan s9hq3feb s9hq3mar s9hq3apr s9hq3may s9hq3jun s9hq3jul s9hq3aug s9hq3sep s9hq3oct s9hq3nov s9hq3dec

*check for duplicates and drop.

duplicates tag,gen(dup)
tab dup
duplicates drop
drop dup

tab s9hq0

count if s9hq0==.
drop  if s9hq0==.


**********************************************************

**Step 1: outlier edits
*Computing total units consumed.

gen valid=1
sort hid
merge hid using "$nlss2004\date_interview.dta"
tab _m
keep if _m==3
drop _m

sort hid
merge m:1 hid using "$nlsstemp04\hhsize04.dta"
tab _m
drop _m
keep if valid==1
drop valid

tostring month,gen(month1) format(%02.0f)
replace year=2004 if year==3
replace year=2004 if year==4
tostring year,gen(year1)  format(%04.0f)
gen hyphen="-"
egen year_mth=concat(year1 hyphen month1)


**annual consumption as data is.

egen tqty=rsum(s9hq4 s9hq5 s9hq6 s9hq7 s9hq8 s9hq9 )
lab var tqty "Total monthly quantity (kg/lit)"

gen tmcon_ori1=tqty*s9hq11
gen anncon_ori1=tmcon_ori1*(365/30)
lab var tqty          "Total monthly quantity (kg/lit)"
lab var tmcon_ori1    "Monthly expenditure"
lab var anncon_ori1   "Annual expenditure"

sort hid s9hq0 -anncon_ori1
duplicates tag (hid s9hq0),gen(dup)
bys hid s9hq0 dup: gen countdup=_n
tab countdup

*largest value taken and all other dropped by item.

drop if countdup>=2
drop dup countdup

tabstat tmcon_ori1,by(s9hq0) s(N mean q sd max)  f(%12.2f)


**replace the outliers for quantities.

egen tqty_mn=mean(tqty), by(state year_mth s9hq0)
egen tqty_md=median(tqty), by(state year_mth s9hq0)
egen tqty_sd=sd(tqty), by(state year_mth s9hq0)
egen tqty_iqr=iqr(tqty), by(state year_mth s9hq0)
tabstat tqty_mn tqty_md tqty_sd tqty_iqr,by(s9hq0)  

gen pctqty=tqty/hhsize
egen pctqty_mn=mean(pctqty), by(state year_mth s9hq0)
egen pctqty_md=median(pctqty), by(state year_mth s9hq0)
egen pctqty_sd=sd(pctqty), by(state year_mth s9hq0)

gen std=(pctqty-pctqty_mn)/pctqty_sd
lab var std "Z score for a normal distribution"

gen tqty1=tqty
count if std>3 & std~=.
replace tqty1=tqty_md   if std>3 & std~=.
count if tqty1>=100 & tqty1~=.
replace tqty1=100       if tqty1>=100 & tqty1~=.
tabstat tqty tqty1,by(s9hq0) 


**Identify outliers for prices

count if  (s9hq4>0 |  s9hq5>0 |  s9hq6>0 |  s9hq7>0 |  s9hq8>0 |  s9hq9>0) &  s9hq11==.
list hid s9hq0 s9hq4 s9hq5 s9hq6 s9hq7 s9hq8 s9hq9 s9hq11 if  (s9hq4>0 |  s9hq5>0 |  s9hq6>0 |  s9hq7>0 |  s9hq8>0 |  s9hq9>0) &  s9hq11==.

*442 cases mising price.
*will apply median prices for missing by item.

gen price=s9hq11
count if price==0
recode price (0=.)
count if price==.

bys state year_mth s9hq0:egen s9hq11_md=median(s9hq11)
bys state year_mth s9hq0:egen s9hq11_sd=sd(s9hq11)
bys state year_mth s9hq0:egen s9hq11_iqr=iqr(s9hq11)
bys state year_mth s9hq0:egen s9hq11_nu=count(s9hq11)
tabstat s9hq11_md s9hq11_sd s9hq11_iqr s9hq11_nu,by(state)

replace price=s9hq11_md  if price==. & tqty1~=.
gen tmcon=tqty1*price
gen ann_con=tmcon*(365/30)
lab var tmcon     "Monthly expenditure (price/quantity editted)"
lab var ann_con   "Annual expenditure (price/quantity editted)"

sort state sector ric
merge m:1 state sector ric using "$nlss2004\Weights.dta"
tab _m
drop _m

tabstat anncon_ori1 ann_con [aw=wta_hh],by(year_mth)  s(sum)   f(%18.2f)
tabstat anncon_ori1 ann_con [aw=wta_hh],by(year_mth)  s(mean)  f(%18.2f)

compress
saveold "$nlsstemp04\Sec9H_Household Expenditure_Filtered.dta", replace


**below file will be used to derive basket of X% of population.
*see section FOOD BASKET

keep  state sector hid s9hq0 ann_con
order state sector hid s9hq0 ann_con

sort hid s9hq0

compress
saveold "$nlsstemp04\Sec9H_Household Expenditure_basket.dta", replace


**********************************************************

**Step 3: Aggregating by broad food groups.

use "$nlsstemp04\Sec9H_Household Expenditure_Filtered.dta", clear

gen fdmaizpr=ann_con  if  (s9hq0==1 | s9hq0==3 | s9hq0==4 | s9hq0==8) 
gen fdricepr=ann_con  if  (s9hq0>=5 & s9hq0<=7) 
gen fdcerepr=ann_con  if  (s9hq0==2 | s9hq0==15 | s9hq0==16 | (s9hq0>=122 & s9hq0<=125)) 
gen fdbrdpr=ann_con   if  (s9hq0>=9 & s9hq0<=11) 
gen fdtubpr=ann_con   if  ((s9hq0>=12 & s9hq0<=14) | (s9hq0>=17 & s9hq0<=26) | s9hq0==126) 
gen fdpoulpr=ann_con  if  (s9hq0>=58 & s9hq0<=61) 
gen fdmeatpr=ann_con  if  ((s9hq0>=77 & s9hq0<=82) | s9hq0==135 | s9hq0==136) 
gen fdfishpr=ann_con  if  (s9hq0>=70 & s9hq0<=76) 
gen fddairpr=ann_con  if  (s9hq0>=62 & s9hq0<=69) 
gen fdfatspr=ann_con  if  (s9hq0==32 | (s9hq0>=34 & s9hq0<=47) | s9hq0==129 | s9hq0==130)
gen fdfrutpr=ann_con  if  ((s9hq0>=48 & s9hq0<=51) | s9hq0==131 | s9hq0==132 | s9hq0==53 | s9hq0==55 | s9hq0==56) 
gen fdvegpr=ann_con   if  (s9hq0>=83 & s9hq0<=92)  | s9hq0==133 | s9hq0==134
gen fdbeanpr=ann_con  if  (s9hq0>=27 & s9hq0<=31)  | s9hq0==33 | s9hq0==127 | s9hq0==128
gen fdswtpr=ann_con   if  (s9hq0>=104 & s9hq0<=107) 
gen fdbevpr=ann_con   if  ((s9hq0>=93 & s9hq0<=96) | s9hq0==52 | s9hq0==54 | s9hq0==57 | s9hq0==109 | s9hq0==110)
gen fdalcpr=ann_con   if  (s9hq0>=111 & s9hq0<=118) 
gen fdrestpr=ann_con  if  (s9hq0>=97 & s9hq0<=104) 
gen fdothpr=ann_con   if  (s9hq0==108)

collapse (sum) fdmaizpr fdricepr fdcerepr fdbrdpr fdtubpr fdpoulpr fdmeatpr fdfishpr fddairpr fdfatspr fdfrutpr ///
	fdvegpr fdbeanpr fdswtpr fdbevpr fdalcpr fdrestpr fdothpr, by(case_id hid)


**********************************************************

**Step 4.  Derive remaining variables.

lab var fdbrdpr  "Bread and the like products auto-consumption"
lab var fdtubpr  "Tubers and plantains auto-consumption"
lab var fdpoulpr "Poultry auto-consumption"
lab var fdmeatpr "Meats auto-consumption"
lab var fdfishpr "Fish and seafood auto-consumption"
lab var fddairpr "Milk, cheese and eggs auto-consumption"
lab var fdfatspr "Oils, fats and oil-rich nuts auto-consumption"
lab var fdfrutpr "Fruits auto-consumption"
lab var fdvegpr  "Vegetables excludes pulses auto-consumption"
lab var fdbeanpr "Pulses (beans and peas) auto-consumption"
lab var fdswtpr  "Sugar, jam, honey, chocolate and confectionary auto-consumption"
lab var fdbevpr  "Non-alcoholic auto-consumption"
lab var fdalcpr  "Alcoholic beverages auto-consumption"
lab var fdrestpr "Food consumed in restaurants and canteens auto-consumption"
lab var fdothpr  "Food items not mentioned above auto-consumption"
lab var fdmaizpr "Maize auto-consumption"
lab var fdricepr "Rice auto-consumption"
lab var fdcerepr "Other cereals auto-consumption"

recode fd* ( . = 0 )

*Consultant excluded crop=108 from food own consumption aggregate.

egen fdtotpr=rsum(fdbrdpr fdtubpr fdpoulpr fdmeatpr fdfishpr  fddairpr fdfatspr fdfrutpr fdvegpr fdbeanpr fdswtpr ///
	fdbevpr fdalcpr fdrestpr fdothpr fdmaizpr fdricepr  fdcerepr)
lab var fdtotpr "Total value of auto-consumption food" 


gen fdpr0=1 if (fdtotpr==0)
lab var fdpr0 "Zero or missing own consumption"
tab fdpr0

sum fdmaizpr fdricepr fdcerepr fdbrdpr fdtubpr fdpoulpr fdmeatpr fdfishpr fddairpr fdfatspr fdfrutpr fdvegpr ///
	fdbeanpr fdswtpr fdbevpr fdalcpr fdrestpr fdothpr fdtotpr

keep  case_id hid fdmaizpr fdricepr fdcerepr fdbrdpr  fdtubpr  fdpoulpr fdmeatpr fdfishpr fddairpr fdfatspr fdfrutpr ///
	fdvegpr  fdbeanpr fdswtpr  fdbevpr  fdalcpr  fdrestpr fdothpr fdtotpr 

order case_id hid fdmaizpr fdricepr fdcerepr fdbrdpr  fdtubpr  fdpoulpr fdmeatpr fdfishpr fddairpr fdfatspr fdfrutpr ///
	fdvegpr  fdbeanpr fdswtpr  fdbevpr  fdalcpr  fdrestpr fdothpr fdtotpr 
 
d
sort hid

compress
saveold "$nlssfintabs04\Table 3 ownconsexp04.dta", replace

 
 

*************************************************************************************************************************************
***Table 4: EDUCATION
*************************************************************************************************************************************
*Title: Compute Educational expenses using Part A (Reference file).
*Purpose: To gather the variables from the raw data required for calculating the education expenditure. 
*Data: Part A : Section 2 part 2A General Education Roster.

**Step 1: Aggregate household expenditure on education and save outfile.
*expenditure data at individual level.

use "$nlss2004\Sec 2 education.dta", clear

duplicates report
duplicates drop

sort hid

*select only persons who attended school last 12 months.

keep if s2aq4==1
gen insch=1 if s2aq4==1 

collapse (sum)  s2aq7 s2aq8 s2aq9 s2aq10 s2aq11 s2aq12 s2aq13 s2aq14 s2aq17 insch,by(state sector case_id hid)
tabstat  s2aq7 s2aq8 s2aq9 s2aq10 s2aq11 s2aq12 s2aq13 s2aq14 s2aq17,by(state)
tabstat  s2aq7 s2aq8 s2aq9 s2aq10 s2aq11 s2aq12 s2aq13 s2aq14 s2aq17,by(sector)


use "$nlss2004\Sec 2 education.dta", clear

list  case_id   pid  s2aq2 s2aq4 s2aq7    if  case_id=="2311506024"
replace  s2aq7=50000 if  case_id=="2311506024" & s2aq7==500000

list  case_id   pid  s2aq2 s2aq4 s2aq7    if  case_id=="2310704046"
replace  s2aq7=45000 if  case_id=="2310704046" & s2aq7==4500

keep if s2aq4==1
gen insch=1 if s2aq4==1 

collapse (sum)  s2aq7 s2aq8 s2aq9 s2aq10 s2aq11 s2aq12 s2aq13 s2aq14 s2aq17 insch,by(case_id hid)
tabstat  s2aq7 s2aq8 s2aq9 s2aq10 s2aq11 s2aq12 s2aq13 s2aq14 s2aq17

ren s2aq7 edtution
ren s2aq10 edbooks
ren s2aq8 edmtnce
ren s2aq9 edunifms
ren s2aq13 edextra
ren s2aq12 edrmbrd
ren s2aq11 edtrnsp
ren s2aq14 edoth1
ren s2aq17 scholar
ren insch inschool


*households have between 1-9 kids in school with an average of about 3 per household in school.

sum inschool

*replacing blanks with 0.
*education costs that cannot be classified (s2a14j) omitted and thus had to create edagg=0.
*omitted edagg1 (see reason above) as identical to quran costs.

gen edagg=.
gen edinsur=.
gen edquran=.

gen edoth=edoth1 

recode ed* (.=0)


**********************************************************

*complete calculating the aggregates.
*in 2004 education insurance not captured as a category by itself and lumped under insurance.
*included education insurance.

egen edtexp=rsum(edtution edbooks edunifms edextra edrmbrd edtrnsp edmtnce edquran edinsur edoth)

lab var edtution "Tuition (school fees and registration)" 
lab var edbooks  "Text books and school supplies" 
lab var edunifms "School uniforms" 
lab var edextra  "Extra-curricular activities" 
lab var edrmbrd  "Feeding and Boarding" 
lab var edtrnsp  "Transport to school" 
lab var edmtnce  "Fees for school maintenance" 
lab var edinsur  "Education insurance" 
lab var edoth    "Expenditure on education not mentioned elsewhere" 
lab var edagg    "Education expenditure if cannot be classified by above groups" 
lab var edquran  "Quranic education"
lab var edtexp   "Total monetary value of education" 

*mean value of scholarship and total education.

sum edtution  edunifms  edbooks  edtrnsp  edrmbrd  edextra  edmtnce  edquran edoth edinsur scholar edtexp

keep  case_id hid edtution edbooks edunifms edextra edrmbrd edtrnsp edmtnce edquran edoth edagg edinsur edtexp

order case_id hid edtution edbooks edunifms edextra edrmbrd edtrnsp edmtnce edquran edoth edagg edinsur edtexp

d
sort hid

compress
saveold "$nlssfintabs04\Table 4 eduexp04.dta", replace




*************************************************************************************************************************************
***Table 5: HEALTH
*************************************************************************************************************************************
**Section 3 aggregates.
*Section 3 and 12 have health and only health costs in Section 3 will be used to avoid double counting.
*Consultant method: excluding vaccines, post and prenatal.

use "$nlss2004\Sec 3 health.dta", clear

duplicates report
duplicates drop

**Step 1.
*annualizing consultations (excluding vaccines, post and prenatal).

gen hlcons = s3aq10*26 

gen hltrsp = s3aq11*26 

gen hlhospt = s3aq15*26  

gen hlpok = s3aq19*13 

gen hlmedc = s3aq17*13 

collapse (sum) hlcons hltrsp hlhospt hlmedc hlpok, by(state sector case_id hid)

gen hloth=.
gen hleqpt=.
gen hlinsur=.


**********************************************************

*computing total health care expenditures.
*HLHOSPT included in the final health costs.  Norm this should be excluded (602 cases).
*experience has shown that HHs do not entirely bear these cost alone.
*fund raising, donations etc help out.
*unfortunately, from survey we cannot state what proportion HH bears these costs.

recode hl* ( . = 0 )

egen hltexp=rsum(hlcons hlmedc hltrsp hlinsur hlhospt hloth)

lab var hlcons   "Consultation fees"
lab var hlmedc   "Medication"
lab var hltrsp   "Transport to hospital"
lab var hlhospt  "Hospitalization"
lab var hltexp   "Total monetary value of health"
lab var hleqpt   "Therapeutic equipment" 
lab var hlinsur  "Health insurance"
lab var hloth    "Expenditures on health not mentioned elsewhere" 

keep  case_id hid hlcons hltrsp hlhospt hlmedc hlinsur hleqpt hloth hltexp 

order case_id hid hlcons hltrsp hlhospt hlmedc hlinsur hleqpt hloth hltexp

sort hid

d
compress
saveold "$nlssfintabs04\Table 5 healthexp04.dta", replace




*************************************************************************************************************************************
***Table 6: FREQUENT NON-FOOD
*************************************************************************************************************************************

**lighting.

use "$nlss2004\Sec 7 housing.dta", clear

duplicates report
duplicates drop

replace s7dq9=.  if s7dq9==0
gen light=(s7dq9*365)     if (s7dq9t==1)
replace light=(s7dq9*52)  if (s7dq9t==2)
replace light=(s7dq9*12)  if (s7dq9t==3)
replace light=(s7dq9*4)   if (s7dq9t==4)
replace light=(s7dq9*2)   if (s7dq9t==5)
replace light=(s7dq9*1)   if (s7dq9t==6)
recode light (0=.)
tabstat light,by(state)  s(n mean sd iqr max)

count if  s7dq9~=. & s7dq9t==.

replace s7dq9=1015  if case_id=="0110701005" & s7dq9==10150
replace s7dq9t=3    if case_id=="0421510057" & s7dq9t==1
replace s7dq9t=3    if case_id=="0621104005" & s7dq9t==1
replace s7dq9t=3    if case_id=="0621204013" & s7dq9t==2
replace s7dq9=350   if case_id=="0621204013" & s7dq9==3500
replace s7dq9t=3    if case_id=="0720906002" & s7dq9t==1
replace s7dq9t=3    if case_id=="0810710005" & s7dq9t==1
replace s7dq9t=3    if case_id=="1220706023" & s7dq9t==2
replace s7dq9t=3    if case_id=="1220807017" & s7dq9t==1
replace s7dq9t=2    if case_id=="1321807048" & s7dq9t==1
replace s7dq9=210   if case_id=="1420706004" & s7dq9==2100
replace s7dq9t=3    if case_id=="1420706004" & s7dq9t==2
replace s7dq9t=2    if case_id=="2120902007" & s7dq9t==1
replace s7dq9=470   if case_id=="2211805017" & s7dq9==4700
replace s7dq9=1350  if case_id=="2711102064" & s7dq9==13500
replace s7dq9t=6    if case_id=="3010805023" & s7dq9t==3
replace s7dq9t=6    if case_id=="3321507025" & s7dq9t==4
replace s7dq9t=3    if case_id=="3521602040" & s7dq9t==1
replace s7dq9t=3    if case_id=="3521602042" & s7dq9t==1
replace s7dq9=500   if case_id=="0421106008" & s7dq9==5000
replace s7dq9t=6    if case_id=="0110701005"
replace s7dq9=1000  if case_id=="0711106001"
replace s7dq9=1000  if case_id=="0711106005"
replace s7dq9=1000  if case_id=="1811510164"
replace s7dq9=1200  if case_id=="2221804017"
replace s7dq9t=6    if case_id=="2710801045"
replace s7dq9t=1    if case_id=="2710801022"
replace s7dq9=350   if case_id=="2711102064"
replace s7dq9=1000  if case_id=="3611604008"
replace s7dq9=1500  if case_id=="3710104073"
replace s7dq9=1500  if case_id=="3710204004"
replace s7dq9=700   if case_id=="3720410019"
replace s7dq9=600   if case_id=="3720410009"
replace s7dq9=300   if case_id=="3720605092"
replace s7dq9=500   if case_id=="3720605123"
replace s7dq9t=3    if case_id=="0811101006"
replace s7dq9t=3    if case_id=="2120902007"
replace s7dq9t=3    if case_id=="2710801022"
replace s7dq9=900   if case_id=="0511401330"
replace s7dq9=890   if case_id=="3010805023"
replace s7dq9t=2    if case_id=="2020710001"
replace s7dq9t=2    if case_id=="3220909004"
replace s7dq9t=2    if case_id=="3420705005"
replace s7dq9t=2    if case_id=="3521602040"
replace s7dq9t=2    if case_id=="3521602042"
replace s7dq9t=2    if case_id=="3621208045"
replace s7dq9=s7dq9/10  if s7dq9>=10000 & s7dq9~=. 
replace s7dq9t=3    if  s7dq9t==. & ( s7dq9~=. &  s7dq9~=0)
replace s7dq9=s7dq9*10  if s7dq9<10

replace light=(s7dq9*365) if (s7dq9t==1)
replace light=(s7dq9*52)  if (s7dq9t==2)
replace light=(s7dq9*12)  if (s7dq9t==3)
replace light=(s7dq9*4)   if (s7dq9t==4)
replace light=(s7dq9*2)   if (s7dq9t==5)
replace light=(s7dq9*1)   if (s7dq9t==6)
tabstat light,by(state)  s(n mean sd iqr max)

bys state:egen light_mn=mean(light)
bys state:egen light_md=median(light)
bys state:egen light_sd=sd(light)
bys state:egen light_iqr=iqr(light)
bys state:egen light_nu=count(light)
tabstat light_md  light_sd  light_iqr  light_nu,by(state)

gen std=(light-light_mn)/light_sd
lab var std "Z score for a normal distribution"

count if std>3 & std~=.
replace light=light_md   if std>3 & std~=.
tabstat light,by(state)  s(n mean sd iqr max)

keep hid light

sort hid 

compress
saveold "$nlsstemp04\Sec7_light.dta", replace
drop _all


**********************************************************

**refuse.

use "$nlss2004\Sec 7 housing.dta", clear

replace s7dq12=.  if s7dq12==0

gen refuse=(s7dq12*365)    if (s7dq12t==1) 
replace refuse=(s7dq12*52) if (s7dq12t==2) 
replace refuse=(s7dq12*12) if (s7dq12t==3) 
replace refuse=(s7dq12*4)  if (s7dq12t==4) 
replace refuse=(s7dq12*2)  if (s7dq12t==5) 
replace refuse=(s7dq12*1)  if (s7dq12t==6) 
recode refuse (0=.)
tabstat refuse,by(state)  s(n mean sd iqr max)

count if  s7dq12~=. &  s7dq12t==.

bys state:egen refuse_mn=mean(refuse)
bys state:egen refuse_md=median(refuse)
bys state:egen refuse_sd=sd(refuse)
bys state:egen refuse_iqr=iqr(refuse)
bys state:egen refuse_nu=count(refuse)
tabstat refuse_md  refuse_sd  refuse_iqr  refuse_nu,by(state)

gen std=(refuse-refuse_mn)/refuse_sd
lab var std "Z score for a normal distribution"

count if std>3 & std~=.
replace refuse=refuse_md   if std>3 & std~=.
tabstat refuse,by(state)  s(n mean sd iqr max)

sort hid 

keep hid refuse

compress
saveold "$nlsstemp04\Sec7_refuse.dta", replace
drop _all


**********************************************************

**water.
*previous survey asked  monthly vendor costs in this section.
*other water costs captured in Section 12B1.
*will compare costs of the two.
*however, Section 7 costs used.

use "$nlss2004\Sec 7 housing.dta", clear

replace s7dq4=.  if s7dq4==0

gen water1 = (s7dq4*365)    if s7dq4t==1
replace water1 = (s7dq4*52) if s7dq4t==2
replace water1 = (s7dq4*12) if s7dq4t==3
replace water1 = (s7dq4*4)  if s7dq4t==4
replace water1 = (s7dq4*2)  if s7dq4t==5
replace water1 = (s7dq4*1)  if s7dq4t==6
replace water1 = s7dq4      if s7dq4t==.
recode water1 (0=.)
tabstat water1,by(state)  s(n mean sd iqr max)

count if  s7dq4~=. &  s7dq4t==.

bys state:egen water1_mn=mean(water1)
bys state:egen water1_md=median(water1)
bys state:egen water1_sd=sd(water1)
bys state:egen water1_iqr=iqr(water1)
bys state:egen water1_nu=count(water1)
tabstat water1_md  water1_sd  water1_iqr  water1_nu,by(state)

gen std=(water1-water1_mn)/water1_sd
lab var std "Z score for a normal distribution"

count if std>3 & std~=.
replace water1=water1_md   if std>3 & std~=.
tabstat water1,by(state)  s(n mean sd iqr max)
drop std


**Water cost paid to a private vendor, separate from the water bill.

gen water2=(s7dq5*26)   
recode water2 (0=.)
tabstat water2,by(state)  s(n mean sd iqr max)
list state hid  s7dq5 water2 if water2>100000 & water2~=.
replace water2=10400   if case_id=="0211207017"
replace water2=26000   if case_id=="3710601002"

bys state:egen water2_mn=mean(water2)
bys state:egen water2_md=median(water2)
bys state:egen water2_sd=sd(water2)
bys state:egen water2_iqr=iqr(water2)
bys state:egen water2_nu=count(water2)
tabstat water2_md  water2_sd  water2_iqr  water2_nu,by(state)

gen std=(water2-water2_mn)/water2_sd
lab var std "Z score for a normal distribution"

count if std>3 & std~=.
replace water2=water2_md   if std>3 & std~=.
tabstat water2,by(state)  s(n mean sd iqr max)

egen water=rowtotal(water1 water2)
recode water (0=.)
tabstat water,by(state)  s(n mean sd iqr max)

sort hid 

keep hid water

compress
saveold "$nlsstemp04\Sec7_water.dta", replace
drop _all


**********************************************************

**minor repairs.

use "$nlss2004\Sec 7 housing.dta", clear

replace s7dq5=0  if s7dq5==.
replace s7dq4=0  if s7dq4==.
replace s7dq9=0  if s7dq9==.
replace s7dq12=0 if s7dq12==.

gen nfdrepar1= s7cq6
recode nfdrepar1 (0=.)
tabstat nfdrepar1,by(state)  s(n mean sd iqr max)

bys state:egen nfdrepar1_mn=mean(nfdrepar1)
bys state:egen nfdrepar1_md=median(nfdrepar1)
bys state:egen nfdrepar1_sd=sd(nfdrepar1)
bys state:egen nfdrepar1_iqr=iqr(nfdrepar1)
bys state:egen nfdrepar1_nu=count(nfdrepar1)
tabstat nfdrepar1_mn nfdrepar1_md  nfdrepar1_sd  nfdrepar1_iqr  nfdrepar1_nu,by(state)

gen std=(nfdrepar1-nfdrepar1_mn)/nfdrepar1_sd
lab var std "Z score for a normal distribution" 

count if nfdrepar1>0 & nfdrepar1~=.
count if std>3 & std~=.

gen nfdrepar2=nfdrepar1
replace nfdrepar2=nfdrepar1_md   if std>3 & std~=.
count if nfdrepar2>=500000 & nfdrepar2~=.

sort hid 

keep hid nfdrepar1

compress
saveold "$nlsstemp04\Sec7_nfdrepar.dta", replace


**********************************************************

***Frequent items PART B: Section 10A2.

**edit outliers.

use "$nlss2004\Sec 10A2 non-food freq.dta", clear

duplicates report
duplicates drop

*577 cases have invalid codes. 
*17 missing product codes.

tab s10a2q0
drop if s10a2q0<308 | s10a2q0==435 | s10a2q0>=809 
tab s10a2q0

gen valid=1
sort hid
merge hid using "$nlss2004\date_interview.dta"
tab _m
keep if _m==3
drop _m

sort hid
merge m:1 hid using "$nlsstemp04\hhsize04.dta"
tab _m
drop _m
keep if valid==1
drop valid

*5 day interval.

egen fnftot1=rsum(s10a2q1 s10a2q2 s10a2q3 s10a2q4 s10a2q5 s10a2q6)
replace fnftot1=fnftot1/30*365

gsort hid s10a2q0 -fnftot1
duplicates tag ( hid s10a2q0),gen(dup)
bys hid s10a2q0 dup: gen countdup=_n
tab countdup
drop if countdup>=2         //keep largest value of item if duplicate.

tostring month,gen(month1) format(%02.0f)
tostring year,gen(year1)   format(%02.0f)
gen hyphen="-"
egen year_mth=concat(year1 hyphen month1)

tabstat fnftot1,by(s10a2q0)  s(sum  N mean median max) f(%15.1f)

**edit outliers.

bys state year_mth s10a2q0:egen fnftot1_md=median(fnftot1)
bys state year_mth s10a2q0:egen fnftot1_sd=sd(fnftot1)
bys state year_mth s10a2q0:egen fnftot1_iqr=iqr(fnftot1)
bys state year_mth s10a2q0:egen fnftot1_nu=count(fnftot1)
tabstat fnftot1_md fnftot1_sd fnftot1_iqr fnftot1_nu,by(state)

gen pcfnftot1=fnftot1/hhsize
bys state year_mth s10a2q0: egen pcfnftot1_mn=mean(pcfnftot1)
bys state year_mth s10a2q0: egen pcfnftot1_md=median(pcfnftot1)
bys state year_mth s10a2q0: egen pcfnftot1_sd=sd(pcfnftot1)

gen std=(pcfnftot1-pcfnftot1_mn)/pcfnftot1_sd
lab var std "Z score for a normal distribution"

gen fnftot=fnftot1
count if std>3 & std~=.
replace fnftot=fnftot1_md   if std>3 & std~=.
tabstat fnftot,by(s10a2q0)  s(mean)  f(%18.2f)

*for 2008-09 edits anyone spending over 150K annually was top-coded to 100K.
*for 2004-04 shall deflate using CPI for top coding.
*allCPI deflator is 0.5141975
*270 observations top coded of total 104,018.

count if fnftot>=77129.625 & fnftot~=.
replace fnftot=77129.625     if fnftot>=77129.625 & fnftot~=.

sort hid
sort state sector ric
merge m:1 state sector ric using "$nlss2004\Weights.dta"
tab _m
drop _m

tabstat fnftot1 fnftot [aw=wta_hh],by(year_mth)  s(sum)  f(%18.2f)

drop s10a2q1 s10a2q2 s10a2q3 s10a2q4 s10a2q5 s10a2q6 day month month1 year year1 ///
	dateinte hhsize ctry_adq wta_hh fnftot1 dup countdup hyphen year_mth fnftot1_md ///
	fnftot1_sd fnftot1_iqr fnftot1_nu pcfnftot1 pcfnftot1_mn pcfnftot1_md pcfnftot1_sd std

sort hid

compress
saveold "$nlsstemp04\Sec10A2_Filtered.dta", replace


**********************************************************

**employer provided transport.
*derived by Consultant but not used.
*will not derive for now.


**********************************************************

**combine freq into one file – all now annualized.

use "$nlsstemp04\Sec10A2_Filtered.dta", clear

append using "$nlsstemp04\Sec7_light.dta"
append using "$nlsstemp04\Sec7_refuse.dta" 
append using "$nlsstemp04\Sec7_water.dta" 
append using "$nlsstemp04\tobaccoexp04.dta"

replace s10a2q0=4 if light>0 & light~=. & s10a2q0==.
replace s10a2q0=5 if refuse>0 & refuse~=. & s10a2q0==.
replace s10a2q0=6 if water>0 & water~=. & s10a2q0==.
replace s10a2q0=120 if tobacco>0 & tobacco~=. & s10a2q0==.

lab define  s10a2q0 4 "Electricity",add
lab define  s10a2q0 5 "Refuse",add
lab define  s10a2q0 6 "Water",add
lab define  s10a2q0 120 "Tobacco",add
tab s10a2q0

sort hid s10a2q0

gen itemexp=fnftot 
replace itemexp=light    if itemexp==.
replace itemexp=refuse   if itemexp==.
replace itemexp=water    if itemexp==.
replace itemexp=tobacco  if itemexp==.

**aggregating by broad groups.
*survey insurance lumpsum not categorized like 2009-10.
*water rates excluded here for included in Section 7.  If included double counting.
*exclude health and education for covered in Section 2 and 3 respectively to avoid double counting.

gen nfdtbac=itemexp    if (s10a2q0==120) 
gen nfdwater1=itemexp  if (s10a2q0==6) 
gen nfdwater2=itemexp  if (s10a2q0==308) 
gen nfdelec=itemexp    if (s10a2q0==4) 
gen nfdutil=itemexp    if (s10a2q0==5) 
gen nfdgas=itemexp     if (s10a2q0==310) 
gen nfdfwood=itemexp   if (s10a2q0==313) 
gen nfdchar=itemexp    if (s10a2q0==312) 
gen nfdkero=itemexp    if (s10a2q0==311) 
gen nfdcloth1=itemexp  if (s10a2q0==314 | s10a2q0==320) 
gen nfdfmtn1=itemexp   if (s10a2q0==404 | s10a2q0==410 | (s10a2q0>=425 & s10a2q0<=431))
gen nfddome1=itemexp   if (s10a2q0==433)
gen nfdpetro=itemexp   if (s10a2q0==608) 
gen nfdlubri=itemexp   if (s10a2q0==609) 
gen nfdtrans1=itemexp  if (s10a2q0==605) 
gen nfdfares1=itemexp  if (s10a2q0>=610 & s10a2q0<=612) 
gen nfdcomm1=itemexp   if (s10a2q0>=613 & s10a2q0<=614) 
gen nfdrecre1=itemexp  if ((s10a2q0>=707 & s10a2q0<=713) | s10a2q0==806) 
gen nfdinsur=itemexp   if (s10a2q0==802) 
gen nfdptax=itemexp    if (s10a2q0==801) 
gen nfdoth1=itemexp    if ((s10a2q0>=804 & s10a2q0<=805) | s10a2q0==807 | s10a2q0==808) 
gen nfdsnppl1=itemexp  if (s10a2q0==420)

compress
saveold "$nlsstemp04\Sec10A2_non-food freq2 annual.dta", replace

collapse (sum) nfdsnppl1,by(hid)
sort hid

compress
saveold "$nlsstemp04\snppl1.dta", replace


**********************************************************

use "$nlsstemp04\Sec10A2_non-food freq2 annual.dta", clear

collapse (sum) nfdtbac nfdwater1 nfdwater2 nfdelec nfdutil nfdgas nfdfwood nfdchar nfdkero nfdcloth1 nfdfmtn1 ///
	nfddome1 nfdpetro nfdlubri nfdtrans1 nfdfares1 nfdcomm1 nfdrecre1 nfdinsur nfdptax nfdoth1,by(hid)

gen nfdsold=.
gen nfdliqd=.
gen nfddiesl=.

lab var nfdtbac   "Tobacco"
lab var nfdwater1 "Water (water bill)"
lab var nfdwater2 "Water (other water)" 
lab var nfdelec   "Electricity" 
lab var nfdgas    "Gas" 
lab var nfdfwood  "Firewood" 
lab var nfdchar   "Charcoal" 
lab var nfdsold   "Other solid fuels" 
lab var nfdkero   "Kerosene"
lab var nfdliqd   "Other liquid fuels" 
lab var nfdutil   "Other utilities" 
lab var nfdfmtn1  "Maintenance" 
lab var nfddome1  "Domestic servants" 
lab var nfdcloth1 "Repairs to clothing and footwear" 
lab var nfdpetro  "Petrol" 
lab var nfddiesl  "Diesel" 
lab var nfdlubri  "Lubricants" 
lab var nfdfares1 "Fares" 
lab var nfdtrans1 "Transport" 
lab var nfdcomm1  "Communication" 
lab var nfdrecre1 "Recreation" 
lab var nfdinsur  "Insurance" 
lab var nfdptax   "Property taxes and licences" 
lab var nfdoth1   "Other miscellaneous items" 

sort hid

compress
saveold "$nlsstemp04\freqnfoodexp04.dta", replace


**********************************************************

***Infrequent items PART B: Section 10A1.
*items include elsewhere dropped = domestic servants, etc.

*edit outliers.

use "$nlss2004\Sec 10A1 non-food less freq.dta", clear

duplicates report
duplicates drop

*drop cases have invalid codes and missing product codes.

tab s10aq0
drop if s10aq0==302 | s10aq0>=307 & s10aq0<=350 | s10aq0==408
tab s10aq0

gen valid=1
sort hid
merge hid using "$nlss2004\date_interview.dta"
tab _m
keep if _m==3
drop _m

sort hid
merge m:1 hid using "$nlsstemp04\hhsize04.dta"
tab _m
drop _m
keep if valid==1
drop valid

*make sure HH responded to either and  not both.

gen f10a1tot11 = s10aq3   if s10aq2<12 
gen f10a1tot22 = s10aq4*4 if s10aq2>=12 
gen del1=1 if  f10a1tot11~=.
gen del2=1 if  f10a1tot22~=.
egen del=rowtotal( del1 del2)
tab  del      			 //no HH has responded to both.
drop del1 del2 del  
egen f10a1tot1=rowtotal(f10a1tot11  f10a1tot22)

gsort hid s10aq0 -f10a1tot1
duplicates tag ( hid s10aq0),gen(dup)
bys hid s10aq0 dup: gen countdup=_n
tab countdup
drop if countdup>=2         	//keep largest value of item if duplicate.

tostring month,gen(month1) format(%02.0f)
tostring year,gen(year1)   format(%02.0f)
gen hyphen="-"
egen year_mth=concat(year1 hyphen month1)

tabstat f10a1tot1,by(s10aq0)  s(sum  N mean median max) f(%15.1f)

**edit outliers.

bys state year_mth s10aq0:egen f10a1tot1_md=median(f10a1tot1)
bys state year_mth s10aq0:egen f10a1tot1_sd=sd(f10a1tot1)
bys state year_mth s10aq0:egen f10a1tot1_iqr=iqr(f10a1tot1)
bys state year_mth s10aq0:egen f10a1tot1_nu=count(f10a1tot1)
tabstat f10a1tot1_md  f10a1tot1_sd  f10a1tot1_iqr  f10a1tot1_nu,by(state)

gen pcf10a1tot1=f10a1tot1/hhsize
bys state year_mth s10aq0: egen pcf10a1tot1_mn1=mean(pcf10a1tot1)
bys state year_mth s10aq0: egen pcf10a1tot1_md1=median(pcf10a1tot1)
bys state year_mth s10aq0: egen pcf10a1tot1_sd1=sd(pcf10a1tot1)

gen std=(pcf10a1tot1-pcf10a1tot1_mn)/pcf10a1tot1_sd
lab var std "Z score for a normal distribution"

gen f10a1tot=f10a1tot1
count if std>3 & std~=.
replace f10a1tot=f10a1tot1_md   if std>3 & std~=.


sort hid
sort state sector ric
merge m:1 state sector ric using "$nlss2004\Weights.dta"
tab _m
drop _m

tabstat f10a1tot1 f10a1tot [aw=wta_hh],by(year_mth)  s(sum)  f(%18.2f)

sort hid

drop  s10aq1 s10aq2 s10aq3 s10aq4 s10aq5 day month month1 year year1 dateinte hhsize ctry_adq ///
	wta_hh f10a1tot11 f10a1tot22 f10a1tot1 dup countdup hyphen year_mth f10a1tot1_md f10a1tot1_sd ///
	f10a1tot1_iqr f10a1tot1_nu pcf10a1tot1 pcf10a1tot1_mn1 pcf10a1tot1_md1 pcf10a1tot1_sd1 std

compress
saveold "$nlsstemp04\Sec10A1_Filtered.dta", replace


**clothing and maintenance.

use "$nlsstemp04\Sec10A1_filtered.dta", clear

gen nfdcloth2=f10a1tot if (s10aq0>=201 & s10aq0<=230) 
gen nfdfmtn2=f10a1tot  if (s10aq0==401 | s10aq0==402 | s10aq0==406 | s10aq0==442 | (s10aq0>=419 & s10aq0<=422) | s10aq0==442) 

collapse (sum) nfdcloth2 nfdfmtn2, by(hid)

lab var nfdcloth2  "Clothing and footwear" 
lab var nfdfmtn2   "Maintenance" 

sort hid

compress
saveold "$nlsstemp04\infreqnfoodexp04.dta", replace


**********************************************************

***Rent.

use "$nlss2004\Sec 7 housing.dta", clear

duplicates report
duplicates drop

gen zone=.
replace zone=5  if (state==3  | state==6  | state==9  | state==10 | state==12  | state==32 )
replace zone=4  if (state==1  | state==4  | state==11 | state==14 | state==16 ) 
replace zone=6  if (state==13 | state==24 | state==27 | state==28 | state==29  | state==30 ) 
replace zone=1  if (state==7  | state==22 | state==23 | state==25 | state==26  | state==31 | state==37 ) 
replace zone=2  if (state==2  | state==5  | state==8  | state==15 | state==34  | state==35 ) 
replace zone=3  if (state==17 | state==18 | state==19 | state==20 | state==21  | state==33 | state==36 ) 
lab var zone "Zone"
lab define zone 1  "North Central" 2  "North East" 3  "North West" 4  "South East" 5  "South South" 6  "South West"
lab val zone zone

*annualize rent for uniformnity.

gen rent=(s7cq1*365)    if (s7cq1t==1)
replace rent=(s7cq1*52) if (s7cq1t==2)
replace rent=(s7cq1*12) if (s7cq1t==3)
replace rent=(s7cq1*4)  if (s7cq1t==4)
replace rent=(s7cq1*2)  if (s7cq1t==5)
replace rent=(s7cq1*1)  if (s7cq1t==6)

tabstat rent, stat (n mean median sd min max) by(zone)
tabstat rent, stat (n mean median sd min max) by(state)
tabstat rent, stat (n mean median sd min max) by(sector)

gen lnrent=ln(rent) 

*if missing rooms (which is impossible) assign mean by zone.

tab s7aq2

bysort zone: egen room_mn=mean(s7aq2)
lab var room_mn "Mean number of rooms by zone"

gen rooms=s7aq2 
replace rooms=room_mn if s7aq2==.

gen lnroom=ln(rooms) 
gen lnroom2=lnroom*lnroom 


**Method 1 .
*location: dummy=South south urban zone (SSURB).
*this broad classification is done cos NGA has 37 states and creating rural/urban would be many and observations too few in some states.
*this classification is based on the geopolitical grouping within the country.

gen ssurb=1 if ((state==3  | state==6  | state==9  | state==10 | state==12 | state==32) & sector==1) 
gen ssrur=1 if ((state==3  | state==6  | state==9  | state==10 | state==12 | state==32) & sector==2) 
gen seurb=1 if ((state==1  | state==4  | state==11 | state==14 | state==16) & sector==1) 
gen serur=1 if ((state==1  | state==4  | state==11 | state==14 | state==16) & sector==2) 
gen swurb=1 if ((state==13 | state==24 | state==27 | state==28 | state==29 | state==30) & sector==1)
gen swrur=1 if ((state==13 | state==24 | state==27 | state==28 | state==29 | state==30) & sector==2)
gen ncurb=1 if ((state==7  | state==22 | state==23 | state==25 | state==26 | state==31 | state==37) & sector==1)
gen ncrur=1 if ((state==7  | state==22 | state==23 | state==25 | state==26 | state==31 | state==37) & sector==2)
gen neurb=1 if ((state==2  | state==5  | state==8  | state==15 | state==34 | state==35) & sector==1)
gen nerur=1 if ((state==2  | state==5  | state==8  | state==15 | state==34 | state==35) & sector==2)
gen nwurb=1 if ((state==17 | state==18 | state==19 | state==20 | state==21 | state==33 | state==36) & sector==1)
gen nwrur=1 if ((state==17 | state==18 | state==19 | state==20 | state==21 | state==33 | state==36) & sector==2)

*water: dummy=piped water. 

recode  s7dq1 (1/4=1) (5/8=2),gen(water)
lab var water "Water source recoded"
lab define water 1 "Piped/protected water"  2 "Unprotected water" 

gen wsource1=1 if (water==1) 
gen wsource2=1 if (water==2) 

*light: dummy=electricity.

gen keroligt=1 if (s7dq8==1)
gen elecligt=1 if (s7dq8>=2 & s7dq8<=4) 
gen othligt=1  if (s7dq8>=5)

*cooking: dummy=electricity.

gen woodcuk=1 if (s7dq10<=2)
gen kerocuk=1 if (s7dq10==3) 
gen eleccuk=1 if (s7dq10>=4 & s7dq10<=5) 
gen othcuk=1  if (s7dq10>=6)

*toilet: dummy=flush toilet.

gen flustoil=1  if (s7dq13>=3 & s7dq13<=4) 
gen viptoil=1   if (s7dq13==6 | s7dq13==8) 
gen othtoil=1   if (s7dq13==2 | s7dq13==5 | s7dq13==7 | s7dq13==9)
gen nontoil=1   if (s7dq13==1)  

*wall: dummy=mud.

gen mudwall=1  if (s7eq1==1 | s7eq1==7 | s7eq1==8 )  
gen permwall=1 if (s7eq1==2 | s7eq1==4)  
gen semiwall=1 if (s7eq1==3 | s7eq1==5 | s7eq1==6)  

*floor: dummy=mud.

gen  mudflor=1  if (s7eq2==1 | s7eq2>=5 | s7eq2==.)
gen  stonflor=1 if (s7eq2>=2 & s7eq2<=4) 

*roof: dummy=thatch roof.

gen semiroof=1 if (s7eq3<=3 | s7eq3==8 | s7eq3==.) 
gen permroof=1 if (s7eq3>=4 & s7eq3<=7)  

recode ssurb ssrur seurb serur swurb swrur ncurb ncrur neurb nerur nwurb nwrur wsource1 wsource2 ///
	keroligt elecligt othligt woodcuk kerocuk eleccuk othcuk flustoil viptoil othtoil nontoil ///
	mudwall permwall semiwall mudflor stonflor semiroof permroof  (.=0) 


**Method 2.
*Computing a quality index based on the housing characteristics.
*quality based on superiority of material.  The higher the quality the greater the value.

recode s7eq1 (1=1)  (2=3)  (3=3)  (4=3)  (5=1)  (7=1)  (6=2) (8=1),gen(wqual)
lab var wqual "Quality index of wall"
lab define wqual  1 "Low"  2 "Medium (semi-permanent)"  3 "Superior (permanent)" 
lab val wqual wqual

recode s7eq2 (1=1) (2=2) (3=2) (4=3) (5=1)  (6=1),gen(fqual)
lab var fqual "Quality index of floor"
lab define fqual  1 "Low"  2 "Medium (semi-permanent)"  3 "Superior (permanent)"
lab val fqual fqual

recode s7eq3 (1=1) (2=1) (3=1) (4=2) (5=3) (7=1) (6=3),gen(rqual)
lab var rqual "Quality index of roof"
lab define rqual  1 "Low"  2 "Medium (semi-permanent)"  3 "Superior (permanent)" 
lab val rqual rqual

egen qindex=rsum(wqual rqual fqual)

sort hid

gen sectr=0      if sector==1
replace sectr=1  if sector==2
lab var sectr "Rural-urban" 
lab define sectr  1 "Rural"  0 "Urban" 
lab var sectr sectr

recode state (1/23 25/37=0) (24=1),gen(lagos)
lab var lagos "Lagos as dummy"
lab define lagos 1 "Lagos"  0 "Non-lagos"
lab val lagos lagos

pwcorr wqual fqual rqual qindex sectr lagos,star(.01)

compress
saveold "$nlsstemp04\House_Utilities_Rent1.dta", replace


**********************************************************

**run regression model.
*selected Standard Error of Predicted Value to observe.
*did sensitivity tests on various models.

regress lnrent lnroom lnroom2 ssrur seurb serur swurb swrur ncurb ncrur neurb nerur nwurb nwrur wsource2 ///
	keroligt othligt woodcuk kerocuk othcuk viptoil othtoil nontoil permwall semiwall stonflor
predict yhat1

regress lnrent lagos qindex
predict yhat2

regress lnrent sectr qindex
predict yhat3

regress lnrent sector qindex
predict yhat4

regress rent lagos qindex
predict yhat5

regress rent sectr qindex
predict yhat6

regress rent sector qindex
predict yhat7


**Rural and urban classification appears inconsistent over time.
*so we leave it out of the regression

tab zone, gen(zonedum)
regress lnrent lnroom lnroom2 zonedum2-zonedum6 wsource2 keroligt othligt woodcuk kerocuk ///
	othcuk viptoil othtoil nontoil permwall semiwall stonflor
predict yhat8

sum yhat1 yhat2 yhat3 yhat4 yhat5 yhat6 yhat7 yhat8


**Consultant remarks - see below 3 bullets.
*Although this model appears to be affected by wide ranging values for actual rent these predictors were the best ones identified.
*One regression Lagos vs non Lagos and the other by sector (as hedonic).  Despite the wide variance, the sector model was selected.
*albeit a weak model. 

**predict actual rent by applying model to data.
*no imputed rent for owner-occupied housing.
*getting close to what was derived therefore will use model derived in STATA.
*Consultant model formuale is (6410.083+(-6062.069*SECTR)+(1578.937*qindex).

recode rent (0/719=.) 

gen rntac=rent 
gen rntif1=0 
gen rntim1=exp(yhat1)
gen rnthh1=rent 
replace rnthh1=rntim1 if rnthh1==.
lab var rntac "Actual rent paid" 
lab var rntif1 "Imputed housing values" 
lab var rntim1 "Statistical imputed rent for all households - method 1"
lab var rnthh1 "Actual and imputed rent for missing households - method 1" 

gen rntim2=exp(yhat2)
gen rnthh2=rntac 
replace rnthh2= rntim2 if rnthh2==.
lab var rntim2 "Statistical imputed rent for all households - method 2"
lab var rnthh2 "Actual and imputed rent for missing households - method 2" 

gen rntim3=exp(yhat3)
gen rnthh3=rntac
replace rnthh3=rntim3 if rnthh3==.
lab var rntim3 "Statistical imputed rent for all households - method 3"
lab var rnthh3 "Actual and imputed rent for missing households - method 3" 

gen rntim4=exp(yhat4)
gen rnthh4=rntac
replace rnthh4=rntim4 if rnthh4==.
lab var rntim4 "Statistical imputed rent for all households - method 4"
lab var rnthh4 "Actual and imputed rent for missing households - method 4" 

gen rntim5=exp(yhat5)
gen rnthh5=rntac
replace rnthh5=rntim5 if rnthh5==.
lab var rntim5 "Statistical imputed rent for all households - method 5"
lab var rnthh5 "Actual and imputed rent for missing households - method 5" 

gen rntim6=yhat6
gen rnthh6=rntac
replace rnthh6=rntim6 if rnthh6==.
lab var rntim6 "Statistical imputed rent for all households - method 6"
lab var rnthh6 "Actual and imputed rent for missing households - method 6" 

gen rntim7=yhat7
gen rnthh7=rntac
replace rnthh7=rntim7 if rnthh7==.
lab var rntim7 "Statistical imputed rent for all households - method 7"
lab var rnthh7 "Actual and imputed rent for missing households - method 7" 

gen rntim8=exp(yhat8)
gen rnthh8=rntac
replace rnthh8=rntim8 if rnthh8==.
lab var rntim8 "Statistical imputed rent for all households - method 8 - No rural/urban"
lab var rnthh8 "Actual and imputed rent for missing households - method 8 - No rural/urban" 

gen rntim9=6410.083+(-6062.069*sectr)+(1578.937*qindex)
gen rnthh9=rntac
replace rnthh9= 6410.083+(-6062.069*sectr)+(1578.937*qindex) if rnthh8==.
lab var rntim9 "Statistical imputed rent for all households - method 9 - Consultant"
lab var rnthh9 "Actual and imputed rent for missing households - method 9 - Consultant" 

sum rnthh1 rnthh2 rnthh3 rnthh4 rnthh5 rnthh6 rnthh7 rnthh8 rnthh9

gen valid=1
sort hid
merge hid using "$nlss2004\date_interview.dta"
tab _m
keep if _m==3
drop _m

tostring month,gen(month1) format(%02.0f)
tostring year,gen(year1)   format(%02.0f)
gen hyphen="-"
egen year_mth=concat(year1 hyphen month1)

sort hid
sort state sector ric
merge m:1 state sector ric using "$nlss2004\Weights.dta"
tab _m
drop _m
keep if valid==1

recode rent (.=0)
tabstat rntac rent rntim8 rnthh8 [aw=wta_hh],by(year_mth)  s(sum)  f(%18.2f)
tabstat rntac rent rntim8 rnthh8 [aw=wta_hh],by(year_mth)  s(mean)  f(%18.2f)

sort hid 

keep  hid rntac rntim8 rnthh8 

order hid rntac rntim8 rnthh8

compress
saveold "$nlsstemp04\nfdrent.dta", replace


**********************************************************

***Non-food own Account Enterprise.
*not included in overall consumption aggregate.

use "$nlss2004\Sec 11D enterprise revenues.dta" , clear

duplicates report
duplicates drop

gen enpown1=s11dq5*26
gen enpown2=s11dq5*26
egen nfdtotpr=rsum(enpown1 enpown2)

collapse (sum) nfdtotpr,by(hid)
lab var nfdtotpr "Own Consumption from Enterprise"

sort hid

compress
saveold "$nlsstemp04\nfdtotpr.dta", replace


**********************************************************

***create Table 6 variables - merge files.

use "$nlsstemp04\freqnfoodexp04.dta", clear

sort hid
merge 1:1 hid using "$nlsstemp04\infreqnfoodexp04.dta"
tab _merge
drop _merge 
sort hid
merge 1:1 hid using "$nlsstemp04\nfdrent.dta" 
tab _merge
drop _merge 
sort hid
merge 1:1 hid using "$nlsstemp04\nfdtotpr.dta"
tab _merge
drop _merge

gen nfdwater=nfdwater1
egen nfdfmtn=rsum(nfdfmtn1 nfdfmtn2) 
egen nfdcloth=rsum(nfdcloth1 nfdcloth2) 
gen nfdfares=nfdfares1
gen nfdtrans=nfdtrans1
gen nfddome=nfddome1
gen nfdcomm=nfdcomm1 
gen nfdrecre=nfdrecre1
gen nfdrntac=rntac 
gen nfdrntim=rntim8 
gen nfdrnthh=rnthh8 
gen nfdfoth=nfdoth1

recode nfdtbac nfdwater nfdelec nfdgas nfdkero nfdchar nfdfwood nfdutil nfdcloth nfdfmtn nfddome nfdfares ///
	nfdtrans nfdcomm nfdrecre nfdinsur nfdptax nfdrntac nfdtotpr nfdfoth (.=0)

egen nfdftexp=rsum(nfdtbac nfdwater nfdelec nfdgas nfdfwood nfdchar nfdsold nfdkero nfdliqd nfdutil nfdcloth ///
	nfdfmtn nfddome nfdpetro nfddiesl nfdlubri nfdfares nfdtrans nfdcomm nfdrecre nfdinsur nfdrnthh nfdfoth) 
lab var nfdftexp  "Total value of frequent non-food expenditures excluding education and health"

lab var nfdtbac		"Tobacco and narcotics"
lab var nfdwater	"Water"
lab var nfdwater	"Electricity"
lab var nfdgas		"Gas"
lab var nfdfwood	"Firewood"
lab var nfdchar		"Charcoal"
lab var nfdsold		"Other solid fuels"
lab var nfdkero		"Kerosene"
lab var nfdliqd		"Other liquid fuels"
lab var nfdutil 	"Refuse, sewage collection, disposal and other services"
lab var nfdcloth	"Clothing and footwear"
lab var nfdfmtn		"Furnishings and routine household maintenance"
lab var nfddome		"Domestic household services"
lab var nfdpetro	"Petrol"
lab var nfddiesl	"Diesel"
lab var nfdlubri	"Lubricants"
lab var nfdfares	"Fares"
lab var nfdtrans	"Other transportation"
lab var nfdcomm		"Communication (postal and telephone)"
lab var nfdrecre	"Recreation and culture"
lab var nfdinsur	"Other insurance excluding education and health"
lab var nfdptax		"Property service charge, licenses and taxes"
lab var nfdrntac	"Actual rent paid"
lab var nfdrntim	"Imputed rent"
lab var nfdrnthh	"Actual and imputed rent for missing households"
lab var nfdfoth		"Expenditures on frequent non-food not mentioned elsewhere"
lab var nfdtotpr	"Own enterprise consumption of non-food items"

keep hid nfdtbac nfdwater nfdelec nfdgas nfdfwood nfdchar nfdsold nfdkero nfdliqd nfdutil nfdcloth ///
	nfdfmtn nfddome nfdpetro nfddiesl nfdlubri nfdfares nfdtrans nfdcomm  nfdrecre nfdinsur nfdptax ///
	nfdrntac nfdrntim nfdrnthh nfdfoth nfdtotpr nfdftexp 

order hid nfdtbac nfdwater nfdelec nfdgas nfdfwood nfdchar nfdsold nfdkero nfdliqd nfdutil nfdcloth ///
	nfdfmtn nfddome nfdpetro nfddiesl nfdlubri nfdfares nfdtrans nfdcomm  nfdrecre nfdinsur nfdptax ///
	nfdrntac nfdrntim nfdrnthh nfdfoth nfdtotpr nfdftexp 

d
sort hid

compress
saveold "$nlssfintabs04\Table 6 nfoodfreqexp04.dta", replace




*************************************************************************************************************************************
***Table 7: INFREQUENT NON-FOOD CONSUMPTION
*************************************************************************************************************************************

***Assets: stack file for easy to work.
**exclude all production items - home, land, boat, canoes and outboard from computation.
*house excluded for captured in rent model to avoid double counting.
*for canoes and company, these are not luxuries but are used for household sustenance. 
*These generate income for household and this is used for basic household expenditure (production goods).

use "$nlss2004\Sec 12B assets.dta" , clear

keep if s12bq1==1
keep if s12bq0<=317

gen item=1 
lab var item "Number of items in household" 
lab define item 1 "One item"  2 "Two items" 3 "Three items"
lab val item item

rename s12bq2a age
rename s12bq3a purchase
rename s12bq4a sale

keep  state sector ric hhno case_id hid s12bq0 item age purchase sale

saveold "$nlsstemp04\durable good first.dta", replace


**********************************************************

use "$nlss2004\Sec 12B assets.dta" , clear

keep if s12bq1==1
keep if s12bq0<=317

gen item=2 
lab var item "Number of items in household" 
lab define item 1 "One item"  2 "Two items" 3 "Three items"
lab val item item

rename s12bq2b age
rename s12bq3b purchase
rename s12bq4b sale

keep  state sector ric hhno case_id hid s12bq0 item age purchase sale

saveold "$nlsstemp04\durable good second.dta", replace


**********************************************************

use "$nlss2004\Sec 12B assets.dta" , clear

keep if s12bq1==1
keep if s12bq0<=317

gen item=3 
lab var item "Number of items in household" 
lab define item 1 "One item"  2 "Two items" 3 "Three items"
lab val item item

rename s12bq2c age
rename s12bq3c purchase
rename s12bq4c sale

keep  state sector ric hhno case_id hid s12bq0 item age purchase sale

saveold "$nlsstemp04\durable good third.dta", replace


**********************************************************

**merge durable files.

use "$nlsstemp04\durable good first.dta",clear

append using "$nlsstemp04\durable good second.dta"  
append using "$nlsstemp04\durable good third.dta"

sort  hid s12bq0
tab s12bq0

lab var age       "Age of asset"
lab var purchase  "Original purchase price"
lab var sale      "Current sales price"

count if age==.
count if purchase==.
count if sale==.


*drop households with missing age, purchase and sale price.

count if age==. & purchase==. & sale==.
drop  if age==. & purchase==. & sale==.

gen valid=0      if purchase==. & sale==.
replace valid=1  if valid==. & purchase==0 & sale==0
replace valid=2  if valid==.
tab valid
keep if valid==2
drop valid


*if either purchase/sale is zero and vice versa==. drop.

gen valid=0      if purchase==0 & sale==.
replace valid=1  if purchase==. & sale==0
replace valid=2  if valid==.
tab valid
keep if valid==2

compress
saveold "$nlsstemp04\durable stacked.dta", replace


**********************************************************

use "$nlsstemp04\durable stacked.dta",clear

*only items less than 5 years selected and only first item due to reliability of the index.

keep if age<=4 | age==90
keep if item==1 & item~=.


**impute missing age, purcahse price and sale price.
*impute if purchase==0 or sale==0.
*if purchase or sale prices missing impute by median by item type.
*item less than 1 year coded as 90.  Recode to 0.

replace age=0  if age==90
bys s12bq0: egen agemed=median(age)
bys s12bq0: egen purmed=median(purchase)
bys s12bq0: egen salemed=median(sale)

gen age1=age
replace age1=agemed 		if age==.						//Replace, for age of item, missings with median value

gen purchase1=purchase
replace purchase1=purmed 	if purchase==0 | purchase==.	//Replace, for purchase price of item, missings and zeros with median value

gen sale1=sale
replace sale1=salemed 		if sale==0 | sale==.  			//Replace, for sale price of item, missings and zeros with median value
format purchase1 sale1 %10.5g


replace  sale1=sale1*1000           if  s12bq0==312 &  sale1<=20
replace  purchase1=purchase1*1000   if  s12bq0==312 &  purchase1<=20
replace  sale1=sale1*10             if  s12bq0==301 &  case_id=="2521005001" 
replace  sale1=sale1*10             if  s12bq0==301 &  case_id=="0421508002" 
replace  sale1=sale1*1000           if  s12bq0==301 &  case_id=="1621006062" 
replace  sale1=sale1*1000           if  s12bq0==301 &  case_id=="0421508004" 
replace  sale1=sale1*1000           if  s12bq0==301 &  case_id=="0420807004" 
replace  sale1=sale1*1000           if  s12bq0==301 &  case_id=="0421305008"
replace  sale1=sale1*1000           if  s12bq0==301 &  case_id=="1821102027"
replace  sale1=sale1*1000           if  s12bq0==301 &  case_id=="1121404017"
replace  sale1=sale1*10             if  s12bq0==301 &  case_id=="2521701015"
replace  sale1=sale1*1000           if  s12bq0==301 &  case_id=="0421607004"
replace  sale1=sale1*100            if  s12bq0==301 &  case_id=="0421508006"
replace  sale1=sale1*1000           if  s12bq0==301 &  case_id=="0421508010"
replace  sale1=sale1*1000           if  s12bq0==301 &  case_id=="1121704015"
replace  sale1=sale1*100            if  s12bq0==302 &  case_id=="0721507082"
replace  sale1=sale1*1000           if  s12bq0==302 &  case_id=="1911206012"
replace  sale1=sale1*1000           if  s12bq0==302 &  case_id=="0621008004"
replace  sale1=sale1*100            if  s12bq0==304 &  case_id=="0420804004"
replace  sale1=sale1*100            if  s12bq0==304 &  case_id=="1120806007"
replace  sale1=sale1*100            if  s12bq0==304 &  case_id=="1911606008"
replace  sale1=sale1*10             if  s12bq0==304 &  case_id=="3510708068"
replace  sale1=sale1*1000           if  s12bq0==304 &  case_id=="1110702040"
replace  sale1=sale1*100            if  s12bq0==304 &  case_id=="1121204111"
replace  sale1=sale1*100            if  s12bq0==304 &  case_id=="0421607002"
replace  sale1=sale1*100            if  s12bq0==304 &  case_id=="2821205009"
replace  sale1=sale1*100            if  s12bq0==304 &  case_id=="0421305028"
replace  sale1=sale1*10             if  s12bq0==304 &  case_id=="0811001010"
replace  sale1=sale1*10             if  s12bq0==304 &  case_id=="0421508002"
replace  sale1=sale1*10             if  s12bq0==304 &  case_id=="0421508002"
replace  sale1=sale1*1000           if  s12bq0==306 &  case_id=="1911606008"
replace  sale1=sale1*100            if  s12bq0==307 &  case_id=="0520705049"
replace  purchase1=purchase1*100    if  s12bq0==307 &  case_id=="0421508004"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="0421508004"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="0421408001"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="1120806007"
replace  purchase1=purchase1*100    if  s12bq0==307 &  case_id=="0421508002"
replace  sale1=sale1*100            if  s12bq0==307 &  case_id=="0421508002"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="3521206049"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="1121104015"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="1911208007"
replace  sale1=sale1*100            if  s12bq0==307 &  case_id=="1010910008"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="0720906010"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="0420807012"
replace  sale1=sale1*100            if  s12bq0==307 &  case_id=="2411409048"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="0520705082"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="0421408009"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="1911606008"
replace  sale1=sale1*100            if  s12bq0==307 &  case_id=="0720701005"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="1121404040"
replace  sale1=sale1*1000           if  s12bq0==307 &  case_id=="0720906004"
replace  sale1=sale1*100            if  s12bq0==307 &  case_id=="2521605013"
replace  sale1=sale1*1000           if  s12bq0==310 &  sale1<=40
replace  sale1=sale1*1000           if  s12bq0==315 &  sale1<=35 & purchase1==2000
replace  sale1=sale1*1000           if  s12bq0==315 &  sale1<=35 & purchase1==5000
replace  sale1=sale1*1000           if  s12bq0==315 &  sale1<=35 & purchase1==5600
replace  purchase1=purchase1*100    if  s12bq0==315 &  case_id=="3221006076"
replace  sale1=sale1*100            if  s12bq0==315 &  case_id=="3221006076"
replace  purchase1=purchase1*100    if  s12bq0==315 &  case_id=="0421305028"
replace  sale1=sale1*100            if  s12bq0==315 &  case_id=="0421305028"
replace  purchase1=purchase1*1000   if  s12bq0==316 &  case_id=="1911606008"
replace  sale1=sale1*1000           if  s12bq0==316 &  case_id=="1911606008"
replace  purchase1=purchase1*1000   if  s12bq0==317 &  case_id=="0421305028"
replace  sale1=sale1*1000           if  s12bq0==317 &  case_id=="0421305028"
replace  sale1=sale1*1000           if  s12bq0==316 &  case_id=="0421607002"


sort hid s12bq0
merge m:1 hid using "$nlssfintabs04\date_interview04.dta"
tab _m
keep if _m==3
drop _m


gen year1=year
drop year 
gen year=year1-age1
tab year
replace year=99    if year==-1


**CPI data file.
*provided by NBS but cpib=cpi/4681.93 (reindexed the CPI to January 2004).
*file name=CPI.dta.
*Stating everything in standard prices (deflator actually used to inflate prices).

sort month year
merge m:1 month year using "E:\hhdbase\NGA\Nigeria_Household Survey_2003\stdfiles-1\data update\Stata\Socio\Other data\CPI.dta"
tab _m
keep if _m==3
drop _m


gen dpp=purchase1/cpib
lab var dpp "Deflated purchase price"

compress
saveold "$nlsstemp04\durable deflated.dta", replace


gen agey=age1
replace agey=.5 if age==0

gen agem=agey*12

gen dep=1-((sale1/dpp)^(1/(agem/12)))

tabstat dep, by(s12bq0) s(median) f(%7.4f)
bys s12bq0: egen deprate=median(dep)


**The real interest rate is 5%: estimates by NBS

gen intrate=5/100
gen nfdvalue=sale1*(intrate+deprate)/(1-deprate)

list hid  s12bq0 age1 purchase1 sale1 dpp deprate intrate  nfdvalue if nfdvalue<=10
 
collapse (sum) nfdvalue, by(hid)

keep hid nfdvalue

sort hid

compress
saveold "$nlsstemp04\nfdusevalue.dta", replace


**********************************************************

***durables last 12 months.
*these are items purchased during the survey period.  Survey period was 12 months.
*kitchen utensils fall under NFDFMTN.
*large items (NFDINVES) will not be included in the final household consumption as these are durables.
*classification of assets is based on COICOP classification.
*see USE VALUE computations above on durables.

use "$nlsstemp04\durable stacked.dta", clear

keep if age<=1

collapse (sum) purchase, by(hid)
ren purchase nfdinves
lab var nfdinves "Large investment expenditure (purchase of household durable assets)"

sort hid

compress
saveold "$nlsstemp04\large investments.dta", replace


**********************************************************

***Electric and non-eletric appliances.

use "$nlsstemp04\Sec10A1_filtered.dta", clear

gen nfdseppl=f10a1tot   if (s10aq0==415) 
gen nfdsnppl2=f10a1tot  if (s10aq0==417 | s10aq0==418) 


collapse (sum) nfdseppl nfdsnppl2, by(hid)
lab var nfdseppl "Electrical items"
lab var nfdsnppl2 "Non-electric items"

sort hid

compress
saveold "$nlsstemp04\appliances.dta", replace


**********************************************************

***ceremonies.

use "$nlss2004\Sec 13A3&A4 misc income.dta", clear

duplicates report
duplicates drop

gen nfdcerem = s13a3q5 

collapse (sum) nfdcerem, by(hid)
lab var nfdcerem  "Ceremonies"

sort hid

compress
saveold "$nlsstemp04\ceremonies.dta", replace


**********************************************************

***Out-transfer.

use "$nlss2004\Sec 13A2 transfersIN.dta", clear

duplicates report
duplicates drop

gen nfdremcs=s13a2q9
gen nfdremfd=s13a2q10
gen nfdremot=s13a2q11

collapse (sum) nfdremcs nfdremfd nfdremot,by(hid)
duplicates tag (hid),gen(dup)
tab dup

lab var nfdremcs "Cash transfer payment"
lab var nfdremfd "Food transfer payment"
lab var nfdremot "Other transfer payment"

sort hid

compress
saveold "$nlsstemp04\remittances.dta", replace


**********************************************************

***merge all above files.

use "$nlsstemp04\large investments.dta", clear

sort hid
merge 1:1 hid using "$nlsstemp04\nfdusevalue.dta" 
tab _merge
drop _merge
sort hid
merge 1:1 hid using "$nlsstemp04\Sec7_nfdrepar.dta"  
tab _merge
drop _merge
sort hid
merge 1:1 hid using "$nlsstemp04\nfdusevalue.dta" 
tab _merge
drop _merge
sort hid
merge 1:1 hid using "$nlsstemp04\snppl1.dta" 
tab _merge
drop _merge
sort hid
merge 1:1 hid using "$nlsstemp04\appliances.dta"  
tab _merge
drop _merge
sort hid
merge 1:1 hid using "$nlsstemp04\ceremonies.dta" 
tab _merge
drop _merge 
sort hid
merge 1:1 hid using "$nlsstemp04\remittances.dta" 
tab _merge
drop _merge 


gen nfdioth=.
gen nfdusevl=nfdvalue 
gen nfdrepar=nfdrepar1 
egen nfdsnppl=rsum(nfdsnppl1 nfdsnppl2)

recode nfd* (.=0) 

egen nfditexp = rsum(nfdseppl nfdsnppl nfdusevl nfdioth)  

lab var nfdseppl    "Electric small appliances"
lab var nfdsnppl    "Non-electric small appliances"
lab var nfdinves    "Large investment expenditure (purchase of household durable assets)"
lab var nfdusevl    "Use value of large investments"
lab var nfdcerem    "Non-regular expenditure"
lab var nfdremcs    "Cash transfer payments (remittances) received"
lab var nfdremfd    "Food transfer payments (remittances) received"
lab var nfdremot    "Other transfer payments (remittances) received"
lab var nfdrepar    "Maintenance and repairs of dwelling unit"
lab var nfdioth     "Expenditures on infrequent non-food not mentioned elsewhere"
lab var nfditexp    "Total infrequent non-food expenditure excluding rent, education and health"


keep  hid nfdseppl nfdsnppl nfdinves nfdusevl nfdcerem nfdremcs nfdremfd nfdremot nfdrepar nfdioth nfditexp
order hid nfdseppl nfdsnppl nfdinves nfdusevl nfdcerem nfdremcs nfdremfd nfdremot nfdrepar nfdioth nfditexp

d
sort hid

compress
saveold "$nlssfintabs04\Table 7 nfoodnonfreqexp04.dta", replace




***********************************************************************************************************************************
***DERIVE UNDEFLATED TOTAL CONSUMPTION EXPENDITURE
***********************************************************************************************************************************

*derive total expenditures without deflators.

use "$nlssfintabs04\Table 1 basicinf04.dta", clear

merge m:1 hid using "$nlssfintabs04\Table 2 foodpurchexp04.dta" 
tab _merge
drop _merge
sort hid
merge m:1 hid using "$nlssfintabs04\Table 3 ownconsexp04.dta"
tab _merge
drop _merge
sort hid
merge m:1 hid using "$nlssfintabs04\Table 4 eduexp04.dta"
tab _merge
drop _merge
sort hid
merge m:1 hid using "$nlssfintabs04\Table 5 healthexp04.dta"
tab _merge
drop _merge
sort hid
merge hid using "$nlssfintabs04\Table 6 nfoodfreqexp04.dta"
tab _merge
drop _merge
sort hid
merge m:1 hid using "$nlssfintabs04\Table 7 nfoodnonfreqexp04.dta"
tab _merge
drop _merge 
sort hid
merge m:1 hid using "$nlssfintabs04\date_interview04.dta", force
tab _merge
keep if _m==3
tab _m
drop _merge

tab sector

egen fdtexp = rsum(fdtotby fdtotpr)
label var fdtexp "Total purchased and auto-consumption food expenditure"


**********************************************************

*the above will help in selecting valid households for the further computations and finalization of the consumption aggregate.
*select valid households only (fdtexp>0).
*second condition must have Part A information of household demography.
*therefore, only households that appear in both Part A and B selected.

recode fd* ed* hl* nfd* (.=0)

count 
count  if fdtexp==0
keep   if fdtexp>0
count  if hhsize==0 | hhsize==.
keep if hhsize>0 | hhsize~=.
count

tab sector

egen nfdtexp = rowtotal(edtexp hltexp nfdftexp nfditexp)
label var nfdtexp "Total non-food consumption expenditure"

egen hhtexp = rowtotal(fdtexp nfdtexp)
label var hhtexp "Total household food and non-food consumption expenditure"

gen pcexp = hhtexp/hhsize
label var pcexp "Per capita total household food and non-food consumption expenditure"


su hhsize   [aw=wta_pop]
su ctry_adq [aw=wta_cadq]


**********************************************************

***quintile groupings by area of residence and population distribution and annual per capita expenditure (undeflated).

*takes into account area of residence (rural or urban).
*quintiles (5 equal groups) and deciles (10 equal groupd) weighted by population.

xtile qrur = pcexp if rururb==1 [pweight=wta_pop], nq(5) 
xtile qurb = pcexp if rururb==2 [pweight=wta_pop], nq(5) 
gen quintile=qrur
replace quintile=qurb if quintile==.
label var quintile "Undeflated quintile by RURURB and PCEXP"

*national quintile groupings by population distribution and annual per capita expenditure.
*does not take into account area of residence (rural or urban).

xtile nquintil=pcexp[aw=wta_pop],nq(5)
label var nquintil "National undeflated quintile by PCEXP"

**national decile groupings by population distribution and annual per capita expenditure.
*does not take into account area of residence (rural or urban).

xtile ndecil=pcexp[aw=wta_pop],nq(10)
label var ndecil "National undeflated decile by PCEXP"

lab var month  "Interview month"
lab var year   "Interview year"

tostring month,gen(month1) format(%02.0f)
tostring year,gen(year1)   format(%02.0f)
gen hyphen="-"
egen year_mth=concat(year1 hyphen month1)
lab var year_mth "Month and year merged into one variable for analysis ease"

sort hid
order year_mth

drop hh qrur qurb hyphen month1 year1

compress
saveold "$nlsstemp04\consaggwoutdeflators04.dta", replace


**********************************************************

**undeflated means and shares
*broad item grouping shares.

gen fdtotby_m=fdtotby/12
gen fdtotpr_m=fdtotpr/12
gen fdtexp_m=fdtexp/12
gen nfdtexp_m=nfdtexp/12
gen hhtexp_m=hhtexp/12
gen pcexp_m=pcexp/12
gen fdtotbyshr = 100*(fdtotby/fdtexp)
gen fdtotprshr = 100*(fdtotpr/fdtexp)
gen fdshr  = 100*(fdtexp/hhtexp)
gen nfdshr = 100*(nfdtexp/hhtexp)
gen edshr  = 100*(edtexp/hhtexp)
gen hlshr  = 100*(hltexp/hhtexp)
lab var fdtotby_m  "Undeflated monthly food purchase"
lab var fdtotpr_m  "Undeflated monthly food own production"
lab var fdtexp_m   "Undeflated monthly total food (purchase and own production)"
lab var fdtotbyshr "Undeflated food purchase share to total food consumption expenditure"
lab var fdtotprshr "Undeflated food autoconsumption share to total food consumption expenditure"
lab var fdshr      "Undeflated food (purchase and own production) share to total household consumption expenditure"
lab var nfdshr     "Undeflated non-food (incl education, health etc) share to total household consumption expenditure"
lab var edshr      "Undeflated education share to total household consumption expenditure"
lab var edshr      "Undeflated health share to total household consumption expenditure"

tabstat hhsize fdtotby_m fdtotpr_m fdtexp_m nfdtexp_m hhtexp_m pcexp_m  [aw=wta_hh], by( rururb )    s(mean) f(%10.1f)
tabstat hhsize fdtotby_m fdtotpr_m fdtexp_m nfdtexp_m hhtexp_m pcexp_m  [aw=wta_hh], by( zone )      s(mean) f(%10.1f)
tabstat hhsize fdtotby_m fdtotpr_m fdtexp_m nfdtexp_m hhtexp_m pcexp_m  [aw=wta_hh], by( state1 )    s(mean) f(%10.1f)
tabstat hhsize fdtotby_m fdtotpr_m fdtexp_m nfdtexp_m hhtexp_m pcexp_m  [aw=wta_hh], by( nquintil)   s(mean) f(%10.1f)
tabstat hhsize fdtotby_m fdtotpr_m fdtexp_m nfdtexp_m hhtexp_m pcexp_m  [aw=wta_hh], by( ndecil )    s(mean) f(%10.1f)
tabstat hhsize fdtotby_m fdtotpr_m fdtexp_m nfdtexp_m hhtexp_m pcexp_m  [aw=wta_hh], by( year_mth )  s(mean) f(%10.1f)

tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( rururb )   s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( zone )     s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( state1 )   s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( nquintil )  s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( ndecil ) s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( year_mth ) s(mean) f(%4.1f)  


**********************************************************

*derive state rural-urban population estimates

collapse (sum) wta_pop,by(zone state1 state sector)

egen totpop=total( wta_pop)
format  totpop %15.0g

bys sector:egen secpop=total(wta_pop)
format  secpop %15.0g

lab var wta_pop  "Household weighting coefficient"
lab var totpop   "Total weighted population in sample (total population)"
lab var secpop   "Total weighted population in sample by sector (rural-urban)"

sort sector state1

compress
saveold "$nlsstemp04\state-area pop.dta", replace




**************************************************************************************************************************
**FOOD BASKET
**************************************************************************************************************************
*We use the food items which account for higher shares of food to include in the basket

*select quintiles/deciles to merge with food item file.

use "$nlsstemp04\consaggwoutdeflators04.dta", clear

egen pophh=total(wta_pop)
lab var pophh "Total population"
format  pophh %15.2f

egen popcadq=total(wta_cadq)
lab var popcadq "Adult equivalent total population"
format  popcadq %15.2f

*select food quintiles/deciles to merge for food basket derivation.

keep   zone state state1 sector hhno hid ctry_adq hhsize wta_hh wta_cadq wta_pop pophh popcadq ///
	fdtexp nfdtexp hhtexp ndecil
order  zone state state1 sector hhno hid ctry_adq hhsize wta_hh wta_cadq wta_pop pophh popcadq ///
	fdtexp nfdtexp hhtexp ndecil

sort hid

saveold "$nlsstemp04\HH quintile-decil.dta", replace


**append and aggregate food (purchases and own consumption) file by item.

use "$nlsstemp04\Sec10B_Household Expenditure_basket.dta", clear
count

append using "$nlsstemp04\Sec9H_Household Expenditure_basket.dta"
count

drop if (s10bq0>=119 & s10bq0<=121)
count

gen item_cd=s9hq0
replace item_cd=s10bq0   if item_cd==.
label copy s9hq0 item_cd
lab val  item_cd item_cd
tab item_cd
count if    item_cd==.
drop if item_cd==.

sort hid item_cd

gen itemfood=ann_purch
replace itemfood=ann_con     if itemfood==.

collapse (sum) itemfood,by( hid item_cd) 
lab var  itemfood "Annual food item consumption expenditure"
saveold  "$nlsstemp04\food item expenditure partial.dta",replace


**every HH must have equal number of items.
*if missing assumed to be zero expenditure.

use "$nlsstemp04\food item expenditure partial.dta",clear

reshape wide itemfood, i(hid) j(item_cd)
reshape long itemfood, i(hid) j(item_cd)

replace itemfood=0  if itemfood==.

compress
saveold "$nlsstemp04\food item expenditure equal items.dta",replace


**drop foods that prices/calories cannot be derived.
*exclude items classified as "other", foods in restaurants/hotels.  Cannot derive calories for ambigiuos.

use "$nlsstemp04\food item expenditure equal items.dta",clear

drop if item_cd==21 | item_cd==22 | item_cd==25 | item_cd==26 | item_cd==30 | item_cd==31 | item_cd==33 | ///
	item_cd==34 | item_cd==39 | item_cd==40 | item_cd>=55 & item_cd<=57 | item_cd==61 | item_cd==64 | item_cd==69 | ///
	item_cd==71 | item_cd==81 | item_cd==82 | item_cd==90 | item_cd==92 | item_cd>=96 & item_cd<=104 | item_cd>=106 & ///
	item_cd<=108 | item_cd==111 | item_cd==112 | item_cd==114 | item_cd>=117 & item_cd<=121 | item_cd==124 |item_cd==125 | ///
	item_cd==130 | item_cd==135 | item_cd==.

sort hid item_cd

compress
saveold "$nlsstemp04\food item expenditure.dta", replace


**Combine file with item level expenditure and aggregate food expenditure to create food shares
*who are the reference group?

sort hid
merge m:1 hid using "$nlsstemp04\HH quintile-decil.dta"
tab  _m
keep if _m==3
drop _m


**Now we can obtain the shares of each item, for those in the 40th percentile

tab item_cd

tab ndecil
keep if ndecil<=4
tab ndecil

egen itemexp=sum(itemfood), by(item_cd)
egen allfood=sum(itemfood)
gen itemshare=(itemexp/allfood)*100
table item_cd [aw=wta_pop], c(mean itemshare) col

sort itemshare

table item_cd [aw=wta_pop], c(mean itemshare) col

collapse itemshare [aw=wta_pop],by(item_cd)
gsort -itemshare


**Take the Table above and use all items that account for 99% of food share
**Those items will be included in the basket

gen fdrank=_n
gen cum_wtratio=itemshare
replace cum_wtratio= cum_wtratio[_n-1] + itemshare[_n] if _n>1

label list item_cd

order fdrank item_cd itemshare cum_wtratio

sort item_cd

egen totshare=total(itemshare)
lab var totshare "Total item shares"

order fdrank item_cd

compress
saveold "$nlsstemp04\food basket selected-national 40th.dta", replace





**************************************************************************************************************************************
***Table 8: PRICE DEFLATORS
**************************************************************************************************************************************

***food
*some food items have no prices.
*as survey old and getting all prices may be difficult, will use whatever prices present.
*will assume that this trully reflects regionally price variation.

clear
insheet using "$nlssfintabs04\Prices_Food2003-04.txt" 

drop  v17 v18 v19

compress
saveold "$nlsstemp04\Rural-urban food prices.dta",replace


**add population distribution by state and rural-urban.

use "$nlsstemp04\Rural-urban food prices.dta",clear

lab define sector 1 "Urban"  2 "Rural", add
lab val sector sector

ren  state  state1
sort sector state1
merge m:1 sector state1 using "$nlsstemp04\state-area pop.dta"
tab  _m
keep if _m==3
drop _m


**drop category "other"

drop if  foodcode==21 | foodcode==57 | foodcode==82 | foodcode==90 | ///
	foodcode==111 | foodcode==112 |  foodcode==117
tab foodcode


**reference will be national price.
*chose base period (Dec 2003).
*assumes that population share affects the national price.
*otherwise one can chose any month as the reference base price.

gen wtprice=(wta_pop/secpop)*dec03

bys sector cpicode: egen natprice=total(wtprice)      //derives national price by item.
	
sort cpicode sector  state1
	
gen def_Sep03=sep03/natprice
gen def_Oct03=oct03/natprice
gen def_Nov03=nov03/natprice
gen def_Dec03=dec03/natprice
gen def_Jan04=jan04/natprice
gen def_Feb04=feb04/natprice
gen def_Mar04=may04/natprice
gen def_Apr04=apr04/natprice
gen def_May04=may04/natprice
gen def_Jun04=jun04/natprice
gen def_Jul04=jul04/natprice
gen def_Aug04=aug04/natprice


ren foodcode item_cd
sort  item_cd
merge m:1 item_cd using "$nlsstemp04\food basket selected-national 40th.dta"
tab _m
tab  item_cd  if  itemshare==.              //can be deleted as refers to "other" which prices had to get.
keep if _m==3
drop _m

gen def1_Sep03=def_Sep03*(itemshare/100)
gen def1_Oct03=def_Oct03*(itemshare/100)
gen def1_Nov03=def_Nov03*(itemshare/100)
gen def1_Dec03=def_Dec03*(itemshare/100)
gen def1_Jan04=def_Jan04*(itemshare/100)
gen def1_Feb04=def_Feb04*(itemshare/100)
gen def1_Mar04=def_May04*(itemshare/100)
gen def1_Apr04=def_Apr04*(itemshare/100)
gen def1_May04=def_May04*(itemshare/100)
gen def1_Jun04=def_Jun04*(itemshare/100)
gen def1_Jul04=def_Jul04*(itemshare/100)
gen def1_Aug04=def_Aug04*(itemshare/100)


sort sector state cpicode
bys state sector: egen sep03df=total(def1_Sep03)
bys state sector: egen oct03df=total(def1_Oct03)
bys state sector: egen nov03df=total(def1_Nov03)
bys state sector: egen dec03df=total(def1_Dec03)
bys state sector: egen jan04df=total(def1_Jan04)
bys state sector: egen feb04df=total(def1_Feb04)
bys state sector: egen mar04df=total(def1_Mar04)
bys state sector: egen apr04df=total(def1_Apr04)
bys state sector: egen may04df=total(def1_May04)
bys state sector: egen jun04df=total(def1_Jun04)
bys state sector: egen jul04df=total(def1_Jul04)
bys state sector: egen aug04df=total(def1_Aug04)


gen fdSep03=sep03df/(totshare/100)
gen fdOct03=oct03df/(totshare/100)
gen fdNov03=nov03df/(totshare/100)
gen fdDec03=dec03df/(totshare/100)
gen fdJan04=jan04df/(totshare/100)
gen fdFeb04=feb04df/(totshare/100)
gen fdMar04=mar04df/(totshare/100)
gen fdApr04=apr04df/(totshare/100)
gen fdMay04=may04df/(totshare/100)
gen fdJun04=jun04df/(totshare/100)
gen fdJul04=jul04df/(totshare/100)
gen fdAug04=aug04df/(totshare/100)

preserve
collapse natprice,by(item_cd)
sort item_cd

compress
saveold "$nlsstemp04\nlss2003-04 average state prices.dta", replace


restore
collapse fdSep03 fdOct03 fdNov03 fdDec03 fdJan04 fdFeb04 fdMar04 fdApr04 ///
	fdMay04 fdJun04 fdJul04 fdAug04,by(sector state state1)

sort sector state1

order state1 state sector

compress
saveold "$nlssfintabs04\Table 8 pricedeflators04.dta", replace




**************************************************************************************************************************
**DEFLATED EXPENDITURES
**************************************************************************************************************************
*aggregate computed very close to 2004 for comparison.
*ceremonies and remittances and large investments not part of consumption epxenidture.

use "$nlsstemp04\consaggwoutdeflators04.dta", clear

sort sector state1

merge m:1 sector state1 using "$nlssfintabs04\Table 8 pricedeflators04.dta"
tab  _m
drop _m

tab month
tab year

tab month year

gen fdpindex=.
replace fdpindex=fdSep03  if (month==9  & year==3)	
replace fdpindex=fdOct03  if (month==10 & year==3)	
replace fdpindex=fdNov03  if (month==11 & year==3)	
replace fdpindex=fdDec03  if (month==12 & year==3)	
replace fdpindex=fdJan04  if (month==1  & year==4)	
replace fdpindex=fdFeb04  if (month==2  & year==4)	
replace fdpindex=fdMar04  if (month==3  & year==4)	
replace fdpindex=fdApr04  if (month==4  & year==4)	
replace fdpindex=fdMay04  if (month==5  & year==4)	
replace fdpindex=fdJun04  if (month==6  & year==4)	
replace fdpindex=fdJul04  if (month==7  & year==4)	
replace fdpindex=fdAug04  if (month==8  & year==4)	

gen nfdpindex=fdpindex
lab var fdpindex   "Food price index"
lab var nfdpindex  "Non-food price index"

compress
saveold "$nlsstemp04\consaggwdeflators04.dta", replace


**********************************************************

**deflate by space and time.

gen fdtexpdr = fdtexp/fdpindex
label var fdtexpdr "Total purchased and auto-consumption food expenditure in regionally deflated prices"

gen nfdtexpdr = nfdtexp/nfdpindex
label var nfdtexpdr "Total non-food consumption expenditure in regionally deflated prices"

egen hhtexpdr = rowtotal(fdtexpdr nfdtexpdr)
label var hhtexpdr "Total household food and non-food consumption expenditure in regionally deflated prices"

gen pcexpdr = hhtexpdr/hhsize
label var pcexpdr "Per capita total household food and non-food consumption expenditure in regionally deflated prices"

**deflated quintile groupings by area of residence and population distribution and deflated per capita expenditure.
*takes into account area of residence (rural or urban).

xtile qrurd = pcexpdr if rururb==1 [pweight=wta_pop], nq(5) 
xtile qurbd = pcexpdr if rururb==2 [pweight=wta_pop], nq(5) 
gen dfquin=qrurd
replace dfquin=qurbd if dfquin==.
label var dfquin "Regional deflated quintile by RURURB and PCEXPDR"

**deflated quintile groupings by annual per capita expenditure (adjusted for price)
*does not take into account area of residence (rural or urban).

xtile ndfquin=pcexpdr[aw=wta_pop],nq(5)
label var ndfquin "National regional deflated quintile by PCEXPDR"

**deflated decile groupings by annual per capita expenditure (adjusted for price)
*does not take into account area of residence (rural or urban).

xtile ndfdecil =pcexpdr[aw=wta_pop],nq(10)
label var ndfdecil "National regional deflated decile by PCEXPDR"

d
compress
saveold "$nlssfintabs04\finnga_04_e.dta", replace


gen fdtotbydr = (fdtotby/12)/fdpindex
gen fdtotprdr = (fdtotpr/12)/fdpindex
gen fdtexpdr_m=fdtexpdr/12
gen nfdtexpdr_m=(nfdtexp/12)/nfdpindex
gen hhtexpdr_m=hhtexpdr/12
gen pcexpdr_m=pcexpdr/12
gen fdtotbyshr = 100*(fdtotbydr/(fdtexpdr/12))
gen fdtotprshr = 100*(fdtotprdr/(fdtexpdr/12))
gen fdshr  = 100*(fdtexpdr/hhtexpdr)
gen nfdshr = 100*(nfdtexpdr/hhtexpdr)
gen edshr  = 100*((edtexp/nfdpindex)/hhtexpdr)
gen hlshr  = 100*((hltexp/nfdpindex)/hhtexpdr)
lab var fdtotbydr    "Deflated monthly food purchase"
lab var fdtotprdr    "Deflated monthly food autoconsumption"
lab var fdtexpdr_m   "Deflated monthly total food (purchase and own production)"
lab var nfdtexpdr_m  "Deflated monthly total non-food"
lab var pcexpdr_m    "Deflated monthly per capita autoconsumption"
lab var fdtotbyshr   "Food purchase share to total food consumption expenditure"
lab var fdtotprshr   "Food autoconsumption share to total food consumption expenditure"
lab var fdshr        "Deflated food (purchase and own production) share to total deflated household consumption expenditure"
lab var nfdshr       "Deflated non-food (incl education, health etc) share to total deflated household consumption expenditure"
lab var edshr        "Deflated education share to total deflated household consumption expenditure"
lab var hlshr        "Deflated health share to total deflated household consumption expenditure"

**weighted by wta_hh.

tabstat  hhsize fdtotbydr fdtotprdr fdtexpdr_m nfdtexpdr_m hhtexpdr_m pcexpdr_m [aw=wta_hh], by( rururb )   s(mean) f(%7.1f)   
tabstat  hhsize fdtotbydr fdtotprdr fdtexpdr_m nfdtexpdr_m hhtexpdr_m pcexpdr_m [aw=wta_hh], by( zone )     s(mean) f(%7.1f)  
tabstat  hhsize fdtotbydr fdtotprdr fdtexpdr_m nfdtexpdr_m hhtexpdr_m pcexpdr_m [aw=wta_hh], by( state1 )   s(mean) f(%7.1f) 
tabstat  hhsize fdtotbydr fdtotprdr fdtexpdr_m nfdtexpdr_m hhtexpdr_m pcexpdr_m [aw=wta_hh], by( ndfquin )  s(mean) f(%7.1f)  
tabstat  hhsize fdtotbydr fdtotprdr fdtexpdr_m nfdtexpdr_m hhtexpdr_m pcexpdr_m [aw=wta_hh], by( ndfdecil ) s(mean) f(%7.1f)  
tabstat  hhsize fdtotbydr fdtotprdr fdtexpdr_m nfdtexpdr_m hhtexpdr_m pcexpdr_m [aw=wta_hh], by( year_mth ) s(mean) f(%7.1f) 

tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( rururb )   s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( zone )     s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( state1 )   s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( ndfquin )  s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( ndfdecil ) s(mean) f(%4.1f)  
tabstat  fdtotbyshr fdtotprshr fdshr edshr hlshr nfdshr [aw=wta_hh], by( year_mth ) s(mean) f(%4.1f)  




**************************************************************************************************************************
**POVERTY LINES
**************************************************************************************************************************

**select key basic charcteristics.

use "$nlssfintabs04\finnga_04_e.dta", clear

gen pcfd=(fdtexp/12)/hhsize
gen totfood_mth=(fdtexp/12)
lab var pcfd "Per capita monthly food"
lab var totfood_mth "Monthly food expenditure"

keep case_id state state1 ric zone hhno rururb hid month year hhsize ctry_adq wta_hh wta_pop wta_cadq ///
	fdtexp nfdtexp hhtexp pcexp month year year_mth pcfd totfood_mth quintile nquintil ndecil 
	
sort hid

compress
saveold "$nlsstemp04\R_basic infor.dta", replace


**********************************************************

**combine files.

use "$nlssfintabs04\HNLSS2009-10 prices-calories.dta",clear

ren  mktprice mktprice2009
ren  itemshare  itemshare2009
ren  cum_wtratio  cum_wtratio2009
ren  fdrank  fdrank2009

*recode to match 2004-04 item codes.
*to make it ease to get calories which already present in nlss.

recode  q1p12a (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (20=8) (9=9) (10=10) (11=11) (23=12) (24=13) (25=14) (22=15)  ///
	(30=17) (34=18) (35=19) (31=20) (32=23) (33=24) (51=27) (52=28) (53=29) (59=32) (57=35) (60=36) (61=37) (62=38)  ///
	(71=41) (76=42) (78=43) (70=44) (72=45) (73=46) (77=47) (86=48) (80=49) (84=50) (87=51) (88=52) (82=53) (89=54)  ///
	(119=58) (123=59) (124=60) (127=62) (128=63) (151=65) (152=66) (153=67) (154=68) (143=70) (141=72) (142=73)  ///
	(144=74) (145=75) (148=76) (131=77) (132=78) (134=79) (110=83) (104=84) (104=85) (105=86) (102=87) (106=88)  ///
	(101=89) (112=91) (161=93) (162=94) (165=95) (181=104) (182=105) (202=109) (200=110) (908=113) (911=115)  ///
	(912=116) (21=123) (36=126) (58=127) (50=128) (63=129) (81=131) (85=132) (107=133) (108=134) (136=136) ///
	(nonmissing=999 "something else"),gen(item_cd)
lab var  item_cd "NLSS item codes"
replace item_cd=.  if item_cd>136
tab item_cd,missing
drop if item_cd==.

count
sort item_cd
format item_cd %8.0g
merge 1:1 item_cd using "$nlsstemp04\nlss2003-04 average state prices.dta"
tab _m
drop _m


gen valid=1
sort item_cd
merge 1:1 item_cd using "$nlsstemp04\food basket selected-national 40th.dta"
tab _m
keep if _m==3
drop  _merge 

keep if valid==1
drop valid  totshare

order fdrank2009 q1p12a itemshare2009 cum_wtratio2009 calper100g mktprice2009 ///
	fdrank item_cd itemshare cum_wtratio natprice
ren natprice mktprice

sort item_cd
	
compress
saveold "$nlssfintabs04\nlss2003-04 prices-calories.dta", replace


**********************************************************

use "$nlsstemp04\food item expenditure.dta", clear

sort item_cd

merge m:1 item_cd using "$nlssfintabs04\nlss2003-04 prices-calories.dta"
tab _m
drop _m

sort hid 
merge m:1 hid using "$nlsstemp04\R_basic infor.dta"
tab _m
drop _m

gen inbasket=1 if calper100g!=.

compress
saveold "$nlsstemp04\all basket.dta", replace


***********************************************************************************

****food poverty line.
*cost of a calorie using expenditures and calorie intake of reference population
*quantity (variable: Qi) is obtained by dividing expenditure by market prices, 
*Expenditure is also annual and is household weighted.
*Need to obtain per capita values. Note that quantity variable from survey is unreliable, 
*so have to obtain quantity (Qi) using expenditure and market prices.
*the items that are found in the food basket are identified as inbasket

use "$nlsstemp04\all basket.dta", clear

keep if inbasket==1 & ndecil<=4

*expenditure here is weighted by household (it is a household level variable), but quantity is obtained by population weights

collapse (sum) sumexp=itemfood (mean) mktprice calper100g wta_hh hhsize, by(hid item_cd)
gen const=1
collapse (sum) Yi=sumexp Mi=hhsize nhhds=const (mean) mktprice calper100g [pw=wta_hh], by(item_cd)
format Yi  %18.2f
format Mi  %14.2f

*derive annual per capita quantities from expenditure and market price.

gen Qi=Yi/(Mi*mktprice)

*price quantity.

gen PiQi=Qi*mktprice

*derive calories by item consumed.

gen QiCi=Qi*calper100g

*generate per capita expenditure from expenditure data (not derived quantities and prices - should be the same)

egen SPiQi=sum(PiQi)
egen SQiCi=sum(QiCi)
gen foodpline=(SPiQi/SQiCi)*2250*30.4*0.1
gen foodpline1=(SPiQi/SQiCi)*2500*30.4*0.1
gen foodpline2=(SPiQi/SQiCi)*2750*30.4*0.1
gen foodpline3=(SPiQi/SQiCi)*3000*30.4*0.1

gen fddelete=1

collapse (first) pl_fd2250=foodpline pl_fd2500=foodpline1 pl_fd2750=foodpline2 pl_fd3000=foodpline3, by(fddelete)
label var pl_fd2250  "Food poverty line 2004 for 2250 calories per day"
label var pl_fd2500  "Food poverty line 2004 for 2500 calories per day"
label var pl_fd2750  "Food poverty line 2004 for 2750 calories per day"
label var pl_fd3000  "Food poverty line 2004 for 3000 calories per day"

compress
saveold "$nlsstemp04\fdinsdpline.dta", replace


**********************************************************

****absolute/overall line for 2250 calories.
*Now bring the food poverty data and full data to obtain the absolute poverty line *

***METHOD 1: regression method

use "$nlssfintabs04\finnga_04_e.dta", clear

gen fddelete=1
sort hid fddelete

merge m:1 fddelete using "$nlsstemp04\fdinsdpline.dta"
tab _m
drop _m fddelete

sort hid

sum pl_fd2250 [aw=wta_pop]

gen pcexp1=pcexp/12
gen pcfdcons=(fdtexp/12)/hhsize
gen pcnfdcons=(nfdtexp/12)/hhsize
lab var pcexp1 "Monthly per capita consumption expnediture"
lab var pcfdcons "Per capita food"
lab var pcnfdcons "Per capita non-food"

gen expratio=pcexp1/pl_fd2250

*Logs of the regression variables.
*pcexp+1 to avoid log of zero.

gen logcons=log(pcexp1+1)
gen logfdpovline=log(pl_fd3000+1)
gen lnxpratio=log(expratio)
gen lnxpratsq=lnxpratio*lnxpratio
gen lhhsize=log(hhsize)

gen fdshare=fdtexp/hhtexp
gen nfdshare=nfdtexp/hhtexp
lab var fdshare  "Food share to total consumption expenditure"
lab var nfdshare "Non-food share to total consumption expenditure"

regress fdshare lnxpratio lnxpratsq
gen alpha=_b[_cons]

*obtain full poverty lines.

gen pl_absREG2004=pl_fd2250 + (1-alpha)*pl_fd2250
label var pl_absREG2004 "Absolute poverty line using food poverty line"


***METHOD 2: food share (Engel's).
*Estimating Engel's coefficient directly.

bysort zone: gen upbands1=(1.10)*pl_fd2250 
bysort zone: gen lbands1=(0.9)*pl_fd2250 

*obtain food share for povline .

egen engcoeff=mean(nfdshare) if pcexp1>=lbands & pcexp1<=upbands
egen mengcof=mean(engcoeff)
gen pl_absENG2004=(2-mengcof)*pl_fd2250
label var  pl_absENG2004 "Absolute poverty line using food poverty line and Engel non-food share"


***METHOD 3: non-parametric (Ravallion).
*Idea: obtain average total per capita consumption for households whose 
*food consumption is 1 percent (plus/minus) food poverty line
*repeat for hhds around plus/minus 2 percent and so on until plus/minus 10
*then take average of all averages. That becomes absolute poverty line

**This is the UPPER poverty line (Non-parametric).

foreach y of numlist 1 2 3 4 5 6 7 8 9 10 {
egen m`y'=mean(pcexp1) if pcfdcons>=(1-(`y'/100))*pl_fd2250 & pcfdcons<=(1+(`y'/100))*pl_fd2250
}
egen mnpline1=rowmean(m1-m10)
egen mnpline11=mean(mnpline1)
drop mnpline1
rename mnpline11 mnpline
drop m1-m10

gen plu_absRAV2004=pl_fd2250 + mnpline
label var  plu_absRAV2004 "Absolute poverty line using food poverty line and Ravallion method (upper bound)"


**This is the LOWER poverty line (Non-parametric).

foreach z of numlist 1 2 3 4 5 6 7 8 9 10 {
egen m`z'=mean(pcnfdcons) if pcexp1>=(1-(`z'/100))*pl_fd2250 & pcexp1<=(1+(`z'/100))*pl_fd2250
}
egen mnpline2=rowmean(m1-m10)
egen mnpline22=mean(mnpline2)
drop mnpline2
rename mnpline22 mnpline2
*drop m1-m10

gen pll_absRAV2004=pl_fd2250 + mnpline2
label var  pll_absRAV2004 "Absolute poverty line using food poverty line and Ravallion method (lower bound)"

keep hid pl_fd2250 pl_fd2500 pl_fd3000 pl_absREG2004 pl_absENG2004 plu_absRAV2004 pll_absRAV2004
sum  pl_fd2250 pl_fd2500 pl_fd3000 pl_absREG2004 pl_absENG2004 plu_absRAV2004 pll_absRAV2004

d
sort hid

gen method=2250

compress
saveold "$nlsstemp04\poverty lines2250.dta", replace


**********************************************************

****absolute/overall line for 3000 calories.
*Now bring the food poverty data and full data to obtain the absolute poverty line *

***METHOD 1: regression method

use "$nlssfintabs04\finnga_04_e.dta", clear

gen fddelete=1
sort hid fddelete

merge m:1 fddelete using "$nlsstemp04\fdinsdpline.dta"
tab _m
drop _m fddelete

sort hid

sum pl_fd2250 [aw=wta_pop]

gen pcexp1=pcexp/12
gen pcfdcons=(fdtexp/12)/hhsize
gen pcnfdcons=(nfdtexp/12)/hhsize
lab var pcexp1 "Monthly per capita consumption expnediture"
lab var pcfdcons "Per capita food"
lab var pcnfdcons "Per capita non-food"

gen expratio=pcexp1/pl_fd3000

*Logs of the regression variables.
*pcexp+1 to avoid log of zero.
*log zero not defined.
*however this should never arise for all HHs must have per capita expenditure.

gen logcons=log(pcexp1+1)
gen logfdpovline=log(pl_fd3000+1)
gen lnxpratio=log(expratio)
gen lnxpratsq=lnxpratio*lnxpratio
gen lhhsize=log(hhsize)

gen fdshare=fdtexp/hhtexp
gen nfdshare=nfdtexp/hhtexp
lab var fdshare  "Food share to total consumption expenditure"
lab var nfdshare "Non-food share to total consumption expenditure"

regress fdshare lnxpratio lnxpratsq
gen alpha=_b[_cons]

*obtain full poverty lines.

gen pl_absREG2004=pl_fd3000 + (1-alpha)*pl_fd3000
label var pl_absREG2004 "Absolute poverty line using food poverty line"


***METHOD 2: food share (Engel's).
*Estimating Engel's coefficient directly.

bysort zone: gen upbands1=(1.10)*pl_fd3000 
bysort zone: gen lbands1=(0.9)*pl_fd3000 

*obtain food share for povline .

egen engcoeff=mean(nfdshare) if pcexp1>=lbands & pcexp1<=upbands
egen mengcof=mean(engcoeff)
gen pl_absENG2004=(2-mengcof)*pl_fd3000
label var  pl_absENG2004 "Absolute poverty line using food poverty line and Engel non-food share"


***METHOD 3: non-parametric (Ravallion).
*Idea: obtain average total per capita consumption for households whose 
*food consumption is 1 percent (plus/minus) food poverty line
*repeat for hhds around plus/minus 2 percent and so on until plus/minus 10
*then take average of all averages. That becomes absolute poverty line

**This is the UPPER poverty line (Non-parametric).

foreach y of numlist 1 2 3 4 5 6 7 8 9 10 {
egen m`y'=mean(pcexp1) if pcfdcons>=(1-(`y'/100))*pl_fd3000 & pcfdcons<=(1+(`y'/100))*pl_fd3000
}
egen mnpline1=rowmean(m1-m10)
egen mnpline11=mean(mnpline1)
drop mnpline1
rename mnpline11 mnpline
drop m1-m10

gen plu_absRAV2004=pl_fd3000 + mnpline
label var  plu_absRAV2004 "Absolute poverty line using food poverty line and Ravallion method (upper bound)"


**This is the LOWER poverty line (Non-parametric).

foreach z of numlist 1 2 3 4 5 6 7 8 9 10 {
egen m`z'=mean(pcnfdcons) if pcexp1>=(1-(`z'/100))*pl_fd3000 & pcexp1<=(1+(`z'/100))*pl_fd3000
}
egen mnpline2=rowmean(m1-m10)
egen mnpline22=mean(mnpline2)
drop mnpline2
rename mnpline22 mnpline2
*drop m1-m10

gen pll_absRAV2004=pl_fd3000 + mnpline2
label var  pll_absRAV2004 "Absolute poverty line using food poverty line and Ravallion method (lower bound)"

keep hid pl_fd2250 pl_fd2500 pl_fd3000 pl_absREG2004 pl_absENG2004 plu_absRAV2004 pll_absRAV2004
sum  pl_fd2250 pl_fd2500 pl_fd3000 pl_absREG2004 pl_absENG2004 plu_absRAV2004 pll_absRAV2004

d
sort hid

compress
saveold "$nlsstemp04\poverty lines3000.dta", replace




**************************************************************************************************************************
**POVERTY LINES
**************************************************************************************************************************
*used 3000 calories food poverty line as in 2004-04 calories.

**merge in poverty lines.

use "$nlssfintabs04\finnga_04_e.dta", clear

drop state
ren state1 state

sort hid
merge 1:1 hid using "$nlsstemp04\poverty lines3000.dta"
tab _m

gen pl_fd2004=pl_fd3000*12
gen pl_abs2004=pll_absRAV2004*12
gen pl_ext2004=pl_fd2004
label var  pl_fd2004  "Food poverty line 2004 (annual)"
label var  pl_abs2004 "Absolute poverty line 2004 (annual)"
label var  pl_ext2004 "Extreme poverty line 2004 (annual)"

keep state ric sector zone country case_id hid surveyr month year year_mth rururb rural hhsize ctry_adq wta_hh wta_pop wta_cadq ///
	hhsex hhagey hhmarstat hghlevel spouses sp_live headmale nevermarried marriedmono marriedpoly divorcewidow ///
	kids0004 kids0509 kids1017 adfems admales ///
	fdby_tr fdriceby fdmaizby fdcereby fdbrdby fdtubby fdpoulby fdmeatby fdfishby fddairby ///
	fdfatsby fdfrutby fdvegby fdbeanby fdswtby fdbevby fdalcby fdrestby fdothby fdtotby ///
	fdricepr fdmaizpr fdcerepr fdbrdpr fdtubpr fdpoulpr fdmeatpr fdfishpr fddairpr fdfatspr fdfrutpr ///
	fdvegpr fdbeanpr fdswtpr fdbevpr fdalcpr fdrestpr fdothpr fdtotpr ///
	edtution edbooks edunifms edextra edrmbrd edtrnsp edmtnce edoth edagg edinsur edquran edtexp ///
	hlcons hlmedc hlhospt hltrsp hlinsur hleqpt hloth hltexp ///
	nfdtbac nfdwater nfdelec nfdgas nfdfwood nfdchar nfdsold nfdkero nfdliqd nfdutil nfdcloth nfdfmtn nfddome ///
	nfdpetro nfddiesl nfdlubri nfdfares ///
	nfdtrans nfdcomm nfdrecre nfdinsur nfdptax nfdrntac nfdrntim nfdrnthh nfdfoth nfdtotpr nfdftexp ///
	nfdseppl nfdsnppl nfdinves nfdusevl nfdcerem nfdremcs nfdremfd nfdremot nfdrepar nfdioth nfditexp ///
	fdpindex nfdpindex fdtexp fdtexpdr nfdtexp nfdtexpdr ///
	hhtexp hhtexpdr pcexp pcexpdr pl_fd2004 pl_abs2004 pl_ext2004 ///
	quintile nquintil ndecil dfquin ndfquin ndfdecil 
	
order state ric sector zone country case_id hid surveyr month year year_mth rururb rural hhsize ctry_adq wta_hh wta_pop wta_cadq ///
	hhsex hhagey hhmarstat hghlevel spouses sp_live headmale nevermarried marriedmono marriedpoly divorcewidow ///
	kids0004 kids0509 kids1017 adfems admales ///
	fdby_tr fdriceby fdmaizby fdcereby fdbrdby fdtubby fdpoulby fdmeatby fdfishby fddairby ///
	fdfatsby fdfrutby fdvegby fdbeanby fdswtby fdbevby fdalcby fdrestby fdothby fdtotby ///
	fdricepr fdmaizpr fdcerepr fdbrdpr fdtubpr fdpoulpr fdmeatpr fdfishpr fddairpr fdfatspr fdfrutpr ///
	fdvegpr fdbeanpr fdswtpr fdbevpr fdalcpr fdrestpr fdothpr fdtotpr ///
	edtution edbooks edunifms edextra edrmbrd edtrnsp edmtnce edoth edagg edinsur edquran edtexp ///
	hlcons hlmedc hlhospt hltrsp hlinsur hleqpt hloth hltexp ///
	nfdtbac nfdwater nfdelec nfdgas nfdfwood nfdchar nfdsold nfdkero nfdliqd nfdutil nfdcloth nfdfmtn nfddome ///
	nfdpetro nfddiesl nfdlubri nfdfares ///
	nfdtrans nfdcomm nfdrecre nfdinsur nfdptax nfdrntac nfdrntim nfdrnthh nfdfoth nfdtotpr nfdftexp ///
	nfdseppl nfdsnppl nfdinves nfdusevl nfdcerem nfdremcs nfdremfd nfdremot nfdrepar nfdioth nfditexp ///
	fdpindex nfdpindex fdtexp fdtexpdr nfdtexp nfdtexpdr ///
	hhtexp hhtexpdr pcexp pcexpdr pl_fd2004 pl_abs2004 pl_ext2004 ///
	quintile nquintil ndecil dfquin ndfquin ndfdecil

sort hid
	
compress
saveold "$nlssfintabs04\NGA_04_E.dta", replace


**********************************************************

use "$nlssfintabs04\NGA_04_E.dta", clear

keep  hid fdtexp fdtexpdr nfdtexp nfdtexpdr hhtexp hhtexpdr pcexp pcexpdr ///
	quintile nquintil ndecil dfquin ndfquin ndfdecil pl_fd2004 pl_abs2004 pl_ext2004

order hid fdtexp fdtexpdr nfdtexp nfdtexpdr hhtexp hhtexpdr pcexp pcexpdr ///
	quintile nquintil ndecil dfquin ndfquin ndfdecil pl_fd2004 pl_abs2004 pl_ext2004

compress
saveold "$nlssfintabs04\NGA_04_quintiles.dta", replace




**************************************************************************************************************************
**POVERTY and INEQUALITY MEASURES - Poverty estimates with point estimates for 2009-10 - QUICK AND DIRTY
**************************************************************************************************************************
*Please note that SPSS and STATA round off their estimates slightly differently and therefore proportions may vary slightly though not significantly.

use "$nlssfintabs04\NGA_04_E.dta", clear

*weighting by wta_cadq derives adult equivalent population estimates (country scales).
*weighting wta_pop derives proportion of population.
*weighting by wta_hh derives proportion of household. 

replace year=2004  if year==3
replace year=2004  if year==4
gen yearmth=year*100 + month


**********************************************************

* Food poverty

gen pcfdadq =  fdtexpdr/ctry_adq
gen pcfdhh  =  fdtexpdr/hhsize

*national.

sepov pcfdadq [w=wta_cadq], p(pl_fd2004) 
sepov pcfdhh  [w=wta_pop],  p(pl_fd2004) 
sepov pcfdhh  [w=wta_pop],  p(pl_fd2004) by (yearmth)
sepov pcfdhh  [w=wta_hh],   p(pl_fd2004) 

*rural-urban.

sepov pcfdadq [w=wta_cadq], p(pl_fd2004) by (sector)
sepov pcfdhh  [w=wta_pop],  p(pl_fd2004) by (sector)
sepov pcfdhh  [w=wta_hh],   p(pl_fd2004) by (sector)

*state.

sepov pcfdadq [w=wta_cadq], p(pl_fd2004) by (state)
sepov pcfdhh  [w=wta_pop],  p(pl_fd2004) by (state)
sepov pcfdhh  [w=wta_hh],   p(pl_fd2004) by (state)

*zone.

sepov pcfdadq [w=wta_cadq], p(pl_fd2004) by (zone)
sepov pcfdhh  [w=wta_pop],  p(pl_fd2004) by (zone)
sepov pcfdhh  [w=wta_hh],   p(pl_fd2004) by (zone)


**********************************************************

*** Absolute poverty

gen pcadq   =  hhtexpdr/ctry_adq
gen pcexphh =  hhtexpdr/hhsize

*national.

sepov pcadq   [w=wta_cadq], p(pl_abs2004) 
sepov pcadq   [w=wta_pop],  p(pl_abs2004) 
sepov pcexphh [w=wta_pop],  p(pl_abs2004) 
sepov pcexphh [w=wta_pop],  p(pl_abs2004) by (yearmth)
sepov pcexphh [w=wta_hh],   p(pl_abs2004) 

*rural-urban.

sepov pcadq   [w=wta_cadq], p(pl_abs2004) by (sector)
sepov pcexphh [w=wta_pop],  p(pl_abs2004) by (sector)
sepov pcexphh [w=wta_hh],   p(pl_abs2004) by (sector)

*state.

sepov pcadq   [w=wta_cadq], p(pl_abs2004) by (state)
sepov pcexphh [w=wta_pop],  p(pl_abs2004) by (state)
sepov pcexphh [w=wta_hh],   p(pl_abs2004) by (state)

*zone.

sepov pcadq   [w=wta_cadq], p(pl_abs2004) by (zone)
sepov pcexphh [w=wta_pop],  p(pl_abs2004) by (zone)
sepov pcexphh [w=wta_hh],   p(pl_abs2004) by (zone)


**********************************************************

***Extreme poverty 

*national.

sepov pcexphh [w=wta_cadq], p(pl_ext2004) 
sepov pcexphh [w=wta_pop],  p(pl_ext2004) 
sepov pcexphh [w=wta_pop],  p(pl_ext2004) by (yearmth)
sepov pcexphh [w=wta_hh],   p(pl_ext2004) 

*rural-urban.

sepov pcadq   [w=wta_cadq], p(pl_ext2004) by (sector)
sepov pcexphh [w=wta_pop],  p(pl_ext2004) by (sector)
sepov pcexphh [w=wta_hh],   p(pl_ext2004) by (sector)

*state.

sepov pcadq   [w=wta_cadq], p(pl_ext2004) by (state)
sepov pcexphh [w=wta_pop],  p(pl_ext2004) by (state)
sepov pcexphh [w=wta_hh],   p(pl_ext2004) by (state)

*zone.

sepov pcadq   [w=wta_cadq], p(pl_ext2004) by (zone)
sepov pcexphh [w=wta_pop],  p(pl_ext2004) by (zone)
sepov pcexphh [w=wta_hh],   p(pl_ext2004) by (zone)


**********************************************************

***Inequality

**food inequality

gen pcfood=fdtexp/hhsize
ineqdeco   pcfood [aw=wta_pop]
ineqdeco   pcfood [aw=wta_pop], by (sector) 
ineqdeco   pcfood [aw=wta_pop], by (state) 
ineqdeco   pcfood [aw=wta_pop], by (zone) 
ineqdeco   pcfood [aw=wta_pop], by (yearmth) 

**computes total food and non-food inequality

ineqdeco   pcexp [aw=wta_pop] 
ineqdeco   pcexp [aw=wta_pop], by (sector) 
ineqdeco   pcexp [aw=wta_pop], by (state) 
ineqdeco   pcexp [aw=wta_pop], by (zone) 
ineqdeco   pcexp [aw=wta_pop], by (yearmth) 



**************************************************************************************************************************
***THE END
**************************************************************************************************************************

clear

log close



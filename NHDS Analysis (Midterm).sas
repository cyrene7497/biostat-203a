libname nhds "/home/u62439433/sasuser.v94/203A/Midterm Project/Midterm Project Final";
run;

proc format;
value agefrmt 0-<15 = "Under 15 years"
             15-44  = "15-44"
             45-64 = "45-64"
             65-high = "65 years and over";
value sexfrmt 1 = "Male"
              2 = "Female";
value racefrmt 1 = "White"
              2 = "Black/African American"
              3 = "American Indian/Alaskan Native"
              4 = "Asian"
              5 = "Native Hawaiian or other Pacific Isldr"
              6 = "Other"
              8 = "Multiple race indicated"
              9 = "Not stated";
value regionfrmt 1 = "Northeast"
              2 = "Midwest"
              3 = "South"
              4 = "West";
value $crfrmt 1 = 'Outcome of delivery'
    2 = 'Other forms of chronic ischemic heart disease'
    3 = 'Heart failure'
    4 = 'Pneumonia, organism unspecified'
    5 = 'Episodic mood disorders'
    6 = 'Cardiac dysrhythmias'
    7 = 'Acute myocardial infarction'
    8 = 'Disorders of fluid, electrolyte, and acid-base balance'
    9 = 'Osteoarthrosis and allied disorders'
    10 = 'Diabetes mellitus'
    11 = 'Complications peculiar to certain specified procedures'
    12 = 'Asthma'
    13 = 'Care involving use of rehabilitation procedures'
    14 = 'Other cellulitis and abscess'
    15 = 'Chronic bronchitis'
    16 = 'Septicemia'
    17 = 'Other disorders of urethra and urinary tract'
    18 = 'Intervertebral disc disorders'
    19 = 'Schizophrenic disorders'
    20 = 'Occlusion of cerebral arteries';
run;

* Data step from NHDS documentation;
DATA    nhds.data_2000_2007 ;
INFILE   "/home/u62439433/sasuser.v94/203A/Midterm Project/Midterm Project Final/NHDS0007.NOTNB.txt";
INPUT               		 
   	 @  1   	 YEAR                                  	$2.
   	 @  3   	 NEWBORN      	  1.
   	 @  4   	 AGEUNITS     	  1.
   	 @  5   	 AGE   		  2.
   	 @  7   	 SEX   		  1.
   	 @  8   	 RACE   		  1.
   	 @  9   	 MARSTAT                             	1.
   	 @ 10   	 ADM_MON                         	$2.
   	 @ 12   	 DISCSTAT   	  1.
   	 @ 13   	 DOC                                     	4.
   	 @ 17   	 LOSFLAG                            	1.
   	 @ 18   	 REGION                               	1.
   	 @ 19   	 BEDSIZE                              	1.
   	 @ 20   	 OWNER                               	1.
   	 @ 21   	 WEIGHT                              	5.
   	 @ 26   	 CENTURY                          	$2.
   	 @ 28   	 DX1   		 $5.
   	 @ 33   	 DX2   		 $5.
   	 @ 38   	 DX3   		 $5.
   	 @ 43   	 DX4   		 $5.
   	 @ 48   	 DX5   		 $5.
   	 @ 53   	 DX6   		 $5.
   	 @ 58   	 DX7   		 $5.
   	 @ 63   	 PD1   		 $4.
   	 @ 67   	 PD2   		 $4.
   	 @ 71   	 PD3   		 $4.
   	 @ 75   	 PD4   		 $4.
   	 @ 79   	 DISCMON                           	$2.
                            	@ 81                     	ESOP1                                  	2.
   	 @ 83   	 ESOP2                                  	2.
   	 @ 85                     	ADM_TYPE                          	1.
                            	@ 86                     	ASOURCE                            	2.
   	 ;
LABEL                	 
   	 YEAR                   	= 'Last two digits of survey year'
   	 NEWBORN 	 = 'Newborn infant flag'
   	 AGEUNITS    = 'Units for age'
   	 AGE   	 = 'Age in years, months, or days'
   	 SEX   	 = 'Patient sex'
   	 RACE   	 = 'Patient race'
   	 MARSTAT            	= 'Marital status of patient'
   	 ADM_MON           	= 'Month of admission'
   	 DISCSTAT    = 'Status at discharge'
   	 DOC   	 = 'Number of days of care'
   	 LOSFLAG  	 = 'Zero length of stay flag'
   	 REGION              	= 'Geographic region of hospital'
   	 BEDSIZE             	= 'Bedsize grouping for hospital'
   	 OWNER               	= 'Ownership of hospital'
   	 WEIGHT             	= 'Analysis weight'
   	 CENTURY           	= 'First two digits of survey year'
   	 DX1   	 = 'ICD-9-CM diagnosis code - first'
   	 DX2   	 = 'ICD-9-CM diagnosis code - second'
   	 DX3   	 = 'ICD-9-CM diagnosis code - third'
   	 DX4   	 = 'ICD-9-CM diagnosis code - fourth'
                            	DX5   	 = 'ICD-9-CM diagnosis code - fifth'
   	 DX6   	 = 'ICD-9-CM diagnosis code - sixth'
   	 DX7   	 = 'ICD-9-CM diagnosis code - seventh'
   	 PD1   	 = 'ICD-9-CM procedure code - first'
   	 PD2   	 = 'ICD-9-CM procedure code - second'
   	 PD3   	 = 'ICD-9-CM procedure code - third'
   	 PD4   	 = 'ICD-9-CM procedure code - fourth'
   	 DISCMON            	= 'Month of discharge'
    	ESOP1                		 = 'Principal expected source of payment'
   	 ESOP2                 	= 'Secondary expected source of payment'
   	 ADM_TYPE         	= 'Type of admission'
    	ASOURCE            	= 'Source of admission'
   	 ;
Run;



* Create prefix variables for first two diagnosis codes;
data nhds.data_2000_2007_working;
    set nhds.data_2000_2007;
    dx1_pre = substr(dx1, 1, 3);
    dx2_pre = substr(dx2, 1, 3);
    
run;

* Determine top 20 primary diagnosis codes by number of patients;
proc freq data=nhds.data_2000_2007_working order=freq;
    tables dx1_pre / out=nhds.primary_code_freq;
run;

data nhds.top_20_codes;
    set nhds.primary_code_freq (obs=20);
run;
    
proc rank data=nhds.top_20_codes descending out=nhds.top_20_codes;
    var count;
    ranks code_rank;
run;

* Merge ranks back to original patient data;
proc sort data=nhds.data_2000_2007_working;
    by dx1_pre;
run;

proc sort data=nhds.top_20_codes;
    by dx1_pre;
run;

data nhds.data_2000_2007_top_20;
    merge nhds.data_2000_2007_working (in=patient_in)
   	   nhds.top_20_codes (in=rank_in);
    by dx1_pre;
    if patient_in & rank_in;
run;

******** APPENDIX 2 BREAK?? ;

* Association between top disease codes;
proc freq data=nhds.data_2000_2007_top_20 order=freq;
    tables dx1_pre * dx2_pre /nocum norow nocol out=nhds.top_20_associations;
run;

* Sort and create bar chart of frequencies;
proc sort data=nhds.data_2000_2007_top_20;
    by code_rank;
run;


ods listing gpath="/home/u62424245/203A Project";
ods graphics / imagename="top_20_barchart" imagefmt=png;
/* title "Top 20 Primary Diagnoses"; */
proc sgplot data=nhds.data_2000_2007_top_20;
    hbar code_rank;
    xaxis label="Count of Patients with Diagnosis";
    yaxis discreteorder=data tickvalueformat=$crfrmt. label="Primary Diagnosis Category";
Run;

/******
Stacked Bar Charts
******/


proc contents data = nhds.data_2000_2007_top_20;

proc sort data=nhds.data_2000_2007_top_20 out=nhds.top20;
by code_rank;                 	/* sort X categories */
run;


proc freq data=nhds.top20 noprint;
    by code_rank;                	/* X categories on BY statement */
    tables sex / out=sexFreqOut;	/* Y (stacked groups) on TABLES statement */
    run;

/*Stacked Bar Chart for Diagnosis by Sex*/
ods listing gpath='/home/u62424249/Biostat 203A/Midterm';
ods graphics / imagename="top20pdgender" imagefmt=png;
title "Breakdown of Top 20 Primary Diagnoses by Sex";
proc sgplot data=sexFreqOut;
hbar code_rank / response=Percent group=SEX groupdisplay=stack;
xaxis grid values=(0 to 100 by 10) label="Percentage of Primary Diagnosis by Sex";
yaxis discreteorder=data tickvalueformat= $crfrmt. label = 'Primary Diagnosis Ordered by Count';
run;

proc freq data=nhds.top20 noprint;
    by code_rank;  /* X categories on BY statement */
    tables REGION / out=RegionFreqOut;	/* Y (stacked groups) on TABLES statement */
    Run;

/*Stacked Bar Chart for Diagnosis by Region*/
ods graphics / imagename="top20pdregion" imagefmt=png;
title "Breakdown of Top 20 Primary Diagnoses by Region";
proc sgplot data=RegionFreqOut;
hgbar code_rank / response=Percent group=REGION groupdisplay=stack;
xaxis grid values=(0 to 100 by 10) label="Percentage of Primary Diagnosis by Region";
yaxis discreteorder=data tickvalueformat= $crfrmt. label = 'Primary Diagnosis Ordered by Count';
run;


/*MY PART
TWO DISEASES: HEART FAILURE (dx1_pre = 428), and PNEUMONIA (dx1_pre = 486)*/
/*want just the people who have dx1_pre = 428
and just the people who have dx1_pre = 486*/


data nhds.data_2000_2007_top_20_age_excl;
    set nhds.data_2000_2007_top_20;
    if ageunits =2 or ageunits = 3 then delete ;
run;


/*PROC FREQ TABLES FOR HEART FAILURE:*/
proc freq data=nhds.data_2000_2007_top_20_age_excl; /*order=freq;*/
    where dx1_pre = "428";
    format age agefrmt.;
    format sex sexfrmt.;
    format race racefrmt.;
    format region regionfrmt.;
    tables age sex race region /nocum norow nocol missprint;
run;

/*PROC FREQ TABLES FOR PNEUMONIA:*/
proc freq data=nhds.data_2000_2007_top_20_age_excl; /*order=freq;*/
    where dx1_pre = "486";
    format age agefrmt.;
    format sex sexfrmt.;
    format race racefrmt.;
    format region regionfrmt.;
    tables age sex race region /nocum norow nocol missprint;
run;


/*Making ods report for HEART FAILURE*/
ods pdf file = '/home/u62446557/sasuser.v94/Midterm Project/DemoBreakdownHeartFailure.pdf';
title1 "Demographic Breakdown for Heart Failure";
proc freq data=nhds.data_2000_2007_top_20_age_excl; /*order=freq;*/
    where dx1_pre = "428";
    format age agefrmt.;
    format sex sexfrmt.;
    format race racefrmt.;
    format region regionfrmt.;
    tables age sex race region /nocum norow nocol;
run;
ods pdf close;


/*Making ods report for PNEUMONIA*/
ods pdf file = '/home/u62446557/sasuser.v94/Midterm Project/DemoBreakdownPneumonia.pdf';
title1 "Demographic Breakdown for Pneumonia";
proc freq data=nhds.data_2000_2007_top_20_age_excl; /*order=freq;*/
    where dx1_pre = "486";
    format age agefrmt.;
    format sex sexfrmt.;
    format race racefrmt.;
    format region regionfrmt.;
    tables age sex race region /nocum norow nocol;
run;
ods pdf close;



/*Making ods report with BOTH diagnoses of focus*/
ods pdf file = '/home/u62446557/sasuser.v94/Midterm Project/DemoBreakdownBothDxs_AgeExcl.pdf';
title1 "Demographic Breakdown for Heart Failure";
proc freq data=nhds.data_2000_2007_top_20_age_excl; /*order=freq;*/
    where dx1_pre = "428";
    format age agefrmt.;
    format sex sexfrmt.;
    format race racefrmt.;
    format region regionfrmt.;
    tables age sex race region /nocum norow nocol;
run;
title1 "Demographic Breakdown for Pneumonia";
proc freq data=nhds.data_2000_2007_top_20_age_excl; /*order=freq;*/
    where dx1_pre = "486";
    format age agefrmt.;
    format sex sexfrmt.;
    format race racefrmt.;
    format region regionfrmt.;
    tables age sex race region /nocum norow nocol;
run;
ods pdf close;



/*checking max/min/mean for the 4 variables we're looking at */
proc means data = nhds.data_2000_2007_top_20_age_excl n mean std median min max;
vars age sex race region; 
run;
/*^^ ran and checked, and values look good and reasonable for all 4 variables*/


/*FORMATTING DATA TO WORK WITH MACRO*/
data nhds.data_2000_2007_HF_PNEU;
    set nhds.data_2000_2007_top_20;
    where dx1_pre = "428" or dx1_pre = "486";
    if ageunits =2 or ageunits = 3 then delete ;
run;


data nhds.data_2000_2007_HF_PNEU; 
 length age_category $ 50 /* specifying length*/
 		race_category $ 50
 		sex_category $ 50
 		region_category $ 50;
 set nhds.data_2000_2007_HF_PNEU;
 if (age <15) then age_category = "Under 15 years";
 if (age >=15) & (age <=44) then age_category = "15-44";
 if (age >=45) & (age <=64) then age_category = "45-64";
 if (age >=65) then age_category = "65 years and over";
 if (age = '') then age_category = "Missing";
 if (race = 1) then race_category = "White";
 if (race = 2) then race_category = "Black/African American";
 if (race = 3) then race_category = "American Indian/Alaskan Native";
 if (race = 4) then race_category = "Asian";
 if (race = 5) then race_category = "Native Hawaiian or other Pacific Isldr";
 if (race = 6) then race_category =  "Other";
 if (race = 8) then race_category =  "Multiple race indicated";
 if (race = 9) then race_category =  "Not stated";
 if (race = '') then race_category = "Missing";
 if (sex = 1) then sex_category = "Male";
 if (sex = 2) then sex_category = "Female";
 if (sex = '') then sex_category = "Missing";
 if (region = 1) then region_category = "Northeast";
 if (region = 2) then region_category = "Midwest";
 if (region = 3) then region_category = "South";
 if (region = 4) then region_category = "West";
 if (region = '') then region_category = "Missing";
 if (dx1_pre = "428") then PrimaryDiagnosis = "Heart Failure";
 if (dx1_pre = "486") then PrimaryDiagnosis = "Pneumonia";
run;




/*trying macro %tablen for visualization*/
%tablen(data=nhds.data_2000_2007_HF_PNEU, by=PrimaryDiagnosis,
     var=age_category sex_category race_category region_category,
     type=2 2 2 2, outdoc=/home/u62446557/sasuser.v94/Midterm Project/DemographicBreakdown_FullTable.rtf);

proc freq data=nhds.data_2000_2007_top_20;
table ageunits;
run;
/*only 1% of entries have age in terms of days or months*/
data nhds.data_inyears;
	set nhds.data_2000_2007_top_20;
	where ageunits = 1;
	if age < 15 then age_bin = 1;
	if 15 <= age <= 44 then age_bin = 2;
	if 45 <= age <= 64 then age_bin = 3;
	if 65 <= age then age_bin = 4;
run;
/*how many left after exclusion*/
proc means data=nhds.data_inyears n;
class dx1_pre;
var age_bin;
where dx1_pre = "428" or dx1_pre = "486";
run;

/*excluded 1% of data to only include entries where data was in years, bucket age*/
/*AGE chi-squared test*/
proc freq data = nhds.data_inyears;
	where dx1_pre = "428";
	tables age_bin / chisq testp=(14.41 9.56 19.36 56.67) missprint;
	output chisq out=nhds.age_chisq;
run;

/*RACE Chi-squared test*/
/*exclude entries where race is not stated*/
proc freq data=nhds.data_inyears;
	format race racefrmt.;
   tables race / missprint;
run;

data nhds.data_racestated;
	set nhds.data_inyears;
	where race ~= 9;
run;

proc means data=nhds.data_racestated n;
class dx1_pre;
var age_bin;
where dx1_pre = "428" or dx1_pre = "486";
run;

proc freq data=nhds.data_racestated;
   where dx1_pre = "486";
   format race racefrmt.;
   tables race / missprint;
run;

proc freq data = nhds.data_racestated;
	where dx1_pre = "428";
	tables race / chisq testp=(75.47 18.75 .34 .71 .17 4.51 .04) missprint;
	output out=nhds.race_chisq chisq;
run;

/*SEX Chi-squared test*/
proc freq data = nhds.data_inyears;
	where dx1_pre = "428";
	tables sex / chisq testp=(47.36 52.64) missprint;
	output out=nhds.sex_chisq chisq;
run;

/*REGION Chi-squared test*/
proc freq data = nhds.data_inyears;
	where dx1_pre = "428";
	tables region / chisq testp=(23.19 30.53 34.79 11.49) missprint;
	output out=nhds.region_chisq chisq;
run;

proc sql;
  title 'Chi Squared Results';
  create table nhds.chisq_values AS
  select * from nhds.age_chisq
  outer union corr
  select * from nhds.race_chisq
  outer union corr
  select * from nhds.sex_chisq
  outer union corr
  select * from nhds.region_chisq;

proc format;
value p_value LOW = "<.0001";

proc transpose data= nhds.chisq_values
out=nhds.values_transp (rename=(col1=Age col2=Race col3=Sex col4=Region));
run;

proc transpose data= nhds.values_transp
out=nhds.values_transp;
run;

data nhds.values_final;
SET NHDS.values_transp;
format p_pchi pvalue.;
label _NAME_ = 'Demographic';
run;

proc contents data=nhds.values_final;
run;

proc print data=nhds.values_final noobs label;
run;

/* export to CSV for final on R*/
proc export data=nhds.data_2000_2007_top_20
outfile = "/home/u62439433/sasuser.v94/203A/Midterm Project/Midterm Project Final/nhdstop20.csv"
dbms=csv
replace;
run;


Pass SAS table to python summarize and export summary table to SAS dataset

WPS/Proc Python: Import export SAS tables

SAS-L: WPS/Python: Pass_a_SAS_table_to_python_summarize_and_export_summary_table_to_SAS_dataset

INPUT
=====

  SD1.HAVE total obs=19

    NAME       SEX    AGE    HEIGHT    WEIGHT

    Alfred      M      14     69.0      112.5
    Alice       F      13     56.5       84.0
    Barbara     F      13     65.3       98.0
    Carol       F      14     62.8      102.5
    Henry       M      14     63.5      102.5
  ...

PYTHON PROCESS (Working code)
======================

   have = pandas.read_sas('d:/sd1/class.sas7bdat',encoding='ascii');
   want=have.describe(include=[np.number]);

OUTPUT
======

   Up to 40 obs from sd1.wantwps total obs=8

   Obs    STATISTIC      AGE       HEIGHT     WEIGHT

    1       count      19.0000    19.0000     19.000
    2       mean       13.3158    62.3368    100.026
    3       std         1.4927     5.1271     22.774
    4       min        11.0000    51.3000     50.500
    5       25%        12.0000    58.2500     84.250
    6       50%        13.0000    62.8000     99.500
    7       75%        14.5000    65.9000    112.250
    8       max        16.0000    72.0000    150.000

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  set sashelp.class;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

Notes

  1. without encoding='ascii' you get 'utf-8'

  2, rownames to first column
     df1.index.name = 'newhead' ;
     df1.reset_index(inplace=True);

  3. Set and reset PYTHONHOME because I have both.
     Prefer 2.7 but neither SAS ro WPS support 2.7.
     More packages in 2.7?
;


%utl_submit_wps64("
libname sd1 sas7bdat 'd:/sd1';
options set=PYTHONHOME 'C:\Program Files\Python 3.5';
proc python;
submit;
import numpy as np;
from sas7bdat import SAS7BDAT;
from pandas import pandas;
have = pandas.read_sas('d:/sd1/class.sas7bdat',encoding='ascii');
want=have.describe(include=[np.number]);
want.index.name = 'statistic' ;
want.reset_index(inplace=True);
endsubmit;
import  python=want data=sd1.wantwps;
run;quit;
");

The WPS System

The PYTHON Procedure

       NAME SEX   AGE  HEIGHT  WEIGHT
0    Alfred   M  14.0    69.0   112.5
1     Alice   F  13.0    56.5    84.0
2   Barbara   F  13.0    65.3    98.0
3     Carol   F  14.0    62.8   102.5
4     Henry   M  14.0    63.5   102.5
5     James   M  12.0    57.3    83.0
6      Jane   F  12.0    59.8    84.5
7     Janet   F  15.0    62.5   112.5
8   Jeffrey   M  13.0    62.5    84.0
9      John   M  12.0    59.0    99.5
10    Joyce   F  11.0    51.3    50.5
11     Judy   F  14.0    64.3    90.0
12   Louise   F  12.0    56.3    77.0
13     Mary   F  15.0    66.5   112.0
14   Philip   M  16.0    72.0   150.0
15   Robert   M  12.0    64.8   128.0
16   Ronald   M  15.0    67.0   133.0
17   Thomas   M  11.0    57.5    85.0
18  William   M  15.0    66.5   112.0

STATISTIC        AGE     HEIGHT      WEIGHT
0   count  19.000000  19.000000   19.000000
1    mean  13.315789  62.336842  100.026316
2     std   1.492672   5.127075   22.773933
3     min  11.000000  51.300000   50.500000
4     25%  12.000000  58.250000   84.250000
5     50%  13.000000  62.800000   99.500000
6     75%  14.500000  65.900000  112.250000
7     max  16.000000  72.000000  150.000000



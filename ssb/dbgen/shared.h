/*
 *  Sccsid:     @(#)shared.h	2.1.8.1
 *  Modified for SSBM
 */
#define N_CMNT_LEN      72
#define N_CMNT_MAX      152
#define R_CMNT_LEN      72
#define R_CMNT_MAX      152
#define  MONEY_SCL     0.01
#define  V_STR_HGH    1.6

#ifdef SSBM
#define  P_NAME_LEN    22
#define  P_MFG_LEN     6
#define  P_COLOR_LEN   3
#define  P_COLOR_MAX   11
#define  P_TYPE_MAX    25
#define  P_CAT_LEN     7
#define  P_CAT_MIN     1
#define  P_CAT_MAX     5
#define  P_CAT_SD      97
#define  S_NATION_NAME_LEN 15
#define  S_REGION_NAME_LEN 12
#define  C_NATION_NAME_LEN 15
#define  C_REGION_NAME_LEN 12
#define  C_NAT_SD     16
#define  C_REG_SD      3
#define  O_SHIP_STRU_LEN 25
#define  O_SHIP_MODE_LEN 10
#define  O_SHIP_PRIO_LEN 1
#define  D_DATE_LEN 18
#define  D_DAYWEEK_LEN 9
#define  D_YEARMONTH_LEN 7
#define  D_SEASON_LEN 12
#define  D_MONTH_LEN  9
#define  D_STARTDATE 694245661 /*corresponding to 1/1/1992 1:1:1*/
#define NAMTION_BRIEF_LEN  9
#define CITY_CODE_SEED   15
#define NUM_DAYS 2556
#define NUM_SEASONS 5
#define NUM_HOLIDAYS 10
#define CITY_FIX 10
#else

#define  P_NAME_LEN    55
#define  P_MFG_LEN     25

#endif

#define  P_BRND_LEN    10

#ifdef SSBM
#define  P_TYPE_LEN    12

#else

#define  P_TYPE_LEN    25

#endif

#define  P_CNTR_LEN    10
#define  P_CMNT_LEN    14
#define  P_CMNT_MAX    23
#define  P_CAT_SEED    25

#define  S_NAME_LEN    25

#ifdef SSBM
#define  S_ADDR_LEN    15
#define  S_ADDR_MAX    25
#else

#define  S_ADDR_LEN    25
#define  S_ADDR_MAX    40
#endif

#define  S_CMNT_LEN    63
#define  S_CMNT_MAX   101
#define  PS_CMNT_LEN  124
#define  PS_CMNT_MAX  199

#ifdef SSBM
#define  C_NAME_LEN    25
#define  C_MSEG_MIN    1
#define  C_MSEG_MAX    5
#define  C_ADDR_LEN    15
#define  C_ADDR_MAX    25
#else
#define  C_NAME_LEN    18
#define  C_ADDR_LEN    25
#define  C_ADDR_MAX    40
#endif

#define  C_MSEG_LEN    10
#define  C_CMNT_LEN    73
#define  C_CMNT_MAX    117

#ifdef SSBM
#define  O_OPRIO_LEN   8

#else
#define  O_OPRIO_LEN   15

#endif

#define  O_CLRK_LEN    15
#define  O_CMNT_LEN    49
#define  O_CMNT_MAX    79
#define  L_CMNT_LEN    27
#define  L_CMNT_MAX    44
#define  L_INST_LEN    25
#define  L_SMODE_LEN   10
#define  T_ALPHA_LEN   10
#define  DATE_LEN      13  /* long enough to hold either date format */
#define  NATION_LEN    25
#define  REGION_LEN    25
#define  PHONE_LEN     15

#ifdef SSBM
#define  MAXAGG_LEN    20    /* max component length for a agg str */

#else
#define  MAXAGG_LEN    20    /* max component length for a agg str */

#endif

#define  P_CMNT_SD      6
#define  PS_CMNT_SD     9
#define  O_CMNT_SD     12
#define  C_ADDR_SD     26
#define  C_CMNT_SD     31
#define  S_ADDR_SD     32
#define  S_CMNT_SD     36
#define  L_CMNT_SD     25







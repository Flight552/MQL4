//+------------------------------------------------------------------+
//|                                                   StopLevels.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

double gStopLossBuy = NormalizeDouble(Ask - 50*_Point, Digits);
double gStopLossSell =  NormalizeDouble(Ask + 50*_Point, Digits);
double gTakeProfitSell = 0;//NormalizeDouble(Bid - 50*_Point, Digits);
double gTakeProfitBuy = 0;//NormalizeDouble(Bid + 50*_Point, Digits);

int gPips = 50;

double gOrderLot = 0.02;



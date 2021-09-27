//+------------------------------------------------------------------+
//|                                            ScriptPriceLevels.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PricesBuy
  {
   public:
   double            PriceHigh;
   public:
   double            PriceLow;

public:
   void              PriceBuyHigh(double priceHigh)
     {
      this.PriceHigh = priceHigh;

     }
public:
   void              PriceBuyLow(double priceLow)
     {
      PriceLow = priceLow;
     }
  };
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                          YBR_OpenLimitOrders.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
#include <MagicNumber.mqh>
#include <Mql4Book\Trade.mqh>
#include <FiboLevels.mqh>
#include <ScriptPriceLevels.mqh>


CCount Count;
CTrade Trade;
PricesBuy setPriceLevelsBuy;

int gBuy,gSell,gSellLimit,gBuyLimit,
    gBuyStop,gSellStop;
int gMagic;
double gNewPriceLevelHighBuy,gNewPriceLevelLowBuy,gNewPriceLevelHighSell,gNewPriceLevelLowSell;
double gLot=0.01;
int spread=(int) NormalizeDouble((Ask-Bid)/Point,Digits);
double fibo_order = level_trade;
double fibo_stop_loss = level_X;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   RefreshRates();
   foundMagic();
   Trade.SetMagicNumber(gMagic);
   openBuyLimit();

  }
//+------------------------------------------------------------------+
bool foundMagic()
  {
   string _symbol=_Symbol;
   gMagic=pMagicNumber(_symbol);
   return true;
  }
//+------------------------------------------------------------------+
void openBuyLimit()
  {
 double gPriceLevelHighSell;
 double gPriceLevelLowSell;
 double gPriceLevelHighBuy = setPriceLevelsBuy.PriceHigh;
 double gPriceLevelLowBuy;
//check if there is no buy limit orders within the range
   if(gPriceLevelLowBuy > 0 && gPriceLevelHighBuy > 0)
     {
      //if no buy limit orders, open one within the price range
      if(Bid>gPriceLevelLowBuy && Bid<gPriceLevelHighBuy)
        {
         double _openPrice= NormalizeDouble((gPriceLevelLowBuy + ((gPriceLevelHighBuy-gPriceLevelLowBuy)*fibo_order)+spread*_Point),Digits);
         //double _stopLoss = NormalizeDouble((gPriceLevelLowBuy + ((gPriceLevelHighBuy-gPriceLevelLowBuy)*fibo_stop_loss)-spread*_Point),Digits);
         double _stopLoss = NormalizeDouble((gPriceLevelLowBuy - spread*_Point),Digits);
         gBuyLimit=Trade.OpenBuyLimitOrder(_Symbol,gLot,_openPrice,_stopLoss,0);
         gNewPriceLevelHighBuy = gPriceLevelHighBuy;
         gNewPriceLevelLowBuy = gPriceLevelLowBuy;
        }
     }
     Print("price High Buy Global - ", gPriceLevelHighBuy);
     Print("price Low Buy Global - ", gPriceLevelLowBuy);
  }
//+------------------------------------------------------------------+

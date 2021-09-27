//+------------------------------------------------------------------+
//|                                                   YBR-System.mq4 |
//|                                        Copyright 2020, Andrey V. |
//|                                       https://www.ybr-system.com |
//+------------------------------------------------------------------+
#property copyright "Andrey V"
#property link      "https://www.ybr-system.com"
#property version   "1.00"
#property strict

#include <MagicNumber.mqh>
#include <Mql4Book\Trade.mqh>
#include <FiboLevels.mqh>
#include <StopLevels.mqh>

CCount Count;
CTrade Trade;

input double gPriceLevelHighSell=0.0;
input double gPriceLevelLowSell=0.0;
input double gPriceLevelHighBuy=0.0;
input double gPriceLevelLowBuy=0.0;
input bool isTrading = false;
input bool extraTrade = false;


int gBuy,gSell,gSellLimit,gBuyLimit,
    gBuyStop,gSellStop;
int gMagic;
double gNewPriceLevelHighBuy,gNewPriceLevelLowBuy,gNewPriceLevelHighSell,gNewPriceLevelLowSell;
int spread=(int) NormalizeDouble((Ask-Bid)/Point,Digits);
double fibo_order = level_trade;
double fibo_stop_loss = level_X;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   RefreshRates();
   foundMagic();
   Trade.SetMagicNumber(gMagic);
   gNewPriceLevelHighBuy = gPriceLevelHighBuy;
   gNewPriceLevelLowBuy = gPriceLevelLowBuy;
   gNewPriceLevelLowSell = gPriceLevelLowSell;
   gNewPriceLevelHighSell = gPriceLevelHighSell;

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   findOrders();
   openBuyLimit();
   openSellLimit();
   modifyBuyLimit();
   modifySellLimit();
   setExtraTradeBuy();
   setExtraTradeSell();
//printPriceLevelsBuy();
//printPriceLevelsSell();

  }
//+------------------------------------------------------------------+

//-------------------------------------------------------------------//get magic number
bool foundMagic()
  {
   string _symbol=_Symbol;
   gMagic=pMagicNumber(_symbol);
   return true;
  }
//--------------------------------------------------------------------//Find Orders

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void findOrders()
  {
   gBuy=0;
   gSell=0;
   gSellLimit=0;
   gBuyLimit=0;
   gBuyStop=0;
   gSellStop=0;

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS)==true)
        {
         if(StringCompare(OrderSymbol(),Symbol())!=0)
           {
            continue;
           }
         int type=OrderType();

         if(gBuy==0 && type==OP_BUY)
           {
            gBuy=OrderTicket();
           }
         if(gSell==0 && type==OP_SELL)
           {
            gSell=OrderTicket();
           }
         if(gSellLimit==0 && type==OP_SELLLIMIT)
           {
            gSellLimit=OrderTicket();
           }
         if(gBuyLimit==0 && type==OP_BUYLIMIT)
           {
            gBuyLimit=OrderTicket();
           }
         if(gSellStop==0 && type==OP_SELLSTOP)
           {
            gSellStop=OrderTicket();
           }
         if(gBuyStop==0 && type==OP_BUYSTOP)
           {
            gBuyStop=OrderTicket();
           }
        }
     }
  }
//-------------------------------------------------------------------------------Open Buy Limit

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void openBuyLimit()
  {
//check if there is no buy limit orders within the range
   if(isTrading)
     {
      if(gPriceLevelLowBuy > 0 && gPriceLevelHighBuy > 0)
        {
         if(Count.BuyLimit()==0 && Count.Buy() == 0)
           {
            //if no buy limit orders, open one within the price range
            if(Bid>gPriceLevelLowBuy && Bid<gPriceLevelHighBuy)
              {
               double _openPrice= NormalizeDouble((gPriceLevelLowBuy + ((gPriceLevelHighBuy-gPriceLevelLowBuy)*fibo_order)/*+spread*_Point*/),Digits);
               //double _stopLoss = NormalizeDouble((gPriceLevelLowBuy + ((gPriceLevelHighBuy-gPriceLevelLowBuy)*fibo_stop_loss)-spread*_Point),Digits);
               double _stopLoss = NormalizeDouble((gPriceLevelLowBuy - (1+spread)*_Point),Digits);
               gBuyLimit=Trade.OpenBuyLimitOrder(_Symbol,gOrderLot,_openPrice,_stopLoss,0);
               gNewPriceLevelHighBuy = gPriceLevelHighBuy;
               gNewPriceLevelLowBuy = gPriceLevelLowBuy;
              }
           }
        }
     }
  }
//+-----------------------------------------------------------------------------Modify Buy Limit

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void modifyBuyLimit()
  {
   if(Count.BuyLimit()>0 && gBuyLimit>0)
     {
      if(OrderSelect(gBuyLimit,SELECT_BY_TICKET)==true)
        {
         int magic = OrderMagicNumber();
         if(gMagic==magic)
           {
            if(High[0] > gNewPriceLevelHighBuy && (gPriceLevelHighBuy != 0.0 && gPriceLevelLowBuy != 0.0))
              {
               gNewPriceLevelHighBuy = High[0];
               double _openPrice= NormalizeDouble((gPriceLevelLowBuy + ((gNewPriceLevelHighBuy-gPriceLevelLowBuy)*fibo_order)/*+spread*_Point*/),Digits);
               // double _stopLoss = NormalizeDouble((gPriceLevelLowBuy + ((gNewPriceLevelHighBuy-gPriceLevelLowBuy)*fibo_stop_loss)-spread*_Point),Digits);
               double _stopLoss = NormalizeDouble(OrderStopLoss(), Digits);
               bool modify = ModifyOrder(gBuyLimit, _openPrice, _stopLoss, 0.0, 0);

              }
           }
        }
     }
  }
//-------------------------------------------------------------------------------Open Sell Limit

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void openSellLimit()
  {
   if(isTrading)
     {
      if(gPriceLevelLowSell > 0 && gPriceLevelHighSell > 0)
        {
         if(Count.SellLimit()==0 && Count.Sell() == 0)
           {
            //if no buy limit orders, open one within the price range
            if(Bid<gPriceLevelHighSell && Bid>gPriceLevelLowSell)
              {
               double _openPrice= NormalizeDouble((gPriceLevelHighSell - ((gPriceLevelHighSell-gPriceLevelLowSell)*(fibo_order))/*-spread*_Point*/),Digits);
               // double _stopLoss = NormalizeDouble((gPriceLevelHighSell - ((gPriceLevelHighSell-gPriceLevelLowSell)*fibo_stop_loss)+spread*_Point),Digits);
               double _stopLoss = NormalizeDouble((gPriceLevelHighSell + (1+spread)*_Point),Digits);
               gSellLimit=Trade.OpenSellLimitOrder(_Symbol,gOrderLot,_openPrice,_stopLoss,0);
               gNewPriceLevelHighSell = gPriceLevelHighSell;
               gNewPriceLevelLowSell = gPriceLevelLowSell;
              }
           }
        }
     }
  }
//+-----------------------------------------------------------------------------Modify Sell Limit

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void modifySellLimit()
  {
   if(Count.SellLimit()>0 && gSellLimit>0)
     {
      if(OrderSelect(gSellLimit,SELECT_BY_TICKET)==true)
        {
         int magic = OrderMagicNumber();
         if(gMagic==magic)
           {
            if(Low[0] < gNewPriceLevelLowSell && (gPriceLevelHighSell != 0.0 && gPriceLevelLowSell != 0.0))
              {
               gNewPriceLevelLowSell = Low[0];
               double _openPrice= NormalizeDouble((gPriceLevelHighSell - ((gPriceLevelHighSell-gNewPriceLevelLowSell)*fibo_order)/*-spread*_Point*/),Digits);
               //double _stopLoss = NormalizeDouble((gPriceLevelHighSell - ((gPriceLevelHighSell-gNewPriceLevelLowSell)*fibo_stop_loss)+spread*_Point),Digits);
               double _stopLoss = NormalizeDouble(OrderStopLoss(), Digits);
               bool modify = ModifyOrder(gSellLimit, _openPrice, _stopLoss, 0.0, 0);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
void printPriceLevelsBuy()
  {
   Print("price High Buy - ", gNewPriceLevelHighBuy);
   Print("price High Buy Global - ", gPriceLevelHighBuy);
   Print("price Low Buy - ", gNewPriceLevelLowBuy);
   Print("price Low Buy Global - ", gPriceLevelLowBuy);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void printPriceLevelsSell()
  {

   Print("price High Sell - ", gNewPriceLevelHighSell);
   Print("price High Sell Global - ", gPriceLevelHighSell);
   Print("price Low Sell  - ", gNewPriceLevelLowSell);
   Print("price Low Sell Global - ", gPriceLevelLowSell);
  }
//-----------------------------------------------------------Extra Trades
void setExtraTradeBuy()
  {
   if(extraTrade)
     {
      if(gPriceLevelLowBuy > 0 && gPriceLevelHighBuy > 0)
        {
         if(Count.Buy() > 0 && Count.BuyLimit() == 0)
           {
            if(Bid>gPriceLevelLowBuy && Bid<gPriceLevelHighBuy)
              {
               double _openPrice= NormalizeDouble((gPriceLevelLowBuy + ((gPriceLevelHighBuy-gPriceLevelLowBuy)*fibo_order)/*+spread*_Point*/),Digits);
               //double _stopLoss = NormalizeDouble((gPriceLevelLowBuy + ((gPriceLevelHighBuy-gPriceLevelLowBuy)*fibo_stop_loss)-spread*_Point),Digits);
               double _stopLoss = NormalizeDouble((gPriceLevelLowBuy - (1+spread)*_Point),Digits);
               gBuyLimit=Trade.OpenBuyLimitOrder(_Symbol,gOrderLot,_openPrice,_stopLoss,0);
               gNewPriceLevelHighBuy = gPriceLevelHighBuy;
               gNewPriceLevelLowBuy = gPriceLevelLowBuy;
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
void setExtraTradeSell()
  {
   if(extraTrade)
     {
      if(gPriceLevelLowSell > 0 && gPriceLevelHighSell > 0)
        {
         if(Count.Sell() > 0 && Count.SellLimit() == 0)
           {
            if(Bid<gPriceLevelHighSell && Bid>gPriceLevelLowSell)
              {
               double _openPrice= NormalizeDouble((gPriceLevelHighSell - ((gPriceLevelHighSell-gPriceLevelLowSell)*fibo_order)/*-spread*_Point*/),Digits);
               // double _stopLoss = NormalizeDouble((gPriceLevelHighSell - ((gPriceLevelHighSell-gPriceLevelLowSell)*fibo_stop_loss)+spread*_Point),Digits);
               double _stopLoss = NormalizeDouble((gPriceLevelHighSell + (1+spread)*_Point),Digits);
               gSellLimit=Trade.OpenSellLimitOrder(_Symbol,gOrderLot,_openPrice,_stopLoss,0);
               gNewPriceLevelHighSell = gPriceLevelHighSell;
               gNewPriceLevelLowSell = gPriceLevelLowSell;

              }
           }
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                        YBR_Open_Order_Double.mq4 |
//|                                                  Andrey Vasiliev |
//|                                                  andrey-fx@bk.ru |
//+------------------------------------------------------------------+
#property copyright "Andrey Vasiliev"
#property link      "andrey-fx@bk.ru"


#property strict 
#include <MagicNumber.mqh>
#include <Mql4Book\Trade.mqh>
#include <StopLevels.mqh>
#include <FiboLevels.mqh>
#include <StopLevels.mqh>

CTrade Trade;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
double MS_Price=WindowPriceOnDropped();
int gMagicNumber;
int open_ticket=0;
int spread=int(NormalizeDouble((Ask-Bid)/Point, Digits));  //EurUsd=2, GbpUsd=3, Gold=5, Silver=5, UsjJpy=3, GBPCHF=7, UsdChf=3, EurJpy=3, UsdCad=4, GbpJpy=7, AudUsd=3
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

    
    
void OnStart()
  {
   foundMagicNumber();
   Trade.SetMagicNumber(gMagicNumber);
   
   if(MS_Price>Bid)
     {
      open_ticket=OrderSend(_Symbol,OP_BUY,gOrderLot,Ask,3,gStopLossBuy,gTakeProfitBuy,NULL,gMagicNumber);
      Alert("Order Buy");
     }

   if(MS_Price<Bid)
     {    
      open_ticket=OrderSend(_Symbol,OP_SELL,gOrderLot,Bid,3,gStopLossSell,gTakeProfitSell,NULL,gMagicNumber);
      Alert("Order Sell");
     }

   Alert(GetLastError());
//---
   return;
  }
//-----------------------------------------------------------------------------------------------------

bool foundMagicNumber()
{
   string _symbol = _Symbol;
   gMagicNumber = pMagicNumber(_symbol);
   return true;
}
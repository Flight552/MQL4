//+------------------------------------------------------------------+
//|                                             OrderMagicNumber.mqh |
//|                                                           Andrey |
//|                                                   YBR_System.com |
//+------------------------------------------------------------------+
#property copyright "Andrey"
#property link      "YBR_System.com"
#property strict

/*
   EURUSD = 1001, 
   GBPUSD = 1002, 
   USDCHF = 1003, 
   GOLD = 1004, 
   EURJPY = 1005,
   GPBJPY = 1006,
   GBPCHF = 1007,
   AUDUSD = 1008,
   USDCAD = 1009,
   USDJPY = 1010,
   CHFJPY = 1011;
    
*/
int _magicNumber = 0;

int pMagicNumber(string _symbol)
{
   
   
   if (_symbol == "EURUSD") 
         {
            _magicNumber = 1001;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   else if(_symbol =="GBPUSD")
            {
            _magicNumber = 1002;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
            }
   else if(_symbol == "USDCHF")
            {
            _magicNumber = 1003;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   else if(_symbol == "GOLD")
            {
            _magicNumber = 1004;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   else if(_symbol == "EURJPY")
            {
            _magicNumber = 1005;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   else if(_symbol == "GBPJPY")
            {
            _magicNumber = 1006;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   else if(_symbol == "GBPCHF")
            {
            _magicNumber = 1007;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   else if(_symbol == "AUDUSD")
            {
            _magicNumber = 1008;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   else if(_symbol == "USDCAD")
            {
            _magicNumber = 1009;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   else if(_symbol == "USDJPY") 
            {
            _magicNumber = 1010;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   else if(_symbol == "CHFJPY")
            {
            _magicNumber = 1011;
            Print("Symbol - ", _symbol, " Magic Number: ", _magicNumber);
         }
   
   else 
      {
         int error = GetLastError();
         Print("Order error", error);
      }
   return _magicNumber;   
}


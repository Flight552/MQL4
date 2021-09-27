 //+------------------------------------------------------------------+
//|                                                     Fractals.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color2 Blue
//---- input parameters

//---- buffers
double ExtDownFractalsBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator buffers mapping  
    SetIndexBuffer(0,ExtDownFractalsBuffer);   
//---- drawing settings
    SetIndexStyle(0,DRAW_ARROW);
    SetIndexArrow(0,119);
//----
    SetIndexEmptyValue(0,0.0);
//---- name for DataWindow
    SetIndexLabel(0,"Fractal Down");
    
//---- initialization done   
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    i,nCountedBars;
   bool   bFound;
   double dCurrent;
   nCountedBars=IndicatorCounted();
//---- last counted bar will be recounted    
   if(nCountedBars<=2)
      i=Bars-nCountedBars-3;
   if(nCountedBars>2)
     {
      nCountedBars--;
      i=Bars-nCountedBars-1;
     }
 
 //----Fractals down
 
 while(i>=2)
 {
      bFound=false;
      dCurrent=Low[i];
      if(dCurrent<Low[i+1] && dCurrent<Low[i+2] && dCurrent<Low[i-1] && dCurrent<Low[i-2])
        {
         bFound=true;
         ExtDownFractalsBuffer[i]=dCurrent;
        }
      //----6 bars Fractal
      if(!bFound && (Bars-i-1)>=3)
        {
         if(dCurrent==Low[i+1] && dCurrent<Low[i+2] && dCurrent<Low[i+3] &&
            dCurrent<Low[i-1] && dCurrent<Low[i-2])
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }                      
        }         
      //----7 bars Fractal
      if(!bFound && (Bars-i-1)>=4)
        {   
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent<Low[i+3] && dCurrent<Low[i+4] &&
            dCurrent<Low[i-1] && dCurrent<Low[i-2])
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }                      
        }  
      //----8 bars Fractal                          
      if(!bFound && (Bars-i-1)>=5)
        {   
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent==Low[i+3] && dCurrent<Low[i+4] && dCurrent<Low[i+5] && 
            dCurrent<Low[i-1] && dCurrent<Low[i-2])
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }                      
        } 
      //----9 bars Fractal                                        
      if(!bFound && (Bars-i-1)>=6)
        {   
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent<=Low[i+3] && dCurrent==Low[i+4] && dCurrent<Low[i+5] && 
            dCurrent<Low[i+6] && dCurrent<Low[i-1] && dCurrent<Low[i-2])
           {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
           }                      
        } 
        
        i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
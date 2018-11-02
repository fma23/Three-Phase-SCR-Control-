library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all; 
   
entity ThreePhase_SCRs_Controller is

generic (FullCycle_Counts:integer:=2000000      -- =20ms/10ns; 20ms is period of sinewave
	);
port (
      clock        : in  std_logic;
      reset        : in  std_logic;
      phaseSelect  : in std_logic_vector(6 downto 0);
      SquareWave1  : in  std_logic;
      SquareWave2  : in  std_logic;
      SquareWave3  : in  std_logic;
      Thyristors   : out std_logic_vector(5 downto 0);
      LED          : out std_logic_vector(7 downto 0)
      );
end ThreePhase_SCRs_Controller;

architecture rtl of ThreePhase_SCRs_Controller is

signal SquareWave1_dly1      : std_logic;
signal SquareWave1_dly2      : std_logic;

signal SquareWave2_dly1      : std_logic;
signal SquareWave2_dly2      : std_logic;

signal SquareWave3_dly1      : std_logic;
signal SquareWave3_dly2      : std_logic;

signal FiringPulse_RisingEdge:integer range 0 to 1333335; 
signal FiringPulse_FallingEdge:integer range 0 to 1333335; 

signal SW1_CrossUp_Pulse  : std_logic;
signal SW1_CrossDwn_Pulse : std_logic;
signal SW2_CrossUp_Pulse  : std_logic;
signal SW2_CrossDwn_Pulse : std_logic;
signal SW3_CrossUp_Pulse  : std_logic;
signal SW3_CrossDwn_Pulse : std_logic;

signal Thyristors_Sig   : std_logic_vector(5 downto 0);

signal PhaseCounter1: integer range 0 to FullCycle_Counts; --equal to 10 ms/half cycle
signal PhaseCounter2: integer range 0 to FullCycle_Counts; --equal to 10 ms/half cycle
signal PhaseCounter3: integer range 0 to FullCycle_Counts;
signal PhaseCounter4: integer range 0 to FullCycle_Counts;
signal PhaseCounter5: integer range 0 to FullCycle_Counts;
signal PhaseCounter6: integer range 0 to FullCycle_Counts;

signal index1       : integer range 0 to 400;  -- 110001111  399
signal index2       : integer range 0 to 400;  -- 110001111  399
signal index3       : integer range 0 to 400;  -- 110001111  399

signal SynchFlag   : std_logic_vector(5 downto 0);

begin

PhaseSELECTION: process(clock,reset)
begin
if(reset='1') then

  FiringPulse_RisingEdge<=0;
  FiringPulse_FallingEdge<=0;
  
 elsif(rising_edge(clock)) then
   if(phaseSelect="000001") then     --zero degrees delay
       FiringPulse_RisingEdge<=333333; --0+60 degrees: pulse duration=120degrees(6.67ms)
       FiringPulse_FallingEdge<=1000000; --120 degrees +60 degrees
   elsif(phaseSelect="000010")then     --15 degrees degrees delay:pulse duration=105degrees(5.83ms)
       FiringPulse_RisingEdge<=416667;
       FiringPulse_FallingEdge<=1000000;  
   elsif(phaseSelect="000100")then     --30 degrees degrees delay:pulse duration=90degrees(5ms)
       FiringPulse_RisingEdge<=500000;
       FiringPulse_FallingEdge<=1000000;
   elsif(phaseSelect="001000")then      --45 degrees degrees delay: pulse duration=75degrees(4.16ms)
       FiringPulse_RisingEdge<=583333;
       FiringPulse_FallingEdge<=1000000;
   elsif(phaseSelect="010000")then     --60 degrees degrees delay: pulse duration=60degrees(3.33ms)
       FiringPulse_RisingEdge<=666667;
       FiringPulse_FallingEdge<=1000000;
   elsif(phaseSelect="010000")then      --75 degrees degrees delay: pulse duration=45degrees(2.5ms)
       FiringPulse_RisingEdge<=750000;
       FiringPulse_FallingEdge<=1000000;  
    elsif(phaseSelect="100000")then       --90 degrees degrees delay: pulse duration=30degrees(1.67ms)
       FiringPulse_RisingEdge<=833333;
       FiringPulse_FallingEdge<=1000000;  
     else
       FiringPulse_RisingEdge<=333333;    --zero degrees delay
       FiringPulse_FallingEdge<=1000000;   
     end if;

end if;
end process PhaseSELECTION

----------------------------------------------------
--squareWaves generation/ Real signals input
------------------------------------------------------
Gen_Squarewaves: process(clock,reset)

begin

if(reset='1') then
 
   SquareWave1_dly1  <='0';
   SquareWave1_dly2  <='0';

   SquareWave2_dly1  <='0';    
   SquareWave2_dly2  <='0'; 
    
   SquareWave3_dly1  <='0';
   SquareWave3_dly2  <='0';
   
elsif(rising_edge(clock)) then

    SquareWave1_dly1 <=NOT SquareWave1; 
    SquareWave1_dly2 <=SquareWave1_dly1;
    
    SquareWave2_dly1 <=NOT SquareWave2;
    SquareWave2_dly2 <=SquareWave2_dly1;
        
    SquareWave3_dly1 <=NOT SquareWave3;
    SquareWave3_dly2 <=SquareWave3_dly1;
    
end if; 
 
end process Gen_Squarewaves;

 ----------------------------------------------------
--Squarewave Comparator Process
---------------------------------------------------
SquareWave_Compatator: process(clock,reset)

begin

     if(reset='1') then
     
     SW1_CrossUp_Pulse<= '0';
     SW1_CrossDwn_Pulse<= '0';
     
     SW2_CrossUp_Pulse<= '0';
     SW2_CrossDwn_Pulse<= '0';
      
     SW3_CrossUp_Pulse<= '0';
     SW3_CrossDwn_Pulse<= '0';
                
     elsif(rising_edge(clock)) then
   
        if(SquareWave1_dly2='0' and SquareWave1_dly1='1')then            --rising edge
           SW1_CrossUp_Pulse<= '1';
        elsif(SquareWave1_dly2='1' and SquareWave1_dly1='0')then        --falling edge
           SW1_CrossDwn_Pulse<= '1';
        else
           SW1_CrossUp_Pulse<= '0';
           SW1_CrossDwn_Pulse<= '0';
        end if; 
          
        if(SquareWave2_dly2='0' and SquareWave2_dly1='1')then             --rising edge
           SW2_CrossUp_Pulse<= '1';
        elsif(SquareWave2_dly2='1' and SquareWave2_dly1='0')then          --falling edge
           SW2_CrossDwn_Pulse<= '1';
        else
           SW2_CrossUp_Pulse<= '0';
           SW2_CrossDwn_Pulse<= '0';
        end if;
          
        if(SquareWave3_dly2='0' and SquareWave3_dly1='1')then              --rising edge
           SW3_CrossUp_Pulse<= '1';
        elsif(SquareWave3_dly2='1' and SquareWave3_dly1='0')then         --falling edge
           SW3_CrossDwn_Pulse<= '1';
        else
           SW3_CrossUp_Pulse<= '0';
           SW3_CrossDwn_Pulse<= '0';
        end if;
            
    end if;    
 end process SquareWave_Compatator;
 
----------------------------------------------------
--Timer counters 
------------------------------------------------------
counters:process (clock,reset)

begin

  if(reset='1') then
  
   PhaseCounter1<=0;
   PhaseCounter2<=0;
   PhaseCounter3<=0;
   PhaseCounter4<=0;
   PhaseCounter5<=0;
   PhaseCounter6<=0;
     
   SynchFlag<="000000";
   
   elsif(rising_edge(clock)) then
   
    
    PhaseCounter1<=PhaseCounter1+1;
      if(SW1_CrossUp_Pulse='1')then
        PhaseCounter1<=0;              
        SynchFlag(0)<='1';
        end if;
               
   PhaseCounter2<=PhaseCounter2+1; 
      if(SW3_CrossDwn_Pulse='1')then
         PhaseCounter2<=0; 
         SynchFlag(1)<='1';             
        end if; 
        
   PhaseCounter3<=PhaseCounter3+1; 
     if(SW2_CrossUp_Pulse='1')then       
       PhaseCounter3<=0;
       SynchFlag(2)<='1';
       end if;
       
   PhaseCounter4<=PhaseCounter4+1;
      if(SW1_CrossDwn_Pulse='1')then
        PhaseCounter4<=0;             
        SynchFlag(3)<='1';
       end if; 
       
   PhaseCounter5<=PhaseCounter5+1; 
   if(SW3_CrossUp_Pulse='1')then
     PhaseCounter5<=0;               
     SynchFlag(4)<='1';
    end if;
    
   PhaseCounter6<=PhaseCounter6+1; 
   if(SW2_CrossDwn_Pulse='1')then         
      PhaseCounter6<=0;            
      SynchFlag(5)<='1';
    end if;
    
   end if;  
 end process counters; 
----------------------------------------------------------------------------------------

SCRs_Control:process (clock,reset)

begin

  if(reset='1') then
 
   Thyristors_Sig<=(others=>'1');
	  
  elsif(rising_edge(clock)) then
     --------------------------------------------------------------
	  --SCR T1 Control   --Sinewave1_CrossUp='1'
	  ---------------------------------------------------------------   
            if(PhaseCounter1=FiringPulse_RisingEdge) then
              Thyristors_Sig(0)<='1'; 
            elsif(PhaseCounter1=FiringPulse_FallingEdge)then
              Thyristors_Sig(0)<='0';
			 end if;
	  --------------------------------------------------------------
	  --SCR T2 Control  --Sinewave3_CrossDwn='1' 
	  -------------------------------------------------------  
           if(PhaseCounter2=FiringPulse_RisingEdge) then
			  Thyristors_Sig(1)<='1'; 
           elsif(PhaseCounter2=FiringPulse_FallingEdge)then
             Thyristors_Sig(1)<='0';
		  end if;
     --------------------------------------------------------------
	  --SCR T3 Control	--Sinewave2_CrossUp='1'	
     -----------------------------------------------------------
         if(PhaseCounter3=FiringPulse_RisingEdge) then
           Thyristors_Sig(2)<='1'; 
         elsif(PhaseCounter3=FiringPulse_FallingEdge)then
           Thyristors_Sig(2)<='0';
         end if;	
	 --------------------------------------------------------------
	 --SCR T4 Control    --Sinewave1_CrossDwn='1'
	 ----------------------------------------------------------
          if(PhaseCounter4=FiringPulse_RisingEdge) then
             Thyristors_Sig(3)<='1'; 
          elsif(PhaseCounter4=FiringPulse_FallingEdge)then
             Thyristors_Sig(3)<='0';
          end if;
	-------------------------------------------------------------
	--SCR T5 Control  --Sinewave3_CrossUp='1'
	-------------------------------------------------------------
          if(PhaseCounter5=FiringPulse_RisingEdge) then
             Thyristors_Sig(4)<='1'; 
          elsif(PhaseCounter5=FiringPulse_FallingEdge)then
             Thyristors_Sig(4)<='0';
          end if;
	--------------------------------------------------------------
	--SCR T6 Control  --Sinewave2_CrossDwn='1'
	--------------------------------------------------------------
       if(PhaseCounter6=FiringPulse_RisingEdge) then
          Thyristors_Sig(5)<='1'; 
       elsif(PhaseCounter6=FiringPulse_FallingEdge)then
          Thyristors_Sig(5)<='0';
       end if;  
  end if;
end process;
------------------------------------------------------------------------------------------------------------------------------------------    
   --use of SynchFlag: SCRs are not activated only after a complete full power cycle is elapsed just to make sure all six timers synchronized.
    Thyristors(0)<= Thyristors_Sig(0) when SynchFlag="111111" else'0';
    Thyristors(1)<= Thyristors_Sig(1) when SynchFlag="111111" else'0';
    Thyristors(2)<= Thyristors_Sig(2) when SynchFlag="111111" else'0';
    Thyristors(3)<= Thyristors_Sig(3) when SynchFlag="111111" else'0';
    Thyristors(4)<= Thyristors_Sig(4) when SynchFlag="111111" else'0';
    Thyristors(5)<= Thyristors_Sig(5) when SynchFlag="111111" else'0';
    
end rtl;

 

# Fire and Water
<details>
  <summary>📁 Project Overview (click to expand)</summary>  
  
  ## Theme 
  
  An interactive instrument based on capacitive sensing circuitry, You're enjoying an evening campfire in the woods, use the mug to create some ambience, but beware of things lurking in the forest or the WATER...
  
  ## Objective 
  
  To produce an interactive piece using capacitive sensing to generate a unique soundscape via the ChucK software.
  
  ## Preperation 
  
  This project utilises an Arduino UNO R3 board along with a circuit setup outlined in bonniee's mug-music: https://github.com/bonniee/mug-music and madlabdk's touche_peak file: https://github.com/madlabdk/touche
</details>

<details>
  <summary>📁 To Use Code (click to expand)</summary>
  
  ## Arduino Setup
    Install and open Arduino IDE
    Connect the board via USB
    Select Serial COM port from drop-down menu.
    Upload the provided Arduino sketch (touche_peak.ino) to your board.
    Connect the sensing wire (e.g., alligator clip) to the mug water.
    Ground yourself (e.g., by touching the laptop case) when using for best sensitivity.

  ## ChucK Setup
    Install ChucK
    Open a terminal or command prompt.
    Run the following command to see your serial ports:
    	chuck fireandwaterfinal.ck:PORT_NUMBER
    Replace PORT_NUMBER with the correct serial port index shown earlier in the Arduino IDE.
</details>

# Full Credits
Code adapted from:
- Mug Music, By Bonnie Eisenman and Harvest Zhang: https://github.com/bonniee/mug-music 
- madlabdk's touche_peak file is reproduced here without significant modifications: https://github.com/madlabdk/touche
- Mostly based on instructions here: www.instructables.com/id/Touche-for-Arduino-Advanced-touch-sensing/?ALLSTEPS
- Original Touché paper: http://www.disneyresearch.com/wp-content/uploads/touchechi2012.pdf
- ChucK software, Princeton University

<details>
  <summary>📁 Sound files are accessed from FreeSounds (click to expand)</summary>
  
    Footsteps
    530384__nox_sound__footsteps_boots_gritty_ground_stones_leaves_mono-glued.wav - 
    Bini_trns
    September 5th, 2016
    
    Wolves
    619844__andrastos87__forest_wolves_doom.mp3
    Andrastos87
    February 14th, 2022
    
    WaterQuench
    666289__ekrcoaster__water-steaming-on-hot-surface-2.ogg
    Ekrcoaster
    December 22nd, 2022
    
    FireCrackle
    firecrackleloop.wav
    FIREBurn_Burning Campfire.Crackling.Squawking.Flame Roar 4_EM_(15lrs).wav
    newlocknew
    June 4th, 2022
</details>

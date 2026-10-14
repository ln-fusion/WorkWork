depth = -1000;
Phase = 0;
counter = 0;
dia_wh = 127;
total_dia = 9 + ((((global.Screen_height + (dia_wh * global.screen_multiplier)) / ((dia_wh / 2) * global.screen_multiplier)) + ((global.Screen_width + (dia_wh * global.screen_multiplier)) / (dia_wh * global.screen_multiplier))) * 2);
currentspr = spr_Transition;
subimg = 9 + total_dia;
alpha = 1;

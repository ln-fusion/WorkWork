if (global.Game_Pause == 0)
{
    if (global.Phase == "Score")
    {
        if (scoreboard_freeze == 0)
        {
            if (scoreboard_scale > 1)
            {
                scoreboard_scale += -0.014;
            }
            else if (scoreboard_scale != 1)
            {
                scoreboard_scale = scr_Approach(scoreboard_scale, 1, 0.01);
            }
        }
        else
        {
            scoreboard_freeze_counter += 1;
            if (scoreboard_freeze_counter >= 3)
            {
                scoreboard_freeze = 0;
                scoreboard_freeze_counter = 0;
            }
        }
        if (fontpoints_freeze == 0)
        {
            if (fontpoints_scale > 1)
            {
                fontpoints_scale -= 0.03;
            }
            else if (fontpoints_scale != 1)
            {
                fontpoints_scale = scr_Approach(fontpoints_scale, 1, 0.03);
            }
        }
        else
        {
            fontpoints_freeze_counter += 1;
            if (fontpoints_freeze_counter >= 3)
            {
                fontpoints_freeze = 0;
                fontpoints_freeze = 0;
            }
        }
        if (fontmult_freeze == 0)
        {
            if (fontmult_scale > 1)
            {
                fontmult_scale -= 0.03;
            }
            else if (fontmult_scale != 1)
            {
                fontmult_scale = scr_Approach(fontmult_scale, 1, 0.03);
            }
        }
        else
        {
            fontmult_freeze_counter += 1;
            if (fontmult_freeze_counter >= 3)
            {
                fontmult_freeze = 0;
                fontmult_freeze_counter = 0;
            }
        }
    }
}
if (global.Game_Pause == 0 && global.Freeze_frame == 0)
{
    switch (global.Phase)
    {
        case "Start_setup":
            Text_preview = Text_atleast;
            scr_Stage_score(0);
            if (Gamestart == 0)
            {
                scr_Cat_positionplace_check(-4, -4);
                Gamestart = 1;
            }
            if (global.Boss == 0)
            {
                global.Phase = "Start_roll";
            }
            else
            {
                global.Phase = "BoonBane_wait";
            }
            if (audio_is_playing(bgm_02_Shop))
            {
                audio_sound_gain(bgm_02_Shop, 0, 2000);
                if (!audio_is_playing(bgm_03_Battle1))
                {
                    var var_music = audio_play_sound(bgm_03_Battle1, 99, true, 0, 0, 1);
                    audio_sound_gain(var_music, 1, 4800);
                }
            }
            break;
        case "Start_roll":
            if (Start_roll == 0 && Roll_counter == 0)
            {
                if (global.Start_points != 0)
                {
                    global.Chips += global.Start_points;
                }
                if (global.Start_mult != 0)
                {
                    global.Mult += global.Start_mult;
                }
            }
            if (scoreboard_subimg > (scoreboard_target * 2))
            {
                scoreboard_subimg -= 0.5;
                if (scoreboard_subimg < 0)
                {
                    scoreboard_subimg = 0;
                }
            }
            if (Midgame == 0)
            {
                if (Start_roll <= 5)
                {
                    Roll_counter += global.deltaTime;
                    if (Roll_counter >= Roll_counterMax)
                    {
                        var var_cat = -4;
                        with (obj_Cat)
                        {
                            if (Cat_pos == other.Start_roll)
                            {
                                Dice_create = 1;
                                var_cat = id;
                            }
                        }
                        if (var_cat == -4)
                        {
                            with (obj_Position)
                            {
                                if (Position == other.Start_roll)
                                {
                                    Dice_create = 1;
                                }
                            }
                        }
                        Roll_counter = 0;
                        Start_roll += 1;
                    }
                }
                else
                {
                    Start_roll = 0;
                    Roll_counter = 0;
                    global.Phase = "Start_wait";
                    Midgame = 1;
                    if (global.Bonus_null > 0)
                    {
                        if (!ds_list_empty(global_Level.List_bonus))
                        {
                            var var_num = irandom_range(0, ds_list_size(global_Level.List_bonus) - 1);
                            var var_bonus = ds_list_find_value(global_Level.List_bonus, var_num);
                            array_set(var_bonus, 3, -1);
                            scr_Bonus_initialize();
                        }
                    }
                }
            }
            else if (Midgame == 1)
            {
                if (Start_roll <= 5)
                {
                    var var_check = 0;
                    Roll_counter += global.deltaTime;
                    if (Roll_counter >= Roll_counterMax)
                    {
                        with (obj_Position)
                        {
                            if (Position == other.Start_roll)
                            {
                                if (Dice_ID != -4)
                                {
                                    var_check = 1;
                                    with (Dice_ID)
                                    {
                                        if (Rolling == 0)
                                        {
                                            if (Face_next > 0)
                                            {
                                                Dice_face = Face_next;
                                                Face_next = 0;
                                            }
                                            else
                                            {
                                                Dice_face = choose(1, 2, 3, 4, 5, 6);
                                            }
                                            with (obj_Dice_tray)
                                            {
                                                Dice_total += 1;
                                            }
                                            Dice_tray = obj_Dice_tray.Dice_total;
                                            Rolling = 1;
                                            Roll_dir = irandom_range(0, 359);
                                            spd = random_range(spdMin, spdMax);
                                            vx = cos(degtorad(Roll_dir)) * spd;
                                            vy = sin(degtorad(Roll_dir)) * -spd;
                                            spin = irandom_range(22, 26);
                                            rotate = irandom_range(0, 359);
                                            subimg = Dice_value[irandom_range(0, 5)];
                                        }
                                    }
                                    Dice_ID = -4;
                                }
                            }
                        }
                        if (var_check == 1)
                        {
                            Roll_counter = 0;
                        }
                        else
                        {
                            Roll_counter = Roll_counterMax;
                        }
                        Start_roll += 1;
                    }
                }
                else
                {
                    Start_roll = 0;
                    Roll_counter = 0;
                    global.Phase = "Start_wait";
                }
            }
            break;
        case "Start_wait":
            var var_check = 0;
            with (obj_Dice)
            {
                if (Rolling != 0)
                {
                    var_check = 1;
                }
            }
            if (var_check == 0)
            {
                global.Phase = "Play";
                scr_Save_meta();
                scr_Save_run();
                scr_Save_cat();
                scr_Save_dice();
            }
            break;
        case "Play":
            global.Chips_display = global.Chips;
            global.Mult_display = global.Mult;
            if (infobar_display == 1)
            {
                infobar_counter += 1;
                if (infobar_counter >= infobar_counterMax)
                {
                    infobar_display = 0;
                    infobar_counter = 0;
                }
            }
            break;
        case "Score":
            if (Score_start == 1)
            {
                if (Score_order <= 5)
                {
                    with (obj_Position)
                    {
                        if (Position == other.Score_order)
                        {
                            Cat_check = 1;
                        }
                    }
                }
                else
                {
                    global.Phase = "Score_wait";
                    global.Chips_display = global.Chips;
                    global.Mult_display = global.Mult;
                    Score_order = 0;
                    Wait_counter = 40;
                    global.Score_current = floor(global.Chips * global.Mult);
                }
                Score_start = 0;
            }
            if (scoreboard_subimg < (scoreboard_target * 2))
            {
                scoreboard_subimg += 0.5;
                if (scoreboard_subimg > (scoreboard_target * 2))
                {
                    scoreboard_subimg = scoreboard_target * 2;
                }
            }
            else if (scoreboard_subimg > (scoreboard_target * 2))
            {
                scoreboard_subimg -= 1;
                if (scoreboard_subimg < 0)
                {
                    scoreboard_subimg = 0;
                }
            }
            break;
        case "Score_wait":
            scoreboard_subimg = scr_Approach(scoreboard_subimg, scoreboard_target * 2, 0.2);
            scoreboard_scale = scr_Approach(scoreboard_scale, 1, 0.01);
            fontpoints_scale = scr_Approach(fontpoints_scale, 1, 0.04);
            fontmult_scale = scr_Approach(fontmult_scale, 1, 0.04);
            Wait_counter += global.deltaTime;
            if (Wait_counter >= Wait_counterMax)
            {
                Wait_counter = 20;
                scoreboard_subimg = scoreboard_target * 2;
                scoreboard_scale = 1;
                fontpoints_scale = 1;
                fontmult_scale = 1;
                global.Phase = "Score_display";
                centerboard_subimg = 1;
                audio_play_sound(sfx_Score_mult, 80, false, global.Ctrl_SFX, 0, global.Pitch_scoring);
                var var_total = floor(global.Chips_display * global.Mult_display);
                scoreboard_target = floor((var_total / global.Score_needed) * 9);
                if (scoreboard_target > 9)
                {
                    scoreboard_target = 9;
                    if (scoreboard_subimg >= (scoreboard_target * 2))
                    {
                        scoreboard_scale = 1.032;
                        scoreboard_freeze = 1;
                        if (global.Sparks_spd > 2)
                        {
                            instance_create_layer(308, 50, "UI", obj_vfx_sparks_emitter);
                            if (global.Sparks_spd > 5)
                            {
                                instance_create_layer(x, y, "UI", obj_screenshake_norm);
                            }
                        }
                        global.Sparks_spd += 1;
                    }
                }
                if (scoreboard_subimg == (scoreboard_target * 2) && scoreboard_subimg >= 4)
                {
                    scoreboard_subimg -= 0.5;
                }
            }
            break;
        case "Score_display":
            if (Wait_counter <= 22)
            {
                fontpoints_scale -= 0.01;
            }
            else if (Wait_counter <= 25)
            {
                fontpoints_scale += 0.088;
            }
            else
            {
                fontpoints_scale = scr_Approach(fontpoints_scale, 1, 0.04);
                scoreboard_scale = scr_Approach(scoreboard_scale, 1, 0.01);
                scoreboard_subimg = scr_Approach(scoreboard_subimg, scoreboard_target * 2, 0.5);
            }
            Wait_counter += global.deltaTime;
            if (Wait_counter >= Wait_counterMax)
            {
                Wait_counter = 30;
                fontpoints_scale = 1;
                scoreboard_target = 0;
                global.Phase = "Score_check";
                if (global.Track_21 == 1)
                {
                    global.Score_current = floor(global.Score_current * 2);
                }
                else if (global.Track_21 == -1)
                {
                    global.Score_current = floor(global.Score_current * 0.5);
                }
                if (global.Attempt_score == 1)
                {
                    if (global.Firstscore_bonus != 1)
                    {
                        global.Score_current = floor(global.Score_current * global.Firstscore_bonus);
                    }
                }
                if (global.Round_score == 0)
                {
                    if (global.Lastscore_bonus != 1)
                    {
                        global.Score_current = floor(global.Score_current * global.Lastscore_bonus);
                    }
                }
                global.Score_total += global.Score_current;
                global.Display_Score_current = global.Score_current;
            }
            break;
        case "Score_check":
            Wait_counter += global.deltaTime;
            if (Wait_counter >= Wait_counterMax)
            {
                if (global.Score_total >= global.Score_needed)
                {
                    global.Phase = "Round_won";
                    scoreboard_subimg = 0;
                    with (obj_Dice)
                    {
                        instance_destroy();
                    }
                    Midgame = 0;
                    with (obj_Dice_tray)
                    {
                        Dice_total = 0;
                    }
                    with (obj_Position)
                    {
                        Dice_ID = -4;
                    }
                    with (obj_Cat)
                    {
                        for (var var_i = 0; var_i < Passive_max; var_i += 1)
                        {
                            Cat_track[var_i] = 0;
                            if (Round_perm[var_i] == 0)
                            {
                                Round_chips[var_i] = 0;
                                Round_mult[var_i] = 0;
                            }
                        }
                    }
                }
                else
                {
                    with (obj_Cat)
                    {
                        if (Passive_increase > 0)
                        {
                            Passive_increase = 0;
                        }
                    }
                    with (obj_Dice)
                    {
                        Score_num = 0;
                    }
                    if (global.Round_score > 0)
                    {
                        global.Phase = "Start_roll";
                    }
                    else
                    {
                        global.Phase = "Round_loss";
                        audio_group_set_gain(audiogroup_Music, 0, 800);
                    }
                }
                Wait_counter = 0;
                centerboard_subimg = 0;
                global.Pitch_scoring = global.Pitch_scoring_start;
                global.Scoring_spd = 0;
                global.Sparks_spd = 0;
                global.Score_current = 0;
                global.Chips = 0;
                global.Chips_next = 0;
                global.Chips_display = 0;
                global.Mult = 0;
                global.Mult_next = 0;
                global.Mult_display = 0;
                global.Passive_scoring = 0;
                scr_Dice_combo_reset();
                scr_Cat_positionplace_check(-4, -4);
                if (global.Phase == "Round_won")
                {
                    global.Chips_display = "";
                    global.Mult_display = "";
                    infobar_win = 1;
                }
            }
            break;
        case "Round_won":
            global.Chips_display = "";
            global.Mult_display = "";
            infobar_win = 1;
            scr_Cat_endround_check();
            with (obj_Cat)
            {
                if (Passive_increase > 0)
                {
                    Passive_increase = 0;
                }
                Cat_moved = 0;
                Anim_state = -2;
            }
            with (obj_Dice)
            {
                Score_num = 0;
            }
            scr_Cat_positionplace_check(-4, -4);
            if (global.Bonus_null > 0)
            {
                if (!ds_list_empty(global_Level.List_bonus))
                {
                    for (var var_i = 0; var_i < ds_list_size(global_Level.List_bonus); var_i += 1)
                    {
                        array_set(ds_list_find_value(global_Level.List_bonus, var_i), 3, 1);
                    }
                    scr_Bonus_initialize();
                }
            }
            global.Phase = "Round_won_display";
            audio_play_sound(sfx_Jingle_win, 99, false, global.Ctrl_SFX, 0, 1);
            instance_create_layer(308, 50, "UI", obj_vfx_coin_emitter);
            break;
        case "Round_won_display":
            win_subimg += 0.052;
            if (win_subimg >= 10.8)
            {
                win_subimg = 0;
                infobar_win = 0;
                global.Phase = "Round_end";
                instance_create_layer(71, 14, "UI", obj_Display_Scoreboard);
                audio_group_set_gain(audiogroup_Music, 0, 2000);
            }
            break;
        case "Round_end":
            break;
        case "Round_loss":
            global.Chips_display = "";
            global.Mult_display = "";
            centerboard_subimg = 3;
            Wait_counter += 1;
            if (Wait_counter == 20)
            {
                audio_play_sound(sfx_Jingle_defeat, 99, false, global.Ctrl_SFX, 0, 1);
            }
            if (Wait_counter >= 100)
            {
                if (global.Lmouse_pressed)
                {
                    global.Freeze_frame = 2;
                    if (file_exists("Save_RunData.sav"))
                    {
                        file_delete("Save_RunData.sav");
                    }
                    if (file_exists("Save_CatData.sav"))
                    {
                        file_delete("Save_CatData.sav");
                    }
                    if (file_exists("Save_DicenData.sav"))
                    {
                        file_delete("Save_DiceData.sav");
                    }
                    if (file_exists("Save_ShopData.sav"))
                    {
                        file_delete("Save_ShopData.sav");
                    }
                    with (instance_create_layer(0, 0, "Controllers", obj_Screen_transition))
                    {
                        Auto = 1;
                        target_room = rm_Titlescreen;
                    }
                    with (par_Menu)
                    {
                        instance_destroy();
                    }
                }
            }
            break;
    }
}
else if (global.Game_Pause == 1)
{
}

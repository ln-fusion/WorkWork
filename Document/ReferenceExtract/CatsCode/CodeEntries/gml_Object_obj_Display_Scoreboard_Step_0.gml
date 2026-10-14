if (global.Game_Pause == 0)
{
    if (Phase >= 0)
    {
        global.Freeze_frame = 2;
    }
    switch (Phase)
    {
        case 0:
            counter += global.deltaTime;
            if (counter >= counter_max)
            {
                counter = 0;
                Phase = 1;
                Total_earned += (global.Stage_earnings + global.Extra_earnings);
                audio_play_sound(sfx_Score_points, 90, false, global.Ctrl_SFX, 0, 0.96);
            }
            break;
        case 1:
            counter += global.deltaTime;
            if (counter >= counter_max)
            {
                counter = 0;
                Phase = 2;
                Total_earned += global.Round_score;
                audio_play_sound(sfx_Score_points, 90, false, global.Ctrl_SFX, 0, 1);
            }
            break;
        case 2:
            counter += global.deltaTime;
            if (counter >= counter_max)
            {
                counter = -10;
                Phase = 3;
                Total_earned += Interest_earned;
                audio_play_sound(sfx_Score_points, 90, false, global.Ctrl_SFX, 0, 1.04);
            }
            break;
        case 3:
            counter += global.deltaTime;
            if (counter >= counter_max)
            {
                counter = 0;
                Phase = 4;
                audio_play_sound(sfx_Score_mult, 90, false, global.Ctrl_SFX, 0, 1.08);
                audio_group_set_gain(audiogroup_Music, global.Ctrl_Music, 0);
                audio_group_stop_all(audiogroup_Music);
            }
            break;
        case 4:
            if (global.Lmouse_pressed)
            {
                audio_play_sound(sfx_UI_money_gain, 80, false, global.Ctrl_SFX, 0, 1);
                global.Player_gold += (global.Stage_earnings + global.Extra_earnings);
                global.Player_gold += global.Round_score;
                global.Player_gold += Interest_earned;
                global.Stage_progress += 1;
                scr_Stage_score(0);
                with (obj_Ctrl_Cat)
                {
                    Text_preview = Text_nextround;
                }
                global.Phase = "Shop_wait";
                global.Attempt_score = 0;
                global.Round_score = "";
                global.Round_reroll = "";
                global.Score_current = 0;
                global.Score_total = 0;
                global.DicePrevious_value = 0;
                global.Stage_earnings = 0;
                global.Track_reroll = 0;
                global.Freeze_frame = 0;
                instance_destroy();
                exit;
            }
            break;
        case -1:
            counter += global.deltaTime;
            if (counter >= counter_max)
            {
                global.Phase = "Score_check";
                with (obj_Ctrl_Cat)
                {
                    global.Score_current = global.Display_Score_current;
                    infobar_win = 0;
                    centerboard_subimg = 1;
                }
                counter = 0;
                Phase = -2;
                with (instance_create_layer(x + 8, y + 44 + 40 + 80, "UI", obj_Exlink))
                {
                    ini_open(global.lang_file);
                    Text = ini_read_string("Base_text", "Steam_title", "");
                    ini_close();
                    External_link = "https://store.steampowered.com/app/3128280/Cats__Dice/";
                }
                with (instance_create_layer(x + 8, y + 44 + 40 + 108, "UI", obj_Exlink))
                {
                    ini_open(global.lang_file);
                    Text = ini_read_string("Base_text", "Discord_title", "");
                    ini_close();
                    External_link = "https://discord.gg/XCVew3K";
                }
                if (!instance_exists(obj_Scoreboard_hideshow))
                {
                    instance_create_layer(x + 468, y + 300, "UI", obj_Scoreboard_hideshow);
                }
            }
            break;
    }
}
else if (global.Game_Pause == 1)
{
}

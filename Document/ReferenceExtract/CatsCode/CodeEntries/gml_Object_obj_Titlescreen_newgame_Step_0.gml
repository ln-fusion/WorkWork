if (Ready != -1)
{
    switch (Ready)
    {
        case 0:
            if (!instance_exists(obj_Screen_transition_start))
            {
                Ready = 0.5;
            }
            break;
        case 0.5:
            wait_counter += 1;
            if (wait_counter >= 12)
            {
                alpha = 0.2;
                Ready = 1;
                wait_counter = 0;
            }
            break;
        case 1:
            alpha += 0.02;
            subimg += 0.2;
            if (subimg >= 2.9)
            {
                currentspr = spr_Titlescreen_start;
                subimg = 0;
                alpha = 1;
                Ready = -1;
            }
            break;
    }
    exit;
}
if (Proceed == 1)
{
    wait_counter += 1;
    if (wait_counter >= 30)
    {
        room_goto_next();
        with (obj_Screen_transition)
        {
            Phase = 1;
        }
    }
    exit;
}
if (global.Game_Pause == 0)
{
    if (position_meeting(obj_Cursor.x, obj_Cursor.y, id))
    {
        if (subimg == 0)
        {
            audio_play_sound(sfx_UI_basic_mouseover, 80, false, global.Ctrl_SFX, 0, random_range(0.98, 1.02));
        }
        subimg = 1;
        shift_y = -1;
        if (global.Lmouse_pressed)
        {
            audio_play_sound(sfx_UI_button_click, 90, false, global.Ctrl_SFX, 0, random_range(0.96, 1.02));
            Proceed = 1;
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
            instance_create_layer(0, 0, "Controllers", obj_Screen_transition);
        }
    }
    else
    {
        subimg = 0;
        shift_y = 0;
    }
}
else if (global.Game_Pause == 1)
{
}

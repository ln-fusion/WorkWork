if (global.Game_Pause == 1)
{
    if (Interactable == 1)
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
                with (instance_create_layer(0, 0, "Controllers", obj_Screen_transition))
                {
                    Auto = 1;
                    target_room = rm_Titlescreen;
                }
                with (par_Menu)
                {
                    instance_destroy();
                }
                audio_group_set_gain(audiogroup_Music, 0, 2000);
            }
        }
        else
        {
            subimg = 0;
            shift_y = 0;
        }
    }
}
else if (global.Game_Pause == 0)
{
}

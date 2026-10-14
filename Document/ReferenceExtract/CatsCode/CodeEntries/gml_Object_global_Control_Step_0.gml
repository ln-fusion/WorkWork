if (steam_is_screenshot_requested())
{
    screen_save(working_directory + "Screenshot_" + string(Screenshot++) + ".png");
}
global.Escape = keyboard_check_pressed(kEscape);
global.Lmouse_click = mouse_check_button(kLmouse);
global.Lmouse_pressed = mouse_check_button_pressed(kLmouse);
global.Rmouse_pressed = mouse_check_button_pressed(kRmouse);
global.Space_pressed = keyboard_check_pressed(kSpace);
global.One_pressed = keyboard_check_pressed(ord("1"));
global.Two_pressed = keyboard_check_pressed(ord("2"));
global.Three_pressed = keyboard_check_pressed(ord("3"));
global.Four_pressed = keyboard_check_pressed(ord("4"));
global.Five_pressed = keyboard_check_pressed(ord("5"));
global.Six_pressed = keyboard_check_pressed(ord("6"));
if (global.Escape)
{
    scr_GamePause();
}
if (global.Game_Pause == 0)
{
    if (global.Freeze_frame == 1)
    {
        Freeze_counterMax = 5 - (global.Scoring_spd / 3);
        if (Freeze_counterMax < 2)
        {
            Freeze_counterMax = 2;
        }
        Freeze_counter += global.deltaTime;
        if (Freeze_counter >= Freeze_counterMax)
        {
            Freeze_counter = 0;
            global.Freeze_frame = 0;
        }
    }
}
else if (global.Game_Pause == 3)
{
    if (instance_exists(obj_Screen_transition_start))
    {
        with (obj_Screen_transition_start)
        {
            instance_destroy();
        }
    }
    global.Game_Pause = 0;
    global.Freeze_frame = 0;
    scr_GamePause();
}
if (Music_start == 0)
{
    audio_sound_gain(bgm_01_Intro, 1, 0);
    var var_intro = audio_play_sound(bgm_01_Intro, 99, true, 0, 0, 1);
    audio_sound_gain(var_intro, 1, 2000);
    Music_start = 1;
}

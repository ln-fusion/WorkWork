if (global.Game_Pause == 0)
{
    if (Sound_create == 0)
    {
        audio_play_sound(sfx_Score_diceup, 80, false, global.Ctrl_SFX, 0, 1);
        Sound_create = 1;
    }
    subimg += 0.16;
    if (subimg >= 7.8)
    {
        instance_destroy();
        exit;
    }
    alpha -= 0.01;
    if (alpha <= 0)
    {
        instance_destroy();
    }
}
else if (global.Game_Pause == 1)
{
}

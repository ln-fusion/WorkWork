global.Game_Pause = 2;
global.Freeze_frame = 2;
switch (Phase)
{
    case 0:
        counter += 1;
        if (counter >= 30)
        {
            Phase = 1;
            counter = 0;
        }
        break;
    case 1:
        subimg -= 0.6;
        if (subimg <= 0)
        {
            subimg = 0;
            global.Game_Pause = 0;
            global.Freeze_frame = 0;
            instance_destroy();
        }
        break;
}

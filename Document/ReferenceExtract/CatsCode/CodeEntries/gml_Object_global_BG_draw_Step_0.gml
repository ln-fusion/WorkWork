x_offset += x_spd;
y_offset += y_spd;
if (x_offset == 256)
{
    x_offset = 0;
    y_offset = 0;
}
switch (global.Phase)
{
    case 0:
        break;
    case "Start_roll":
        if (subimg != 0)
        {
            Change = 1;
            previous_subimg = subimg;
            subimg = 0;
        }
        if (Change == 0)
        {
            subimg = 0;
        }
        break;
    case "Play":
        if (Change == 0)
        {
            subimg = 0;
        }
        break;
    case "Shop_start":
        if (subimg != 1)
        {
            Change = 1;
            previous_subimg = subimg;
            subimg = 1;
        }
        if (Change == 0)
        {
            subimg = 1;
        }
        break;
    case "Shop_load":
        if (Change == 0)
        {
            subimg = 1;
        }
        break;
    case "BoonBane_start":
        if (subimg != 2)
        {
            Change = 1;
            previous_subimg = subimg;
            subimg = 2;
        }
        if (Change == 0)
        {
            subimg = 2;
        }
        break;
    case "BoonBane":
        if (Change == 0)
        {
            subimg = 2;
        }
        break;
}
if (Change == 1)
{
    alpha -= 0.02;
    if (alpha <= 0)
    {
        Change = 0;
        alpha = 1;
    }
}

function scr_Stage_score(arg0)
{
    var var_Boss = 0;
    if (global.Stage_progress > 1)
    {
        if ((global.Stage_progress % 4) == 0)
        {
            var_Boss = 1;
            global.Stage_earnings = 6;
        }
        else
        {
            global.Stage_earnings = 5;
        }
    }
    else
    {
        global.Stage_earnings = 4;
    }
    if (arg0 == 0)
    {
        switch (global.Stage_progress)
        {
            case 0:
                global.Score_needed = 300;
                break;
            case 1:
                global.Score_needed = 500;
                break;
            case 2:
                global.Score_needed = 800;
                break;
            case 3:
                global.Score_needed = 1400;
                break;
            case 4:
                global.Score_needed = 2400;
                break;
            case 5:
                global.Score_needed = 3800;
                break;
            case 6:
                global.Score_needed = 6200;
                break;
            case 7:
                global.Score_needed = 10000;
                break;
            case 8:
                global.Score_needed = 15000;
                break;
            case 9:
                global.Score_needed = 22000;
                break;
            case 10:
                global.Score_needed = 32000;
                break;
            case 11:
                global.Score_needed = 46000;
                break;
            case 12:
                global.Score_needed = 68000;
                break;
            case 13:
                global.Score_needed = 98000;
                break;
            case 14:
                global.Score_needed = 140000;
                break;
            case 15:
                global.Score_needed = 200000;
                break;
            case 16:
                global.Score_needed = 280000;
                break;
            case 17:
                global.Score_needed = 380000;
                break;
            case 18:
                global.Score_needed = 500000;
                break;
            case 19:
                global.Score_needed = 640000;
                break;
            case 20:
                global.Score_needed = 800000;
                break;
            case 21:
                global.Score_needed = 1000000;
                break;
            case 22:
                global.Score_needed = 1200000;
                break;
            case 23:
                global.Score_needed = 1500000;
                break;
            case 24:
                global.Score_needed = 2000000;
                break;
            case 25:
                break;
        }
    }
    global.Boss = var_Boss;
}

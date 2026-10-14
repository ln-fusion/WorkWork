if (global.Game_Pause == 0)
{
    if (Progress == 0)
    {
        if (room == rm_Battlestage)
        {
            Progress = 1;
        }
        else
        {
            exit;
        }
    }
    if (Setup > 0)
    {
        switch (Setup)
        {
            case 1.1:
                x = obj_Button_Score.x - 222;
                y = obj_Dice_tray.y - 54;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress1_body", "");
                ini_close();
                break;
            case 2:
                x = obj_Dice_tray.x + 4;
                y = obj_Dice_tray.y + 40;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress2_body", "");
                ini_close();
                break;
            case 3:
                x = obj_Button_Bonus.x - 26;
                y = obj_Button_Bonus.y + 14;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress3_body", "");
                ini_close();
                break;
            case 4:
                x = obj_Button_Score.x - 200;
                y = obj_Dice_tray.y + 8;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress4_body", "");
                ini_close();
                break;
            case 5:
                x = obj_Button_Score.x - 200;
                y = obj_Dice_tray.y + 8;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress5_body", "");
                ini_close();
                break;
            case 6:
                x = 464;
                y = 54;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress6_body", "");
                ini_close();
                break;
            case 7.1:
                x = obj_Dice_tray.x + 4;
                y = obj_Dice_tray.y - 48;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress7_body", "");
                ini_close();
                break;
            case 8:
                x = obj_Dice_tray.x + 4;
                y = obj_Dice_tray.y - 48;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress8_body", "");
                ini_close();
                break;
            case 9:
                x = obj_Dice_tray.x + 40;
                y = obj_Dice_tray.y - 104;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress9_body", "");
                ini_close();
                break;
            case 10:
                x = obj_Dice_tray.x + 172;
                y = obj_Dice_tray.y - 24;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress10_body", "");
                ini_close();
                break;
            case 11:
                x = obj_Dice_tray.x + 172;
                y = obj_Dice_tray.y - 24;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress11_body", "");
                ini_close();
                break;
            case 12:
                x = (obj_Dice_tray.x + obj_Dice_tray.Set_ticket_x) - 86;
                y = obj_Dice_tray.y - 24;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress12_body", "");
                ini_close();
                break;
            case 13:
                x = obj_Button_Score.x - 128;
                y = obj_Button_Score.y - 24;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress13_body", "");
                ini_close();
                break;
            case 14:
                x = obj_Button_Score.x - 128;
                y = obj_Button_Score.y - 24;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress14_body", "");
                ini_close();
                break;
        }
        Setup = 0;
    }
    switch (Progress)
    {
        case 1:
            if (global.Phase == "Play")
            {
                global.Freeze_frame = 1;
                with (global_Control)
                {
                    Freeze_counter = 0;
                }
                x = obj_Button_Score.x - 222;
                y = obj_Dice_tray.y - 54;
                Progress = 1.1;
                Show = 1;
                ini_open(global.lang_file);
                Text1 = ini_read_string("Tutorial_text", "Progress1_body", "");
                ini_close();
            }
            break;
        case 1.1:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 1/6)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 2;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress2_body", "");
                    ini_close();
                    Text2 = "";
                    x = obj_Dice_tray.x + 4;
                    y = obj_Dice_tray.y + 40;
                }
            }
            break;
        case 2:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 2/6)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 3;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress3_body", "");
                    ini_close();
                    Text2 = "";
                    x = obj_Button_Bonus.x - 26;
                    y = obj_Button_Bonus.y + 14;
                }
            }
            break;
        case 3:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 3/6)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 4;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress4_body", "");
                    ini_close();
                    Text2 = "";
                    x = obj_Button_Score.x - 200;
                    y = obj_Dice_tray.y + 8;
                }
            }
            break;
        case 4:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 4/6)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 5;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress5_body", "");
                    ini_close();
                    Text2 = "";
                }
            }
            break;
        case 5:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 5/6)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    x = 464;
                    y = 54;
                    Progress = 6;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress6_body", "");
                    ini_close();
                    Text2 = "";
                }
            }
            break;
        case 6:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 6/6)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    global.Freeze_frame = 0;
                    counter = 0;
                    Progress = 7;
                    Text2 = "";
                    Show = 0;
                }
            }
            break;
        case 7:
            if (global.Phase == "Shop")
            {
                counter += 1;
                if (counter >= (counter_max - 6))
                {
                    global.Freeze_frame = 1;
                    with (global_Control)
                    {
                        Freeze_counter = 0;
                    }
                    x = obj_Dice_tray.x + 4;
                    y = obj_Dice_tray.y - 48;
                    counter = 0;
                    Progress = 7.1;
                    Show = 1;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress7_body", "");
                    ini_close();
                }
            }
            break;
        case 7.1:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 1/8)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 8;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress8_body", "");
                    ini_close();
                    Text2 = "";
                }
            }
            break;
        case 8:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 2/8)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 9;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress9_body", "");
                    ini_close();
                    Text2 = "";
                    x = obj_Dice_tray.x + 40;
                    y = obj_Dice_tray.y - 104;
                }
            }
            break;
        case 9:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 3/8)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 10;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress10_body", "");
                    ini_close();
                    Text2 = "";
                    x = obj_Dice_tray.x + 172;
                    y = obj_Dice_tray.y - 24;
                }
            }
            break;
        case 10:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 4/8)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 11;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress11_body", "");
                    ini_close();
                    Text2 = "";
                }
            }
            break;
        case 11:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 5/8)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 12;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress12_body", "");
                    ini_close();
                    Text2 = "";
                    x = (obj_Dice_tray.x + obj_Dice_tray.Set_ticket_x) - 86;
                    y = obj_Dice_tray.y - 24;
                }
            }
            break;
        case 12:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 6/8)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 13;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress13_body", "");
                    ini_close();
                    Text2 = "";
                    x = obj_Button_Score.x - 128;
                    y = obj_Button_Score.y - 24;
                }
            }
            break;
        case 13:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 7/8)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    counter = 0;
                    Progress = 14;
                    ini_open(global.lang_file);
                    Text1 = ini_read_string("Tutorial_text", "Progress14_body", "");
                    ini_close();
                    Text2 = "";
                }
            }
            break;
        case 14:
            Show = 1;
            global.Freeze_frame = 1;
            with (global_Control)
            {
                Freeze_counter = 0;
            }
            counter += 1;
            if (counter >= counter_max)
            {
                if (Text2 == "")
                {
                    Text2 = Text_proceed + " 8/8)";
                }
                if (global.Lmouse_pressed || global.Rmouse_pressed)
                {
                    instance_destroy();
                }
            }
            break;
    }
    global.Tut_Progress = Progress;
}
else if (global.Game_Pause == 1)
{
}

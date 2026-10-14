function scr_Boonbane_text(arg0, arg1)
{
    var var_Text = "";
    if (arg0 == "Boon")
    {
        switch (arg1)
        {
            case UnknownEnum.Value_0:
                ini_open(global.lang_file);
                Text = ini_read_string("Boonbane_text", "Boon_bonus", "") + " " + ini_read_string("Mechanics_text", "Blackjack_title", "") + ini_read_string("Mechanics_text", "Blackjack_body", "");
                ini_close();
                currentspr = spr_Boonbanetied_choose;
                break;
            case UnknownEnum.Value_1:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Boon0", "");
                ini_close();
                break;
            case UnknownEnum.Value_2:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Boon1", "");
                ini_close();
                break;
            case UnknownEnum.Value_3:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Boon2", "");
                ini_close();
                break;
            case UnknownEnum.Value_4:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Boon3", "");
                ini_close();
                break;
            case UnknownEnum.Value_5:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Boon4", "");
                ini_close();
                break;
            case UnknownEnum.Value_6:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Boon5", "");
                ini_close();
                break;
        }
    }
    else if (arg0 == "Bane")
    {
        switch (arg1)
        {
            case UnknownEnum.Value_1:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Bane0", "");
                ini_close();
                break;
            case UnknownEnum.Value_2:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Bane1", "");
                ini_close();
                break;
            case UnknownEnum.Value_3:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Bane2", "");
                ini_close();
                break;
            case UnknownEnum.Value_4:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Bane3", "");
                ini_close();
                break;
            case UnknownEnum.Value_5:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Bane4", "");
                ini_close();
                break;
            case UnknownEnum.Value_6:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Bane5", "");
                ini_close();
                break;
            case UnknownEnum.Value_9:
                ini_open(global.lang_file);
                var_Text = ini_read_string("Boonbane_text", "Bane6", "");
                ini_close();
                break;
        }
    }
    return var_Text;
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4,
    Value_5,
    Value_6,
    Value_9 = 9
}

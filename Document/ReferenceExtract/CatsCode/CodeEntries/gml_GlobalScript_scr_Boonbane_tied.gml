function scr_Boonbane_tied(arg0)
{
    if (arg0 == UnknownEnum.Value_0 || arg0 == UnknownEnum.Value_8)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

enum UnknownEnum
{
    Value_0,
    Value_8 = 8
}

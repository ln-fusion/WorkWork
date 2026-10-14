function scr_Dice_setup(arg0)
{
    if (arg0 == -4)
    {
        for (var var_i = 1; var_i < 7; var_i += 1)
        {
            Dice_value[var_i] = var_i;
            Dice_effect[var_i] = [];
        }
    }
    else
    {
        for (var var_i = 1; var_i < 7; var_i += 1)
        {
            Dice_value[var_i] = arg0.Dice_value[var_i];
            var var_len = array_length(arg0.Dice_effect[var_i]);
            array_copy(Dice_effect[var_i], 0, arg0.Dice_effect[var_i], 0, var_len);
        }
    }
}

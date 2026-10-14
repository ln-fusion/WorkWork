x = mouse_x;
y = mouse_y;
if (wait_counter > 0)
{
    wait_counter -= 1;
    if (wait_counter <= 0)
    {
        wait_counter = 0;
        Holding = 0;
    }
}

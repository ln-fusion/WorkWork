if (global.Game_Pause == 0)
{
    part_system_automatic_update(pluspoints_system, true);
    counter += global.deltaTime;
    if (counter >= counter_max)
    {
        part_emitter_destroy(pluspoints_system, pluspoints_emitter);
    }
    if (part_particles_count(pluspoints_system) == 0)
    {
        part_type_destroy(pluspoints_type);
        part_system_destroy(pluspoints_system);
        instance_destroy();
        exit;
    }
}
else if (global.Game_Pause == 1)
{
    part_system_automatic_update(pluspoints_system, false);
}

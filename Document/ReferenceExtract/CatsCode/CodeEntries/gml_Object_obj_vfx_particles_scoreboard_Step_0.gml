if (global.Game_Pause == 0)
{
    part_system_automatic_update(scoreboard_system, true);
    if (part_particles_count(scoreboard_system) == 0)
    {
        part_type_destroy(scoreboard_type);
        part_system_destroy(scoreboard_system);
        part_emitter_destroy(scoreboard_system, scoreboard_emitter);
        instance_destroy();
        exit;
    }
}
else if (global.Game_Pause == 1)
{
    part_system_automatic_update(scoreboard_system, false);
}

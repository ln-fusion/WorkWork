if (part_emitter_exists(scoreboard_system, scoreboard_emitter))
{
    part_emitter_destroy(scoreboard_system, scoreboard_emitter);
}
if (part_type_exists(scoreboard_type))
{
    part_type_destroy(scoreboard_type);
}
if (part_system_exists(scoreboard_system))
{
    part_system_destroy(scoreboard_system);
}

#!include "constants.opy"
#!include "variables.opy"
#!include "config.opy"
#!include "util.opy"
#!include "notes.opy"

rule "Initialize Global":
    @Event global
    scores = [0,0,0,0]

    registerConfig(bool, "Switch Teams Enabled", "Switch Teams", opt_SwitchTeams_Enabled, true, 0)
    registerConfig(int[15:900], "Switch Teams Time (Seconds)", "Switch Teams", opt_SwitchTeams_Time, 60, 1)
    registerConfig(bool, "Enable Server Stats Monitor", "Advanced", opt_EnableServerStats, false, 0)
    registerConfig(float[1:10], "Update Shared Stats Interval", "Advanced", opt_UpdateServerStatsInterval, 2, 1)
    registerConfig(bool, "Team Balance Enabled", "Team Balance", opt_TeamBalance_Enabled, true, 0)
    registerConfig(bool, "Team Balance Swap Players Teams", "Team Balance", opt_TeamBalance_MovePlayers, true, 0)
    registerConfig(bool, "Team Balance Spawn Bots", "Team Balance", opt_TeamBalance_SpawnBot, true, 0)
    registerConfig(int[0:6], "Team Balance Spawn Bot Count", "Team Balance", opt_TeamBalance_SpawnBotCount, 3, 0)

    spawn = [
        false,
        vect(49.469, -1.611, -13.959),
        vect(35.795, 4.230, -23.222),
        getConfig(opt_SwitchTeams_Time)
    ]
    
    createHud(clientOnly(), "\u200b\n\n\n\n\nNUCLEAR", 5, HudPosition.LEFT, Color.RED, SpecVisibility.ALWAYS)
    createHud(clientOnly(), "WEAPONS", 6, HudPosition.LEFT, Color.ORANGE, SpecVisibility.ALWAYS)
    createHud(clientOnly(), "WAREHOUSE\n", 7, HudPosition.LEFT, Color.YELLOW, SpecVisibility.ALWAYS)

    createHud(clientOnly(), "{}  SCORE: {}".format(
        abilityIconString(Hero.ECHO, Button.SECONDARY_FIRE), getTeamScore(localPlayer.getTeam())
    ), 8, HudPosition.LEFT, Color.WHITE, SpecVisibility.NEVER)

    createHud(clientOnly(), "{}  ENEMY SCORE: {}".format(
        iconString(Icon.SKULL), getTeamScore(getOppositeTeam(localPlayer.getTeam()))
    ), 9, HudPosition.LEFT, Color.WHITE, SpecVisibility.NEVER)

    createHud(clientOnly(), "{}  SCORE DIFFERENCE: {}".format(
        abilityIconString(Hero.MOIRA, Button.ABILITY_2), 
        getTeamScore(localPlayer.getTeam()) - getTeamScore(getOppositeTeam(localPlayer.getTeam()))
    ), 10, HudPosition.LEFT, Color.WHITE, SpecVisibility.NEVER)

    createHud(clientOnly(), "{}  HIGHEST TEAM SCORE: {}".format(
        iconString(Icon.DIAMOND), getTeamHighScore(localPlayer.getTeam())
    ), 11, HudPosition.LEFT, Color.WHITE, SpecVisibility.NEVER)

    createHud(clientOnly(), "\u200b\n{}  GLOBAL DAMAGE DONE: {}".format(
        abilityIconString(Hero.ROADHOG, Button.ULTIMATE), statText[STAT_DAMAGE]
    ), 12, HudPosition.LEFT, Color.WHITE, SpecVisibility.ALWAYS)

    createHud(clientOnly(), "{}  GLOBAL HEALING DONE: {}".format(
        abilityIconString(Hero.ZENYATTA, Button.ULTIMATE), statText[STAT_HEAL]
    ), 13, HudPosition.LEFT, Color.WHITE, SpecVisibility.ALWAYS)

    createHud(clientOnly(), "\u200b\n{}  TEAMS SPAWN SWITCHING IN: {}".format(
        iconString(Icon.RECYCLE), getTimeFormat(spawn[3])
    ), 14, HudPosition.LEFT, Color.GREEN, SpecVisibility.ALWAYS)

    createHud(clientOnly(), "{}  MATCH TIME: {}".format(
        iconString(Icon.SPIRAL), getTimeFormat(getMatchTime())
    ), 15, HudPosition.LEFT, Color.LIME_GREEN, SpecVisibility.ALWAYS)


    disableAnnouncer()
    disableMusic()

    tempVarY = 3
    inWorldText(null, "NUCLEAR WEAPONS WAREHOUSE".format(iconString(Icon.SKULL)), vect(26.989, tempVarY, -20.708), Color.ORANGE)
    
    tempVarY -= 0.30
    inWorldText(null, "SCOREBOARD", vect(26.989, tempVarY, -20.708), Color.YELLOW)
    
    tempVarY -= 0.35
    inWorldText(null, "TEAM 1: {}".format(scores[0]), vect(26.989, tempVarY, -20.708), Color.WHITE)
    
    tempVarY -= 0.30
    inWorldText(null, "TEAM 2: {}".format(scores[1]), vect(26.989, tempVarY, -20.708), Color.WHITE)

rule "Initialize player":
    @Event playerJoined
    @Condition eventPlayer.isDummy() == false
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableDeathSpectateTargetHud()
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableVoiceChat(true, false, false)

#!include "modules/stats.opy"
#!include "modules/spawn.opy"
#!include "modules/score.opy"
#!include "modules/icon.opy"
#!include "modules/balance.opy"
#!include "modules/bots.opy"

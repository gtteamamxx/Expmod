/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <expmod_achievements>

#define PLUGIN "ExpMod Achievement UMP45"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"

#define WEAP CSW_UMP45

new const szNameI[] = "Mistrz UMP I";
new const szNameII[] = "Mistrz UMP II";
new const szNameIII[] = "Mistrz UMP III";

new const szDescI[] = "Zabij z UMP45 140 wrogow";
new const szDescII[] = "Zabij z UMP45 300 wrogow";
new const szDescIII[] = "Zabij z UMP45 500 wrogow";

new szAwardI = 5100;
new szAwardII = 8500;
new szAwardIII = 13900;

new szLvlI = 10;
new szLvlII = 90;
new szLvlIII = 150;

new szNeedI = 140;
new szNeedII = 300;
new szNeedIII = 500;

new enabled[33][3];
new ach[3];

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	ach[0] = exp_register_achI(szNameI, szDescI, szLvlI, szAwardI, szNeedI)
	ach[1] = exp_register_achII(szNameII, szDescII, szLvlII, szAwardII, szNeedII)
	ach[2] = exp_register_achIII(szNameIII, szDescIII, szLvlIII, szAwardIII, szNeedIII)
	
	register_event("DeathMsg", "DeathMsg",	"a");

}

public achievement_enabled(id, achid, achlvl){
	if(achid == ach[0] && achlvl == 1)
		enabled[id][0] = 1;
	if(achid == ach[1] && achlvl == 2)
		enabled[id][1] = 1;
	if(achid == ach[2] && achlvl == 3)
		enabled[id][2] = 1;
}

public achievement_disabled(id, achid, achlvl){
	if(achid == ach[0] && achlvl == 1)
		enabled[id][0] = 0;
	if(achid == ach[1] && achlvl == 2 && enabled[id][0] == 0)
		enabled[id][1] = 0;
	if(achid == ach[2] && achlvl == 3 && enabled[id][1] == 0)
		enabled[id][2] = 0;
}
public DeathMsg()
{
	new atakujacy = read_data(1)
	new id = read_data(2)
	
	if(!is_user_connected(atakujacy) || is_user_hltv(atakujacy))
		return PLUGIN_CONTINUE
	
	new bron = get_user_weapon(atakujacy)
	
	if(atakujacy != id && get_user_team(atakujacy) != get_user_team(id))
	{
		if(enabled[atakujacy][0] == 1 && bron == WEAP)
			exp_set_achievement_progress(atakujacy, ach[0], 1, exp_get_achievement_progress(atakujacy, ach[0], 1)+1)
		else if(enabled[atakujacy][1] == 1 && bron == WEAP)
			exp_set_achievement_progress(atakujacy, ach[1], 2, exp_get_achievement_progress(atakujacy, ach[1], 2)+1)
		else if(enabled[atakujacy][2] == 1 && bron == WEAP)
			exp_set_achievement_progress(atakujacy, ach[2], 3, exp_get_achievement_progress(atakujacy, ach[2], 3)+1)
	}
	return PLUGIN_CONTINUE
}

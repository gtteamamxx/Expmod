/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <expmod_mission>

#define PLUGIN "ExpMod Mission Profesjonalista"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"

new misja;
new enabled[33]

new nazwa[] = "Profesjonalista"
new opis[]  = "Zabij 30 wrogow strzalem w glowe"
new wymagany_lvl = 6
new nagroda = 1000
new ile_czego = 30   

public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	misja = exp_register_mission(nazwa, opis, wymagany_lvl, nagroda, ile_czego)
	register_event("DeathMsg", "DeathMsg",	"a");
}

public mission_selected(id, misjaid)
	if(misja == misjaid)
		enabled[id] = 1;
public mission_completed(id, misjaid)
	if(misjaid == misja)
		enabled[id] = 0
public DeathMsg()
{
	new atakujacy = read_data(1);
	new obronca = read_data(2);
	new hs = read_data(3)
	if(!is_user_connected(atakujacy) || !is_user_connected(obronca))
		return PLUGIN_CONTINUE
		
	if(atakujacy != obronca && is_user_connected(atakujacy) && get_user_team(atakujacy) != get_user_team(obronca))
	{
		if(enabled[atakujacy] && hs) {
			exp_set_user_mission_progress(atakujacy, exp_get_user_mission_progress(atakujacy)+1)
		}
	}
	
	return PLUGIN_CONTINUE
}


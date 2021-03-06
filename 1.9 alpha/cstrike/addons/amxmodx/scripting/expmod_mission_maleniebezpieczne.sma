/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <expmod_mission>

#define PLUGIN "ExpMod Mission Male Niebezpieczne..."
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"

new misja1;
new enabled[33]

new nazwa[] = "Male-Niebezpieczne"
new opis[]  = "Zabij z HE 100 wrogow"
new wymagany_lvl = 115
new nagroda = 13150
new ile_czego = 100

public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	misja1 = exp_register_mission(nazwa, opis, wymagany_lvl, nagroda, ile_czego)
	register_event("DeathMsg", "DeathMsg",	"a");
}

public mission_selected(id, Misja)
	if(misja1 == Misja)
		enabled[id] = 1;
public mission_completed(id, misjaid)
	if(misjaid == misja1)
		enabled[id] = 0
public DeathMsg()
{
	new atakujacy = read_data(1);
	new obronca = read_data(2);
	
	if(!is_user_connected(atakujacy) || !is_user_connected(obronca))
		return PLUGIN_CONTINUE
	
	new weapon[64]
	read_data(4, weapon, 63);

	if(atakujacy != obronca && is_user_connected(atakujacy))
	{
		if(enabled[atakujacy] && equal(weapon, "grenade")) 
		{
			exp_set_user_mission_progress(atakujacy, exp_get_user_mission_progress(atakujacy)+1)
		}
	}
	
	return PLUGIN_CONTINUE
}


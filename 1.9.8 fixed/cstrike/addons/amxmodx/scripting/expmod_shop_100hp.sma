/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <expmod_shop>
#include <fun>

#define PLUGIN "ExpMod Shop 100 hp"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"

new const nazwa[] = "100 hp"
new const opis[]  = "Dodatkowe 100 hp"
new cena = 15;
new one_round = 0;
new if_dead = 1;

new item;
public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	item = exp_shop_register_item(nazwa, opis, cena, one_round, if_dead)
}
public item_selected(id, itemid)
{
	if(item == itemid)
	{
		set_user_health(id, get_user_health(id)+100);
	}
}

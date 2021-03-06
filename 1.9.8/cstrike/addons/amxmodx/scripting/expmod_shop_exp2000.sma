/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <expmod_shop>
#include <expmod>

#define PLUGIN "ExpMod Shop Exp 2000"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"

new const nazwa[] = "Exp 2000"
new const opis[]  = "Dostajesz 2000 expa"
new cena = 20;
new one_round = 1;
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
		exp_set_user_exp(id, exp_get_user_exp(id)+2000);
	}
}

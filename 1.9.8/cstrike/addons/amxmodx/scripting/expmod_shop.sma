/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <expmod>
#include <colorchat>

#define PLUGIN "ExpMod Shop"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"
#define MAX_ITEMY 50

new NazwyItemow[MAX_ITEMY+1][64];
new OpisyItemow[MAX_ITEMY+1][128];
new KosztyItemow[MAX_ITEMY+1];

new RazNaRunde[MAX_ITEMY+1];
new DisabledIfDead[MAX_ITEMY+1]
new Kupil[33][MAX_ITEMY+1];

new liczba_itemow;

new prefix[] = "[EXPMOD : SKLEP]"

new item_selected;

public plugin_natives()
{
	register_native("exp_shop_register_item", "shop_register_item", 1);
	register_native("exp_shop_get_prefix", "get_prefix", 1);
}
public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	item_selected = CreateMultiForward("item_selected", ET_CONTINUE, FP_CELL, FP_CELL);
	register_dictionary("ExpMod.txt")
	register_event("HLTV", "NowaRunda", "a", "1=0", "2=0")
	register_clcmd("say /sklep", "MenuSklep")
	register_clcmd("say /shop", "MenuSklep")
}
public NowaRunda()
{
	for(new i = 1; i < 33; i++)
	{
		if(!is_user_connected(i) || is_user_hltv(i))	
			continue;
		for(new j = 1; j <= liczba_itemow; j++)
		{
			Kupil[i][j] = 0;
		}
	}
}
public MenuSklep(id)
{
	new tytul[128], opis[128]
	formatex(tytul, 127, "%L : ", id, "MENU_SHOP_TITLE", exp_get_user_monets(id))
	
	new menu = menu_create(tytul, "MenuSklep1")
	new menu_cb = menu_makecallback("MenuSklep_Cb")
	for(new i = 1; i <= liczba_itemow; i++)
	{
		formatex(opis, 127, "%s \w[\r%d\y monet\w]", NazwyItemow[i], KosztyItemow[i])
		menu_additem(menu, opis, _, _, menu_cb)
	}
	menu_display(id, menu)
}
public MenuSklep_Cb(id, menu, item)
{
	for(new i = 1; i <= liczba_itemow;i++)
	{
		if((item == i-1 && exp_get_user_monets(id) < KosztyItemow[i]) || (item == i-1 && Kupil[id][i] == 1))
			return ITEM_DISABLED
			
		if(item == i-1 && (DisabledIfDead[i] == 1 && !is_user_alive(id)))
			return ITEM_DISABLED;
	}
	return ITEM_ENABLED
}
new temp;
public MenuSklep1(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	new szYes[33], szNo[33];
	item++;
	temp = item;
	new tytul[256]
	
	formatex(szYes, 32, "%L", id, "YES")
	formatex(szNo, 32, "%L", id, "NO")
	
	formatex(tytul, 255, "%L: \y%s^n\wO%L: \y%s^n\w%L: \y%d^n\w%L:\y %s^n\r%L ?", id, "NAME", NazwyItemow[item], id, "DESCRIPTION", OpisyItemow[item], id, "PRICE", KosztyItemow[item], id, "ONE_PER_ROUND", RazNaRunde[item] ? szYes:szNo, id, "BUY")	
	
	new menus = menu_create(tytul, "MenuSklep2")
	menu_additem(menus, szYes)
	menu_additem(menus, szNo)
	menu_display(id, menus)
	return PLUGIN_CONTINUE
}
public MenuSklep2(id, menu, item)
{
	if(item == MENU_EXIT || item == 1)
	{
		menu_destroy(menu)
		temp = 0
		return PLUGIN_CONTINUE
	}
	if(item == 0)
	{
		KupPrzedmiotForward(id, temp)
	}
	return PLUGIN_CONTINUE
}
public KupPrzedmiotForward(id, itemid)
{
	new iRet;
	ExecuteForward(item_selected, iRet, id, itemid);
	ColorChat(id, GREEN, "%s^x01 %L:^x04 %s", prefix, id, "BOUGHT", NazwyItemow[itemid])
	ColorChat(id, GREEN, "%s^x01 %L:^x04 %s", prefix, id, "DESCRIPTION", OpisyItemow[itemid])
	ColorChat(id, GREEN, "%s^x01 %L:^x04 %d^x01 monet", prefix, id, "FOR", KosztyItemow[itemid])
	temp = 0;
	if(RazNaRunde[itemid])
	{
		Kupil[id][itemid] = 1;
	}
	exp_set_user_monets(id, exp_get_user_monets(id)-KosztyItemow[itemid])
}

public shop_register_item(const name[], const desc[], price, one_round, if_dead)
{
	
	if(liczba_itemow+1 > MAX_ITEMY+1)
		return PLUGIN_CONTINUE
		
	liczba_itemow++
	param_convert(1)
	param_convert(2)
	copy(NazwyItemow[liczba_itemow], 63, name)
	copy(OpisyItemow[liczba_itemow], 127, desc)

	KosztyItemow[liczba_itemow] = price
	RazNaRunde[liczba_itemow] = one_round
	DisabledIfDead[liczba_itemow] = if_dead
	
	return liczba_itemow;
}

public get_prefix(dest[], len)
{
	param_convert(1)
	copy(dest, len, prefix);
}


/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
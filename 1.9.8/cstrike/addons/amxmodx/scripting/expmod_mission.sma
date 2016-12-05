#include <amxmodx>
#include <amxmisc>
#include <fakemeta>
#include <ColorChat>
#include <expmod>
#include <nvault>

#define PLUGIN "ExpMod Missions"
#define VERSION "1.2"
#define AUTHOR "tomcionek15 & grs4"
#define MAX_MISJI 100

new NazwyMisji[MAX_MISJI+1][64];
new OpisyMisji[MAX_MISJI+1][128];
new WymaganyPoziom[MAX_MISJI+1];
new NagrodaMisji[MAX_MISJI+1];
new PotrzebaMisji[MAX_MISJI+1];

new PostepGracza[33];
new WykonaneMisje[33][MAX_MISJI+1];
new misja_gracza[33];
new numer_misji, temp;
new gmsgStatusText;
new selected, completed;
new misja[256];

new prefix[] = "[EXPMOD]";
new plik
public plugin_natives()
{
	register_native("exp_register_mission", 		"register_mission", 		1);
	register_native("exp_set_user_mission_progress","set_user_mission_progress", 	1);
	register_native("exp_get_user_mission_progress","get_user_mission_progress", 	1);
	register_native("exp_get_user_mission", 		"get_user_mission", 		1);
	register_native("exp_set_user_mission", 		"set_user_mission", 		1);
	register_native("exp_get_mission_name", 		"get_mission_name", 		1);
	register_native("exp_get_mission_desc", 		"get_mission_desc", 		1);
	register_native("exp_get_mission_need_level", 	"get_mission_need_level", 	1);
	register_native("exp_get_mission_award", 		"get_mission_award", 		1);
	register_native("exp_get_mission_need", 		"get_mission_need", 		1);
	register_native("exp_get_mission_status", 		"get_mission_status", 		1);
	register_native("exp_set_mission_status", 		"set_mission_status", 		1);
	register_native("exp_get_missionid_by_name", 	"get_missionid_by_name", 	1);
	register_native("exp_get_missionid_by_desc", 	"get_missionid_by_desc", 	1);
	register_native("exp_get_missions_numbers", 	"get_missions_numbers", 	1);

}
new p_mission_savetime;
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_dictionary("ExpMod.txt")
	
	plik = nvault_open("ExpMod_Missions")
	
	register_clcmd("say /misja", "MenuMisji")
	register_clcmd("say /anuluj", "AnulujMisje")
	register_clcmd("say /opisy", "OpisMisji")
	
	selected = CreateMultiForward("mission_selected", ET_CONTINUE, FP_CELL, FP_CELL);
	completed= CreateMultiForward("mission_completed",ET_CONTINUE, FP_CELL, FP_CELL);
	
	gmsgStatusText = get_user_msgid("StatusText");
	
	copy(NazwyMisji[0], 63, "Brak")
	copy(OpisyMisji[0], 63, "Brak")
	
	set_task(2.0, "PokazMisje", _, _, _, "b")
	p_mission_savetime = register_cvar("exp_mission_savetime", "120.0")
	
	if(get_pcvar_float(p_mission_savetime) != 0.0)
		set_task(get_pcvar_float(p_mission_savetime), "Zaapisz", _, _, _, "b")
}
public Zaapisz()
{
	for(new i = 1; i < 33; i++)
	{
		if(!is_user_connected(i) || is_user_hltv(i))
			continue;
		Zapisz(i)
	}
}
public client_connect(id)
{
	Wczytaj(id)
	new iRet;
	ExecuteForward(selected, iRet, id, misja_gracza[id]);
}
public client_disconnect(id)
	Zapisz(id)
	
public OpisMisji(id)
{	
	new title[64]
	formatex(title, 63, "%L", id, "MISSION_MENU_TITLE")
	new menu = menu_create(title, "OpisMisji1")
	
	new szOpis[128]
	
	for(new i = 1 ; i <= numer_misji ; i++){
		if(misja_gracza[id] == i)
			formatex(szOpis, charsmax(szOpis), "%s \r[%d lvl]\y -\w X", NazwyMisji[i], WymaganyPoziom[i])
		else 
			formatex(szOpis, charsmax(szOpis), "%s \r[%d lvl]", NazwyMisji[i], WymaganyPoziom[i])
		menu_additem(menu, szOpis)
	}
	
	menu_display(id, menu)
}

public OpisMisji1(id, menu, item) {
	if(item == MENU_EXIT) {
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	
	item++;
	
	new szOpis[256], szBack[33]
	
	formatex(szOpis, charsmax(szOpis), "\y%L :\w %s^n\y%L :\w %s^n\y%L :\r %d^n\y%L :\r %d\y exp", id, "MISSION", NazwyMisji[item], id, "DESCRIPTION", OpisyMisji[item], id, "REQUIRED_LEVEL", WymaganyPoziom[item], id, "AWARD", NagrodaMisji[item])
	formatex(szBack, 32, "%L", id, "BACK");
	
	new menus = menu_create(szOpis, "OpisMisji2")
	menu_additem(menus, szBack)
	
	menu_display(id, menus)
	
	return PLUGIN_CONTINUE
}

public OpisMisji2(id, menu, item)
{
	if(item == MENU_EXIT){
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	
	if(item == 0)
		OpisMisji(id)
	return PLUGIN_CONTINUE
}
public AnulujMisje(id)
{
	if(misja_gracza[id])
	{
		new tytul[256]
		new szYes[33], szNo[33]
		
		formatex(szYes, 32, "%L", id, "YES")
		formatex(szNo, 32, "%L", id, "NO")
		formatex(tytul, 255, "\y%L :\r %s^n\y%L : \r%s^n\y%L : \r%d\w /\r %d^n\%L", id, "MISSION", NazwyMisji[misja_gracza[id]], id, "TARGET", OpisyMisji[misja_gracza[id]], id, "PROGRESS", PostepGracza[id], PotrzebaMisji[misja_gracza[id]], id, "MENU_CANCEL_TEXT")
		new menu = menu_create(tytul, "AnulujMisjeH")
		menu_additem(menu, szYes)
		menu_additem(menu, szNo)
		menu_display(id, menu)
	}
	else
	{
		ColorChat(id, GREEN, "%s^x01 %L", prefix, id, "MSG_DONT_HAVE_MISSION")
		return PLUGIN_CONTINUE
	}
	return PLUGIN_CONTINUE
}
public AnulujMisjeH(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	if(item == 0)
	{
		ColorChat(id,GREEN,"%s^x01 %L", prefix, id, "MSG_CONFIRM_CANCEL_MISSION", NazwyMisji[misja_gracza[id]])
		AnlujMisjeForward(id, misja_gracza[id])
	}
	return PLUGIN_CONTINUE
}
public AnlujMisjeForward(id, idmisji)
{
	new iRet;
	ExecuteForward(completed, iRet, id, idmisji);
	
	WykonaneMisje[id][idmisji] = 1;
	misja_gracza[id] = 0;
	PostepGracza[id] = 0;
	temp = 0;
	Zapisz(id)
}

public MenuMisji(id)
{
	new szTitle[64]
	formatex(szTitle, 63, "%L", id, "SELECT_MISSION")
	new menu = menu_create(szTitle, "MenuMisjiH")
	new opis[85]
	new menucb = menu_makecallback("MenuMisji_CallBack")
	for(new i = 1; i <= numer_misji ; i++)
	{
		formatex(opis, 84, "%s\w [\r%d \ylvl\w]", NazwyMisji[i], WymaganyPoziom[i])
		menu_additem(menu, opis, _, _, menucb)
	}
	menu_display(id, menu)
}
public MenuMisji_CallBack(id, menu, item)
{
	item++
	for(new i = 1; i <= numer_misji ; i++)
	{
		if(item == i && WymaganyPoziom[i] > exp_get_user_level(id) || item == i && misja_gracza[id])
			return ITEM_DISABLED
		if(item == i && WykonaneMisje[id][i] == 1)
			return ITEM_DISABLED
	}
	return ITEM_ENABLED
}

public MenuMisjiH(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	new szYes[33], szNo[33];
	formatex(szYes, 32, "%L", id, "YES")
	formatex(szNo, 32, "%L", id, "NO")
	item++
	temp = item;
	new misja[256]
	formatex(misja, 255, "\y%L :\w %s^n\y%L :\w %s^n\y%L :\w %d^n\y%L :\w %d exp", id, "MISSION", NazwyMisji[item], id, "TARGET", OpisyMisji[item], id, "REQUIRED_LEVEL", WymaganyPoziom[item], id, "AWARD", NagrodaMisji[item])
	new menus = menu_create(misja, "MenuMisji2H")
	menu_additem(menus, szYes)
	menu_additem(menus, szNo)
	
	menu_display(id, menus)
	return PLUGIN_CONTINUE
}

public MenuMisji2H(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	
	if(item == 0)
	{
		WybranieMisji(id, temp)
		ColorChat(id, GREEN, "%s^x01 %L:^x04 %s", prefix, id, "YOU_SELECT_MISSION", NazwyMisji[misja_gracza[id]])
		ColorChat(id, GREEN, "%s^x01 %L:^x04 %s", prefix, id, "TARGET", OpisyMisji[misja_gracza[id]])
		ColorChat(id, GREEN, "%s^x01 %L:^x04 %d exp", prefix, id, "AWARD", NagrodaMisji[misja_gracza[id]])
		ColorChat(id, GREEN, "%s^x03 %L^x01 !", prefix, id, "GOOD_LUCK")
	}
	return PLUGIN_CONTINUE
}

public WybranieMisji(id, idmisji)
{	
	new iRet;
	ExecuteForward(selected, iRet, id, idmisji);
	
	PostepGracza[id] = 0
	misja_gracza[id] = idmisji;
	temp = 0
	Zapisz(id)
}
public register_mission(const name[], const description[], required_level, award, need)
{
	numer_misji++
	if(numer_misji > MAX_MISJI+1)
		return PLUGIN_CONTINUE
	param_convert(1)
	param_convert(2)
	
	copy(NazwyMisji[numer_misji], 63, name)
	copy(OpisyMisji[numer_misji], 127, description)
	
	WymaganyPoziom[numer_misji] = required_level
	NagrodaMisji[numer_misji] = award
	PotrzebaMisji[numer_misji] = need
	
	return numer_misji;
}

public SprawdzMisje(id)
{
	if(!misja_gracza[id] || get_playersnum() < get_cvar_num("exp_of_players"))
		return PLUGIN_CONTINUE
		
	if(PostepGracza[id] >= PotrzebaMisji[misja_gracza[id]])
	{
		ColorChat(id, GREEN, "%s^x03 %L!^x01 %L :^x04 %s", prefix, id, "CONGRATULATIONS", id, "YOU_COMPLETE_MISSION", NazwyMisji[misja_gracza[id]])
		ColorChat(id, GREEN, "%s^x01 %L :^x04 %s", prefix, id, "TASK", OpisyMisji[misja_gracza[id]])
		ColorChat(id, GREEN, "%s^x01 %L:^x04 %i %L", prefix, id, "AWARD", NagrodaMisji[misja_gracza[id]], id, "EXP")
		
		WykonanaMisja(id, misja_gracza[id])
	}
	else
		return PLUGIN_CONTINUE
	return PLUGIN_CONTINUE
}
public WykonanaMisja(id, missionid)
{
	new iRet;
	ExecuteForward(completed, iRet, id, missionid);
	exp_set_user_exp(id, exp_get_user_exp(id)+NagrodaMisji[missionid])
	WykonaneMisje[id][misja_gracza[id]] = 1
	misja_gracza[id] = 0
	PostepGracza[id] = 0
	temp = 0	
	Zapisz(id)
}
public PokazMisje()
{
	for(new i = 1 ; i < 33 ; i++)
	{
		
		if(!is_user_alive(i) || !is_user_connected(i) || is_user_bot(i) || is_user_hltv(i))
		{
			continue;
		}
		else if(is_user_alive(i) && is_user_connected(i) && !is_user_bot(i))
		{

			formatex(misja, charsmax(misja), "%L: %s | %L: %d/%d (+%d)", i, "MISSION", NazwyMisji[misja_gracza[i]], i, "PROGRESS", PostepGracza[i], PotrzebaMisji[misja_gracza[i]], PotrzebaMisji[misja_gracza[i]]-PostepGracza[i])
			message_begin(MSG_ONE_UNRELIABLE, gmsgStatusText, _, i);
			write_byte(0);
			write_string(misja);
			message_end();
		}
	}
}

public Zapisz(id)
{
	new nick[33], dane[128]
	get_user_name(id, nick, 32)
	
	formatex(dane, 127, "%d %d", misja_gracza[id], PostepGracza[id])
	
	new dodatek[5]
	for(new i = 1; i <= numer_misji; i++)
	{
		formatex(dodatek, 4, " %d", WykonaneMisje[id][i])
		add(dane, 127, dodatek)
	}
	nvault_set(plik, nick, dane)
}

public Wczytaj(id)
{
	new nick[33], dane[128]
	get_user_name(id, nick, 32)
	
	nvault_get(plik, nick, dane, 127)
	
	new wartosc[MAX_MISJI+4][15]
	explode(dane, ' ', wartosc, MAX_MISJI+4, 14)
	
	misja_gracza[id] = str_to_num(wartosc[0])
	PostepGracza[id] = str_to_num(wartosc[1])
	
	for(new i = 1; i <= numer_misji; i++)
		WykonaneMisje[id][i] = str_to_num(wartosc[i+1])
		
}
stock explode(const string[],const character,output[][],const maxs,const maxlen){
        new iDo = 0;
        new len = strlen(string);
        new oLen = 0;
        do
        {
                oLen += (1+copyc(output[iDo++],maxlen,string[oLen],character))
        }
        while(oLen < len && iDo < maxs)
}

public set_user_mission_progress(index, how_many)
{
	if(!misja_gracza[index] || get_playersnum() < get_cvar_num("exp_of_players"))
		return PLUGIN_CONTINUE
		
	PostepGracza[index] = how_many
	SprawdzMisje(index)
	return PLUGIN_CONTINUE
}
public get_user_mission(index)
	return misja_gracza[index]

public set_user_mission(index, missionid, progress)
{
	if(missionid > numer_misji || missionid < 0)
		return PLUGIN_CONTINUE
	
	new iRet;
	ExecuteForward(selected, iRet, index, missionid);
	
	misja_gracza[index] = missionid
	PostepGracza[index] = progress
	return PLUGIN_CONTINUE
}
public get_user_mission_progress(index)
	return PostepGracza[index]
	
public get_mission_name(missionid, dest[], len)
{
	param_convert(2)
	if(missionid > numer_misji || missionid < 0)
		return PLUGIN_CONTINUE
	copy(dest, len, NazwyMisji[missionid])
	return PLUGIN_CONTINUE
}
public get_mission_desc(missionid, dest[], len)
{
	param_convert(2)
	if(missionid > numer_misji || missionid < 0)
		return PLUGIN_CONTINUE
	copy(dest, len, OpisyMisji[missionid])
	return PLUGIN_CONTINUE
}
public get_mission_need_level(missionid)
{
	if(missionid > numer_misji || missionid < 0)
		return PLUGIN_CONTINUE
	return WymaganyPoziom[missionid]
}
public get_mission_award(missionid)
{
	if(missionid > numer_misji || missionid < 0)
		return PLUGIN_CONTINUE
	return NagrodaMisji[missionid]
}
public get_mission_need(missionid)
{
	if(missionid > numer_misji || missionid < 0)
		return PLUGIN_CONTINUE
	return PotrzebaMisji[missionid]
}
public get_mission_status(index, missionid)
{
	if(missionid > numer_misji || missionid < 0)
		return PLUGIN_CONTINUE
	return WykonaneMisje[index][missionid]
}
public set_mission_status(index, missionid, value)
{
	if(missionid > numer_misji || missionid < 0 || value > 1 || value < 0 || get_playersnum() < get_cvar_num("exp_of_players"))
		return PLUGIN_CONTINUE
		
	if(value == 1)
	{
		new iRet;
		ExecuteForward(completed, iRet, index, missionid);
	}

	WykonaneMisje[index][missionid] = value;
	
	return PLUGIN_CONTINUE
}
public get_missionid_by_name(const name[])
{
	for(new i = 1; i <= numer_misji; i++)
	{
		if(equali(NazwyMisji[i], name, strlen(name)))
		{
			return i;
		}
	}
	return -1;
}
public get_missionid_by_desc(const desc[])
{
	for(new i = 1; i <= numer_misji; i++)
	{
		if(equali(OpisyMisji[i], desc, strlen(desc)))
		{
			return i;
		}
	}
	return -1;
}
public get_missions_numbers()
	return numer_misji;

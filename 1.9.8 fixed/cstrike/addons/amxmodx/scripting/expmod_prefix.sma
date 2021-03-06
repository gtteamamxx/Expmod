/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <expmod>
#define PLUGIN "ExpMod Prefix"
#define VERSION "1.1"
#define AUTHOR "tomcionek 15 & grs4"

// THX to DarkGl from amxx.pl

new p_on

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	p_on = register_cvar("exp_prefix", "1")
	register_message(get_user_msgid("SayText"),"handleSayText");
}

public handleSayText(msgId, msgDest, msgEnt)
{
	if(get_pcvar_num(p_on) == 1)
	{
		
		new id = get_msg_arg_int(1);
		
		if(!is_user_connected(id))      
			return PLUGIN_CONTINUE;
		
		new szTmp[256],szTmp2[256];
		get_msg_arg_string(2,szTmp, charsmax( szTmp ) )
		
		
		new szPrefix[64]
		if(!exp_is_user_vip(id))
			formatex(szPrefix, 63, "^x04[^x01%d ^x03lvl^x04]", exp_get_user_level(id))
		else
			formatex(szPrefix, 63, "^x04[^x01%d ^x03lvl^x04][^x01VIP^x04]", exp_get_user_level(id))
		
		if(!equal(szTmp,"#Cstrike_Chat_All"))
		{
			add(szTmp2,charsmax(szTmp2),szPrefix);
			add(szTmp2,charsmax(szTmp2)," ");
			add(szTmp2,charsmax(szTmp2),szTmp);
		}
		else
		{
			add(szTmp2,charsmax(szTmp2),szPrefix);
			add(szTmp2,charsmax(szTmp2),"^x03 %s1^x01 :  %s2");
		}
		
		set_msg_arg_string(2,szTmp2);
	}
	return PLUGIN_CONTINUE;
}

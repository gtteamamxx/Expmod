#include <amxmodx>

#define PLUGIN "Crosshair Effect"
#define VERSION "1.1"
#define AUTHOR "STRIKER"

new pcrosshair_enemy_color, pcrosshair_team_color, 
pcrosshair_default_color, crosshair_team_color[32], 
crosshair_enemy_color[32], crosshair_default_color[32],
g_MsgSync, crosshair_effect_x, crosshair_color;

public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	pcrosshair_enemy_color = register_cvar("cross_enemy_color", "red")
	pcrosshair_team_color = register_cvar("cross_team_color", "blue")
	pcrosshair_default_color = register_cvar("cross_default_color", "green")

	crosshair_color = register_cvar("cross_color", "1")
	crosshair_effect_x = register_cvar("cross_effect_x", "1")

	register_event("StatusValue", "Show", "be", "1=2", "2!0")
	register_event("StatusValue", "Delete", "be", "1=1", "2=0")
	register_event("Damage", "ShowX", "b", "2!0", "3=0", "4!0")
	register_event( "HLTV", "ResetCrosshair", "a", "1=0", "2=0" )
	
	g_MsgSync = CreateHudSyncObj() 
}
public ResetCrosshair()
{
	if(get_pcvar_num(crosshair_color) == 1)
	{
		for(new id =1;id<33;id++)
		{
			if(!is_user_connected(id) || !is_user_alive(id))
				return PLUGIN_CONTINUE
				
			get_pcvar_string(pcrosshair_default_color, crosshair_default_color, 31)
			if(equal(crosshair_default_color, "red")) client_cmd(id, "cl_crosshair_color ^"250 50 50^"")
				else if(equal(crosshair_default_color, "yellow")) client_cmd(id, "cl_crosshair_color ^"250 250 50^"")
				else if(equal(crosshair_default_color, "orange")) client_cmd(id, "cl_crosshair_color ^"250 128 50^"")
				else if(equal(crosshair_default_color, "gray")) client_cmd(id, "cl_crosshair_color ^"192 192 192^"")
				else if(equal(crosshair_default_color, "white")) client_cmd(id, "cl_crosshair_color ^"250 250 250^"")
				else if(equal(crosshair_default_color, "black")) client_cmd(id, "cl_crosshair_color ^"0 0 0^"")
				else if(equal(crosshair_default_color, "blue")) client_cmd(id, "cl_crosshair_color ^"50 50 250^"")
				else if(equal(crosshair_default_color, "magenta")) client_cmd(id, "cl_crosshair_color ^"250 50 250^"")
				else if(equal(crosshair_default_color, "lblue")) client_cmd(id, "cl_crosshair_color ^"50 250 250^"")
				else if(equal(crosshair_default_color, "green")) client_cmd(id, "cl_crosshair_color ^"50 250 50^"")
				else if(equal(crosshair_default_color, "pink")) client_cmd(id, "cl_crosshair_color ^"250 10 170^"")
		}
	}
	return PLUGIN_CONTINUE
}	
public ShowX(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE
		
	if(get_pcvar_num(crosshair_effect_x) == 1)
	{
		new at = get_user_attacker(id) 
		if(is_user_connected(id) && is_user_connected(at)) 
		{ 
			set_hudmessage(255, 255, 255, -1.0, -1.0, 1, 0.1, 1.0, 0.1, 0.1, -1)
			ShowSyncHudMsg(at, g_MsgSync, "x")
			
			
		}
	}
	return PLUGIN_CONTINUE
}

public Show(id)
{
	if(!is_user_bot(id) && is_user_connected(id) && get_pcvar_num(crosshair_color) == 1)
	{
		if(get_user_team(id) != get_user_team(read_data(2)))
		{
			get_pcvar_string(pcrosshair_enemy_color, crosshair_enemy_color, 31)
			if(equal(crosshair_enemy_color, "red")) client_cmd(id, "cl_crosshair_color ^"250 50 50^"")
			else if(equal(crosshair_enemy_color, "yellow")) client_cmd(id, "cl_crosshair_color ^"250 250 50^"")
				else if(equal(crosshair_enemy_color, "orange")) client_cmd(id, "cl_crosshair_color ^"250 128 50^"")
				else if(equal(crosshair_enemy_color, "gray")) client_cmd(id, "cl_crosshair_color ^"192 192 192^"")
				else if(equal(crosshair_enemy_color, "white")) client_cmd(id, "cl_crosshair_color ^"250 250 250^"")
				else if(equal(crosshair_enemy_color, "black")) client_cmd(id, "cl_crosshair_color ^"0 0 0^"")
				else if(equal(crosshair_enemy_color, "blue")) client_cmd(id, "cl_crosshair_color ^"50 50 250^"")
				else if(equal(crosshair_enemy_color, "magenta")) client_cmd(id, "cl_crosshair_color ^"250 50 250^"")
				else if(equal(crosshair_enemy_color, "lblue")) client_cmd(id, "cl_crosshair_color ^"50 250 250^"")
				else if(equal(crosshair_enemy_color, "green")) client_cmd(id, "cl_crosshair_color ^"50 250 50^"")
				else if(equal(crosshair_enemy_color, "pink")) client_cmd(id, "cl_crosshair_color ^"250 10 170^"")
			}
		else if(get_user_team(id) == get_user_team(read_data(2)))
		{
			get_pcvar_string(pcrosshair_team_color, crosshair_team_color, 31)
			if(equal(crosshair_team_color, "red")) client_cmd(id, "cl_crosshair_color ^"250 50 50^"")
			else if(equal(crosshair_team_color, "yellow")) client_cmd(id, "cl_crosshair_color ^"250 250 50^"")
				else if(equal(crosshair_team_color, "orange")) client_cmd(id, "cl_crosshair_color ^"250 128 50^"")
				else if(equal(crosshair_team_color, "gray")) client_cmd(id, "cl_crosshair_color ^"192 192 192^"")
				else if(equal(crosshair_team_color, "white")) client_cmd(id, "cl_crosshair_color ^"250 250 250^"")
				else if(equal(crosshair_team_color, "black")) client_cmd(id, "cl_crosshair_color ^"0 0 0^"")
				else if(equal(crosshair_team_color, "blue")) client_cmd(id, "cl_crosshair_color ^"50 50 250^"")
				else if(equal(crosshair_team_color, "magenta")) client_cmd(id, "cl_crosshair_color ^"250 50 250^"")
				else if(equal(crosshair_team_color, "lblue")) client_cmd(id, "cl_crosshair_color ^"50 250 250^"")
				else if(equal(crosshair_team_color, "green")) client_cmd(id, "cl_crosshair_color ^"50 250 50^"")
				else if(equal(crosshair_team_color, "pink")) client_cmd(id, "cl_crosshair_color ^"250 10 170^"")
			}
	}
} 

public Delete(id)
{
	if(get_pcvar_num(crosshair_color) == 1)
	{
		get_pcvar_string(pcrosshair_default_color, crosshair_default_color, 31)
		if(equal(crosshair_default_color, "red")) client_cmd(id, "cl_crosshair_color ^"250 50 50^"")
		else if(equal(crosshair_default_color, "yellow")) client_cmd(id, "cl_crosshair_color ^"250 250 50^"")
			else if(equal(crosshair_default_color, "orange")) client_cmd(id, "cl_crosshair_color ^"250 128 50^"")
			else if(equal(crosshair_default_color, "gray")) client_cmd(id, "cl_crosshair_color ^"192 192 192^"")
			else if(equal(crosshair_default_color, "white")) client_cmd(id, "cl_crosshair_color ^"250 250 250^"")
			else if(equal(crosshair_default_color, "black")) client_cmd(id, "cl_crosshair_color ^"0 0 0^"")
			else if(equal(crosshair_default_color, "blue")) client_cmd(id, "cl_crosshair_color ^"50 50 250^"")
			else if(equal(crosshair_default_color, "magenta")) client_cmd(id, "cl_crosshair_color ^"250 50 250^"")
			else if(equal(crosshair_default_color, "lblue")) client_cmd(id, "cl_crosshair_color ^"50 250 250^"")
			else if(equal(crosshair_default_color, "green")) client_cmd(id, "cl_crosshair_color ^"50 250 50^"")
			else if(equal(crosshair_default_color, "pink")) client_cmd(id, "cl_crosshair_color ^"250 10 170^"")
	}
}
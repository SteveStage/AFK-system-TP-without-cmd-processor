#include <a_samp>

forward OnPlayerResume(playerid, pausedtime);
forward OnPlayerEnterPause(playerid);

new
	player_timer[MAX_PLAYERS],
	afk_last_call[MAX_PLAYERS],
	bool:afk_check[MAX_PLAYERS char] = false,
	Text3D:afk_3dtext[MAX_PLAYERS],
	afk_timer[MAX_PLAYERS],
	bool:login_check[MAX_PLAYERS char] = true,
	bool:afk_death[MAX_PLAYERS char];

public OnGameModeInit()
{
	return true;
}
public OnGameModeExit()
{
	return true;
}
public OnPlayerRequestClass(playerid, classid)
{
	return true;
}
public OnPlayerConnect(playerid)
{
	login_check{playerid} = true;
	return true;
}
public OnPlayerDisconnect(playerid, reason)
{
	KillTimer(afk_timer[playerid]);
	return true;
}
public OnPlayerSpawn(playerid)
{
	SetPlayerSkin(playerid, 7);
	SetPlayerPos(playerid, 2495.3323, -1689.1377, 14.2433);
	afk_death{playerid} = false;
	afk_last_call[playerid] = gettime();
	if(login_check{playerid} == true)
	{
		CallLocalFunction("@_UpdatePlayer", "d", playerid);
		login_check{playerid} = false;
	}
	return true;
}
public OnPlayerDeath(playerid, killerid, reason)
{
	afk_death{playerid} = true;
	return true;
}
public OnVehicleSpawn(vehicleid)
{
	return true;
}
public OnVehicleDeath(vehicleid, killerid)
{
	return true;
}
public OnPlayerText(playerid, const text[])
{
	return false;
}
public OnPlayerCommandText(playerid, const cmdtext[])
{
	new
		cmd[32], params[126], pos = 0;
    while(cmdtext[pos] > ' ')
    {
        cmd[pos] = cmdtext[pos];
        pos++;
    }
    while(cmdtext[pos] == ' ')
    {
        pos++;
        if(!cmdtext[pos])
        {
            params = "\1";
            break;
        }
    }
    strcat(params, cmdtext[pos]);
    strcat(params, " ");
	if(!strcmp(cmd, "/tp"))
	{
		new
			Float:x, Float:y, Float:z, tmp[20+1];
		for(new i = 0, j = 0, l = 0; i < strlen(params)+1; i++)
		{
			if(params[i] == ' ')
			{
				strmid(tmp, params, j, i);
				switch(l)
				{
					case 0: x = floatstr(tmp);
					case 1: y = floatstr(tmp);
					case 2: z = floatstr(tmp);
				}
				l++;
				j = i+1;
			}
		}
		SetPlayerPos(playerid, x, y, z);
		return true;
	}
	return true;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return true;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
	return true;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return true;
}
public OnPlayerEnterCheckpoint(playerid)
{
	return true;
}
public OnPlayerLeaveCheckpoint(playerid)
{
	return true;
}
public OnPlayerEnterRaceCheckpoint(playerid)
{
	return true;
}
public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return true;
}
public OnRconCommand(const cmd[])
{
	return true;
}
public OnPlayerRequestSpawn(playerid)
{
	return true;
}
public OnObjectMoved(objectid)
{
	return true;
}
public OnPlayerObjectMoved(playerid, objectid)
{
	return true;
}
public OnPlayerPickUpPickup(playerid, pickupid)
{
	return true;
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
	return true;
}
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return true;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return true;
}
public OnPlayerSelectedMenuRow(playerid, row)
{
	return true;
}
public OnPlayerExitedMenu(playerid)
{
	return true;
}
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return true;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return true;
}
public OnRconLoginAttempt(const ip[], const password[], success)
{
	return true;
}
public OnPlayerUpdate(playerid)
{
	afk_last_call[playerid] = gettime();
	return true;
}
public OnPlayerStreamIn(playerid, forplayerid)
{
	return true;
}
public OnPlayerStreamOut(playerid, forplayerid)
{
	return true;
}
public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return true;
}
public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return true;
}
public OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
	return true;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return true;
}
public OnPlayerEnterPause(playerid)
{
	afk_check{playerid} = true;
	afk_3dtext[playerid] = Create3DTextLabel("AFK: 5 seconds", 0x00C0FFFF, 0.0, 0.0, 0.0, 50.0, GetPlayerVirtualWorld(playerid));
	Attach3DTextLabelToPlayer(afk_3dtext[playerid], playerid, 0.0, 0.0, 0.5);
	CallLocalFunction("@_AFKTimer", "dd", playerid, 10);
	return true;
}
public OnPlayerResume(playerid, pausedtime)
{
	afk_check{playerid} = false;
	new
		str[128+1];
	format(str, sizeof(str), "Вы были в АФК: %d секунд!", pausedtime);
	SendClientMessage(playerid, 0x00C0FFFF, str);
	return true;
}
@_UpdatePlayer(playerid);
@_UpdatePlayer(playerid)
{
	if(afk_check{playerid} == false)
	{
		if((gettime() - afk_last_call[playerid]) >= 5) CallLocalFunction("OnPlayerEnterPause", "d", playerid);
	}
	player_timer[playerid] = SetTimerEx("@_UpdatePlayer", 500, false, "d", playerid);
	return true;
}
@_AFKTimer(playerid, time);
@_AFKTimer(playerid, time)
{
	if(login_check{playerid} == true || afk_death{playerid} == true) return false;
	if(afk_last_call[playerid] == gettime())
	{
		if(time % 2 != 0) time--;
		CallLocalFunction("OnPlayerResume", "dd", playerid, time/2);
		Delete3DTextLabel(afk_3dtext[playerid]);
		return false;
	}
	new
		str[128+1];
	if(time % 2 != 0) format(str, sizeof(str), "AFK: %d seconds", (time-1)/2);
	else format(str, sizeof(str), "AFK: %d seconds", time/2);
	Update3DTextLabelText(afk_3dtext[playerid], 0x00C0FFFF, str);
	afk_timer[playerid] = SetTimerEx("@_AFKTimer", 500, false, "dd", playerid, time+1);
	return true;
}
main(){}

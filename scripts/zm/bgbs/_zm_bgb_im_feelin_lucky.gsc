// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_im_feelin_lucky;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_im_feelin_lucky
	Checksum: 0x3327B3A5
	Offset: 0x198
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_im_feelin_lucky", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_im_feelin_lucky
	Checksum: 0x618ABAC6
	Offset: 0x1D8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_im_feelin_lucky", "activated", 2, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: zm_bgb_im_feelin_lucky
	Checksum: 0x13E16015
	Offset: 0x238
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	powerup_origin = self bgb::get_player_dropped_powerup_origin();
	n_roll = randomfloatrange(0, 1);
	if(n_roll < 0.75)
	{
		e_powerup = zm_powerups::specific_powerup_drop(zm_powerups::get_regular_random_powerup_name(), powerup_origin);
	}
	else
	{
		if(isdefined(level.get_random_powerup_str_cb))
		{
			str_powerup = [[level.get_random_powerup_str_cb]]();
		}
		else
		{
			str_powerup = get_random_powerup_str();
		}
		if(str_powerup === "free_perk")
		{
			if(isdefined(level.get_random_powerup_str_cb))
			{
				str_powerup = [[level.get_random_powerup_str_cb]]();
			}
			else
			{
				str_powerup = get_random_powerup_str();
			}
		}
		e_powerup = zm_powerups::specific_powerup_drop(str_powerup, powerup_origin, undefined, undefined, undefined, self);
	}
	is_in_enabled_zone = zm_utility::check_point_in_enabled_zone(e_powerup.origin, undefined, undefined);
	wait(1);
	if(!is_in_enabled_zone)
	{
		level thread bgb::powerup_stolen_by_sam(e_powerup);
	}
}

/*
	Name: get_random_powerup_str
	Namespace: zm_bgb_im_feelin_lucky
	Checksum: 0x43562EDC
	Offset: 0x400
	Size: 0xF2
	Parameters: 0
	Flags: Linked
*/
function get_random_powerup_str()
{
	powerups = getarraykeys(level.zombie_powerups);
	powerups = array::randomize(powerups);
	foreach(str_key in powerups)
	{
		// prevents dropping widows wine grenades and the void bow runes
		if(level.zombie_powerups[str_key].player_specific === 1)
		{
			arrayremovevalue(powerups, str_key);
		}
	}
	return powerups[0];
}


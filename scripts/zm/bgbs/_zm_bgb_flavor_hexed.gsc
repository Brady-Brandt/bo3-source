// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_flavor_hexed;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_flavor_hexed
	Checksum: 0xD8BFB07
	Offset: 0x240
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_flavor_hexed", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_flavor_hexed
	Checksum: 0x85B9D166
	Offset: 0x280
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
	bgb::register("zm_bgb_flavor_hexed", "event", &event, undefined, undefined, undefined);
}

/*
	Name: event
	Namespace: zm_bgb_flavor_hexed
	Checksum: 0x1C0336DD
	Offset: 0x2E0
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function event()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self.available_gums = [];
	current_bgb_pack = self.bgb_pack;
	foreach(str_bgb, gobble_gum in level.bgb)
	{
		if(gobble_gum.consumable == 1)
		{
			if(!isinarray(current_bgb_pack, str_bgb) && str_bgb != "zm_bgb_flavor_hexed")
			{
				if(!isdefined(self.available_gums))
				{
					self.available_gums = [];
				}
				else if(!isarray(self.available_gums))
				{
					self.available_gums = array(self.available_gums);
				}
				self.available_gums[self.available_gums.size] = str_bgb;
			}
		}
	}
	/#
		assert(self.available_gums.size, "");
	#/
	gobble_gum_name = array::random(self.available_gums);
	self thread activate(gobble_gum_name);
}

/*
	Name: activate
	Namespace: zm_bgb_flavor_hexed
	Checksum: 0x82B521A0
	Offset: 0x4B0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function activate(gobble_gum_name)
{
	wait(1);
	self thread handle_first_activation(gobble_gum_name);
	self playsoundtoplayer("zmb_bgb_flavorhex", self);
	self thread bgb::give(gobble_gum_name);
	arrayremovevalue(self.available_gums, gobble_gum_name);
}

/*
	Name: handle_first_activation
	Namespace: zm_bgb_flavor_hexed
	Checksum: 0x218D34AA
	Offset: 0x540
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function handle_first_activation(gobble_gum_name)
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_gumball_anim_give");
	self waittill("bgb_update_give_" + gobble_gum_name);
	self notify("bgb_flavor_hexed_give_" + gobble_gum_name);
	self waittill(#"bgb_update", not_used, used_gobble_gum_name);
	if(used_gobble_gum_name === gobble_gum_name && self.available_gums.size)
	{
		new_gobble_gum_name = array::random(self.available_gums);
		self playsoundtoplayer("zmb_bgb_flavorhex", self);
		self thread handle_second_activation(new_gobble_gum_name);
		self bgb::give(new_gobble_gum_name);
	}
}

/*
	Name: handle_second_activation
	Namespace: zm_bgb_flavor_hexed
	Checksum: 0x8ED1A3AD
	Offset: 0x650
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function handle_second_activation(gobble_gum_name)
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self waittill("bgb_update_give_" + gobble_gum_name);
	self notify("bgb_flavor_hexed_give_" + gobble_gum_name);
}


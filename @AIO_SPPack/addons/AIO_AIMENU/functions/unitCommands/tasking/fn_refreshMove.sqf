params ["_unit"];
_groupPlayer = group player;
_tempGrp = createGroup (side _groupPlayer);
_assignedTeam = assignedTeam _unit;
[_unit] joinSilent _tempGrp;
_tempGrp setBehaviour "AWARE";
[_unit] joinSilent _groupPlayer;
_unit assignTeam _assignedTeam;
doStop _unit;
deleteGroup _tempGrp;
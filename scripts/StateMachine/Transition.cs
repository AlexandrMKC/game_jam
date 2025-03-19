using Godot;
using System;

[GlobalClass]
public partial class Transition : Node
{
	[Export]
	public State toNewState;

	[Export]
	public string nameEvent;

	public bool ComperedEvents(string nameEvent){
		return this.nameEvent == nameEvent;
	}

}

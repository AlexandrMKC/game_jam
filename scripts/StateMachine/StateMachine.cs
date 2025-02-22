using Godot;
using Godot.Collections;
using System;

public partial class StateMachine : Node
{
	[Export]
	public State startState;

	//states
	private Dictionary<string, State> _states = new Dictionary<string, State>();

	//current state
	private State _currentState;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		foreach(var child in GetChildren()){
			if(child is State){
				var state = (State)child;
				_states[state.name] = state;
			}
		}

		if(startState == null){
			startState.Enter();
			_currentState = startState;
		}
	}

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    // public override void _Process(double delta)
    // {
    // }
    public override void _PhysicsProcess(double delta)
    {
        
    }

	public void changeState(State state, State newState){

	}
}

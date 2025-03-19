using Godot;
using Godot.Collections;
using System;

// [Icon("hgg")]
[GlobalClass]
public partial class StateMachine : Node
{
	//states
	private Dictionary<string, State> _states = new Dictionary<string, State>();

	[Export]
	public State startState;

	//current state
	private State _currentState;

	// event queue
	private Array<string> _eventQueue = new Array<string>();


	public void SendEvent(string nameEvent){
		GD.Print("State: send event: " + nameEvent);
		_eventQueue.Add(nameEvent);
		_RunEvents();
	}

	private void _RunEvents(){
		// 
		foreach(var _event in _eventQueue){
			State newState = _currentState.ProcessTransition(_event);
			if(newState != null){
				_currentState.Exit();
				_currentState = newState;
				_currentState.Enter();
				GD.Print("State: new state: " + _currentState.stateName);
			}
		}
	}

	public override void _Ready()
	{
		// find states
		foreach(var child in GetChildren()){
			if(child is State){
				var state = (State)child;
				_states[state.stateName] = state;
				state.InitState();
			}
		}

		if(startState != null){
			// check start state is contained in the dictionary of states
			if(!_states.ContainsKey(startState.stateName)){
				return;
			}

			// initial start state
			startState.Enter();
			_currentState = startState;

		} else {
			GD.Print("Error: the initial state is not selected!");
			return;
		}
	}

    public override void _PhysicsProcess(double delta)
    {
        _currentState.PhysicsUpdate(delta);
    }

    public override void _Process(double delta)
    {
        _currentState.Update(delta);
    }
}

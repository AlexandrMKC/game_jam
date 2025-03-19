using Godot;
using Godot.Collections;
using System;

[GlobalClass]
public partial class State : Node
{
	[Signal]
	public delegate void StateEnteredEventHandler();

	[Signal]
	public delegate void StateExitedEventHandler();

	// [Signal]
	// public delegate void TransitionEventHandler(State currentState, State newState);

	[Export]
	public string stateName;

	// array of Transition objects
	private Array<Transition> _transitions = new Array<Transition>();

	public void InitState(){

		// set up transitions
		_transitions.Clear();
		foreach(var child in GetChildren()){
			if(child is Transition){
				var transition = (Transition)child;
				_transitions.Add(transition);
			}
		}
	}

	public State ProcessTransition(string nameEvent){
		// check all transitions
		foreach(var transition in _transitions){
			if(transition.ComperedEvents(nameEvent)){
				return transition.toNewState;
			}
		}

		return null;
	}

	virtual public void PhysicsUpdate(double delta){

	}

	virtual public void Update(double delta){
		
	}

    virtual public void Enter(){

	}

	virtual public void Exit(){

	}
}

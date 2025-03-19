using Godot;
using System;

[GlobalClass]
public partial class MoveState : State
{
	[Export]
	private CharacterBody2D _player;

	[Export]
	public float _speedFly = 150.0f;
	

	public override void PhysicsUpdate(double delta){
		_player.LookAt(_player.GetGlobalMousePosition());

		Vector2 velocity = _player.Velocity;
		velocity.X = 0.0f;
		velocity.Y = 0.0f;
		if(Input.IsActionPressed("move_right")){
			velocity.X = _speedFly;
			velocity = velocity.Rotated(_player.Rotation);
		}
		if(Input.IsActionPressed("move_left")){
			velocity.X = -_speedFly;
			velocity = velocity.Rotated(_player.Rotation);
		}
		if(Input.IsActionPressed("move_up")){
			velocity.Y = -_speedFly;
			velocity = velocity.Rotated(_player.Rotation);
		}
		if(Input.IsActionPressed("move_down")){
			velocity.Y = _speedFly;
			velocity = velocity.Rotated(_player.Rotation);
		}

		_player.Velocity = velocity;
	}

    public override void Enter(){

	}

	public override void Exit(){

	}
}

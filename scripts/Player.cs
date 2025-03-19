using Godot;
using System;

public partial class Player : CharacterBody2D
{
	[Export]
	public float speedFly = 100.0f;

	[Export]
	public StateMachine stateMachine;

    public override void _Ready()
    {
        //Input.MouseMode = Input.MouseModeEnum.Captured;
    }

    public override void _PhysicsProcess(double delta)
	{
		motionProcessing();
		MoveAndSlide();
	}

	private void motionProcessing(){
		// LookAt(GetGlobalMousePosition());

		// Vector2 velocity = Velocity;
		// velocity.X = 0.0f;
		// velocity.Y = 0.0f;
		// if(Input.IsActionPressed("move_right")){
		// 	velocity.X = speedFly;
		// 	velocity = velocity.Rotated(Rotation);
		// }
		// if(Input.IsActionPressed("move_left")){
		// 	velocity.X = -speedFly;
		// 	velocity = velocity.Rotated(Rotation);
		// }
		// if(Input.IsActionPressed("move_up")){
		// 	velocity.Y = -speedFly;
		// 	velocity = velocity.Rotated(Rotation);
		// }
		// if(Input.IsActionPressed("move_down")){
		// 	velocity.Y = speedFly;
		// 	velocity = velocity.Rotated(Rotation);
		// }

		if(Input.IsActionPressed("move_right")){
			stateMachine.SendEvent("move");
		}
		// if(Input.IsActionPressed("move_left")){
		// 	velocity.X = -speedFly;
		// 	velocity = velocity.Rotated(Rotation);
		// }
		// if(Input.IsActionPressed("move_up")){
		// 	velocity.Y = -speedFly;
		// 	velocity = velocity.Rotated(Rotation);
		// }
		// if(Input.IsActionPressed("move_down")){
		// 	velocity.Y = speedFly;
		// 	velocity = velocity.Rotated(Rotation);
		// }

		// Velocity = velocity;
	}
}

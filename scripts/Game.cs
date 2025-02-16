using Godot;
using System;
using System.Net;
using System.Net.Http.Headers;

[GlobalClass]
public partial class Game : Node3D
{
    private bool mouseCaptured;
    public override void _Ready()
    {
        Input.MouseMode = Input.MouseModeEnum.Captured;
        mouseCaptured = true;
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("exit(DEBUG)"))
        {
            if (mouseCaptured)
            {
                Input.MouseMode = Input.MouseModeEnum.Visible;
            }
            else
            {
                Input.MouseMode = Input.MouseModeEnum.Captured;
            }
            mouseCaptured = !mouseCaptured;
        }
    }
}

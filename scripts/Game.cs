using Godot;
using System;
using System.Net;
using System.Net.Http.Headers;

[GlobalClass]
public partial class Game : Node3D
{
    public override void _Ready()
    {
        Input.MouseMode = Input.MouseModeEnum.Captured;
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event.IsActionPressed("exit(DEBUG)"))
        {
            Input.MouseMode = Input.MouseModeEnum.Visible;
        }
    }
}

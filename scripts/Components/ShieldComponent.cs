using Godot;
using System;
using System.Reflection.Metadata.Ecma335;

[GlobalClass]
public partial class ShieldComponent : Resource
{
    [Export]
    private float TotalShield = 0;
    [Export]
    private bool Invincible = false;

    [Signal]
    public delegate void ShieldActivatedEventHandler();
    [Signal]
    public delegate void ShieldDeactivatedEventHandler();

    private float _shield;
    private bool _invincible;

    public ShieldComponent()
    {
        // грязный хак
        CallDeferred(MethodName.Ready);
    }

    private void Ready()
    {
        _shield = TotalShield;
        _invincible = Invincible;
        if (Mathf.IsZeroApprox(_shield))
        {
            GD.PushError("Shield of ", ResourceSceneUniqueId, " is 0, most likely is a mistake!\n if you want to do invincible shield then set the value to 1.");
        }
    }

    public void Activate(bool invincibleOverride)
    {
        _shield = TotalShield;
        _invincible = invincibleOverride;
        EmitSignal(SignalName.ShieldActivated);
    }

    public void TakeDamage(float damage)
    {
        if (_invincible)
        {
            return;
        }

        if (damage < 0)
        {
            GD.PushWarning("Damage is not positive, something is wrong");
        }

        _shield -= damage;
        if (_shield <= 0.0f || Mathf.IsZeroApprox(_shield)) // maybe change later
        {
            Deactivate();
        }
    }

    public void Deactivate()
    {
        EmitSignal(SignalName.ShieldDeactivated);
    }
}

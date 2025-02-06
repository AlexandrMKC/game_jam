using Godot;
using System;

[GlobalClass]
public partial class HealthComponent : Resource
{
    [Export]
    private float TotalHealth = 0;

    [Signal]
    public delegate void HealthDepletedEventHandler();

    private float _health;

    public HealthComponent()
    {
        // грязный хак
        CallDeferred(MethodName.Ready);
    }

    private void Ready()
    {
        _health = TotalHealth;
    }

    public void TakeDamage(float damage)
    {
        if (damage < 0)
        {
            GD.PushWarning("Damage is not positive, something is wrong");
        }

        _health -= damage;
        if (_health <= 0.0f || Mathf.IsZeroApprox(_health)) // maybe change later
        {
            EmitSignal(SignalName.HealthDepleted);
        }
    }

    public void Heal(float value)
    {
        if (value < 0)
        {
            GD.PushWarning("Heal value is not positive, something is wrong");
        }
        _health = Mathf.Clamp(_health + value, 0, TotalHealth);
    }
}

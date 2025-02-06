using Godot;
using System;

public interface IHittable
{
    public void RegisterHit(float damage);
}
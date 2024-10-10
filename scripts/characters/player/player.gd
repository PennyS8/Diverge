extends CharacterBody2D

# All the logic is handled by the xsm below
# Even variables have now been moved to states
# Player keeps it own velocity, as well as vars that can be used by many different states

var dir : Vector2 = Vector2.ZERO

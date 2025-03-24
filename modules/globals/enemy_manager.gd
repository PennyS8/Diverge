extends Node

## The number of enemies allowed to run towards the player at one single time
const MAX_ENGAGERS = 2

## The number of enemies allowed to target the player with projectile attacks
const MAX_TARGETERS = 1

var current_engagers : Array[CharacterBody2D] = []

## If an enemy wishes to engage the player, make sure they can
func request_engagement(enemy : CharacterBody2D):
	if current_engagers.size() < MAX_ENGAGERS:
		current_engagers.append(enemy)
		return true
	return false

func release_engagement(enemy : CharacterBody2D):
	if current_engagers.has(enemy):
		current_engagers.erase(enemy)

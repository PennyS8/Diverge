# MIT LICENSE Copyright 2020-2023 Etienne Blanc - ATN
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("State", "Node", load("res://addons/xsm/state.gd"), 		load("res://addons/xsm/icons/state.png"))
	add_custom_type("StateAnimation", "Node", load("res://addons/xsm/state_animation.gd"), 		load("res://addons/xsm/icons/state.png"))
	add_custom_type("StateLoop", "Node", load("res://addons/xsm/state_loop.gd"), 		load("res://addons/xsm/icons/state_loop.png"))
	add_custom_type("StateRegions", "Node", load("res://addons/xsm/state_regions.gd"), 		load("res://addons/xsm/icons/state_regions.png"))
	add_custom_type("StateRand", "Node", load("res://addons/xsm/state_rand.gd"), 		load("res://addons/xsm/icons/state_rand.png"))
	add_custom_type("StateSound", "Node", load("res://addons/xsm/state_sound.gd"), 		load("res://addons/xsm/icons/state_sound.png"))


func _exit_tree():
	remove_custom_type("StateSound")
	remove_custom_type("StateRand")
	remove_custom_type("StateRegions")
	remove_custom_type("StateLoop")
	remove_custom_type("StateAnimation")
	remove_custom_type("State")

# MIT LICENSE Copyright 2020-2021 Etienne Blanc - ATN
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
@icon("res://addons/xsm/icons/state_regions.png")
extends State
class_name StateRegions

# StateRegions has all its children active or inactive at the same time

#
# PRIVATE FUNCTIONS
#

# overridden to have all children ACTIVE
func _init_status_active() -> void:
	enter()
	for c in get_children():
		if c is State:
			c._init_status_active()
	_after_enter(null)


func change_children_status_to_exiting() -> void:
	for c in get_children():
		c.status = EXITING
		c.change_children_status_to_exiting()


func change_children_status_to_entering(new_state_path: NodePath) -> void:
	for c in get_children():
		c.status = ENTERING
		c.change_children_status_to_entering(new_state_path)


func enter_children(args_on_enter = null, args_after_enter = null) -> void:
	if disabled:
		return
	# if hasregions, enter all children and that's all
	for c in get_children():
		c.enter(args_on_enter)
		c.enter_children(args_on_enter, args_after_enter)
		c._after_enter(args_after_enter)


# returns all children if active
func get_active_substate():
	if status == ACTIVE:
		return get_children()
	return null

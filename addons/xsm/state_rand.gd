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
@icon("res://addons/xsm/icons/state_rand.png")
extends State
class_name StateRand

# StateRand Can chose a random state based on priorities
# Call rand_state() to chose a random substate
# In this state's inspector, you can define priorities
# for your sub-States, to have some appear more often
#
# Call change_to_next_substate() selects randomly the next State


var randomized := true:
	set(value):
		randomized = value
		notify_property_list_changed()
# This seed will not be used if this state is randomized
var state_seed := 0
var priorities = {}:
	set(value):
		if get_parent(): # is false during ready !!!
			for k in value.keys():
				var nod  = get_node_or_null(k)
				if not k is String or not nod or not nod is State:
					print(priorities)
					print(value)
					# prints(k, nod, nod.get)
					value.erase(k)
				if value[k] and value[k] is int:
					priorities[k] = value[k]
		else:
			priorities = value
var is_ready := false

#
# INIT
#
func _ready():
	super()

	if randomized:
		randomize()
	else:
		seed(state_seed)

	var _c1 = child_entered_tree.connect(_substate_entered)
	var _c2 = child_exiting_tree.connect(_substate_exiting)
	for c in get_children():
		if c is State:
			var _conn = c.renamed.connect(_substate_renamed.bind(c.name, c))


# We want to add some export variables in their categories
# And separate those of the root state
func _get_property_list():
	var properties = []

	# Adds a State category in the inspector
	properties.append({
		name = "StateRand",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE,
	})
	properties.append({
		name = "randomized",
		type = TYPE_BOOL,
	})
	if not randomized:
		properties.append({
			name = "state_seed",
			type = TYPE_INT,
		})
	properties.append({
		name = "priorities",
		type = TYPE_DICTIONARY,
	})
	
	return properties


#
# PUBLIC FUNCTIONS
#
func change_to_next_substate():
	var rand_array = []
	for c in priorities.keys():
		for i in priorities[c]:
			rand_array.append(c)
	var rand_idx = randi() % rand_array.size()
	var _st =  change_state_node_force(get_node_or_null(rand_array[rand_idx]))


#
# PRIVATE FUNCTIONS
#
func _substate_entered(node):
	if node is State:
		priorities[node.name] = 1
		var _c = node.renamed.connect(_substate_renamed.bind(node.name, node))


func _substate_exiting(node):
	if node is State:
		priorities.erase(node.name)


# in case a state child is renamed, update its name in priorities
# have to reconnect its signal
func _substate_renamed(old_name, node):
	var old_priority = priorities[old_name]
	priorities.erase(old_name)
	priorities[node.name] = old_priority
	# Has to reconnect the signal to update the bindings names
	node.renamed.disconnect(_substate_renamed)
	var _c = node.renamed.connect(_substate_renamed.bind(node.name, node))

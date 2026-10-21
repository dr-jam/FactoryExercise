class_name ShieldFactory
extends Node

# This factory exists to retool a shield. Think of it as a shipyard or drydock.
@export var shield_in_factory:Shield

func build(spec:ShieldSpec, shield:Shield = self.shield_in_factory):
	shield.max_capacity = spec.max_capacity
	shield.type = spec.type
	shield.recharge_delay = spec.recharge_delay
	shield.recharge_rate = spec.recharge_rate
	if !_verify(shield):
		_fit_to_constraints(shield)
	
## Determines if the sheidl is withing overall rating and inidividual attribute constraints.
func _verify(shield:Shield) -> bool:
	#stage task
	return true
	
	
## Modifies the shield to match the overall rating and attribute constraints.
func _fit_to_constraints(shield:Shield):
	#stage task
	pass

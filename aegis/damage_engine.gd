class_name DamageEngine
extends Node

const FACTOR_MATRIX := {
	Effects.Type.KENETIC: {
		Effects.Type.KENETIC: 1.0,
		Effects.Type.ENERGY: 0.5,
		Effects.Type.ARCANE: 2.0,
	},
	Effects.Type.ENERGY: {
		Effects.Type.KENETIC: 2.0,
		Effects.Type.ENERGY: 1.0,
		Effects.Type.ARCANE: 0.5,
	},
	Effects.Type.ARCANE: {
		Effects.Type.KENETIC: 0.5,
		Effects.Type.ENERGY: 2.0,
		Effects.Type.ARCANE: 1.0,
	},
}


static func calc_damage(shield: Shield, projectile: Projectile) -> float:
	var projectile_factors:Dictionary = FACTOR_MATRIX.get(projectile.type, {})
	var type_factor:float = projectile_factors.get(shield.type, 1.0)
	return projectile.damage * type_factor

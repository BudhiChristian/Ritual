extends Node

signal state_entered(state)
signal disable_tool(tool)
signal enable_tool(tool)

signal thurible_smoke_changed(color)
signal spirit_revealed(color)
signal spawn_spirit_trio(color, spirit_types)
signal chains_created()

# knife actions
signal spirit_clicked(spirit)
signal soul_jar_clicked()
# jar actions
signal put_spirit_in_jar(spirit)
signal spirit_escapes_jar(spirit)
signal exorcise_spirits_in_jar(spirits)

# spirit indicator
signal set_spirit_stored(is_stored)

# pins
signal pin_removed(pin)
signal triangle_created()
signal triangle_dispelled_early()
signal triangle_expired()

# ectoplasm
signal ectoplasm_spawned()
signal ectoplasm_clicked(ectoplasm)
signal ectoplasm_manually_removed(ectoplasm)

# levels
signal host_completely_exorcised()
signal host_is_possessed()

# UI
signal show_overlay_for(option)

extends Node

signal state_entered(state)

signal thurible_smoke_changed(color)
signal spirit_revealed()
signal spawn_spirit_trio(color)

# knife actions
signal spirit_clicked(spirit)
signal soul_jar_clicked()
# jar actions
signal put_spirit_in_jar(spirit)
signal spirit_escapes_jar(spirit)
signal exorcise_spirits_in_jar(spirits)

# spirit indicator
signal set_spirit_stored(is_stored)

signal pin_removed(pin)
signal triangle_created()
signal triangle_dispelled_early()

# levels
signal host_completely_exorcised()
signal host_is_possessed()

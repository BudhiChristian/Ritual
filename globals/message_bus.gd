extends Node

signal state_entered(state)

signal thurible_smoke_changed(color)
signal spirit_revealed()

# knife actions
signal spirit_clicked(spirit)
signal soul_jar_clicked()

signal put_spirit_in_jar(spirit)
signal spirit_escapes_jar(spirit)
signal exorcise_spirits_in_jar(spirits)

# spirit indicator
signal set_spirit_stored(is_stored)

signal pin_removed(pin)

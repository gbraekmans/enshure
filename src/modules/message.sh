module_type message
module_description "$(translate "Displays a message to the user.")"

argument message string identifier "$(translate "The message to be shown.")" "'Hello world!'"

get_message() {
	printf '%s' "$message"
}

variable disable_api_termination {
    default = true
    type = bool
    description = "Prevent resource from begin terminated on stop"
}

variable monitoring {
    type = bool
}

variable ami {
    type = string
    default = "ami--"
}


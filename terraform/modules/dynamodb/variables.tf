variable "table_name" {
    description = "The name of the DynamoDB table."
    type = string
}

variable "hash_key" {
    description = "The partition key attribute name for the DynamoDB table."
    type = string
}

variable "read_capacity" {
    description = "Read capacity units for the table"
    type = number
    default = 5
}

variable "write_capacity" {
    description = "Write capacity units for the table"
    type = number
    default = 5
}
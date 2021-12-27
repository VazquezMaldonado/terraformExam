

resource "aws_dynamodb_table" "example_DynamoDB" {
  name             = "${var.dynamodb_name}"
  hash_key         = "ID"
  write_capacity     = 10
  read_capacity      = 10
  attribute {
    name = "ID"
    type = "S"
  }

	 tags = {
    DEV_EXAM        = "Alfredo Vazquez Maldonado"
  }

}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  min_capacity       = 1
  max_capacity       = 5
  resource_id        = "table/${var.dynamodb_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

output "value" {
  value = aws_appautoscaling_target.dynamodb_table_read_target
}


resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 50
  }
}


resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  min_capacity       = 2
  max_capacity       = 10
  resource_id        = "table/${var.dynamodb_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}


resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = 70
  }
}

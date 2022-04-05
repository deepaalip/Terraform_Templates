resource "aws_iam_role" "myTestUser" {
  name = "myTestUser"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.myTestUser.name
}

resource "aws_codedeploy_app" "sample-app" {
  name = "sample-app"
}

resource "aws_sns_topic" "sns-topic" {
  name = "sns-topic"
}

resource "aws_codedeploy_deployment_group" "cd-group" {
  app_name              = aws_codedeploy_app.sample-app.name
  deployment_group_name = "cd-group"
  service_role_arn      = aws_iam_role.myTestUser.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "filterkey1"
      type  = "KEY_AND_VALUE"
      value = "filtervalue"
    }

    ec2_tag_filter {
      key   = "filterkey2"
      type  = "KEY_AND_VALUE"
      value = "filtervalue"
    }
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "sample-trigger"
    trigger_target_arn = aws_sns_topic.sns-topic.arn
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  }
}

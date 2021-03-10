resource "aws_resourcegroups_group" "ui-resources" {
  name = "ui-resources-${var.top_private_domain}"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "Module",
      "Values": ["terraform-ui-module"]
    }
  ]
}
JSON
  }
}
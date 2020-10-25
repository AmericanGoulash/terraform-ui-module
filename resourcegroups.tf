resource "aws_resourcegroups_group" "ui-resources" {
  name = "ui-resources"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "Component",
      "Values": ["ui"]
    }
  ]
}
JSON
  }
}
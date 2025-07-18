# Terraform-aws-ses

# Terraform AWS Cloud SES Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [License](#license)
- [Author](#Author)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This Terraform module creates an AWS  Simple Email Service (SES) along with additional configuration options.
## Usage
To use this module, you should have Terraform installed and configured for AWS. This module provides the necessary Terraform configuration for creating AWS resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Examples
```hcl
module "ses" {
  source       = "git::https://github.com/shanav-tech/terraform-aws-ses.git?ref=v1.0.0"

  name         = local.name
  environment  = local.environment
  domain       = "shanav-tech.ca"
  enable_email = true
  emails       = []
  zone_id      = "XXXXXXXX7289RP"

  enable_mx         = true
  enable_spf_domain = true
}
```



## Examples
For detailed examples on how to use this module, please refer to the [examples](https://github.com/shanav-tech/terraform-aws-ses/tree/master/_example) directory within this repository.

## License
This Terraform module is provided under the **MIT** License. Please see the [LICENSE](https://github.com/shanav-tech/terraform-aws-ses/blob/master/LICENSE) file for more details.

## Author
Your Name
Replace **MIT** and **shanav-tech** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.50.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | git::https://github.com/shanav-tech/terraform-aws-labels.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_route53_record.dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.mx_receive](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.mx_send_mail_from](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.spf_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.spf_mail_from](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ses_domain_dkim.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim) | resource |
| [aws_ses_domain_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity) | resource |
| [aws_ses_domain_mail_from.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_mail_from) | resource |
| [aws_ses_email_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_email_identity) | resource |
| [aws_ses_identity_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_identity_policy) | resource |
| [aws_ses_receipt_filter.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_receipt_filter) | resource |
| [aws_ses_template.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_template) | resource |
| [aws_iam_policy_document.allow_iam_name_to_send_emails](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cname_type"></a> [cname\_type](#input\_cname\_type) | CNAME type for Record Set. | `string` | `"CNAME"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain to use for SES. | `string` | `""` | no |
| <a name="input_emails"></a> [emails](#input\_emails) | Emails list to use for SES. | `list(string)` | `[]` | no |
| <a name="input_enable_domain"></a> [enable\_domain](#input\_enable\_domain) | Control whether or not to enable domain identity for AWS SES. | `bool` | `true` | no |
| <a name="input_enable_email"></a> [enable\_email](#input\_enable\_email) | Control whether or not to enable email identity for AWS SES. | `bool` | `false` | no |
| <a name="input_enable_filter"></a> [enable\_filter](#input\_enable\_filter) | Control whether or not to enable receipt filter. | `bool` | `false` | no |
| <a name="input_enable_mail_from"></a> [enable\_mail\_from](#input\_enable\_mail\_from) | Control whether or not to enable mail from domain. | `bool` | `false` | no |
| <a name="input_enable_mx"></a> [enable\_mx](#input\_enable\_mx) | Control whether or not to enable mx DNS recodrds. | `bool` | `false` | no |
| <a name="input_enable_policy"></a> [enable\_policy](#input\_enable\_policy) | Control whether identity policy create for SES. | `bool` | `false` | no |
| <a name="input_enable_spf_domain"></a> [enable\_spf\_domain](#input\_enable\_spf\_domain) | Control whether or not to enable enable spf domain. | `bool` | `false` | no |
| <a name="input_enable_template"></a> [enable\_template](#input\_enable\_template) | Control whether create a template for emails. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Boolean indicating whether or not to create sns module. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_filter_cidr"></a> [filter\_cidr](#input\_filter\_cidr) | The IP address or address range to filter, in CIDR notation. | `string` | `""` | no |
| <a name="input_filter_policy"></a> [filter\_policy](#input\_filter\_policy) | Block or Allow filter. | `string` | `""` | no |
| <a name="input_iam_name"></a> [iam\_name](#input\_iam\_name) | IAM username. | `string` | `""` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_mail_from_domain"></a> [mail\_from\_domain](#input\_mail\_from\_domain) | Subdomain (of the route53 zone) which is to be used as MAIL FROM address. | `string` | `""` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'shanav-tech' | `string` | `"shanav-tech"` | no |
| <a name="input_mx_type"></a> [mx\_type](#input\_mx\_type) | MX type for Record Set. | `string` | `"MX"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `""` | no |
| <a name="input_spf_domain_name"></a> [spf\_domain\_name](#input\_spf\_domain\_name) | n/a | `string` | `"spf_domain"` | no |
| <a name="input_template_html"></a> [template\_html](#input\_template\_html) | The HTML body of the email. Must be less than 500KB in size, including both the text and HTML parts. | `string` | `""` | no |
| <a name="input_template_subject"></a> [template\_subject](#input\_template\_subject) | The subject line of the email. | `string` | `""` | no |
| <a name="input_text"></a> [text](#input\_text) | The email body that will be visible to recipients whose email clients do not display HTML. | `string` | `""` | no |
| <a name="input_txt_type"></a> [txt\_type](#input\_txt\_type) | Txt type for Record Set. | `string` | `"TXT"` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Route53 host zone ID to enable SES. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_identity_arn"></a> [domain\_identity\_arn](#output\_domain\_identity\_arn) | ARN of the SES domain identity. |
| <a name="output_iam_access_key_id"></a> [iam\_access\_key\_id](#output\_iam\_access\_key\_id) | The access key ID. |
| <a name="output_iam_access_key_secret"></a> [iam\_access\_key\_secret](#output\_iam\_access\_key\_secret) | The access key secret. |
| <a name="output_id"></a> [id](#output\_id) | The domain name of the domain identity. |
<!-- END_TF_DOCS -->
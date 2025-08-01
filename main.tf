
locals {
  # some ses resources don't allow for the terminating '.' in the domain name
  # so use a replace function to strip it out
  stripped_mail_from_domain = replace(var.mail_from_domain, "/[.]$/", "")
}

module "labels" {
  source = "git::https://github.com/Shanav-Technologies/terraform-aws-labels.git?ref=v1.0.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

#Module      : DOMAIN IDENTITY
#Description : Terraform module to create domain identity using domain
resource "aws_ses_domain_identity" "default" {
  count  = var.enabled && var.enable_domain ? 1 : 0
  domain = var.domain
}

#Module      : EMAIL IDENTITY
#Description : Terraform module to create Emails identity using domain
resource "aws_ses_email_identity" "default" {
  count = var.enabled && var.enable_email ? length(var.emails) : 0
  email = var.emails[count.index]
}

# Module      : DOMAIN DKIM
# Description : Terraform module which creates Domain DKIM resource on AWS
resource "aws_ses_domain_dkim" "default" {
  count  = var.enabled && var.enable_domain ? 1 : 0
  domain = aws_ses_domain_identity.default[0].domain
}

###DKIM VERIFICATION#######

#Module      : DOMAIN DKIM VERIFICATION
#Description : Terraform module to verify domain DKIM on AWS
resource "aws_route53_record" "dkim" {
  count = var.enabled && var.zone_id != "" ? 3 : 0

  zone_id = var.zone_id
  name    = format("%s._domainkey.%s", element(aws_ses_domain_dkim.default[0].dkim_tokens, count.index), var.domain)
  type    = var.cname_type
  ttl     = 600
  records = [format("%s.dkim.amazonses.com", element(aws_ses_domain_dkim.default[0].dkim_tokens, count.index))]
}

###SES MAIL FROM DOMAIN#######

#Module      : DOMAIN MAIL FROM
#Description : Terraform module to create domain mail from on AWS
resource "aws_ses_domain_mail_from" "default" {
  count = var.enable_domain && var.enabled && var.enable_mail_from ? 1 : 0

  domain           = aws_ses_domain_identity.default[count.index].domain
  mail_from_domain = local.stripped_mail_from_domain
}

###SPF validaton record#######

#Module      : SPF RECORD
#Description : Terraform module to create record of SPF for domain mail from
resource "aws_route53_record" "spf_mail_from" {
  count = var.enabled && var.enable_mail_from ? 1 : 0

  zone_id = var.zone_id
  name    = aws_ses_domain_mail_from.default[count.index].mail_from_domain
  type    = var.txt_type
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

#Module      : SPF RECORD
#Description : Terraform module to create record of SPF for domain
resource "aws_route53_record" "spf_domain" {
  count = var.enabled && var.enable_spf_domain && var.zone_id != "" ? 1 : 0

  zone_id = var.zone_id
  name    = var.spf_domain_name
  type    = var.txt_type
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

###Sending MX Record#######

data "aws_region" "current" {}

#Module      : MX RECORD
#Description : Terraform module to create record of MX for domain mail from
resource "aws_route53_record" "mx_send_mail_from" {
  count = var.enabled && var.zone_id != "" && var.enable_mail_from ? 1 : 0

  zone_id = var.zone_id
  name    = aws_ses_domain_mail_from.default[count.index].mail_from_domain
  type    = var.mx_type
  ttl     = "600"
  records = [format("10 feedback-smtp.%s.amazonses.com", data.aws_region.current.name)]
}

###Receiving MX Record#######

#Module      : MX RECORD
#Description : Terraform module to create record of MX for receipt
resource "aws_route53_record" "mx_receive" {
  count = var.enabled && var.enable_mx && var.zone_id != "" ? 1 : 0

  zone_id = var.zone_id
  name    = module.labels.id
  type    = var.mx_type
  ttl     = "600"
  records = [format("10 inbound-smtp.%s.amazonaws.com", data.aws_region.current.name)]
}

#Module      : SES FILTER
#Description : Terraform module to create receipt filter on AWS
resource "aws_ses_receipt_filter" "default" {
  count = var.enabled && var.enable_filter ? 1 : 0

  name   = module.labels.id
  cidr   = var.filter_cidr
  policy = var.filter_policy
}

#Module      : SES BUCKET POLICY
#Description : Document of Policy to create Identity policy of SES
data "aws_iam_policy_document" "document" {
  count = var.enabled && var.enable_domain ? 1 : 0
  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_domain_identity.default[0].arn]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
}

#Module      : SES IDENTITY POLICY
#Description : Terraform module to create ses identity policy on AWS
resource "aws_ses_identity_policy" "default" {
  count = var.enable_domain && var.enabled && var.enable_policy ? 1 : 0

  identity = aws_ses_domain_identity.default[count.index].arn
  name     = module.labels.id
  policy   = data.aws_iam_policy_document.document[0].json
}

#Module      : SES TEMPLATE
#Description : Terraform module to create template on AWS
resource "aws_ses_template" "default" {
  count = var.enabled && var.enable_template ? 1 : 0

  name    = module.labels.id
  subject = var.template_subject
  html    = var.template_html
  text    = var.text
}


###SMTP DETAILS#######

# Module      : IAM USER
# Description : Terraform module which creates SMTP Iam user resource on AWS
resource "aws_iam_user" "default" {
  count = var.enabled && var.iam_name != "" ? 1 : 0

  name = var.iam_name
}

# Module      : IAM ACCESS KEY
# Description : Terraform module which creates SMTP Iam access key resource on AWS
resource "aws_iam_access_key" "default" {
  count = var.enabled && var.iam_name != "" ? 1 : 0

  user = join("", aws_iam_user.default[*].name)
}

# Module      : IAM USER POLICY
# Description : Terraform module which creates SMTP Iam user policy resource on AWS
resource "aws_iam_user_policy" "default" {
  count = var.enabled && var.iam_name != "" ? 1 : 0

  name   = module.labels.id
  user   = join("", aws_iam_user.default[*].name)
  policy = data.aws_iam_policy_document.allow_iam_name_to_send_emails.json
}

# Module      : IAM USER POLICY DOCUMENT
# Description : Terraform module which creates SMTP Iam user policy document resource on AWS
#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "allow_iam_name_to_send_emails" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

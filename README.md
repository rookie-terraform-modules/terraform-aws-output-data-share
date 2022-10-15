# terraform-aws-output-data-share

[![Github Actions](https://github.com/tobeyOguney/terraform-aws-output-data-share/actions/workflows/main.yml/badge.svg)](https://github.com/tobeyOguney/terraform-aws-output-data-share/actions/workflows/main.yml)
[![Releases](https://img.shields.io/github/v/release/tobeyOguney/terraform-aws-output-data-share)](https://github.com/tobeyOguney/terraform-aws-output-data-share/releases/latest)

[Terraform Module Registry](https://registry.terraform.io/modules/tobeyOguney/remote-state-s3-backend/aws)

A Terraform module to set up secure sharing of module outputs across workspaces via S3 (with fine-grained access control) as an alternative to [remote state access](https://www.terraform.io/cloud-docs/workspaces/state#remote-state-access-controls).

This is the more secure approach if you're not using Terraform Cloud workspaces according to the [official documentation](https://www.terraform.io/language/state/remote-state-data#alternative-ways-to-share-data-between-configurations).

It introduces the concept of "output groups" - which are simply groups of your root module outputs that you'd like to have different access control settings for.

For example, there could be a group of non-sensitive outputs that you want to give every account user access to. Also, you may have another group of sensitive outputs that you only want to give specific users access to.

All this is powered by an encrypted S3 bucket (SSE-S3) used to store these output groups and user policy attachments for access control.

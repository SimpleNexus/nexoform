# Nexoform

Nexoform wraps terraform to provide easy support for multiple environments and remote backends.

## Quick Start

### Install terraform

[Install terraform](https://www.terraform.io/intro/getting-started/install.html),
and create some terraform files.  To work easily with nexoform, use one var file for
each environment you will want.  For example, if you plan to use a dev, staging, and
prod environment, create dev.tfvars, staging.tfvars, and prod.tfvars.

### Install nexoform:

```bash
gem install nexoform
```

### Generate a base config file:

```bash
nexoform config-file

# or pass a project name to prefix your s3 buckets:
nexoform config-file --project-name 'simplenexus'
```

The base file includes three different environments:  dev, staging, and prod.
You can add more by putting additional keys under 'environments'.
The name of the key will be the name of the environment

### Use nexoform instead of terraform

The three main commands you will use are plan, apply, and destroy.

Plan:  will figure out what changes terraform will need to make to your infrastructure
to get it in the desired state.  If enabled, this will be saved to a file that can be
used with `apply` to make sure exactly those changes are made.

Apply:  will implement the plan from the previous step, or if run without a plan file
apply will first calculate a plan and present it to you for approval.

Destroy:  will delete/remove any resources created during an `apply`

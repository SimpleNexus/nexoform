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

```
Commands:
  nexoform apply           # Apply changes (Runs a terraform apply)
  nexoform config-file     # Write a default config file
  nexoform destroy         # Destroy all provisioned resources (runs a terrafor...
  nexoform help [COMMAND]  # Describe available commands or one specific command
  nexoform list-envs       # List the environments
  nexoform output          # Print any output from terraform
  nexoform plan            # Print out changes that will be made on next apply ...
  nexoform version         # Check current installed version of nexoform

Options:
  e, [--environment=ENVIRONMENT]
  y, [--assume-yes], [--no-assume-yes]
```

`-e|--environment` allows you to specify the environment directly.  If you don't
want to type that repeatedly, you can set a `default` environment in the config
file.  The special "environment" named `default` is just a string that points
to the environment that will be used if you do not specify one on the command
line.  If you do specify, it will override the default value for that command only.

The three main commands you will use are plan, apply, and destroy.

#### Plan

This will figure out what changes terraform will need to make to your infrastructure
to get it in the desired state.  If enabled, this will be saved to a file that can be
used with `apply` to make sure exactly those changes are made.

```bash
nexoform plan
```

#### Apply

This will implement the plan from the previous step, or if run without a plan file
apply will first calculate a plan and present it to you for approval.

#### Destroy

This will delete/remove any resources created during an `apply`

#### config-file

This will generate a starting config file for you with three environments:

* dev
* staging
* prod

You can of course add more or delete some to fit your needs.

#### list-envs

This will print out a list of environment available.

#### Output

This will perform the setup and run `terraform output` for you.

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
Usage:
  nexoform plan

Options:
  o, [--out=OUT]
  s, [--save], [--no-save]
  n, [--nosave], [--no-nosave]
  w, [--overwrite], [--no-overwrite]
  e, [--environment=ENVIRONMENT]
  y, [--assume-yes], [--no-assume-yes]

Description:
    Prints out any changes that will be made the next time
    a nexoform apply is run.  Under the hood, this command
    runs a terraform plan.

    If you pass an arg to 'out' the plan will be saved to that filename.
    If you pass '--save' or '-s' the plan will be saved to 'nexoform.tfplan'
    If you pass '--nosave' or '-n' the plan will not be saved
    If you pass none of those, you'll be prompted about saving the plan

    > $ nexoform plan
    > $ nexoform plan --environment 'dev'
    > $ nexoform plan --environment 'dev' --save --overwrite
    > $ nexoform plan --environment 'dev' --out='nexoform.tfplan'
```

#### Apply

This will implement the plan from the previous step, or if run without a plan file
apply will first calculate a plan and present it to you for approval.

```bash
Usage:
  nexoform apply

Options:
  p, [--plan=PLAN]
  n, [--noplan], [--no-noplan]
  e, [--environment=ENVIRONMENT]
  y, [--assume-yes], [--no-assume-yes]

Description:
    Applies any applicable changes.  Under the hood, this command runs a
    terraform apply.

    If you pass --plan, the specified file will be used for the plan
    If you pass --noplan, no plan file will be used
    If you don't pass either, no plan file will be used unless the default
    is present.  If it is, you'll be prompted about using it

    > $ nexoform apply
    > $ nexoform apply --environment 'dev'
    > $ nexoform apply --environment 'dev' --noplan
    > $ nexoform apply --environment 'dev' --plan=nexoform.tfplan
```

#### Destroy

This will delete/remove any resources created during an `apply`

```bash
Usage:
  nexoform destroy

Options:
  e, [--environment=ENVIRONMENT]
  y, [--assume-yes], [--no-assume-yes]

Description:
    Destroys any resources that have been provisioned

    > $ nexoform destroy
    > $ nexoform destroy --environment 'dev'
```

#### config-file

This will generate a starting config file for you with three environments:

* dev
* staging
* prod

You can of course add more or delete some to fit your needs.

```bash
Usage:
  nexoform config-file

Options:
  f, [--force]
  p, [--project-name=PROJECT-NAME]

Description:
    Writes a nexoform config file to ./nexoform.yml
    containing the default settings.  This can then be configured
    as preferred.

    > $ nexoform config-file [--force] [--project-name 'simplenexus']
```

#### list-envs

This will print out a list of environment available.

```bash
Usage:
  nexoform list-envs

Options:
  e, [--environment=ENVIRONMENT]
  y, [--assume-yes], [--no-assume-yes]

Description:
    Lists the available environments and the current default (if applicable).
    These are defined in the config file at ./nexoform.yml

    > $ nexoform list-envs
```

#### Output

This will perform the setup and run `terraform output` for you.

```bash
Usage:
  nexoform output

Options:
  e, [--environment=ENVIRONMENT]
  y, [--assume-yes], [--no-assume-yes]

Description:
    Prints any output from last terraform state.  Runs a 'terraform output'

    > $ nexoform output
```


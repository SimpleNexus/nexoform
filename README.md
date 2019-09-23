# Nexoform

Nexoform wraps terraform to provide easy support for multiple environments and remote backends.
Nexoform also makes it trivial to use [ERB](https://www.stuartellis.name/articles/erb/)
inside your terraform files.

## Table of Contents

1. [Main Features](#main-features)
1. [Quick Start](#quick-start)
1. [Tutorial](#tutorial)

## Main Features

* Allows usage of ERB in your terraform files
* Enables easy use of multiple environments
* Transparently handles remote storage of your state files
* Automatically handles initializing the repo

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
  nexoform destroy         # Destroy all provisioned resources (runs a terraform destroy)
  nexoform generate        # Generate the raw terraform files for the environment but don't run terraform on them
  nexoform help [COMMAND]  # Describe available commands or one specific command
  nexoform list-envs       # List the environments
  nexoform output          # Print any output from terraform
  nexoform plan            # Print out changes that will be made on next apply (runs a terraform plan)
  nexoform version         # Check current installed version of nexoform

Options:
  e, [--environment=ENVIRONMENT]
  y, [--assume-yes], [--no-assume-yes]
  r, [--refresh], [--no-refresh]
                                        # Default: true
```

`-e|--environment` allows you to specify the environment directly.  If you don't
want to type that repeatedly, you can set a `default` environment in the config
file.  The special "environment" named `default` is just a string that points
to the environment that will be used if you do not specify one on the command
line.  If you do specify, it will override the default value for that command only.

The three main commands you will use are `plan`, `apply`, and `destroy`
(and maybe `generate` for debugging).

#### Plan

This will figure out what changes terraform will need to make to your infrastructure
to get it in the desired state.  If enabled, this will be saved to a file that can be
used with `apply` to make sure exactly those changes are made.  If you are using ERB,
the terraform files will be generated (run through ERB) before calculating the plan.

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
  r, [--refresh], [--no-refresh]
                                        # Default: true

Description:
    Prints out any changes that will be made the next time
    a nexoform apply is run.  Under the hood, this command
    runs a terraform plan.  If you have ERB files, they will be
    run through ERB to generate the output before running plan.

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
apply will first calculate a plan and present it to you for approval.  If you are using ERB,
the terraform files will be generated (run through ERB) before running apply.

```bash
Usage:
  nexoform apply

Options:
  p, [--plan=PLAN]                      
  n, [--noplan], [--no-noplan]          
  e, [--environment=ENVIRONMENT]        
  y, [--assume-yes], [--no-assume-yes]  
  r, [--refresh], [--no-refresh]        
                                        # Default: true

Description:
    Applies any applicable changes.  Under the hood, this command runs a
    terraform apply.  If you have ERB files, they will be
    run through ERB to generate the output before running plan.

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

This will delete/remove any resources created during an `apply`.  If you are using ERB,
the terraform files will be generated (run through ERB) before running destroy.


```bash
Usage:
  nexoform destroy

Options:
  e, [--environment=ENVIRONMENT]
  y, [--assume-yes], [--no-assume-yes]
  r, [--refresh], [--no-refresh]
                                        # Default: true

Description:
    Destroys any resources that have been provisioned.  If you have ERB files,
    they will be run through ERB to generate the output before running destroy.

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

This will perform the setup and run `terraform output` for you.  If you are using ERB,
the terraform files will be generated (run through ERB) before calculating the plan.

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

## Tutorial

Before learning nexoform, you need to learn terraform.  Start with installation:

### Installing Terraform

Note about versions:  As soon as you run terraform against a state file, everyone
that uses that state file will be required to have a version equal to or newer
than you.  For this reason, it is good ettiquette to sync versions with the rest
of your team.  Minor versions matter, so if your team uses 12.5, use 12.5 not
12.6 unless everybody is ok to upgrade.

To install, download the correct binary for your system and put it in your PATH:
https://www.terraform.io/downloads.html

For more help on installation, see https://learn.hashicorp.com/terraform/getting-started/install

### Learn the basics of terraform

Learn the basics of terraform.  There's lots of resources but I recommend these tutorials:

- https://learn.hashicorp.com/terraform
- https://learn.hashicorp.com/terraform/getting-started/build
- https://learn.hashicorp.com/terraform/getting-started/change
- https://learn.hashicorp.com/terraform/getting-started/destroy
- https://learn.hashicorp.com/terraform/getting-started/dependencies

### Write some terraform code

Let's create a simple project that just creates some SSH keys in AWS.

#### Create a base file for boiler plate stuff like providers:

`providers.tf`

```terraform
provider "aws" {
  version = "~> 2.10.0"
  region  = var.region
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

# Handy array you can loop through to get the first three availability zones
# You don't need this right now but this is handy to include for projects
# that require high availability
locals {
  aws_availability_zones_names = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1],
    data.aws_availability_zones.available.names[2],
  ]
}

# Required for nexoform to manage the state file
terraform {
  backend "s3" {
  }
}
```

#### Create a file called variables.tf

It's nice to declare your variables in a separate file, so we will do that:

`variables.tf`

```terraform
variable "region" {
  type        = string
  description = "AWS region to create assets in.  Should be one of [us-east-1, us-west-2, etc]"
}
```

#### Create a file called versions.tf

This is new for terraform v0.12.

`versions.tf`

```terraform
terraform {
  required_version = ">= 0.12"
}
```

#### Create a file called keys.tf

I'm truncating my key here, but you'll need to use a real key if you plan to actually run this code:

`keys.tf`:

```terraform
resource "aws_key_pair" "infrastructure-ssh-key" {
    key_name = "infrastructure-ssh-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQGAvgRp...BKJH6b75Zom0AzwJI5HhX infrastructure@sn"
  }
```

### Run the project

You now have a valid terraform project that you can run.  Let's try it:

```bash
terraform init && terraform apply
```

### Now let's add Nexoform

Of course the purpose of this is to get nexoform in, so let's do that.

#### Install nexoform

Nexoform ships as a ruby gem, so install with gem:

```bash
gem install nexoform
```

You may wish to create a Gemfile for it in your project:

`Gemfile`

```ruby
# frozen_string_literal: true

source "https://rubygems.org"

gem "nexoform"
```

Then run:

```bash
bundle install
```

#### Generate a config file for nexoform:

```bash
nexoform config-file
```

#### Set the company name

To store terraform state, nexoform will need an s3 bucket.  I recommend
<companyname>-terraform-state or something like it.  For example if your
company name is "Hooli" create an s3 bucket call "hooli-terraform-state"

Then update the "bucket" keys under each environment.  If you only want
to use one environment, you can remove the extras.  One of nexoform's good
features tho is the ability to easily make use of environments.

This config file has three environments, dev, staging, and prod.  If an
environment isn't passed on the command line at runtime, the "dev" will
be the default.  You can remove the default key or change it per your preferences.

`nexoform.yml`

```yaml
---
nexoform:
  environments:
    default: dev          # optional default env so you don't have to specify
    dev:                  # name of environment
      varFile: dev.tfvars # terraform var-file to use
      plan:               # optional block. Avoids getting prompted
        enabled: yes      # yes | no.  If no, a plan file is not used
        file: dev.tfplan  # file the plan is saved to automatically
        overwrite: yes    # overwrite existing file. could be: yes | no | ask
      state:              # configuration for state management s3 backend
        bucket: hooli-terraform-state
        key: dev.tfstate
        region: us-east-1
    staging:                  # name of environment
      varFile: staging.tfvars # terraform var-file to use
      plan:                   # optional block. Avoids getting prompted
        enabled: yes          # yes | no.  If no, a plan file is not used
        file: staging.tfplan  # file the plan is saved to automatically
        overwrite: yes        # overwrite existing file. could be: yes | no | ask
      state:                  # configuration for state management s3 backend
        bucket: hooli-terraform-state
        key: staging.tfstate
        region: us-east-1
    prod:                  # name of environment
      varFile: prod.tfvars # terraform var-file to use
      plan:                # optional block. Avoids getting prompted
        enabled: yes       # yes | no.  If no, a plan file is not used
        file: prod.tfplan  # file the plan is saved to automatically
        overwrite: yes     # overwrite existing file. could be: yes | no | ask
      state:               # configuration for state management s3 backend
        bucket: hooli-terraform-state
        key: prod.tfstate
        region: us-east-1

```

#### Create vars file

For passing in environment variables, you need a file names <environment>.tfvars for each env.  So create dev.tfvars, staging.tfvars, and prod.tfvars, and fill the files with this:

`dev.tfvars`

```terraform
region = "us-west-2"
```

#### Run Nexoform

You are now ready to use nexoform!  Run a plan with:

```bash
nexoform plan
```

or run an apply with:

```bash
nexoform apply
```

### Using ERB

One of nexoform's best feature is the support for using ERB in your terraform files.  The Terraform HCL is limited, and although it is getting better it is still missing several features that full programming languages offer.

Let's improve on our SSH key project from the previous step.  In the real world you probably have more than one key that needs to be managed.  This is a good use case for ERB/nexoform.

To be continued ...

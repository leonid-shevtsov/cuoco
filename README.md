# Cuoco provides plumbing necessary to run Chef Solo through Capistrano with zero configuration.

## Key values

* reuse as much server information from Capistrano as possible (including roles);
* comply to Chef directory structure as much as possible to simplify transition;
* bootstrap bare machines with minimal footprint.

## Summary

*Capistrano and Chef Solo, sitting in a tree...*

[Capistrano](https://github.com/capistrano/capistrano#capistrano) is a framework that allows you to run commands in parallel on multiple remote machines. Its primary use is application deployment, but Capistrano can automate any task you can do over SSH. A big advantage of Capistrano is that it is wildly popular among web developers, and thus well supported and rich with plugins.

Another common task you have to do on the remote machines is server provisioning/management, and Capistrano has no facilities for that. It's definitely possible to manage machines using Capistrano, but you have to bring your own scripts.

[Chef Solo](http://wiki.opscode.com/display/chef/Chef+Solo) is a tool that uses well-structured, data-driven Ruby scripts to describe and run configuration management routines. It manages the machine it's running from. So before running Chef Solo on a remote machine, you have to install it there and upload your scripts to that machine. You can do that by hand, you can use one of the many Chef Solo bootstrap scripts, or you can use some tool like littlechef, which needs to be configured to know about your servers.

But wait - not only Capistrano knows where your servers are, it can already run commands on them, and in parallel. It's exactly what Chef Solo is lacking.

Cuoco provides a set of Capistrano tasks to tie in Chef Solo into Capistrano.

## Installation

    gem install cuoco

If you're using bundler you already know the drill.

To make Cuoco tasks available in Capistrano, require this file in your `Capfile` or `config/deploy.rb`:

    require 'cuoco/capistrano'

## Usage

### Fully automatic mode

Cuoco can turn a completely bare machine into a live server with a single command. You buy servers, you declare them in Capistrano, you run `cap deploy:setup && cap deploy`. Done! [*]

To do so, require this file in your `Capfile` or `config/deploy.rb`.

    require 'cuoco/capistrano/automatic'

It hooks up `cuoco:update_configuration` before `deploy:setup`. This built-in task, quote, 
*"Prepares one or more servers for deployment."*. Which is what Chef does. If you 
update your server configuration you run `cap deploy:setup` again, it is non-destructive.

My personal opinion is that running Chef on each deploy is wasteful and forces
sudo rights as a requirement for all deployers. If you really want to do that, you'll
have to figure out the (extremely tricky) Capistrano directive yourself.

[*] Naturally, you have to write the provisioning scripts first.

### Manual mode

There are separate Cuoco tasks defined for more granular control.

    cuoco:bootstrap # Installs chef, but does not run anything
    cuoco:run       # Runs chef assuming it's already installed

### Usage without deployment

If application deployment doesn't apply in your scenario, you can just run

    cap cuoco:update_configuration

directly.

### Custom bootstrap scripts

**As of September 2, 2012 the [pg gem fails to compile on Chef installed with the default bootstrap script](http://tickets.opscode.com/browse/COOK-1406).**

You can replace the Omnibus installation script with any other, like this one I wrote for Ubuntu 12.04:

    set :chef_install_command, 'wget -q -O - https://raw.github.com/gist/3601146/install_chef_ubuntu_precise.sh | sudo bash'

## Minimal requirements for remote machines

Here are the minimal requirements for running Cuoco:

* the server is running [one of the operating systems supported by Omnibus](http://wiki.opscode.com/display/chef/Installing+Omnibus+Chef+Client+on+Linux+and+Mac#InstallingOmnibusChefClientonLinuxandMac-TestedOperatingSystems) (most flavors of Linux will do);
* the server has `sudo`, `bash` and either `curl` or `wget` installed (most Linux servers do);
* Capistrano can connect to the server;
* the Capistrano user has sudo rights on the server. See [my article on setting up user accounts](http://leonid.shevtsov.me/en/how-to-set-up-user-accounts-on-your-web-server) for the suggested approach.

## Configuration

Cuoco works with a traditional Chef directory structure. By default it looks for it in `config/chef`.
You can change that:

    # set the root Chef directory 
    set :chef_path, 'chef'

### Roles

**Cuoco assigns Chef roles from Capistrano roles.**

This means that every server that you will run `cuoco:update_configuration` on will
get its own run list based on the roles it has: if it has `:app` and `:db` roles, Chef's run list for that server will be `role[app], role[db]`.

The chef roles directory *must* contain a role file for every Capistrano role you are using.

### Variables

TODO

### Environments

TODO Environments are not supported by Chef Solo. It would be nice to provide the functionality based on Capistrano stages.

## What's in a name?

"Cuoco" means "cook" in Italian. The original [Capistrano is a city in Italy](https://maps.google.com/maps?f=q&source=s_q&hl=en&geocode=&q=Capistrano,+Vibo+Valentia,+Italy&aq=0&oq=capistrano,+italy&sll=37.0625,-95.677068&sspn=60.376022,135.263672&vpsrc=0&t=h&ie=UTF8&hq=&hnear=Capistrano,+Province+of+Vibo+Valentia,+Calabria,+Italy&z=16). So a chef working solo in Capistrano would be called *un cuoco*... get it now?

(If you've been expecting to see Kaley Cuoco here, I'll save you a trip to Reddit:)

![Another Cuoco](http://i.imgur.com/u5OIil.jpg)

* * * 

2012 [Leonid Shevtsov](http://leonid.shevtsov.me)
# ReleaseHub
ReleaseHub as the deploy mechanism, a deployment tool to release codes and make
it easy to the team.

## Introduction
It's especially essential for large teams of developers and designers
who work together to build and deploy GitHub repos. Inspired by [Shipit](https://github.com/Shopify/shipit-engine),
ReleaseHub aims to be a system that will let us release the code more efficient
to different environments.

## Features
- Github integration
- Slack integration
- Dashboard showing environment status
- Operational history
- Github Markdown Support

This app is assuming that your team is using github as the source control and slack
for internal team communication.

This is the demo - [ReleaseHub](https://releasehub.herokuapp.com/)

Read the [wiki pages](https://github.com/JIAZHEN/releasehub/wiki) for more details

## Getting started
### Clone the application

    $ git clone git@github.com:JIAZHEN/releasehub.git

Configurate the database. By default it's using MySQL database. Therefore need to
make sure MySQL is installed and the database credential is correct. You can
of course change to other database.

### Install gems

    $ cd releasehub
    $ bundle install

### Setup github authentication

- Create a new application on https://github.com/settings/applications/new,
  more details at https://developer.github.com/guides/basics-of-authentication/.
- Once it's created, record the `Client ID` and `Client Secret`.
- Create an access token on https://github.com/settings/tokens/new,
  select scopes `repo` and `user`. This will allow ReleaseHub to pull data
  from the organisation.

### Create `config/development.env` file with the following variables

    export GITHUB_CLIENT_ID= # github application client ID
    export GITHUB_CLIENT_SECRET= # github application client secret
    export GITHUB_ACCESS_TOKEN= # github account access token
    export ORGANISATION= # the name of your github organisation
    export SLACK_TOKEN= # the slack team token
    # the slack ID of the admin members, they can change deployment status
    export ADMIN_MEMBERS=
    # the slack ID of members that need to be notified when deploy to production
    export DEFAULT_NOTIFY_IDS=
    # the slack ID of channel that need to be notified as default
    export DEFAULT_CHANNEL=

### Bootstrap the configuration

    $ rake bootstrap

### Populate the database

    $ rake db:initialise

This task will do the following:

- `db:drop` Drop the database if exists.
- `db:create` Create the database.
- `db:migrate` Build the database.
- `db:populate` Insert default environments and statuses.
- `db:github_repo` Pull all the repositories from the organisation and insert into repositories table.

### Start the app locally

    $ rails s

Visit [http://localhost:3000](http://localhost:3000)

## Licensing and Attribution
ReleaseHub is released under the MIT license as detailed in the LICENSE file that should be distributed with this library; the source code is freely available.

ReleaseHub was developed by [Jiazhen Xie](http://sheerdevelopment.com/) while employed by [Venntro Media Group](http://www.venntro.com/). Venntro Media Group have kindly agreed to the extraction and release of this software under the license terms above.

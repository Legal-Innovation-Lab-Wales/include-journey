<p align="center">
  <img src="logo-header-svg.jpg">
</p>

<p align="center">
  <a href="#introduction">Introduction & Motivation</a> •
  <a href="#tech-stack-and-requirements">Tech Stack & Requirements</a> •
  <a href="#local-installation">Local Installation</a> •
    <a href="#credit-and-license">Credit and License</a> •
  <br>
</p>


## Introduction

This project is a web application for Include Uk. The application is a journey tracker allowing
users to track their wellbeing journey. The features includes:
* Journaling + Sharing with Staff
* Visual analytics to track progress and wellbeing
* Self assesments
 

---

## Tech Stack and Requirements

The core technologies used for this project are:

* Ruby (2.7.2) (we recommend using rbenv for managing Ruby versions)
* Rails (6.1.3)
* Webpacker (5.0)
* Pg (1.1)
* Puma (5.0)
* Bootstrap (5.0.0.beta2)

---
## Local Installation
Follow these instuctions for local installation:

### Install dependencies
<details>
<summary>Some additional dependency steps might include:</summary>

#### Postgres

```zsh
sudo apt install postgresql postgresql-contrib`
sudo apt install libpq-dev
```
Setup postgres local db

#### Node

```zsh
sudo apt install nodejs
sudo apt install npm
sudo npm install -g npm@latest
sudo npm install --global yarn
```
</details>

Install Gems

`bundle`

Install Webpack

`rails webpacker:install`

Create the database and run migrations:

```zsh
rails db:create
rails db:migrate
```

### Seeding the database

In the `db` directory, create a new file called `config.rb`. This file should contain a module called `Config` declaring several constant variables used by `seed.rb` to control the size of the database.

<details>
<summary>An example `config.rb` file:</summary>

```zsh
# db/config.rb
module Config
    TOTAL_USER_COUNT = 10
    WELLBEING_ASSESSMENTS_FOR_EACH_USER = 20
    JOURNAL_ENTRIES_FOR_EACH_USER = 5
    CONTACTS_FOR_EACH_USER = 5
    APPOINTMENTS_FOR_EACH_USER = 20
    PAST_APPOINTMENTS_FOR_EACH_USER = 20
    NOTES_COUNT = 100
    GOALS_FOR_EACH_USER = 10 # Half short-term, half long-term
    CRISIS_EVENTS_COUNT = 20
    CRISIS_NOTES_COUNT = 20
    UPCOMING_AFFIRMATIONS = 5
    PAST_AFFIRMATIONS = 10
    SURVEY_RESPONSES = 15
end
```

</details>

Then finally, seed the database.

```zsh
rails db:seed
```

### Run the application

`rails s`

You should now be able to view the main web page at

``http://localhost:3000``

### Other Potential Fixes


You might be asked to override your local webpacker environment to work

```javascript
config/webpack/environment.js
```

#### Sending Email 

If emails are not working while on localhost, try running the following commands:

```zsh
$ echo "export SENDGRID_API_KEY=SG.apikeyfromsendgrid" > sendgrid.env
$ source ./sendgrid.env
```

#### Deleting User Accounts

User account deletion has a grace period of 30 days which is configured in the `app/controllers/users/registrations_controller.rb`
&gt; `destroy` action, if you want to lower this grace period for local testing you can do so here i.e. `+ 1.minute`
will create a grace period of only 1 minute.

The account deletion is handled either via the system should a user interact with it after their deletion date 
(such as if they're still logged in when the countdown expires) **or** via a scheduled job should the user set their account
to be deleted and not interact with the system again. 

This scheduled job is handled by the [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler) in the deployed
application which is configured via the `scheduler.rake` config file but it can also be emulated locally using a cronjob
with the [whenever](https://github.com/javan/whenever) gem. 

If you are not using `rbenv` to manage your ruby version you'll need to amend the `schedule.rb` config file to use `rails`
rather than `rbenv_rails` to run the task. If you want to setup this cronjob locally run 

`whenever --update-crontab --set environment='development'`

to create the new crontab which can be viewed with `crontab -l`, edited with `crontab -e` and cleared with 
`whenever --clear-crontab`.

If you want to run the task without setting it up as a cronjob locally this is also possible by running `rails users:delete`,
this is the recommended method as this is the command that the Heroku Scheduler runs on the deployed application and 
invoking this yourself means you don't have to wait for a cronjob execution to occur.

---


## Credits and license
[MIT License](https://github.com/Legal-Innovation-Lab-Wales/include-journey/blob/main/LICENSE)

[Legal Innovation Lab Wales](https://legaltech.wales/)


---
<details>
<summary>## Before Initial Commit</summary>

These were the steps taken to spin up the application before the initial commit.

```zsh
rbenv local 2.7.2

rails new include-journey -d=postgresql
```

update .gitignore

update gem file with devise, sassc, faker, rspec, factory_bot_rails
```zsh
bundle
rails g devise:install
````
Following this guide:

https://github.com/heartcombo/devise/wiki/How-to-Setup-Multiple-Devise-User-Models
 ```zsh
rails g devise staff
rails g devise user
```
Update routes, generate views, generate controllers, finish multi-user-model guide

 ```zsh
 rails g model Note content:text visible_to_user:boolean team_member:belongs_to user:references 

 rails g scaffold_controller Note 

 rails g model CrisisType type:string team_member:belongs_to 

 rails g model CrisisEvent additional_info:text closed:boolean closed_by:integer closed_at:datetime user:belongs_to crisis_type:belongs_to 

 rails g model CrisisNote content:text crisis_event:belongs_to team_member:belongs_to 

 rails g controller CrisisTypes; rails g controller CrisisEvents; rails g controller CrisisNotes; 

 rails g model WellbeingMetric name:string type:string team_member:belongs_to 

 rails g model WbaSelf user:belongs_to 

 rails g model WbaSelfScore value:integer priority:integer wba_self:belongs_to wellbeing_metric:belongs_to 

 rails g model WbaSelfPermission wba_self:belongs_to team_member:belongs_to 

 rails g model WbaSelfViewLog wba_self:belongs_to team_member:belongs_to 

 rails g model WbaTeamMember team_member:belongs_to user:references 

 rails g model WbaTeamMemberScore value:integer priority:integer wba_team_member:belongs_to wellbeing_metric:belongs_to 

 rails g controller WellbeingMetrics; rails g controller WbaSelves; rails g controller WbaSelfScores; rails g controller WbaSelfPermissions; rails g controller WbaSelfViewLogs; rails g controller WbaTeamMembers; rails g controller WbaTeamMemberScores;
 
 rails db:create; rails db:migrate
 ```

Setup Repo
</details>

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## Before Initial Commit

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

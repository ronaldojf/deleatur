Deleatur
=========

[![Circle CI](https://circleci.com/gh/ronaldojf/deleatur/tree/master.svg?style=shield&circle-token=8a7ae8cba8c9ad625e7f5a1a9267ef53b32e24a6)](https://circleci.com/gh/ronaldojf/deleatur/tree/master) [![Code Climate](https://codeclimate.com/github/ronaldojf/deleatur/badges/gpa.svg)](https://codeclimate.com/github/ronaldojf/deleatur) [![Test Coverage](https://codeclimate.com/github/ronaldojf/deleatur/badges/coverage.svg)](https://codeclimate.com/github/ronaldojf/deleatur/coverage)

This project is a [Rails](http://rubyonrails.org/) application used to be an academic software that assesses high school students skills through questionnaires.

## Dependencies

To run this project you need to have:

* Ruby 2.2.1 - You can use [RVM](http://rvm.io)
* [PostgreSQL](http://www.postgresql.org/)
  * OSX - [Postgress.app](http://postgresapp.com/)
  * Linux - `$ sudo apt-get install postgresql`
  * Windows - [PostgreSQL for Windows](http://www.postgresql.org/download/windows/)

1. Install the dependencies above
2. `$ git clone git@github.com:ronaldojf/deleatur.git` - Clone the project
3. `$ cd deleatur` - Go into the project folder
4. `$ bin/setup` - Run the setup script
5. `$ bin/rspec` - Run the specs to see if everything is working fine

If everything goes OK, you can now run the project!

You can see [an example here](http://showterm.io/6a0054fb8b6b53a56ef2c#slow)

## Running the project

1. `$ rails server` - Opens the server
2. Open [http://localhost:3000](http://localhost:3000)

## Demo URL

### Administrator's panel
[http://deleatur.herokuapp.com/admin](http://deleatur.herokuapp.com/admin)
* Username: teste@teste.com.br
* Password: deleatur1234

### Teacher's panel
[http://deleatur.herokuapp.com/professor/entrar](http://deleatur.herokuapp.com/professor/entrar)

### Student's panel
[http://deleatur.herokuapp.com/estudante/entrar](http://deleatur.herokuapp.com/estudante/entrar)

# Curiosity

## Installation

Clone it from github

And then just run it as standalone application `iex -S mix`

`Curiosity.Console` module is responsible for interaction in Elixir console

### Or

Add the Curiosity to your deps list as git dependency, and add `Curiosity.Spawner` as supervisor in your application.

## Usage

There is Curiosity.API module, which provides API for the management of calculating workers.

API supports three types of input data.

* File
* String
* List

Each type of input you may use in sync or async mode.

Copyright for portions of project bemobi/migrate are held by [Matthias Kadenbach, 2014] as part of project mattes/migrate.
All other copyright for project bemobi/migrate are held by [Bemobi, 2017].

---

# migrate

[![Build Status](https://travis-ci.org/bemobi/migrate.svg?branch=master)](https://travis-ci.org/bemobi/migrate)
[![GoDoc](https://godoc.org/github.com/bemobi/migrate?status.svg)](https://godoc.org/github.com/bemobi/migrate)

A migration helper written in Go. Use it in your existing Golang code 
or run commands via the CLI. 

```
GoCode   import github.com/bemobi/migrate/migration
CLI      go get -u github.com/bemobi/migrate
```

__Features__

* Super easy to implement [Driver interface](http://godoc.org/github.com/bemobi/migrate/driver#Driver).
* Gracefully quit running migrations on ``^C``.
* No magic search paths routines, no hard-coded config files.
* CLI is build on top of the ``migration package``.


## Available Drivers

 * [PostgreSQL](driver/postgres)

Need another driver? Just implement the [Driver interface](http://godoc.org/github.com/bemobi/migrate/driver#Driver) and open a PR.


## Usage from Terminal

```bash
# install
go get github.com/bemobi/migrate

# create new migration file in path
migrate -url driver://url -path ./migrations create migration_file_xyz

# apply all available migrations
migrate -url driver://url -path ./migrations up

# roll back all migrations
migrate -url driver://url -path ./migrations down

# roll back the most recently applied migration, then run it again.
migrate -url driver://url -path ./migrations redo

# run down and then up command
migrate -url driver://url -path ./migrations reset

# show the current migration version
migrate -url driver://url -path ./migrations version

# apply the next n migrations
migrate -url driver://url -path ./migrations migrate +1
migrate -url driver://url -path ./migrations migrate +2
migrate -url driver://url -path ./migrations migrate +n

# roll back the previous n migrations
migrate -url driver://url -path ./migrations migrate -1
migrate -url driver://url -path ./migrations migrate -2
migrate -url driver://url -path ./migrations migrate -n

# go to specific migration
migrate -url driver://url -path ./migrations goto 1
migrate -url driver://url -path ./migrations goto 10
migrate -url driver://url -path ./migrations goto v
```


## Usage in Go

See GoDoc here: http://godoc.org/github.com/bemobi/migrate/migration

```go
import "github.com/bemobi/migrate/migration"

// Import any required drivers so that they are registered and available
import _ "github.com/bemobi/migrate/driver/postgres"

// use synchronous versions of migration functions ...
allErrors, ok := migration.UpSync("driver://url", "./path")
if !ok {
  fmt.Println("Oh no ...")
  // do sth with allErrors slice
}

// use the asynchronous version of migration functions ...
pipe := migration.NewPipe()
go migration.Up(pipe, "driver://url", "./path")
// pipe is basically just a channel
// write your own channel listener. see writePipe() in main.go as an example.
```

## Migration files

The format of migration files looks like this:

```
1481574547_initial_plan_to_do_sth.up.sql     # up migration instructions
1481574547_initial_plan_to_do_sth.down.sql   # down migration instructions
1482438365_xxx.up.sql
1482438365_xxx.down.sql
...
```

Why two files? This way you could still do sth like 
``psql -f ./db/migrations/1481574547_initial_plan_to_do_sth.up.sql`` and there is no
need for any custom markup language to divide up and down migrations. Please note
that the filename extension depends on the driver.


## Alternatives

 * https://bitbucket.org/liamstask/goose
 * https://github.com/tanel/dbmigrate
 * https://github.com/BurntSushi/migration
 * https://github.com/DavidHuie/gomigrate
 * https://github.com/rubenv/sql-migrate
 * https://github.com/mattes/migrate

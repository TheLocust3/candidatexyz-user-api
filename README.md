# User API

## Running
`bundle exec puma -b tcp://127.0.0.1:3003 -v`
Use puma for this, lots of servers send requests to this and it often gets hung up in development when running a normal Rails server

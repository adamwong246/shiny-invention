# canix test readme
https://gist.github.com/ericve25/9bc1ef4fdf1a0908dcde45ca942ccbd0

- install rbenv
`brew install rbenv`

- install ruby 3.1.2
`rbenv install 3.1.2`

- switch to ruby 3.1.2
`eval "$(rbenv init -)"`

- install gems
`bundle install`

- run the tests
`bin/rake`

- migrate the DB
`bin/rails db:migrate`

- start the server
`bin/rails s`

## more notes
- test just a model
`bin/rails test test/models/uploaded_file_test.rb`
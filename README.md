Freshmail
===================

This is a Rails Gem for Freshmail REST API.

## Instalation

```console
gem install freshmail
```

or add it to your `Gemfile`:

```ruby
gem 'freshmail'
```

## Usage

Create instance of gem:

```ruby
freshmail = Freshmail::Api.new('YOUR_API_KEY', 'YOUR_API_SECRET')
```

After that, you can access Freshmail methods, for example:

```ruby
my_lists = freshmail.lists
my_first_list_hash = my_lists['lists'].first['subscriberListHash']
my_last_list_hash = my_lists['lists'].last['subscriberListHash']

freshmail.add_subscriber(email: 'test@test.net', list: my_first_list_hash, state: 1)

freshmail.batch_add_subscriber(subscribers: [{email: 'test@test.net'}, {email: 'test2@test.net'}], list: my_last_list_hash, state: 1)

freshmail.subscriber(email: 'test@test.net', list: my_first_list_hash)
freshmail.subscribers(subscribers: [{email: 'test2@test.net'}], list: my_last_list_hash)

freshmail.delete_subscriber(email: 'test@test.net', list: my_first_list_hash)
freshmail.batch_delete_subscriber(subscribers: [{email: 'test@test.net'}, {email: 'test2@test.net'}], list: my_last_list_hash)
```

Available methods:

```ruby
freshmail.ping
freshmail.mail(...)
freshmail.subscriber(...)
freshmail.subscribers(...)
freshmail.add_subscriber(...)
freshmail.batch_add_subscriber(...)
freshmail.delete_subscriber(...)
freshmail.batch_delete_subscriber(...)
freshmail.lists
freshmail.create_list(...)
freshmail.update_list(...)
freshmail.delete_list(...)
```

## TODO

Add more methods.
Add tests.

## Licence

Copyright (c) 2015 Marcin Adamczyk, released under the MIT license


*Feel free to contact me if you need help: marcin.adamczyk [--a-t--] subcom.me*

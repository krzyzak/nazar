# Nazar [![Build Status](https://github.com/krzyzak/nazar/actions/workflows/main.yml/badge.svg)](https://github.com/krzyzak/nazar/actions) [![Gem Version](https://badge.fury.io/rb/nazar.svg)](https://badge.fury.io/rb/nazar) [![Code Climate](https://codeclimate.com/github/krzyzak/nazar/badges/gpa.svg)](https://codeclimate.com/github/krzyzak/nazar) [![Test Coverage](https://api.codeclimate.com/v1/badges/f89b8bfdf557900e1f9f/test_coverage)](https://codeclimate.com/github/krzyzak/nazar/test_coverage)

Turn this:
```ruby
>> User.all
  User Load (0.4ms)  SELECT "users".* FROM "users" /* loading for inspect */ LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<User id: 1, email: "delma@goldner.co", name: "Mrs. Charis Brown", description: "Quasi atque ea. Beatae corporis quia. Eveniet veli...", created_at: "2021-09-01 05:42:24.341344000 +0000", updated_at: "2021-09-20 09:36:29.289078000 +0000", active: false, last_login_at: nil>, #<User id: 2, email: "markpfeffer@wunschbraun.info", name: "Ms. Sherice Champlin", description: "Omnis ut illum. Non velit mollitia. Expedita facil...", created_at: "2021-09-10 07:27:00.182298000 +0000", updated_at: "2021-09-20 09:36:29.292065000 +0000", active: true, last_login_at: "2021-09-19 16:25:32.094418000 +0000">, #<User id: 3, email: "nathansimonis@kunde.org", name: "Florentino Gleason", description: "Non recusandae eos. Et voluptates iusto. Commodi e...", created_at: "2021-09-07 18:24:45.608164000 +0000", updated_at: "2021-09-20 09:36:29.293572000 +0000", active: false, last_login_at: nil>, #<User id: 4, email: "edwardowilkinson@walkerschiller.info", name: "Judie Boehm", description: "Ut ea eum. Tempore voluptates praesentium. Animi s...", created_at: "2021-09-05 02:11:36.564693000 +0000", updated_at: "2021-09-20 09:36:29.295763000 +0000", active: true, last_login_at: "2021-09-19 20:17:24.074515000 +0000">, #<User id: 5, email: "isaiahebert@brauncarroll.net", name: "Mari Ullrich", description: "Aperiam quas voluptas. Autem alias quia. Aut persp...", created_at: "2021-09-09 05:23:03.229860000 +0000", updated_at: "2021-09-20 09:36:29.296928000 +0000", active: nil, last_login_at: nil>, #<User id: 6, email: "alexander@anderson.io", name: "Sam Larson DDS", description: "Sed velit consectetur. Quas cupiditate enim. Neque...", created_at: "2021-09-03 02:52:14.055696000 +0000", updated_at: "2021-09-20 09:36:29.299157000 +0000", active: true, last_login_at: "2021-09-20 05:01:39.019563000 +0000">, #<User id: 7, email: "chirunolfon@keler.io", name: "Ying Kub I", description: "Cupiditate ut consequatur. Eos ab laboriosam. Ipsa...", created_at: "2021-09-10 05:52:32.005877000 +0000", updated_at: "2021-09-20 09:36:29.301469000 +0000", active: true, last_login_at: "2021-09-19 21:30:48.854010000 +0000">, #<User id: 8, email: "johnny@anderson.net", name: "Johnie Corwin II", description: "Suscipit itaque adipisci. Assumenda ad error. Quas...", created_at: "2021-09-12 13:05:49.845361000 +0000", updated_at: "2021-09-20 09:36:29.302657000 +0000", active: nil, last_login_at: nil>, #<User id: 9, email: "yahairakuhn@schneider.com", name: "Sharie Weber", description: "Sapiente voluptatum mollitia. Dolores voluptatum a...", created_at: "2021-09-19 03:03:39.360526000 +0000", updated_at: "2021-09-20 09:36:29.304929000 +0000", active: true, last_login_at: "2021-09-20 06:46:05.846685000 +0000">, #<User id: 10, email: "tommye@schuppe.biz", name: "Yoshiko Mohr", description: "Similique laborum totam. Non cum atque. Placeat qu...", created_at: "2021-09-08 05:41:36.588541000 +0000", updated_at: "2021-09-20 09:36:29.306120000 +0000", active: nil, last_login_at: nil>, ...]>
```
Into this:

```ruby
>> User.all
   (0.6ms)  SELECT sqlite_version(*)
  User Load (0.8ms)  SELECT "users".* FROM "users"
┏━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ id    │ email                                │ name                  │ description                                                                             │ created_at              │ updated_at              │ active │ last_login_at           ┃
┣═══════╪══════════════════════════════════════╪═══════════════════════╪═════════════════════════════════════════════════════════════════════════════════════════╪═════════════════════════╪═════════════════════════╪════════╪═════════════════════════┫
┃ 1     │ delma@goldner.co                     │ Mrs. Charis Brown     │ Quasi atque ea. Beatae corporis quia. Eveniet velit ad.                                 │ 2021-09-01 05:42:24 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 2     │ markpfeffer@wunschbraun.info         │ Ms. Sherice Champlin  │ Omnis ut illum. Non velit mollitia. Expedita facilis dignissimos.                       │ 2021-09-10 07:27:00 UTC │ 2021-09-20 09:36:29 UTC │ ✓      │ 2021-09-19 16:25:32 UTC ┃
┃ 3     │ nathansimonis@kunde.org              │ Florentino Gleason    │ Non recusandae eos. Et voluptates iusto. Commodi est in.                                │ 2021-09-07 18:24:45 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 4     │ edwardowilkinson@walkerschiller.info │ Judie Boehm           │ Ut ea eum. Tempore voluptates praesentium. Animi sapiente distinctio.                   │ 2021-09-05 02:11:36 UTC │ 2021-09-20 09:36:29 UTC │ ✓      │ 2021-09-19 20:17:24 UTC ┃
┃ 5     │ isaiahebert@brauncarroll.net         │ Mari Ullrich          │ Aperiam quas voluptas. Autem alias quia. Aut perspiciatis eos.                          │ 2021-09-09 05:23:03 UTC │ 2021-09-20 09:36:29 UTC │ ∅      │ ∅                       ┃
┃ 6     │ alexander@anderson.io                │ Sam Larson DDS        │ Sed velit consectetur. Quas cupiditate enim. Neque facere harum.                        │ 2021-09-03 02:52:14 UTC │ 2021-09-20 09:36:29 UTC │ ✓      │ 2021-09-20 05:01:39 UTC ┃
┃ 7     │ chirunolfon@keler.io                 │ Ying Kub I            │ Cupiditate ut consequatur. Eos ab laboriosam. Ipsam ut veritatis.                       │ 2021-09-10 05:52:32 UTC │ 2021-09-20 09:36:29 UTC │ ✓      │ 2021-09-19 21:30:48 UTC ┃
┃ 8     │ johnny@anderson.net                  │ Johnie Corwin II      │ Suscipit itaque adipisci. Assumenda ad error. Quas enim beatae.                         │ 2021-09-12 13:05:49 UTC │ 2021-09-20 09:36:29 UTC │ ∅      │ ∅                       ┃
┃ 9     │ yahairakuhn@schneider.com            │ Sharie Weber          │ Sapiente voluptatum mollitia. Dolores voluptatum accusamus. Veniam voluptatem deserunt. │ 2021-09-19 03:03:39 UTC │ 2021-09-20 09:36:29 UTC │ ✓      │ 2021-09-20 06:46:05 UTC ┃
┃ 10    │ tommye@schuppe.biz                   │ Yoshiko Mohr          │ Similique laborum totam. Non cum atque. Placeat quia velit.                             │ 2021-09-08 05:41:36 UTC │ 2021-09-20 09:36:29 UTC │ ∅      │ ∅                       ┃
┃ 11    │ derekbeier@hermankuhlman.co          │ Lavern Feil           │ Itaque molestias et. Iure tempora minus. Dolore autem omnis.                            │ 2021-09-05 04:04:51 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 12    │ lavernwillms@runolfsdottirbogan.org  │ Marcy Gottlieb Sr.    │ Mollitia quia dolor. Libero laborum aperiam. Velit est eum.                             │ 2021-09-08 19:22:49 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 13    │ earlhills@mclaughlingreenholt.info   │ Adina Luettgen        │ In qui rem. Illum itaque dignissimos. Enim vitae tenetur.                               │ 2021-09-08 10:16:12 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 14    │ larry@rice.com                       │ Carolina Kuhlman II   │ Ipsum ut fuga. Sunt id a. Rerum nulla sint.                                             │ 2021-09-03 23:11:42 UTC │ 2021-09-20 09:36:29 UTC │ ∅      │ ∅                       ┃
┃ 15    │ randy@kuhicfritsch.name              │ Harvey Runolfsdottir  │ Dolorum officiis sed. Ut recusandae culpa. Odit aut nostrum.                            │ 2021-09-08 04:28:38 UTC │ 2021-09-20 09:36:29 UTC │ ∅      │ ∅                       ┃
┃ 16    │ lashaun@mooreleannon.co              │ Lucio Raynor          │ Et expedita rerum. Autem nesciunt labore. Suscipit aut eum.                             │ 2021-09-06 20:47:51 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 17    │ omeryost@becker.com                  │ Rocky Hettinger       │ Ut deleniti voluptas. Explicabo voluptas rerum. Illum sapiente quo.                     │ 2021-09-14 23:05:33 UTC │ 2021-09-20 09:36:29 UTC │ ✓      │ 2021-09-20 09:35:14 UTC ┃
┃ 18    │ nilsa@corwinkub.name                 │ Serena Brakus         │ Qui non provident. Omnis excepturi quasi. Ratione suscipit dolor.                       │ 2021-09-14 01:06:02 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 19    │ berniebednar@spinkamiller.co         │ Merlin Predovic       │ Omnis et minus. Tempore in laboriosam. Molestiae aut eveniet.                           │ 2021-09-16 18:34:20 UTC │ 2021-09-20 09:36:29 UTC │ ✓      │ 2021-09-19 12:01:59 UTC ┃
┃ 20    │ claude@smithamhaley.io               │ Claudette Thompson MD │ Aut consectetur soluta. Laborum quia qui. Vel incidunt minima.                          │ 2021-09-10 03:53:24 UTC │ 2021-09-20 09:36:29 UTC │ ∅      │ ∅                       ┃
┃ 21    │ matilde@cormierstroman.name          │ Dalton Witting        │ Voluptatum provident earum. Ad esse odit. Quasi non ut.                                 │ 2021-09-10 04:51:53 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 22    │ randistrosin@littel.io               │ Miss Lucio Kub        │ Ea quia sapiente. Reprehenderit esse ut. Veritatis magnam quia.                         │ 2021-08-31 18:33:02 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 23    │ noah@kuphal.co                       │ Alonzo Stroman        │ Officia fugit eos. Qui quo et. Ducimus harum dignissimos.                               │ 2021-09-13 14:36:31 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┃ 24    │ cristinaschneider@cole.biz           │ Dr. Newton Ritchie    │ Corporis suscipit recusandae. Voluptas voluptas quo. Non perferendis fugiat.            │ 2021-09-02 20:54:38 UTC │ 2021-09-20 09:36:29 UTC │ ✓      │ 2021-09-20 02:35:39 UTC ┃
┃ 25    │ mirtha@spinkabayer.co                │ Kory Cummings         │ Aut ut aut. Quis voluptas sit. Consequatur quia voluptatibus.                           │ 2021-09-17 08:45:02 UTC │ 2021-09-20 09:36:29 UTC │ ✗      │ ∅                       ┃
┠───────┼──────────────────────────────────────┴───────────────────────┴─────────────────────────────────────────────────────────────────────────────────────────┴─────────────────────────┴─────────────────────────┴────────┴─────────────────────────┨
┃ Total │ 25                                                                                                                                                                                                                                            ┃
┗━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

## Installation

### Per-project installation

While nothing stops you from adding Nazar to each project separately, I find it cumbersome to add it to every project I'm working on - it also alters REPL behaviour for other teammates, which is another reason why personally I don't recommend that approach. Anyway, here's quick how-to:

Add `nazar` to Gemfile:
```ruby
group :development, :test do
  gem 'nazar', require: false
end
```
Then, you have to call `Nazar.enable!`. If you're using Rails, you might want to add this snippet to `config/application.rb`: 

```ruby
console do
  require 'nazar'

  Nazar.enable! # See configuration section for more options and 
                # Opt-in setup section if you don't want to enable it for every item
end
```
Otherwise, call it in `bin/console` or any other script that launches your REPL.

### Global installation

This is my recommended way to install this gem - that way it works automatically in all your projects, even in standalone `irb` or `pry` sessions.

- **Create global gems path** 
  
  `mkdir -p ~/.gem/ruby/global` - You're welcome to use any other path for your global gemset
- **Install nazar in your global gemset**
  
  `gem install nazar -i ~/.gem/ruby/global`
- **Load Nazar in your REPL rc file**
  Add following snippet to your `.irbrc` or `.pryrc`:
  
```ruby
global_gemset_path = File.expand_path('~/.gem/ruby/global/gems')

if Dir.exist?(global_gemset_path)
  global_gems_path = Dir.glob("#{global_gemset_path}/*/lib")

  $LOAD_PATH.unshift(*global_gems_path)
end

%w[nazar].each do |gem|
  begin
    require gem
  rescue LoadError
  end
end

Nazar.enable! if defined?(Nazar)
```

## Shorthand method

Nazar defines top level `__(data)` method, that can be useful for two things:

### Inspecting (array of) Hashes/Structs

Nazar by design won't enhance output for any collection that does not consist of supported (eg. ActiveRecord/Sequel) items. If you have a data that is structurally compatible (ie: all items consists of the same keys), and want to enahance the output, you can simply use `#__` method:

```ruby
__ [{foo: :bar, test: 123},{foo: :baz, test: 456}]
┏━━━━━━━┯━━━━━━┓
┃ foo   │ test ┃
┣═══════╪══════┫
┃ :bar  │ 123  ┃
┃ :baz  │ 456  ┃
┠───────┼──────┨
┃ Total │ 2    ┃
┗━━━━━━━┷━━━━━━┛
```

It works with Structs and Hashes (or, more specifically - with any object that reponds to `#keys` and `#values`)

### Opt-in setup

If you use `Nazar.load!` instead of `Nazar.enable!`, it would not enhance output for every element in the console. Instead, you have to call `#__` for each item that you want to enhance output

```ruby

Nazar.load!
User.all # Returns default output
__ User.all # Returns output enhanced by Nazar
```


## Configuration

By default, Nazar improves output for ActiveRecord (both collections and a single item) and for CSV Tables. You can configure that by calling `#enable!` with optional argument:

`Nazar.enable!(extensions: [:active_record, :csv, :sequel])` will enhance output for <a href="https://github.com/jeremyevans/sequel/">Sequel</a> as well.

You can also configure behaviour of Nazar:

| Config | Default | Description |
| ------ | ------- | ----------- |
| `Nazar.config.colors.enabled` | true | Determines whether the output should be colorised or not |
| `Nazar.config.formatter.nil` | `∅` | Sets character printed if the value was nil | 
| `Nazar.config.formatter.boolean` | ['✓', '✗'] | First item in array is a character for `true`, second for `false` |
| `Nazar.config.enable_shorthand_method` | true | Determines if shorthand method should be defined. See <a href="#opt-in-setup">Opt-in setup</a> for more details |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/krzyzak/nazar.


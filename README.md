# ActsAsBoolean

Treat time-y attributes like boolean attributes.
    
## Why

Ruby is expressive. Expressive is sexy. ActiveRecord time-y objects are time-y objects. Time-y objects are a nightmare, and therefore, not sexy. 

We like sexy.

## How

    class Post < ApplicationRecord
      acts_as_boolean :published_at 
    end 

    class PostsController < ApplicationController
      def index
        @posts = Post.published 
      end
      
      def show
        @post = Post.find(params[:id])
        unless @post.published?
          raise ActiveRecord::RecordNotFound
        end
      end 
    end  

## What 

Given `Post#published_at`:

| Method            | Description
| ----------------- | -----------
| `Post#published`  | `true` if `Post#published_at` is greater than or equal to `Time.current`; otherwise `false` 
| `Post#published?` | Sexy alias of `Post#published`
| `Post#published=` | Sets the value of `published_at` to `Time.current` if the value passed is truth-y per `ActiveModel::Type::Boolean`; otherwise sets `published_at` to nil
| `Post.published`  | Creates a scope of `Post.where('published_at <= ?', Time.current).where.not(published_at: nil)`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acts_as_boolean'
```

And then execute:

```bash
$ bundle
```

The great migration — you probably want an index here because we create a scope to the column:

`rails g migration AddPublishedAtToPosts published_at:datetime:index`

`rake db:migrate`

Then drop it in:

    class Post < ApplicationRecord
      acts_as_boolean :published_at 
    end
    
## Advanced configuration

### Default time-y thing

By default, `ActsAsBoolean` uses `Time.current`. Want to use `DateTime.now`? Great, just send in a `proc`.
 
In `config/initializers/acts_as_boolean.rb`:

```ruby
ActsAsBoolean.timeish = -> { DateTime.now }
```

Want more control? Pass it in.

```ruby
class Post < ApplicationRecord
  acts_as_boolean :published_at, time: -> { DateTime.now }
end 
```
### New method name

By default, `ActsAsBoolean` assumes you want `column_name.to_s.delete_suffix("_at")`. Given you have `published_pie` as your column name (which, of course, you do, because you love pie)...
    
```ruby
class Post < ApplicationRecord
  acts_as_boolean :published_pie, as: :published
end 
```    

Want to control this globally?

In `config/initializers/acts_as_boolean.rb`:

```ruby
ActsAsBoolean.normalize_column = -> (str) { str.gsub("_at", "") }
```

## Contributing

Yes.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

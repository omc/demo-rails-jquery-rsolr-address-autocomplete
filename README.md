# Solr Demo: Address Autocompletion

This application

## Getting started

```sh
# clone application and install gems
git clone git://github.com/onemorecloud/demo-rails-jquery-rsolr-address-autocomplete.git
cd demo-rails-jquery-rsolr-address-autocomplete
bundle install

# start solr and generate sample data
bundle exec rake sunspot:solr:start
WEBSOLR_URL=http://localhost:8982/solr rake db:seed
```

N.B. — This application uses the `WEBSOLR_URL` environment variable for its Solr index.

## How it works

### Configure Solr client

This demo uses [RSolr](https://github.com/mwmitchell/rsolr) for its Solr client. RSolr is fairly low-level, mapping closely to Solr's own API.

RSolr is configured in [config/initializers/solr.rb](tree/master/config/initializers/solr.rb) where it creates a global `$solr` variable for later use throughout the application.

### Adding documents to Solr

RSolr can create a document with a hash, or an array of hashes. In this case, a single new document would look like this:

```ruby
$solr.add(id: 1, address_text: '123 Main St, Anytown, NY, 01234')
```

The `rake db:seed` task, defined in [db/seeds.rb](tree/master/db/seeds.rb), generates and indexes 1,000,000 sample addresses.

These field names correspond to definitions present in the [solr/conf/schema.xml](tree/master/solr/conf/schema.xml) file. Read through that file to learn more about how Solr's fields and types are configured.

### Searching Solr

Solr's default request handler for searches is called the select handler, located at `/select`.

A simple search to count the total number of documents is performed in the [`addresses#index`](tree/master/app/controllers/addresses_controller.rb#L4) action.

```ruby
$solr.select(params: { q: '*:*' })
```

A more advanced search, using dismax for full-text querying, and highlighting results, is defined in the [`addresses#perform_search`](tree/master/app/controllers/addresses_controller.rb#L14-31) controller method.
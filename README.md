#eyeq_metadata

##Installation
```
gem install eyeq_metadata
```

##Usage
```ruby
require 'eyeq_metadata'

eyeq = EyeQ.new(clientid, clientid_tag)
# optional option logging = false/true(default). EyeQ.new(clientid, clientid_tag, logging: false)
# Disabling logging may cause some unintended consequences to other portions of your script/app.
response.request(query_type: 'tvchannel_fetch', gnid: '123-456-789')
# returns a Nokogiri::XML object that contains the response from eyeq

# list of supported searches
# ----------------------- EPG
# tvchannel_fetch               - :gnid
# tvchannel_lookup_by_provider  - :gnid
# tvprovider_na                 - :zipcode
# tvprovider_or                 - :tvregion
# tvprogram_fetch               - :gnid
# tvgrid_search                 - :program_title & :tvchannel_gnid (optional :date_start & :date_end)
# tvgrid_lookup                 - :tvchannel_gnid (optional :date_start & :date_end)
# ----------------------- VIDEO
# avwork_fetch                  - :gnid
```

##Navigating Nokogiri::XML objects
[Nokogiri Docs](http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html)
```ruby
response.css('RESPONSES')
#returns all RESPONSES from Nokogiri::XML
```

##Contributing
Feel free to create a pull request!
```shell
  # installing gem requirements
  bundle install
```

#eyeq_metadata

##Installation
```
gem install eyeq_metadata
```

##Usage
```ruby
require 'eyeq_metadata'

eyeq = EyeQ.new(clientid, clientid_tag)
response.request("query_type: 'tvchannel_fetch', gnid: '123-456-789")
#returns a Nokogiri::XML object that contains the response from eyeq
```

##Navigating Nokogiri::XML objects
[Nokogiri Docs](http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html)
```ruby
response.css('RESPONSES')
#returns RESPONSES from Nokogiri::XML
```
